<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<head>
    <title>${product != null ? 'Edit Product' : 'Add New Product'}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <h2>${product != null ? 'Edit Product' : 'Add New Product'}</h2>
    <form action="products?action=${product != null ? 'update' : 'insert'}" method="post">
        <c:if test="${product != null}">
            <input type="hidden" name="id" value="${product.id}"/>
        </c:if>

        <div class="mb-3">
            <label class="form-label">Label</label>
            <input type="text" name="label" class="form-control" value="${product.label}" required/>
        </div>

        <div class="mb-3">
            <label class="form-label">Stock Quantity</label>
            <input type="number" name="stockQuantity" class="form-control" value="${product.stockQuantity}" required min="0"/>
        </div>

        <div class="mb-3">
            <label class="form-label">Alert Threshold</label>
            <input type="number" name="alertThreshold" class="form-control" value="${product.alertThreshold}" required min="0"/>
        </div>

        <div class="mb-3">
            <label class="form-label">Unit Price</label>
            <input type="number" step="0.01" name="unitPrice" class="form-control" value="${product.unitPrice}" required min="0"/>
        </div>

        <div class="mb-3">
            <label class="form-label">Supplier</label>
            <select name="supplierId" class="form-select">
                <option value="">Select Supplier</option>
                <c:forEach var="supplier" items="${listSupplier}">
                    <option value="${supplier.id}" ${product.supplier.id == supplier.id ? 'selected' : ''}>
                        ${supplier.name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Save</button>
        <a href="products" class="btn btn-secondary">Cancel</a>
    </form>
</body>
</html>
