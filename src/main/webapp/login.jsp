<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | SmartStock ERP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: #f8fafc;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
            animation: slideUp 0.5s ease-out;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .logo-circle {
            width: 60px; height: 60px;
            background: var(--brand-blue);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 1.5rem;
            box-shadow: 0 10px 20px rgba(11, 94, 158, 0.2);
        }
    </style>
</head>
<body>
    <div class="login-card card border-0 p-5 shadow-lg">
        <div class="logo-circle">
            <i class="bi bi-box-seam-fill text-white fs-3"></i>
        </div>
        
        <h3 class="fw-800 text-center mb-1">System Login</h3>
        <p class="text-muted text-center small mb-4">SmartStock ERP Console v1.0</p>
        
        <c:if test="${not empty error}">
            <div class="alert bg-soft-danger border-0 text-danger small mb-4">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            </div>
        </c:if>

        <form action="login" method="POST">
            <div class="mb-3">
                <label class="form-label small fw-bold text-muted">EMAIL ADDRESS</label>
                <input type="email" class="form-control py-2" name="email" required 
                       placeholder="admin@smartstock.com">
            </div>
            
            <div class="mb-4">
                <label class="form-label small fw-bold text-muted">PASSWORD</label>
                <input type="password" class="form-control py-2" name="password" required 
                       placeholder="••••••••">
            </div>

            <button type="submit" class="btn btn-primary w-100 py-3 fw-bold mb-3 shadow-lg">
                SECURE LOGIN <i class="bi bi-shield-lock-fill ms-2"></i>
            </button>
            
            <div class="text-center">
                <a href="index.jsp" class="text-muted small text-decoration-none">
                    <i class="bi bi-arrow-left me-1"></i> Return to landing
                </a>
            </div>
        </form>
    </div>
</body>
</html>
