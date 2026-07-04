<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Module</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow" style="max-width: 600px; margin: 0 auto;">
        <div class="card-header bg-primary text-white">
            <h4>Add New Module</h4>
        </div>
        <div class="card-body">

            <form action="${pageContext.request.contextPath}/AddModuleServlet" method="post">
                
                <input type="hidden" name="courseId" value="<%= request.getParameter("courseId") %>">

                <div class="mb-3">
                    <label class="form-label">Module Name</label>
                    <input type="text" name="moduleName" class="form-control" placeholder="Enter module name" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="4" placeholder="Module description..."></textarea>
                </div>

                <button type="submit" class="btn btn-primary w-100">Add Module</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>