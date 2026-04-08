<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau bon de commande — SmartStockERP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/sidebar.jsp"/>

<div class="main-content">
    <div class="topbar d-flex align-items-center px-4 py-3">
        <a href="${pageContext.request.contextPath}/purchase-orders" class="btn btn-light btn-sm rounded-pill me-3">
            <i class="bi bi-arrow-left"></i>
        </a>
        <div>
            <h4 class="fw-bold mb-0">Nouveau bon de commande</h4>
            <p class="text-muted small mb-0">Créer une commande fournisseur</p>
        </div>
    </div>

    <div class="content-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger rounded-3 mb-4">${error}</div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/purchase-orders" method="POST">
                            <input type="hidden" name="action" value="create">

                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Fournisseur <span class="text-danger">*</span></label>
                                <select name="supplierId" class="form-select" required>
                                    <option value="">— Sélectionner un fournisseur —</option>
                                    <c:forEach var="s" items="${listSuppliers}">
                                        <option value="${s.id}">${s.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Date de livraison prévue</label>
                                <input type="date" name="expectedDeliveryDate" class="form-control"
                                       min="${java.time.LocalDate.now()}">
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Notes / Observations</label>
                                <textarea name="notes" class="form-control" rows="3"
                                          placeholder="Instructions spéciales, conditions de livraison..."></textarea>
                            </div>

                            <div class="d-flex gap-2 justify-content-end">
                                <a href="${pageContext.request.contextPath}/purchase-orders"
                                   class="btn btn-light rounded-pill px-4">Annuler</a>
                                <button type="submit" class="btn btn-primary rounded-pill px-4">
                                    <i class="bi bi-check-lg me-2"></i>Créer le bon de commande
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
