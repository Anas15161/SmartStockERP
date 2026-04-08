<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saisir un mouvement — SmartStockERP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/sidebar.jsp"/>

<div class="main-content">
    <div class="topbar d-flex align-items-center px-4 py-3">
        <a href="${pageContext.request.contextPath}/stock-movements" class="btn btn-light btn-sm rounded-pill me-3">
            <i class="bi bi-arrow-left"></i>
        </a>
        <div>
            <h4 class="fw-bold mb-0">Saisir un mouvement de stock</h4>
            <p class="text-muted small mb-0">Enregistrer une entrée ou une sortie de stock</p>
        </div>
    </div>

    <div class="content-body">
        <c:if test="${not empty error}">
            <div class="alert alert-danger rounded-3 mb-4">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/stock-movements" method="POST">

                            <%-- Type de mouvement --%>
                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Type de mouvement <span class="text-danger">*</span></label>
                                <div class="d-flex gap-3">
                                    <div class="form-check form-check-inline flex-fill">
                                        <input class="form-check-input" type="radio" name="movementType"
                                               id="typeEntry" value="ENTRY" required checked>
                                        <label class="form-check-label w-100 p-3 border rounded-3 text-center cursor-pointer"
                                               for="typeEntry" style="cursor:pointer">
                                            <i class="bi bi-arrow-down-circle text-success fs-4 d-block mb-1"></i>
                                            <span class="fw-bold text-success small">Entrée</span>
                                        </label>
                                    </div>
                                    <div class="form-check form-check-inline flex-fill">
                                        <input class="form-check-input" type="radio" name="movementType"
                                               id="typeExit" value="EXIT" required>
                                        <label class="form-check-label w-100 p-3 border rounded-3 text-center cursor-pointer"
                                               for="typeExit" style="cursor:pointer">
                                            <i class="bi bi-arrow-up-circle text-danger fs-4 d-block mb-1"></i>
                                            <span class="fw-bold text-danger small">Sortie</span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <%-- Produit --%>
                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Produit <span class="text-danger">*</span></label>
                                <select name="productId" class="form-select" required id="productSelect">
                                    <option value="">— Sélectionner un produit —</option>
                                    <c:forEach var="p" items="${listProducts}">
                                        <option value="${p.id}"
                                                data-stock="${p.stockQuantity}"
                                                data-threshold="${p.alertThreshold}">
                                            ${p.label} (Stock actuel : ${p.stockQuantity})
                                        </option>
                                    </c:forEach>
                                </select>
                                <div id="stockInfo" class="form-text text-muted mt-1" style="display:none;">
                                    Stock actuel : <strong id="currentStock">—</strong> unités
                                    | Seuil d'alerte : <strong id="alertThreshold">—</strong> unités
                                </div>
                            </div>

                            <%-- Quantité --%>
                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Quantité <span class="text-danger">*</span></label>
                                <input type="number" name="quantity" class="form-control" min="1" required
                                       placeholder="Ex: 50">
                            </div>

                            <%-- Référence --%>
                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Référence du document</label>
                                <input type="text" name="reference" class="form-control"
                                       placeholder="Ex: BC-2024-001, BL-2024-042">
                                <div class="form-text">Numéro de bon de commande, bon de livraison, etc.</div>
                            </div>

                            <%-- Notes --%>
                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Notes</label>
                                <textarea name="notes" class="form-control" rows="2"
                                          placeholder="Observations, motif de l'ajustement..."></textarea>
                            </div>

                            <div class="d-flex gap-2 justify-content-end">
                                <a href="${pageContext.request.contextPath}/stock-movements"
                                   class="btn btn-light rounded-pill px-4">Annuler</a>
                                <button type="submit" class="btn btn-primary rounded-pill px-4">
                                    <i class="bi bi-check-lg me-2"></i>Enregistrer le mouvement
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
<script>
    // Afficher les informations de stock lors de la sélection d'un produit
    document.getElementById('productSelect').addEventListener('change', function() {
        const option = this.options[this.selectedIndex];
        const infoDiv = document.getElementById('stockInfo');
        if (this.value) {
            document.getElementById('currentStock').textContent = option.dataset.stock;
            document.getElementById('alertThreshold').textContent = option.dataset.threshold;
            infoDiv.style.display = 'block';
        } else {
            infoDiv.style.display = 'none';
        }
    });

    // Mettre en évidence le type de mouvement sélectionné
    document.querySelectorAll('input[name="movementType"]').forEach(radio => {
        radio.addEventListener('change', function() {
            document.querySelectorAll('input[name="movementType"] + label').forEach(label => {
                label.classList.remove('border-success', 'border-danger', 'bg-success', 'bg-danger', 'bg-opacity-10');
            });
            const label = this.nextElementSibling;
            if (this.value === 'ENTRY') {
                label.classList.add('border-success', 'bg-success', 'bg-opacity-10');
            } else {
                label.classList.add('border-danger', 'bg-danger', 'bg-opacity-10');
            }
        });
    });
    // Initialiser le premier bouton
    document.getElementById('typeEntry').nextElementSibling.classList.add('border-success', 'bg-success', 'bg-opacity-10');
</script>
</body>
</html>
