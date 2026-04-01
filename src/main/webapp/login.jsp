<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStock ERP - Professional Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-blue: #0b5e9e;
            --secondary-green: #4caf50;
            --text-dark: #2c3e50;
        }
        body { 
            background: #f0f2f5;
            display: flex; 
            align-items: center; 
            justify-content: center; 
            min-height: 100vh; 
            margin: 0;
            font-family: 'Inter', sans-serif;
            overflow-x: hidden;
        }
        .main-container {
            width: 90%;
            max-width: 950px;
            background: white;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
            display: flex;
            overflow: hidden;
            animation: containerFadeIn 1s cubic-bezier(0.23, 1, 0.32, 1);
        }
        @keyframes containerFadeIn {
            from { opacity: 0; transform: translateY(30px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        
        /* Left Panel - Logo & Branding */
        .brand-panel {
            flex: 1;
            background: #fff;
            padding: 4rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            border-right: 1px solid #f0f0f0;
            position: relative;
        }
        .brand-panel::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle at 10% 10%, rgba(11, 94, 158, 0.03) 0%, transparent 50%);
            pointer-events: none;
        }
        .logo-img {
            max-width: 280px;
            height: auto;
            margin-bottom: 2rem;
            filter: drop-shadow(0 10px 15px rgba(0,0,0,0.05));
            animation: logoFloat 6s ease-in-out infinite;
        }
        @keyframes logoFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        /* Right Panel - Form */
        .form-panel {
            flex: 1;
            padding: 4rem;
            background: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .welcome-text {
            color: var(--text-dark);
            font-weight: 800;
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        .subtitle {
            color: #64748b;
            margin-bottom: 2.5rem;
        }
        .form-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: #64748b;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }
        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .form-control:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 4px rgba(11, 94, 158, 0.1);
            outline: none;
        }
        .btn-login {
            background: var(--primary-blue);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 1rem;
            font-weight: 700;
            font-size: 1rem;
            margin-top: 1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .btn-login:hover {
            background: #084a7d;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px -5px rgba(11, 94, 158, 0.4);
            color: white;
        }
        
        /* Mobile Responsive */
        @media (max-width: 850px) {
            .main-container { flex-direction: column; max-width: 450px; }
            .brand-panel { padding: 3rem 2rem; border-right: none; border-bottom: 1px solid #f0f0f0; }
            .form-panel { padding: 3rem 2rem; }
            .logo-img { max-width: 200px; }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Brand Side -->
        <div class="brand-panel">
            <img src="${pageContext.request.contextPath}/assets/logo.png" alt="SmartStock ERP Logo" class="logo-img">
            <div class="mt-2">
                <span class="badge rounded-pill px-3 py-2" style="background: rgba(11, 94, 158, 0.1); color: var(--primary-blue); font-weight: 600;">
                    v1.0 Enterprise
                </span>
            </div>
        </div>

        <!-- Login Side -->
        <div class="form-panel">
            <h1 class="welcome-text">Sign In</h1>
            <p class="subtitle">Enter your credentials to access the ERP dashboard.</p>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 d-flex align-items-center mb-4" style="background: #fef2f2; color: #991b1b; border-radius: 12px;">
                    <i class="bi bi-shield-exclamation me-2 fs-5"></i>
                    <small class="fw-bold">${error}</small>
                </div>
            </c:if>

            <form action="login" method="POST">
                <div class="mb-3">
                    <label class="form-label uppercase">EMAIL ADDRESS</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0" style="border-radius: 12px 0 0 12px; border: 2px solid #e2e8f0;">
                            <i class="bi bi-envelope text-muted"></i>
                        </span>
                        <input type="email" class="form-control border-start-0" name="email" required placeholder="admin@smartstock.com" style="border-radius: 0 12px 12px 0;">
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label">PASSWORD</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0" style="border-radius: 12px 0 0 12px; border: 2px solid #e2e8f0;">
                            <i class="bi bi-lock text-muted"></i>
                        </span>
                        <input type="password" class="form-control border-start-0" name="password" required placeholder="••••••••" style="border-radius: 0 12px 12px 0;">
                    </div>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-login">
                        ACCESS SYSTEM <i class="bi bi-arrow-right-short fs-4"></i>
                    </button>
                </div>
            </form>
            
            <div class="mt-5 text-center">
                <p class="text-muted small">© 2026 SmartStock ERP Systems. All rights reserved.</p>
            </div>
        </div>
    </div>
</body>
</html>
