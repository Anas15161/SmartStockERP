<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStock ERP - Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --accent-color: #3498db;
        }
        body { 
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex; 
            align-items: center; 
            justify-content: center; 
            min-height: 100vh; 
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-card { 
            width: 100%; 
            max-width: 420px; 
            padding: 2.5rem; 
            background: white; 
            border-radius: 16px; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
        }
        .brand-logo {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 0.8rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #1a252f;
            transform: translateY(-1px);
        }
        .form-control {
            padding: 0.8rem 1rem;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        .form-control:focus {
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
            border-color: var(--accent-color);
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="text-center mb-4">
            <div class="brand-logo">
                <i class="bi bi-box-seam"></i>
            </div>
            <h3 class="fw-bold text-dark">Welcome Back</h3>
            <p class="text-muted">Log in to manage your inventory</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <div>${error}</div>
            </div>
        </c:if>

        <form action="login" method="POST">
            <div class="mb-3">
                <label for="email" class="form-label small fw-bold text-uppercase text-muted">Email address</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                    <input type="email" class="form-control border-start-0" id="email" name="email" required placeholder="admin@smartstock.com">
                </div>
            </div>
            <div class="mb-4">
                <div class="d-flex justify-content-between">
                    <label for="password" class="form-label small fw-bold text-uppercase text-muted">Password</label>
                </div>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-lock text-muted"></i></span>
                    <input type="password" class="form-control border-start-0" id="password" name="password" required placeholder="admin123">
                </div>
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-primary mb-3">
                    Sign In
                </button>
            </div>
        </form>
        
        <div class="text-center">
            <hr class="my-4">
            <small class="text-muted">
                <i class="bi bi-info-circle me-1"></i> Demo: <b>admin@smartstock.com</b> / <b>admin123</b>
            </small>
        </div>
    </div>
</body>
</html>
