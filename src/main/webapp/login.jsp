<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | SmartStock ERP Enterprise</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            background: #f8fafc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 100%;
            background: linear-gradient(135deg, rgba(11, 94, 158, 0.05) 0%, rgba(34, 197, 94, 0.05) 100%);
            z-index: -1;
        }

        .login-container {
            width: 100%;
            max-width: 1000px;
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            background: white;
            border-radius: 32px;
            overflow: hidden;
            box-shadow: 0 40px 100px rgba(0,0,0,0.1);
        }

        @media (max-width: 992px) {
            .login-container { grid-template-columns: 1fr; }
            .login-visual { display: none; }
        }

        .login-visual {
            background: url('https://images.unsplash.com/photo-1494412651409-8963ce7935a7?q=80&w=2070&auto=format&fit=crop') center/cover;
            position: relative;
            padding: 4rem;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            color: white;
        }

        .login-visual::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(7, 74, 125, 0.9), transparent);
        }

        .visual-content {
            position: relative;
            z-index: 2;
        }

        .login-form-side {
            padding: 4rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px 16px;
            background: #f1f5f9 !important;
            border: 2px solid transparent !important;
            transition: var(--transition-smooth);
        }

        .form-control:focus {
            background: white !important;
            border-color: var(--brand-blue) !important;
            box-shadow: none !important;
        }

        .brand-logo {
            height: 48px;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <div class="login-container animate-fade-up">
        <div class="login-visual">
            <div class="visual-content">
                <h2 class="fw-800 display-6">Global Logistics <br> Under Control.</h2>
                <p class="opacity-75 lead">The definitive J2EE foundation for the next generation of warehouse ecosystems.</p>
            </div>
        </div>
        
        <div class="login-form-side">
            <div class="text-center text-lg-start">
                <img src="${pageContext.request.contextPath}/assets/logo.png" alt="SmartStock ERP" class="brand-logo">
                <h3 class="fw-800 mb-1">Terminal Login</h3>
                <p class="text-muted small mb-4">Authorized Personnel Only • v1.0.4-LTS</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert bg-soft-danger border-0 text-danger small mb-4 py-3 rounded-4">
                    <i class="bi bi-shield-exclamation me-2 fs-5"></i> ${error}
                </div>
            </c:if>

            <form action="login" method="POST">
                <div class="mb-3">
                    <label class="form-label smallest fw-800 text-muted text-uppercase tracking-wider">Authentication Email</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-0 pe-0"><i class="bi bi-envelope text-muted"></i></span>
                        <input type="email" class="form-control" name="email" required 
                               placeholder="admin@smartstock.com">
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="form-label smallest fw-800 text-muted text-uppercase tracking-wider">Security Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-0 pe-0"><i class="bi bi-key text-muted"></i></span>
                        <input type="password" class="form-control" name="password" required 
                               placeholder="••••••••">
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-3 fw-bold mb-4 shadow-lg">
                    INITIALIZE SESSION <i class="bi bi-cpu ms-2"></i>
                </button>
                
                <div class="text-center">
                    <a href="index.jsp" class="text-muted small text-decoration-none hover-blue">
                        <i class="bi bi-arrow-left me-1"></i> Return to Infrastructure Overview
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
