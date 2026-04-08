<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord — SmartStockERP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>

<%-- Sidebar de navigation --%>
<jsp:include page="/WEB-INF/views/fragments/sidebar.jsp"/>

<div class="main-content">
    <%-- Topbar --%>
    <div class="topbar d-flex align-items-center justify-content-between px-4 py-3">
        <div>
            <h4 class="fw-bold mb-0">Tableau de bord</h4>
            <p class="text-muted small mb-0">Bienvenue, <strong>${currentUser.fullName}</strong> — Vue d'ensemble de votre inventaire</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/reports?type=inventory" target="_blank"
               class="btn btn-outline-primary btn-sm rounded-pill">
                <i class="bi bi-download me-1"></i> Rapport PDF
            </a>
            <a href="${pageContext.request.contextPath}/products?action=new"
               class="btn btn-primary btn-sm rounded-pill">
                <i class="bi bi-plus-lg me-1"></i> Nouveau produit
            </a>
        </div>
    </div>

    <div class="content-body px-4 pb-5">

        <%-- Alertes actives --%>
        <c:if test="${outOfStockCount > 0}">
            <div class="alert alert-danger d-flex align-items-center rounded-3 mb-4" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-3 fs-4"></i>
                <div>
                    <strong>${outOfStockCount} produit(s) en rupture de stock !</strong>
                    <a href="${pageContext.request.contextPath}/products?status=out" class="alert-link ms-2">Voir les produits →</a>
                </div>
            </div>
        </c:if>
        <c:if test="${lowStockCount > 0 && outOfStockCount == 0}">
            <div class="alert alert-warning d-flex align-items-center rounded-3 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-3 fs-4"></i>
                <div>
                    <strong>${lowStockCount} produit(s) avec un stock faible.</strong>
                    <a href="${pageContext.request.contextPath}/products?status=low" class="alert-link ms-2">Voir les alertes →</a>
                </div>
            </div>
        </c:if>

        <%-- Cartes de statistiques --%>
        <div class="row g-4 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="stat-card stat-card-blue">
                    <div class="stat-icon"><i class="bi bi-box-seam"></i></div>
                    <div class="stat-value">${totalProducts}</div>
                    <div class="stat-label">Produits en catalogue</div>
                    <a href="${pageContext.request.contextPath}/products" class="stat-link">Gérer →</a>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="stat-card stat-card-green">
                    <div class="stat-icon"><i class="bi bi-truck"></i></div>
                    <div class="stat-value">${totalSuppliers}</div>
                    <div class="stat-label">Fournisseurs actifs</div>
                    <a href="${pageContext.request.contextPath}/suppliers" class="stat-link">Gérer →</a>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="stat-card ${outOfStockCount > 0 ? 'stat-card-red' : (lowStockCount > 0 ? 'stat-card-orange' : 'stat-card-green')}">
                    <div class="stat-icon"><i class="bi bi-exclamation-triangle"></i></div>
                    <div class="stat-value">${lowStockCount + outOfStockCount}</div>
                    <div class="stat-label">Alertes de stock</div>
                    <a href="${pageContext.request.contextPath}/products?status=low" class="stat-link">Voir →</a>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="stat-card stat-card-purple">
                    <div class="stat-icon"><i class="bi bi-currency-dollar"></i></div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${totalStockValue}" type="number" maxFractionDigits="0"/>
                    </div>
                    <div class="stat-label">Valeur totale du stock (DH)</div>
                    <a href="${pageContext.request.contextPath}/reports?type=inventory" target="_blank" class="stat-link">Rapport →</a>
                </div>
            </div>
        </div>

        <%-- Ligne principale : Graphiques + Alertes --%>
        <div class="row g-4 mb-4">

            <%-- Graphique : Répartition du stock --%>
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-header bg-white border-0 py-3">
                        <h6 class="fw-bold mb-0"><i class="bi bi-pie-chart me-2 text-primary"></i>Répartition du stock</h6>
                    </div>
                    <div class="card-body d-flex align-items-center justify-content-center">
                        <canvas id="stockStatusChart" style="max-height: 260px;"></canvas>
                    </div>
                </div>
            </div>

            <%-- Produits en alerte --%>
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h6 class="fw-bold mb-0"><i class="bi bi-exclamation-triangle me-2 text-warning"></i>Produits en alerte</h6>
                        <a href="${pageContext.request.contextPath}/products?status=low" class="btn btn-sm btn-link text-primary fw-semibold text-decoration-none">Voir tout</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4 smallest text-uppercase text-muted">Produit</th>
                                    <th class="smallest text-uppercase text-muted">Stock</th>
                                    <th class="smallest text-uppercase text-muted">Seuil</th>
                                    <th class="pe-4 text-end smallest text-uppercase text-muted">Statut</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${lowStockProducts}" end="7">
                                    <tr>
                                        <td class="ps-4">
                                            <div class="fw-semibold small">${p.label}</div>
                                            <div class="text-muted" style="font-size:0.7rem">${p.supplier.name}</div>
                                        </td>
                                        <td><span class="badge bg-warning text-dark rounded-pill">${p.stockQuantity}</span></td>
                                        <td class="text-muted small">${p.alertThreshold}</td>
                                        <td class="pe-4 text-end">
                                            <a href="${pageContext.request.contextPath}/purchase-orders?action=new"
                                               class="btn btn-sm btn-outline-primary rounded-pill px-3" style="font-size:0.7rem">
                                                Commander
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:forEach var="p" items="${outOfStockProducts}" end="3">
                                    <tr>
                                        <td class="ps-4">
                                            <div class="fw-semibold small">${p.label}</div>
                                            <div class="text-muted" style="font-size:0.7rem">${p.supplier.name}</div>
                                        </td>
                                        <td><span class="badge bg-danger rounded-pill">0</span></td>
                                        <td class="text-muted small">${p.alertThreshold}</td>
                                        <td class="pe-4 text-end">
                                            <span class="badge bg-danger rounded-pill" style="font-size:0.7rem">RUPTURE</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty lowStockProducts && empty outOfStockProducts}">
                                    <tr>
                                        <td colspan="4" class="text-center py-5 text-muted">
                                            <i class="bi bi-check2-circle fs-1 text-success opacity-50 d-block mb-2"></i>
                                            <span class="small">Tous les niveaux de stock sont sains.</span>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%-- Ligne secondaire : Bons de commande + Mouvements récents --%>
        <div class="row g-4">

            <%-- Bons de commande en attente --%>
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h6 class="fw-bold mb-0"><i class="bi bi-file-earmark-text me-2 text-info"></i>Commandes en attente</h6>
                        <span class="badge bg-info rounded-pill">${pendingOrders}</span>
                    </div>
                    <div class="card-body">
                        <c:if test="${pendingOrders == 0}">
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-check-circle fs-2 text-success opacity-50 d-block mb-2"></i>
                                <span class="small">Aucune commande en attente.</span>
                            </div>
                        </c:if>
                        <c:if test="${pendingOrders > 0}">
                            <p class="text-muted small">
                                <strong>${pendingOrders}</strong> bon(s) de commande nécessitent une action.
                            </p>
                        </c:if>
                        <div class="d-grid gap-2 mt-3">
                            <a href="${pageContext.request.contextPath}/purchase-orders"
                               class="btn btn-outline-info btn-sm rounded-pill">
                                <i class="bi bi-list-ul me-1"></i> Voir toutes les commandes
                            </a>
                            <a href="${pageContext.request.contextPath}/purchase-orders?action=new"
                               class="btn btn-info btn-sm rounded-pill text-white">
                                <i class="bi bi-plus-lg me-1"></i> Nouveau bon de commande
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Derniers mouvements de stock --%>
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h6 class="fw-bold mb-0"><i class="bi bi-arrow-left-right me-2 text-secondary"></i>Derniers mouvements de stock</h6>
                        <a href="${pageContext.request.contextPath}/stock-movements" class="btn btn-sm btn-link text-primary fw-semibold text-decoration-none">Voir tout</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4 smallest text-uppercase text-muted">Produit</th>
                                    <th class="smallest text-uppercase text-muted">Type</th>
                                    <th class="smallest text-uppercase text-muted">Quantité</th>
                                    <th class="smallest text-uppercase text-muted">Date</th>
                                    <th class="pe-4 smallest text-uppercase text-muted">Référence</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="mv" items="${recentMovements}">
                                    <tr>
                                        <td class="ps-4 small fw-semibold">${mv.product.label}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${mv.movementType == 'ENTRY'}">
                                                    <span class="badge bg-success rounded-pill">
                                                        <i class="bi bi-arrow-down-circle me-1"></i>Entrée
                                                    </span>
                                                </c:when>
                                                <c:when test="${mv.movementType == 'EXIT'}">
                                                    <span class="badge bg-danger rounded-pill">
                                                        <i class="bi bi-arrow-up-circle me-1"></i>Sortie
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary rounded-pill">Ajustement</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="small fw-bold">${mv.quantity}</td>
                                        <td class="small text-muted">
                                            <fmt:formatDate value="${mv.movementDate}" pattern="dd/MM/yyyy HH:mm"
                                                            type="both"/>
                                        </td>
                                        <td class="pe-4 small text-muted">${mv.reference}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentMovements}">
                                    <tr>
                                        <td colspan="5" class="text-center py-4 text-muted small">
                                            Aucun mouvement de stock enregistré.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div><%-- fin content-body --%>
</div><%-- fin main-content --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script>
    // ---- Graphique en donut : Répartition du stock ----
    const totalProducts  = ${totalProducts};
    const lowStockCount  = ${lowStockCount};
    const outStockCount  = ${outOfStockCount};
    const healthyCount   = Math.max(0, totalProducts - lowStockCount - outStockCount);

    const ctx = document.getElementById('stockStatusChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Stock sain', 'Stock faible', 'Rupture de stock'],
            datasets: [{
                data: [healthyCount, lowStockCount, outStockCount],
                backgroundColor: ['#16a34a', '#f59e0b', '#dc2626'],
                borderColor: ['#fff', '#fff', '#fff'],
                borderWidth: 3,
                hoverOffset: 8
            }]
        },
        options: {
            responsive: true,
            cutout: '65%',
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { padding: 16, font: { size: 12 } }
                },
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
                            const pct = total > 0 ? ((ctx.parsed / total) * 100).toFixed(1) : 0;
                            return ` ${ctx.label}: ${ctx.parsed} (${pct}%)`;
                        }
                    }
                }
            }
        }
    });
</script>
</body>
</html>
