<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartStock ERP - Product Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-top: 2rem; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-box-seam me-2"></i>SmartStock ERP
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">
                        <i class="bi bi-grid-3x3-gap me-1"></i>Products
                    </a>
                </li>
            </ul>
            <div class="navbar-nav align-items-center">
                <c:if test="${not empty sessionScope.user}">
                    <span class="navbar-text me-3 text-light opacity-75">
                        <i class="bi bi-person-circle me-1"></i>${sessionScope.user}
                    </span>
                    <a class="btn btn-outline-light btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right me-1"></i>Logout
                    </a>
                </c:if>
                <c:if test="${empty sessionScope.user}">
                    <a class="btn btn-primary btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/login">
                        Login
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</nav>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<div class="container">
