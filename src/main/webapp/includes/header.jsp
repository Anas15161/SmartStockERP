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
    <style>
        :root {
            --brand-blue: ${appSettings.theme_color != null ? appSettings.theme_color : '#0b5e9e'};
            --brand-blue-dark: ${appSettings.theme_color != null ? appSettings.theme_color : '#074a7d'};
        }
    </style>
</head>
<body>
    <!-- System Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top mb-5" style="background: var(--brand-blue-dark) !important; border-bottom: 3px solid var(--brand-green); padding: 12px 0;">
        <div class="container-fluid px-lg-5">
            <a class="navbar-brand d-flex align-items-center fw-800" href="${pageContext.request.contextPath}/index.jsp">
                <img src="${pageContext.request.contextPath}/assets/logo.png" alt="SmartStock ERP" style="height: 36px;">
            </a>
            
            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#systemNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="systemNav">
                <ul class="navbar-nav mx-auto bg-glass-nav rounded-pill px-3 py-1 gap-1">
<%--                    <li class="nav-item">--%>
<%--                        <a class="nav-link px-3 rounded-pill" --%>
<%--                           href="${pageContext.request.contextPath}/presentation.jsp">--%>
<%--                            <i class="bi bi-display me-2"></i>Présentation--%>
<%--                        </a>--%>
<%--                    </li>--%>
                    <li class="nav-item">
                        <a class="nav-link px-3 rounded-pill" 
                           href="${pageContext.request.contextPath}/documentation.jsp">
                            <i class="bi bi-journal-code me-2"></i>Documentation
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link px-3 rounded-pill ${request.requestURI.contains('dashboard') ? 'active bg-success' : ''}" 
                           href="${pageContext.request.contextPath}/dashboard">
                            <i class="bi bi-grid-1x2 me-2"></i>Terminal
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link px-3 rounded-pill ${request.requestURI.contains('products') ? 'active bg-success' : ''}" 
                           href="${pageContext.request.contextPath}/products">
                            <i class="bi bi-box2 me-2"></i>Inventory
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link px-3 rounded-pill ${request.requestURI.contains('suppliers') ? 'active bg-success' : ''}" 
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
                                <div class="bg-success rounded-circle d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; box-shadow: 0 0 15px rgba(34, 197, 94, 0.3);">
                                    <i class="bi bi-person text-white"></i>
                                </div>
                                <div class="text-start d-none d-xl-block">
                                    <div class="text-white small fw-bold lh-1">${sessionScope.user.split('@')[0]}</div>
                                    <div class="smallest text-white opacity-75">Administrator</div>
                                </div>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end glass-card border-0 p-2 shadow-lg mt-3">
                                <li><a class="dropdown-item rounded-2 py-2 small ${request.requestURI.contains('settings') ? 'active bg-success text-white' : ''}" 
                                       href="${pageContext.request.contextPath}/settings">
                                    <i class="bi bi-gear me-2"></i>Settings</a>
                                </li>
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
