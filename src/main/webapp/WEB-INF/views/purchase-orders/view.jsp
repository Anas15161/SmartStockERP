<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bon de commande ${order.orderNumber} — SmartStockERP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/sidebar.jsp"/>

<div class="main-content">
    <div class="topbar d-flex align-items-center justify-content-between px-4 py-3">
        <div class="d-flex align-items-center">
            <a href="${pageContext.request.contextPath}/purchase-orders" class="btn btn-light btn-sm rounded-pill me-3">
                <i class="bi bi-arrow-left"></i>
            </a>
            <div>
                <h4 class="fw-bold mb-0">Bon de commande — ${order.orderNumber}</h4>
                <p class="text-muted small mb-0">Fournisseur : <strong>${order.supplier.name}</strong></p>
            </div>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/reports?type=purchase-order&id=${order.id}"
               class="btn btn-outline-danger btn-sm rounded-pill" target="_blank">
                <i class="bi bi-file-earmark-pdf me-1"></i> PDF
            </a>
            <c:if test="${order.status == 'DRAFT'}">
                <a href="${pageContext.request.contextPath}/purchase-orders?action=submit&id=${order.id}"
                   class="btn btn-primary btn-sm rounded-pill"
                   onclick="return confirm('Confirmer l\'envoi de ce bon de commande ?')">
                    <i class="bi bi-send me-1"></i> Envoyer
                </a>
            </c:if>
            <c:if test="${order.status == 'SENT' || order.status == 'PARTIALLY_RECEIVED'}">
                <a href="${pageContext.request.contextPath}/purchase-orders?action=receive&id=${order.id}"
                   class="btn btn-success btn-sm rounded-pill"
                   onclick="return confirm('Confirmer la réception complète de cette commande ?')">
                    <i class="bi bi-check-all me-1"></i> Marquer reçu
                </a>
            </c:if>
            <c:if test="${order.status == 'DRAFT'}">
                <a href="${pageContext.request.contextPath}/purchase-orders?action=cancel&id=${order.id}"
                   class="btn btn-outline-danger btn-sm rounded-pill"
                   onclick="return confirm('Annuler définitivement ce bon de commande ?')">
                    <i class="bi bi-x-circle me-1"></i> Annuler
                </a>
            </c:if>
        </div>
    </div>

    <div class="content-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger rounded-3 mb-4">${error}</div>
        </c:if>

        <div class="row g-4">
            <%-- Informations du bon de commande --%>
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-white border-0 py-3">
                        <h6 class="fw-bold mb-0"><i class="bi bi-info-circle me-2 text-primary"></i>Informations</h6>
                    </div>
                    <div class="card-body">
                        <table class="table table-sm mb-0">
                            <tr>
                                <td class="text-muted small">N° Commande</td>
                                <td class="fw-bold small">${order.orderNumber}</td>
                            </tr>
                            <tr>
                                <td class="text-muted small">Statut</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'DRAFT'}"><span class="badge badge-status-draft rounded-pill">Brouillon</span></c:when>
                                        <c:when test="${order.status == 'SENT'}"><span class="badge badge-status-sent rounded-pill">Envoyé</span></c:when>
                                        <c:when test="${order.status == 'PARTIALLY_RECEIVED'}"><span class="badge badge-status-partially rounded-pill">Partiel</span></c:when>
                                        <c:when test="${order.status == 'RECEIVED'}"><span class="badge badge-status-received rounded-pill">Reçu</span></c:when>
                                        <c:when test="${order.status == 'CANCELLED'}"><span class="badge badge-status-cancelled rounded-pill">Annulé</span></c:when>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted small">Fournisseur</td>
                                <td class="small">${order.supplier.name}</td>
                            </tr>
                            <tr>
                                <td class="text-muted small">Date commande</td>
                                <td class="small">${order.orderDate}</td>
                            </tr>
                            <tr>
                                <td class="text-muted small">Livraison prévue</td>
                                <td class="small">${order.expectedDeliveryDate != null ? order.expectedDeliveryDate : '—'}</td>
                            </tr>
                            <tr>
                                <td class="text-muted small">Montant HT</td>
                                <td class="fw-bold small">
                                    <fmt:formatNumber value="${order.totalAmountHT}" type="number" maxFractionDigits="2"/> DH
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted small">TVA (${order.taxRate}%)</td>
                                <td class="small">
                                    <fmt:formatNumber value="${order.totalAmountHT * order.taxRate / 100}" type="number" maxFractionDigits="2"/> DH
                                </td>
                            </tr>
                            <tr class="table-primary">
                                <td class="fw-bold small">Total TTC</td>
                                <td class="fw-bold small">
                                    <fmt:formatNumber value="${order.totalAmountHT * (1 + order.taxRate / 100)}" type="number" maxFractionDigits="2"/> DH
                                </td>
                            </tr>
                        </table>
                        <c:if test="${not empty order.notes}">
                            <hr>
                            <p class="small text-muted mb-0"><strong>Notes :</strong> ${order.notes}</p>
                        </c:if>
                    </div>
                </div>
            </div>

            <%-- Lignes de commande --%>
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h6 class="fw-bold mb-0"><i class="bi bi-list-ul me-2 text-secondary"></i>Lignes de commande</h6>
                        <c:if test="${order.status == 'DRAFT'}">
                            <button class="btn btn-sm btn-outline-primary rounded-pill" data-bs-toggle="modal" data-bs-target="#addItemModal">
                                <i class="bi bi-plus-lg me-1"></i> Ajouter un produit
                            </button>
                        </c:if>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">Produit</th>
                                    <th>Qté commandée</th>
                                    <th>Qté reçue</th>
                                    <th>Prix unitaire</th>
                                    <th class="pe-4 text-end">Sous-total HT</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.items}">
                                    <tr>
                                        <td class="ps-4 small fw-semibold">${item.product.label}</td>
                                        <td class="small">${item.quantityOrdered}</td>
                                        <td class="small">
                                            <c:choose>
                                                <c:when test="${item.quantityReceived == item.quantityOrdered}">
                                                    <span class="text-success fw-bold">${item.quantityReceived}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-warning">${item.quantityReceived}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="small">
                                            <fmt:formatNumber value="${item.unitPrice}" type="number" maxFractionDigits="2"/> DH
                                        </td>
                                        <td class="pe-4 text-end fw-bold small">
                                            <fmt:formatNumber value="${item.quantityOrdered * item.unitPrice}" type="number" maxFractionDigits="2"/> DH
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty order.items}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted small">
                                            Aucun produit ajouté. Cliquez sur "Ajouter un produit".
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Modal : Ajouter un produit --%>
<div class="modal fade" id="addItemModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/purchase-orders" method="POST">
                <input type="hidden" name="action" value="addItem">
                <input type="hidden" name="orderId" value="${order.id}">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Ajouter un produit</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Produit <span class="text-danger">*</span></label>
                        <select name="productId" class="form-select" required>
                            <option value="">— Sélectionner un produit —</option>
                            <c:forEach var="p" items="${listProducts}">
                                <option value="${p.id}">${p.label} (Réf: ${p.reference})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row g-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold small">Quantité <span class="text-danger">*</span></label>
                            <input type="number" name="quantityOrdered" class="form-control" min="1" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold small">Prix unitaire HT (DH) <span class="text-danger">*</span></label>
                            <input type="number" name="unitPrice" class="form-control" min="0.01" step="0.01" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">
                        <i class="bi bi-plus-lg me-1"></i> Ajouter
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
