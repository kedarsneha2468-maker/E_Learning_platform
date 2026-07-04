<%@ page import="java.util.*, model.Submission, model.Assignment" %>
<%@ page session="true" %>
<%
    Integer instructorId = (Integer) session.getAttribute("instructor_id");
    if (instructorId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Submission> submissions = (List<Submission>) request.getAttribute("submissions");
    Assignment assignment = (Assignment) request.getAttribute("assignment");
    Integer assignmentId = (Integer) request.getAttribute("assignmentId");
    
    if (assignmentId == null && assignment != null) {
        assignmentId = assignment.getAssignmentId();
    }
    
    // Calculate statistics
    int totalSubmissions = 0;
    int pendingCount = 0;
    int gradedCount = 0;
    double totalMarksObtained = 0;
    int gradedSubmissionsForAvg = 0;
    
    if (submissions != null && !submissions.isEmpty()) {
        totalSubmissions = submissions.size();
        for (Submission sub : submissions) {
            String status = sub.getStatus() != null ? sub.getStatus() : "pending";
            if ("submitted".equals(status)) {
                pendingCount++;
            } else if ("graded".equals(status)) {
                gradedCount++;
                if (sub.getMarksObtained() != null) {
                    totalMarksObtained += sub.getMarksObtained();
                    gradedSubmissionsForAvg++;
                }
            }
        }
    }
    
    double averageScore = 0;
    if (gradedSubmissionsForAvg > 0) {
        averageScore = totalMarksObtained / gradedSubmissionsForAvg;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Submissions - EduStream</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1a56db;
            --primary-light: #e8effe;
            --accent: #f97316;
            --bg: #f5f7ff;
            --surface: #ffffff;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: linear-gradient(135deg, var(--bg) 0%, #eef2ff 100%);
            min-height: 100vh;
            padding: 2rem;
        }

        .navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            padding: 0.85rem 0;
            margin-bottom: 2rem;
            border-radius: 12px;
        }

        .logo {
            font-family: 'Sora', sans-serif;
            font-size: 1.55rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
        }

        .container-custom {
            max-width: 1300px;
            margin: 0 auto;
        }

        .header-card {
            background: var(--surface);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .header-card h2 {
            font-family: 'Sora', sans-serif;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .stat-mini-card {
            background: var(--surface);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            border: 1px solid var(--border);
            transition: transform 0.3s ease;
        }
        .stat-mini-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .stat-mini-card i {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }
        .stat-mini-card .number {
            font-size: 2rem;
            font-weight: 800;
        }
        .stat-mini-card .label {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        .submissions-table {
            background: var(--surface);
            border-radius: 16px;
            overflow-x: auto;
            border: 1px solid var(--border);
        }
        .submissions-table table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }
        .submissions-table th {
            background: var(--primary-light);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.85rem;
        }
        .submissions-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }
        .submissions-table tr:hover {
            background: var(--primary-light);
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
            display: inline-block;
        }
        .status-submitted {
            background: #fed7aa;
            color: #c2410c;
        }
        .status-graded {
            background: #d1fae5;
            color: #059669;
        }

        .btn-grade {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            border: none;
            padding: 0.3rem 0.8rem;
            border-radius: 6px;
            font-size: 0.7rem;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-view-pdf {
            background: #dc2626;
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 6px;
            font-size: 0.7rem;
            text-decoration: none;
        }
        .btn-view-pdf:hover {
            background: #b91c1c;
            color: white;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            padding: 0.5rem 1rem;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 8px;
            text-decoration: none;
            color: var(--text);
        }
        .back-btn:hover {
            background: var(--primary-light);
            color: var(--primary);
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
        }
        .empty-state i {
            font-size: 3rem;
            color: #ccc;
        }

        @media (max-width: 768px) {
            body { padding: 1rem; }
            .stats-row { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="container">
        <a class="logo" href="InstructorDashboardServlet">
            <i class="bi bi-mortarboard-fill"></i>
            Edu<span style="color:var(--accent)">Stream</span> Instructor
        </a>
        <div>
            <span><i class="bi bi-person-circle"></i> <%= session.getAttribute("name") %></span>
        </div>
    </div>
</nav>

<div class="container-custom">
    
    <a href="ViewAssignmentServlet?courseId=<%= assignment != null ? assignment.getCourseId() : "" %>" class="back-btn">
        <i class="bi bi-arrow-left"></i> Back to Assignments
    </a>
    
    <!-- Header Card -->
    <div class="header-card">
        <h2><i class="bi bi-file-text"></i> <%= assignment != null ? assignment.getTitle() : "Assignment Submissions" %></h2>
        <p class="text-muted"><%= assignment != null && assignment.getDescription() != null ? assignment.getDescription() : "" %></p>
        <div class="d-flex gap-3 flex-wrap mt-2">
            <span class="badge bg-primary"><i class="bi bi-star"></i> Total Marks: <%= assignment != null ? assignment.getTotalMarks() : 0 %></span>
            <span class="badge bg-warning"><i class="bi bi-calendar"></i> Due: <%= assignment != null && assignment.getDueDate() != null ? assignment.getDueDate() : "No deadline" %></span>
        </div>
    </div>
    
    <!-- Statistics Cards -->
    <div class="stats-row">
        <div class="stat-mini-card">
            <i class="bi bi-people-fill text-primary"></i>
            <div class="number"><%= totalSubmissions %></div>
            <div class="label">Total Submissions</div>
        </div>
        <div class="stat-mini-card">
            <i class="bi bi-clock-history text-warning"></i>
            <div class="number text-warning"><%= pendingCount %></div>
            <div class="label">Pending Grading</div>
        </div>
        <div class="stat-mini-card">
            <i class="bi bi-check-circle-fill text-success"></i>
            <div class="number text-success"><%= gradedCount %></div>
            <div class="label">Graded</div>
        </div>
        <div class="stat-mini-card">
            <i class="bi bi-trophy-fill text-accent"></i>
            <div class="number"><%= String.format("%.1f", averageScore) %>%</div>
            <div class="label">Average Score</div>
        </div>
    </div>
    
    <!-- Submissions Table -->
    <div class="submissions-table">
        <table class="table mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Student Name</th>
                    <th>Student Email</th>
                    <th>Submitted On</th>
                    <th>Submission</th>
                    <th>Status</th>
                    <th>Marks</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (submissions != null && !submissions.isEmpty()) {
                        int count = 1;
                        for (Submission sub : submissions) {
                            String status = sub.getStatus() != null ? sub.getStatus() : "pending";
                            java.util.Date submittedAt = sub.getSubmittedAt();
                            String submittedDateStr = "N/A";
                            if (submittedAt != null) {
                                submittedDateStr = new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(submittedAt);
                            }
                %>
                <tr>
                    <td><%= count++ %></td>
                    <td><strong><%= sub.getStudentName() != null ? sub.getStudentName() : "Unknown" %></strong></td>
                    <td><%= sub.getStudentEmail() != null ? sub.getStudentEmail() : "N/A" %></td>
                    <td><i class="bi bi-clock"></i> <%= submittedDateStr %></td>
                    <td>
                        <% if (sub.getFilePath() != null && !sub.getFilePath().isEmpty()) { %>
                            <a href="<%= request.getContextPath() %>/<%= sub.getFilePath() %>" target="_blank" class="btn-view-pdf">
                                <i class="bi bi-file-pdf"></i> View PDF
                            </a>
                        <% } else if (sub.getSubmissionText() != null && !sub.getSubmissionText().isEmpty()) { %>
                            <button class="btn-view-pdf" style="background:#6c757d;" onclick="viewText('<%= sub.getSubmissionText().replace("\"", "&quot;").replace("\n", "\\n") %>')">
                                <i class="bi bi-file-text"></i> View Text
                            </button>
                        <% } else { %>
                            <span class="text-muted">No file uploaded</span>
                        <% } %>
                    </td>
                    <td>
                        <span class="status-badge status-<%= "submitted".equals(status) ? "submitted" : ("graded".equals(status) ? "graded" : "pending") %>">
                            <%= "submitted".equals(status) ? "SUBMITTED" : ("graded".equals(status) ? "GRADED" : "PENDING") %>
                        </span>
                    </td>
                    <td>
                        <% if ("graded".equals(status) && sub.getMarksObtained() != null) { %>
                            <strong class="text-success"><%= sub.getMarksObtained() %>/<%= sub.getTotalMarks() %></strong>
                        <% } else { %>
                            <span class="text-muted">Not graded</span>
                        <% } %>
                    </td>
                    <td>
                        <button class="btn-grade" onclick="gradeSubmission(<%= sub.getSubmissionId() %>, '<%= sub.getStudentName() %>', <%= sub.getTotalMarks() %>)">
                            <i class="bi bi-pencil"></i> Grade
                        </button>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="8" class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h5>No Submissions Yet</h5>
                        <p class="text-muted">No students have submitted this assignment yet.</p>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Text Submission Modal -->
<div class="modal fade" id="textModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-file-text"></i> Student Submission</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="p-3 bg-light rounded" id="submissionText" style="white-space: pre-wrap; max-height: 400px; overflow-y: auto;"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
    function gradeSubmission(submissionId, studentName, totalMarks) {
        var marks = prompt("Enter marks for " + studentName + " (out of " + totalMarks + "):");
        if (marks !== null && marks !== "") {
            if (isNaN(marks) || marks < 0 || marks > totalMarks) {
                alert("Please enter valid marks between 0 and " + totalMarks);
                return;
            }
            var feedback = prompt("Enter feedback for " + studentName + ":");
            
            // ✅ Use POST instead of GET
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = 'GradeSubmissionServlet';
            
            var submissionIdField = document.createElement('input');
            submissionIdField.type = 'hidden';
            submissionIdField.name = 'submissionId';
            submissionIdField.value = submissionId;
            form.appendChild(submissionIdField);
            
            var marksField = document.createElement('input');
            marksField.type = 'hidden';
            marksField.name = 'marksObtained';
            marksField.value = marks;
            form.appendChild(marksField);
            
            var feedbackField = document.createElement('input');
            feedbackField.type = 'hidden';
            feedbackField.name = 'feedback';
            feedbackField.value = feedback || '';
            form.appendChild(feedbackField);
            
            var assignmentIdField = document.createElement('input');
            assignmentIdField.type = 'hidden';
            assignmentIdField.name = 'assignmentId';
            assignmentIdField.value = <%= assignmentId %>;
            form.appendChild(assignmentIdField);
            
            document.body.appendChild(form);
            form.submit();
        }
    }
    
    function viewText(text) {
        document.getElementById('submissionText').innerHTML = text;
        var modal = new bootstrap.Modal(document.getElementById('textModal'));
        modal.show();
    }
    
    window.addEventListener('pageshow', function(event) {
        if (event.persisted || performance.getEntriesByType("navigation")[0].type === 'back_forward') {
            location.reload();
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>