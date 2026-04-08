<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bons de commande — SmartStockERP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/sidebar.jsp"/>

<div class="main-content">
    <div class="topbar d-flex align-items-center justify-content-between px-4 py-3">
        <div>
            <h4 class="fw-bold mb-0">Bons de commande</h4>
            <p class="text-muted small mb-0">${totalItems} commande(s) au total</p>
        </div>
        <a href="${pageContext.request.contextPath}/purchase-orders?action=new"
           class="btn btn-primary rounded-pill px-4">
            <i class="bi bi-plus-lg me-2"></i>Nouveau bon de commande
        </a>
    </div>

    <div class="content-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger rounded-3">${error}</div>
        </c:if>

        <div class="card border-0 shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">N° Commande</th>
                            <th>Fournisseur</th>
                            <th>Date</th>
                            <th>Livraison prévue</th>
                            <th>Montant HT</th>
                            <th>Statut</th>
                            <th class="pe-4 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td class="ps-4">
                                    <a href="${pageContext.request.contextPath}/purchase-orders?action=view&id=${order.id}"
                                       class="fw-bold text-decoration-none text-primary">
                                        ${order.orderNumber}
                                    </a>
                                </td>
                                <td class="small">${order.supplier.name}</td>
                                <td class="small text-muted">${order.orderDate}</td>
                                <td class="small text-muted">${order.expectedDeliveryDate != null ? order.expectedDeliveryDate : '—'}</td>
                                <td class="fw-semibold small">
                                    <fmt:formatNumber value="${order.totalAmountHT}" type="number" maxFractionDigits="2"/> DH
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'DRAFT'}">
                                            <span class="badge badge-status-draft rounded-pill px-3">Brouillon</span>
                                        </c:when>
                                        <c:when test="${order.status == 'SENT'}">
                                            <span class="badge badge-status-sent rounded-pill px-3">Envoyé</span>
                                        </c:when>
                                        <c:when test="${order.status == 'PARTIALLY_RECEIVED'}">
                                            <span class="badge badge-status-partially rounded-pill px-3">Partiel</span>
                                        </c:when>
                                        <c:when test="${order.status == 'RECEIVED'}">
                                            <span class="badge badge-status-received rounded-pill px-3">Reçu</span>
                                        </c:when>
                                        <c:when test="${order.status == 'CANCELLED'}">
                                            <span class="badge badge-status-cancelled rounded-pill px-3">Annulé</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td class="pe-4 text-end">
                                    <a href="${pageContext.request.contextPath}/purchase-orders?action=view&id=${order.id}"
                                       class="btn btn-sm btn-light rounded-pill me-1" title="Voir le détail">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <c:if test="${order.status == 'DRAFT' || order.status == 'SENT'}">
                                        <a href="${pageContext.request.contextPath}/reports?type=purchase-order&id=${order.id}"
                                           class="btn btn-sm btn-light rounded-pill" title="Télécharger PDF" target="_blank">
                                            <i class="bi bi-file-earmark-pdf text-danger"></i>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orders}">
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-file-earmark-x fs-1 opacity-25 d-block mb-2"></i>
                                    Aucun bon de commande trouvé.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <%-- Pagination --%>
            <c:if test="${totalPages > 1}">
                <div class="card-footer bg-white border-0 py-3">
                    <nav>
                        <ul class="pagination pagination-sm justify-content-center mb-0">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link rounded-circle mx-1"
                                       href="${pageContext.request.contextPath}/purchase-orders?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
