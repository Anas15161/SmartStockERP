<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Fragment de navigation latérale commun à toutes les pages protégées --%>
<nav class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-brand">
            <img src="${pageContext.request.contextPath}/assets/logo.png" alt="SmartStock" class="brand-logo-sm">
            <span class="brand-text">SmartStock<span class="text-primary">ERP</span></span>
        </a>
        <button class="sidebar-toggle d-lg-none" id="sidebarToggle">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>

    <div class="sidebar-user">
        <div class="user-avatar">
            <i class="bi bi-person-circle fs-2 text-primary"></i>
        </div>
        <div class="user-info">
            <div class="user-name fw-bold small">${currentUser.fullName}</div>
            <div class="user-role badge bg-soft-primary text-primary smallest">${currentUser.role.name}</div>
        </div>
    </div>

    <ul class="sidebar-nav">
        <li class="nav-section-title">PRINCIPAL</li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/dashboard"
               class="nav-link ${pageContext.request.servletPath.contains('dashboard') ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i>
                <span>Tableau de bord</span>
            </a>
        </li>

        <li class="nav-section-title">INVENTAIRE</li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/products"
               class="nav-link ${pageContext.request.servletPath.contains('product') ? 'active' : ''}">
                <i class="bi bi-box-seam"></i>
                <span>Produits</span>
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/stock-movements"
               class="nav-link ${pageContext.request.servletPath.contains('stock-movement') ? 'active' : ''}">
                <i class="bi bi-arrow-left-right"></i>
                <span>Mouvements de stock</span>
            </a>
        </li>

        <li class="nav-section-title">ACHATS</li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/suppliers"
               class="nav-link ${pageContext.request.servletPath.contains('supplier') ? 'active' : ''}">
                <i class="bi bi-truck"></i>
                <span>Fournisseurs</span>
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/purchase-orders"
               class="nav-link ${pageContext.request.servletPath.contains('purchase-order') ? 'active' : ''}">
                <i class="bi bi-file-earmark-text"></i>
                <span>Bons de commande</span>
            </a>
        </li>

        <li class="nav-section-title">RAPPORTS</li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/reports?type=inventory"
               class="nav-link" target="_blank">
                <i class="bi bi-file-earmark-pdf"></i>
                <span>Rapport inventaire</span>
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/reports?type=low-stock"
               class="nav-link" target="_blank">
                <i class="bi bi-exclamation-triangle"></i>
                <span>Alertes de stock</span>
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/reports?type=movements"
               class="nav-link" target="_blank">
                <i class="bi bi-graph-up-arrow"></i>
                <span>Rapport mouvements</span>
            </a>
        </li>

        <c:if test="${currentUser.role.name == 'ADMIN'}">
            <li class="nav-section-title">ADMINISTRATION</li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/settings" class="nav-link">
                    <i class="bi bi-gear"></i>
                    <span>Paramètres</span>
                </a>
            </li>
        </c:if>
    </ul>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
            <i class="bi bi-box-arrow-left"></i>
            <span>Déconnexion</span>
        </a>
    </div>
</nav>
