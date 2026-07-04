<%@ page import="model.Assignment, model.Submission" %>
<%@ page session="true" %>
<%
    Integer studentId = (Integer) session.getAttribute("student_id");
    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Assignment assignment = (Assignment) request.getAttribute("assignment");
    Submission submission = (Submission) request.getAttribute("submission");
    int courseId = (Integer) request.getAttribute("courseId");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Assignment - EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1a56db;
            --accent: #f97316;
            --bg: #f5f7ff;
            --surface: #ffffff;
            --border: #e2e8f0;
            --danger: #ef4444;
            --success: #10b981;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: linear-gradient(135deg, var(--bg) 0%, #eef2ff 100%);
            min-height: 100vh;
            padding: 2rem;
        }
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background: var(--surface);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 12px 40px rgba(0,0,0,0.1);
            border: 1px solid var(--border);
        }
        .form-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .form-header h2 {
            font-family: 'Sora', sans-serif;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .alert-danger {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
            border-radius: 10px;
            padding: 0.75rem 1rem;
        }
        .file-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 0.5rem;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            border: none;
            padding: 0.75rem;
            font-weight: 600;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(26,86,219,0.3);
        }
        .file-label {
            background: var(--primary-light);
            border: 2px dashed var(--primary);
            border-radius: 10px;
            padding: 1.5rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .file-label:hover {
            background: var(--bg);
            border-color: var(--accent);
        }
        .file-label i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        #fileName {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-container">
        <div class="form-header">
            <h2><i class="bi bi-upload"></i> Submit Assignment</h2>
            <p class="text-muted">Upload your assignment as PDF file</p>
        </div>
        
        <% if (error != null) { %>
            <div class="alert alert-danger mb-3">
                <i class="bi bi-exclamation-triangle-fill"></i> <%= error %>
            </div>
        <% } %>
        
        <div class="mb-4">
            <h5><%= assignment.getTitle() %></h5>
            <p class="text-muted"><%= assignment.getDescription() %></p>
            <div class="row mt-2">
                <div class="col-6">
                    <small class="text-muted">
                        <i class="bi bi-star"></i> Total Marks: <%= assignment.getTotalMarks() %>
                    </small>
                </div>
                <div class="col-6 text-end">
                    <small class="text-muted">
                        <i class="bi bi-calendar"></i> Due: <%= assignment.getDueDate() != null ? assignment.getDueDate() : "No deadline" %>
                    </small>
                </div>
            </div>
        </div>
        
        <form action="SubmitAssignmentServlet" method="post" enctype="multipart/form-data" id="submissionForm">
            <input type="hidden" name="assignmentId" value="<%= assignment.getAssignmentId() %>">
            <input type="hidden" name="courseId" value="<%= courseId %>">
            
            <div class="mb-3">
                <label class="form-label fw-bold">Your Answer / Submission</label>
                <textarea name="submissionText" class="form-control" rows="6" placeholder="Write your answer here..."><%= submission != null ? submission.getSubmissionText() : "" %></textarea>
            </div>
            
            <div class="mb-3">
                <label class="form-label fw-bold">
                    <i class="bi bi-file-pdf"></i> Upload PDF File
                </label>
                <div class="file-label" onclick="document.getElementById('fileInput').click()">
                    <i class="bi bi-cloud-upload"></i>
                    <p class="mb-0">Click to upload or drag and drop</p>
                    <small class="text-muted">PDF files only (Max 5MB)</small>
                    <div id="fileName" class="mt-2"></div>
                </div>
                <input type="file" name="file" id="fileInput" accept=".pdf,application/pdf" style="display: none;" onchange="displayFileName(this)">
                <div class="file-info mt-2">
                    <small>
                        <i class="bi bi-info-circle"></i> 
                        <strong>File Requirements:</strong>
                        <ul class="mb-0 mt-1">
                            <li>Only <strong>PDF</strong> files are allowed</li>
                            <li>Maximum file size: <strong>5MB</strong></li>
                            <li>File name should not contain special characters</li>
                        </ul>
                    </small>
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary w-100" id="submitBtn">
                <i class="bi bi-send"></i> Submit Assignment
            </button>
            <a href="CourseDetailsServlet?courseId=<%= courseId %>" class="btn btn-secondary w-100 mt-2">
                Cancel
            </a>
        </form>
    </div>
</div>

<script>
    function displayFileName(input) {
        const fileNameDiv = document.getElementById('fileName');
        const submitBtn = document.getElementById('submitBtn');
        
        if (input.files && input.files[0]) {
            const file = input.files[0];
            const fileName = file.name;
            const fileSize = (file.size / 1024 / 1024).toFixed(2);
            const fileExt = fileName.split('.').pop().toLowerCase();
            
            // Validate file extension
            if (fileExt !== 'pdf') {
                fileNameDiv.innerHTML = '<span class="text-danger">❌ Invalid file type! Please select a PDF file.</span>';
                submitBtn.disabled = true;
                submitBtn.style.opacity = '0.5';
                alert('Only PDF files are allowed! Please select a PDF file.');
                input.value = '';
                return;
            }
            
            // Validate file size (5MB = 5 * 1024 * 1024 bytes)
            if (file.size > 5 * 1024 * 1024) {
                fileNameDiv.innerHTML = '<span class="text-danger">❌ File too large! Maximum size is 5MB.</span>';
                submitBtn.disabled = true;
                submitBtn.style.opacity = '0.5';
                alert('File size exceeds 5MB limit! Please select a smaller file.');
                input.value = '';
                return;
            }
            
            // Valid file
            fileNameDiv.innerHTML = '<span class="text-success">✅ Selected: ' + fileName + ' (' + fileSize + ' MB)</span>';
            submitBtn.disabled = false;
            submitBtn.style.opacity = '1';
        } else {
            fileNameDiv.innerHTML = '';
            submitBtn.disabled = false;
            submitBtn.style.opacity = '1';
        }
    }
    
    // Drag and drop functionality
    const dropZone = document.querySelector('.file-label');
    
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        dropZone.addEventListener(eventName, preventDefaults, false);
    });
    
    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }
    
    ['dragenter', 'dragover'].forEach(eventName => {
        dropZone.addEventListener(eventName, highlight, false);
    });
    
    ['dragleave', 'drop'].forEach(eventName => {
        dropZone.addEventListener(eventName, unhighlight, false);
    });
    
    function highlight(e) {
        dropZone.style.background = '#e8effe';
        dropZone.style.borderColor = '#1a56db';
    }
    
    function unhighlight(e) {
        dropZone.style.background = '';
        dropZone.style.borderColor = '';
    }
    
    dropZone.addEventListener('drop', handleDrop, false);
    
    function handleDrop(e) {
        const dt = e.dataTransfer;
        const files = dt.files;
        const fileInput = document.getElementById('fileInput');
        fileInput.files = files;
        displayFileName(fileInput);
    }
</script>

</body>
</html>