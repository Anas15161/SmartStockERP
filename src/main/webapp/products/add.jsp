<%@ include file="/includes/header.jsp" %>
    <h2>Add New Product</h2>
    <hr>
    <form action="products?action=insert" method="post" class="mt-4">
        <div class="row g-3">
            <div class="col-md-6 mb-3">
                <label class="form-label">Product Label</label>
                <input type="text" name="label" class="form-control" required/>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Supplier</label>
                <select name="supplierId" class="form-select" required>
                    <option value="">Select a supplier...</option>
                    <c:forEach var="supplier" items="${listSupplier}">
                        <option value="${supplier.id}">${supplier.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="row g-3">
            <div class="col-md-4 mb-3">
                <label class="form-label">Unit Price (€)</label>
                <input type="number" step="0.01" name="unitPrice" class="form-control" required min="0"/>
            </div>
            <div class="col-md-4 mb-3">
                <label class="form-label">Initial Stock</label>
                <input type="number" name="stockQuantity" class="form-control" required min="0"/>
            </div>
            <div class="col-md-4 mb-3">
                <label class="form-label">Alert Threshold</label>
                <input type="number" name="alertThreshold" class="form-control" required min="0"/>
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
