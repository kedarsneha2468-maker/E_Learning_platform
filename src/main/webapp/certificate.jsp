<%@ page import="model.Certificate" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Integer studentId = (Integer) session.getAttribute("student_id");
    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get data from request attributes (set by servlet)
    Certificate certificate = (Certificate) request.getAttribute("certificate");
    String studentName = (String) request.getAttribute("studentName");
    String courseName = (String) request.getAttribute("courseName");
    String issueDate = (String) request.getAttribute("issueDate");
    String certificateCode = (String) request.getAttribute("certificateCode");
    Integer courseId = (Integer) request.getAttribute("courseId");
    
    if (certificate == null || studentName == null) {
        response.sendRedirect("StudentDashboardServlet?error=Certificate not available");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Course Completion Certificate - EduStream</title>

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500&family=Great+Vibes&display=swap" rel="stylesheet" />
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- jsPDF + html2canvas -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

    <style>
        body {
            background: #e5e7eb;
            font-family: "Poppins", sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 2rem;
            margin: 0;
        }

        .navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid #e2e8f0;
            padding: 0.85rem 0;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
        }

        .logo {
            font-family: 'Playfair Display', serif;
            font-size: 1.55rem;
            font-weight: 800;
            background: linear-gradient(135deg, #1a56db 0%, #f97316 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
        }

        .certificate-container {
            margin-top: 80px;
        }

        /* WRAPPER */
        .wrapper {
            background: #f9fafb;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        /* CERTIFICATE */
        .certificate {
            width: 1000px;
            max-width: 100%;
            min-height: 600px;
            background: linear-gradient(#ffffff, #fafafa);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        /* CORNERS */
        .corner-top {
            position: absolute;
            top: 0;
            left: 0;
            width: 320px;
            height: 160px;
            background: #0f172a;
            clip-path: polygon(0 0, 100% 0, 0 100%);
        }

        .corner-bottom {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 320px;
            height: 160px;
            background: #0f172a;
            clip-path: polygon(100% 100%, 0 100%, 100% 0);
        }

        /* GOLD LINES */
        .gold-line {
            position: absolute;
            width: 6px;
            height: 220px;
            background: linear-gradient(#d4af37, #facc15);
            transform: rotate(35deg);
        }

        .gold1 {
            top: -40px;
            left: 90px;
        }
        .gold2 {
            top: -40px;
            left: 115px;
        }
        .gold3 {
            bottom: -40px;
            right: 90px;
        }
        .gold4 {
            bottom: -40px;
            right: 115px;
        }

        /* BORDER */
        .inner-border {
            position: absolute;
            inset: 20px;
            border: 3px solid #d4af37;
        }

        /* WATERMARK */
        .watermark {
            position: absolute;
            width: 420px;
            height: 420px;
            background: radial-gradient(
                circle,
                rgba(212, 175, 55, 0.15),
                transparent 70%
            );
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        /* CONTENT */
        .content {
            text-align: center;
            padding: 50px 80px 20px;
            flex-grow: 1;
            position: relative;
            z-index: 2;
        }
        
        /* TITLE */
        .title {
            font-family: "Playfair Display", serif;
            font-size: 46px;
            color: #1e293b;
        }

        .subtitle {
            font-size: 16px;
            letter-spacing: 3px;
            color: #6b7280;
            margin-bottom: 10px;
        }

        /* NAME */
        .name {
            font-family: "Great Vibes", cursive;
            font-size: 52px;
            margin: 20px 0;
            color: #1e293b;
        }

        /* DIVIDER */
        .divider {
            width: 320px;
            height: 2px;
            background: linear-gradient(
                to right,
                transparent,
                #d4af37,
                transparent
            );
            margin: 20px auto;
        }

        /* TEXT */
        .desc {
            font-size: 14px;
            color: #4b5563;
            max-width: 650px;
            margin: auto;
            line-height: 1.6;
        }

        /* DATE */
        .date {
            margin-top: 15px;
            font-size: 14px;
            color: #374151;
        }

        /* SEAL */
        .seal {
            width: 85px;
            height: 85px;
            background: radial-gradient(circle, #fde68a, #b45309);
            border-radius: 50%;
            margin: 20px auto;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .seal i {
            font-size: 40px;
            color: #fff;
        }

        /* FOOTER (SIGNATURES) */
        .footer {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            padding: 0 60px 30px;
            position: relative;
            z-index: 2;
        }

        .sign {
            text-align: center;
            width: 30%;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }

        /* SIGNATURE TEXT */
        .signature-text {
            font-family: "Great Vibes", cursive;
            font-size: 22px;
            color: #1e293b;
        }

        .line {
            width: 180px;
            border-top: 1px solid #000;
            margin: 5px auto;
        }

        .label {
            font-size: 13px;
            color: #555;
        }

        /* Buttons */
        .btn-download {
            background: linear-gradient(135deg, #1a56db, #2563eb);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            margin-top: 30px;
            transition: all 0.3s;
        }
        .btn-download:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(26,86,219,0.3);
        }
        .btn-back {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            margin-top: 30px;
            margin-right: 10px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-back:hover {
            background: #5a6268;
            color: white;
        }

        @media (max-width: 768px) {
            .certificate { transform: scale(0.95); }
            .content { padding: 30px 40px 20px; }
            .name { font-size: 36px; }
            .title { font-size: 32px; }
            .footer { padding: 0 20px 20px; }
            .line { width: 100px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="container">
        <a class="logo" href="StudentDashboardServlet">
            <i class="bi bi-mortarboard-fill"></i>
            Edu<span style="color:#f97316">Stream</span>
        </a>
        <div>
            <span><i class="bi bi-person-circle"></i> <%= session.getAttribute("name") %></span>
        </div>
    </div>
</nav>

<div class="certificate-container">
    <div class="wrapper">
        <div class="certificate" id="certificate">
            <div class="corner-top"></div>
            <div class="corner-bottom"></div>

            <div class="gold-line gold1"></div>
            <div class="gold-line gold2"></div>
            <div class="gold-line gold3"></div>
            <div class="gold-line gold4"></div>

            <div class="inner-border"></div>
            <div class="watermark"></div>

            <div class="content">
                <div class="title">CERTIFICATE</div>
                <div class="subtitle">OF COURSE COMPLETION</div>

                <p>This is to certify that</p>

                <div class="name"><%= studentName %></div>

                <div class="divider"></div>

                <p class="desc">
                    has successfully completed the course
                    <b>“<%= courseName %>”</b>, demonstrating dedication,
                    commitment, and a strong understanding of the subject. This
                    achievement reflects the successful acquisition of essential
                    knowledge and practical skills.
                </p>

                <div class="date">Date of Completion: <b><%= issueDate %></b></div>

                <div class="seal">
                    <i class="bi bi-award-fill"></i>
                </div>

                <!-- SIGNATURE SECTION -->
                <div class="footer">
                    <div class="sign">
                        <div class="signature-text">Dr. Sarah Johnson</div>
                        <div class="line"></div>
                        <div class="label">Course Director</div>
                    </div>

                    <div class="sign">
                        <div class="signature-text">EduStream</div>
                        <div class="line"></div>
                        <div class="label">Certificate ID: <%= certificateCode %></div>
                    </div>

                    <div class="sign">
                        <div class="signature-text">Prof. Michael Chen</div>
                        <div class="line"></div>
                        <div class="label">Head of Academics</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Buttons -->
    <div class="text-center mt-4">
        <a href="CourseDetailsServlet?courseId=<%= courseId %>" class="btn-back">
            <i class="bi bi-arrow-left"></i> Back to Course
        </a>
        <button onclick="generatePDF()" class="btn-download">
            <i class="bi bi-download"></i> Download Certificate (PDF)
        </button>
    </div>
</div>

<script>
    async function generatePDF() {
        const element = document.getElementById("certificate");
        
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="bi bi-hourglass-split"></i> Generating PDF...';
        btn.disabled = true;
        
        try {
            const canvas = await html2canvas(element, {
                scale: 3,
                backgroundColor: '#ffffff',
                logging: false,
                useCORS: true
            });
            
            const imgData = canvas.toDataURL("image/png");
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('landscape', 'mm', 'a4');
            
            const imgWidth = 297;
            const imgHeight = canvas.height * imgWidth / canvas.width;
            
            pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
            pdf.save("EduStream_Certificate_<%= studentName.replace(" ", "_") %>.pdf");
        } catch (error) {
            console.error('PDF generation error:', error);
            alert('Error generating PDF. Please try again.');
        } finally {
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>