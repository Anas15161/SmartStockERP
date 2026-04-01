<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStock ERP | Management Console</title>
    
    <!-- External Assets -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <!-- System Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top mb-5">
        <div class="container-fluid px-lg-5">
            <a class="navbar-brand d-flex align-items-center fw-800" href="${pageContext.request.contextPath}/index.jsp">
                <img src="${pageContext.request.contextPath}/assets/logo.png" alt="SmartStock ERP" style="height: 32px;">
            </a>
            
            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#systemNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="systemNav">
                <ul class="navbar-nav mx-auto bg-glass-nav rounded-pill px-3 py-1 gap-1">
                    <li class="nav-item">
                        <a class="nav-link px-3 rounded-pill ${request.requestURI.contains('dashboard') ? 'active bg-soft-primary' : ''}" 
                           href="${pageContext.request.contextPath}/dashboard">
                            <i class="bi bi-grid-1x2 me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link px-3 rounded-pill ${request.requestURI.contains('products') ? 'active bg-soft-primary' : ''}" 
                           href="${pageContext.request.contextPath}/products">
                            <i class="bi bi-box2 me-2"></i>Inventory
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link px-3 rounded-pill ${request.requestURI.contains('suppliers') ? 'active bg-soft-primary' : ''}" 
                           href="${pageContext.request.contextPath}/suppliers">
                            <i class="bi bi-truck me-2"></i>Partners
                        </a>
                    </li>
                </ul>
                
                <div class="navbar-nav align-items-center">
                    <c:if test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <button class="btn btn-link text-decoration-none d-flex align-items-center gap-2 p-0 shadow-none" 
                                    type="button" data-bs-toggle="dropdown">
                                <div class="bg-soft-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                                    <i class="bi bi-person text-primary"></i>
                                </div>
                                <div class="text-start d-none d-xl-block">
                                    <div class="text-white small fw-bold lh-1">${sessionScope.user.split('@')[0]}</div>
                                    <div class="smallest text-dim opacity-75">Administrator</div>
                                </div>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end glass-card border-0 p-2 shadow-lg mt-3">
                                <li><a class="dropdown-item rounded-2 py-2 small" href="#"><i class="bi bi-gear me-2"></i>Settings</a></li>
                                <li><hr class="dropdown-divider opacity-10"></li>
                                <li><a class="dropdown-item rounded-2 py-2 small text-danger" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i>Logout</a>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </nav>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .bg-glass-nav { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.05); }
        .nav-link { font-size: 0.9rem; font-weight: 600; color: var(--text-dim) !important; transition: all 0.3s; }
        .nav-link:hover, .nav-link.active { color: var(--text-main) !important; }
        .smallest { font-size: 0.7rem; }
        .dropdown-item { color: var(--text-dim) !important; }
        .dropdown-item:hover { background: rgba(255,255,255,0.05) !important; color: var(--text-main) !important; }
    </style>
    <div class="container-fluid px-lg-5">
