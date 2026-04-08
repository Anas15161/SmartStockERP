<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mouvements de stock — SmartStockERP</title>
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
            <h4 class="fw-bold mb-0">Historique des mouvements de stock</h4>
            <p class="text-muted small mb-0">${totalItems} mouvement(s) enregistré(s)</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/reports?type=movements" target="_blank"
               class="btn btn-outline-danger btn-sm rounded-pill">
                <i class="bi bi-file-earmark-pdf me-1"></i> Rapport PDF
            </a>
            <a href="${pageContext.request.contextPath}/stock-movements?action=new"
               class="btn btn-primary btn-sm rounded-pill">
                <i class="bi bi-plus-lg me-1"></i> Saisir un mouvement
            </a>
        </div>
    </div>

    <div class="content-body">

        <%-- Filtres --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body py-3">
                <form method="GET" action="${pageContext.request.contextPath}/stock-movements" class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label fw-semibold small mb-1">Filtrer par produit</label>
                        <select name="productId" class="form-select form-select-sm">
                            <option value="">— Tous les produits —</option>
                            <c:forEach var="p" items="${listProducts}">
                                <option value="${p.id}"
                                    ${selectedProduct != null && selectedProduct.id == p.id ? 'selected' : ''}>
                                    ${p.label}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-4">
                            <i class="bi bi-funnel me-1"></i> Filtrer
                        </button>
                        <a href="${pageContext.request.contextPath}/stock-movements" class="btn btn-light btn-sm rounded-pill ms-2">
                            Réinitialiser
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <%-- Tableau des mouvements --%>
        <div class="card border-0 shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Produit</th>
                            <th>Type</th>
                            <th>Quantité</th>
                            <th>Stock avant</th>
                            <th>Stock après</th>
                            <th>Date</th>
                            <th>Référence</th>
                            <th class="pe-4">Opérateur</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="mv" items="${movements}">
                            <tr>
                                <td class="ps-4">
                                    <div class="fw-semibold small">${mv.product.label}</div>
                                    <div class="text-muted" style="font-size:0.7rem">${mv.product.reference}</div>
                                </td>
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
                                            <span class="badge bg-secondary rounded-pill">
                                                <i class="bi bi-pencil me-1"></i>Ajustement
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="fw-bold small">
                                    <c:choose>
                                        <c:when test="${mv.movementType == 'ENTRY'}">
                                            <span class="text-success">+${mv.quantity}</span>
                                        </c:when>
                                        <c:when test="${mv.movementType == 'EXIT'}">
                                            <span class="text-danger">-${mv.quantity}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-secondary">${mv.quantity}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="small text-muted">${mv.quantityBefore}</td>
                                <td class="small fw-semibold">${mv.quantityAfter}</td>
                                <td class="small text-muted">
                                    <fmt:formatDate value="${mv.movementDate}" pattern="dd/MM/yyyy" type="date"/>
                                    <br><small class="text-muted opacity-75">
                                        <fmt:formatDate value="${mv.movementDate}" pattern="HH:mm" type="time"/>
                                    </small>
                                </td>
                                <td class="small text-muted">${mv.reference != null ? mv.reference : '—'}</td>
                                <td class="pe-4 small text-muted">
                                    ${mv.performedBy != null ? mv.performedBy.fullName : 'Système'}
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty movements}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1 opacity-25 d-block mb-2"></i>
                                    Aucun mouvement de stock enregistré.
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
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link rounded-pill me-1"
                                   href="${pageContext.request.contextPath}/stock-movements?page=${currentPage - 1}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link rounded-circle mx-1"
                                       href="${pageContext.request.contextPath}/stock-movements?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link rounded-pill ms-1"
                                   href="${pageContext.request.contextPath}/stock-movements?page=${currentPage + 1}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
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
