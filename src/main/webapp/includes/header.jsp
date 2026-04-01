<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartStock ERP - Product Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .navbar-brand { font-size: 1.4rem; color: #fff !important; }
        .nav-link { font-weight: 500; opacity: 0.9; }
        .nav-link:hover { opacity: 1; color: var(--secondary-green) !important; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark shadow-lg sticky-top mb-4">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-box-seam-fill me-2" style="color: var(--secondary-green);"></i>SMARTSTOCK ERP
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">
                        <i class="bi bi-grid-3x3-gap me-1"></i>Products
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/suppliers">
                        <i class="bi bi-truck me-1"></i>Suppliers
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
