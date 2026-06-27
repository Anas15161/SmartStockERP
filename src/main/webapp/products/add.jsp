<%@ include file="/includes/header.jsp" %>
    <h2>Add New Product</h2>
    <hr>
    <form action="products?action=insert" method="post" class="mt-4">
        <div class="row g-3">
            <div class="col-md-6 mb-3">
                <label class="form-label">Product Label</label>
                <input type="text" name="label" class="form-control ${not empty errors.label ? 'is-invalid' : ''}" value="${product.label}" required/>
                <c:if test="${not empty errors.label}">
                    <div class="invalid-feedback">${errors.label}</div>
                </c:if>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Supplier</label>
                <select name="supplierId" class="form-select ${not empty errors.supplier ? 'is-invalid' : ''}" required>
                    <option value="">Select a supplier...</option>
                    <c:forEach var="supplier" items="${listSupplier}">
                        <option value="${supplier.id}" ${product.supplier.id == supplier.id ? 'selected' : ''}>${supplier.name}</option>
                    </c:forEach>
                </select>
                <c:if test="${not empty errors.supplier}">
                    <div class="invalid-feedback">${errors.supplier}</div>
                </c:if>
            </div>
        </div>

        <div class="row g-3">
            <div class="col-md-4 mb-3">
                <label class="form-label">Unit Price (${appSettings.currency != null ? appSettings.currency : 'DH'})</label>
                <input type="number" step="0.01" name="unitPrice" class="form-control ${not empty errors.unitPrice ? 'is-invalid' : ''}" value="${product.unitPrice}" required/>
                <c:if test="${not empty errors.unitPrice}">
                    <div class="invalid-feedback">${errors.unitPrice}</div>
                </c:if>
            </div>
            <div class="col-md-4 mb-3">
                <label class="form-label">Initial Stock</label>
                <input type="number" name="stockQuantity" class="form-control ${not empty errors.stockQuantity ? 'is-invalid' : ''}" value="${product.stockQuantity}" required/>
                <c:if test="${not empty errors.stockQuantity}">
                    <div class="invalid-feedback">${errors.stockQuantity}</div>
                </c:if>
            </div>
            <div class="col-md-4 mb-3">
                <label class="form-label">Alert Threshold</label>
                <input type="number" name="alertThreshold" class="form-control ${not empty errors.alertThreshold ? 'is-invalid' : ''}" value="${product.alertThreshold}" required/>
                <c:if test="${not empty errors.alertThreshold}">
                    <div class="invalid-feedback">${errors.alertThreshold}</div>
                </c:if>
            </div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary px-4">Create Product</button>
            <a href="products" class="btn btn-link text-secondary">Cancel</a>
        </div>
    </form>
</div> <!-- Closing container -->
</body>
</html>
