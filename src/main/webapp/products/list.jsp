<%@ include file="/includes/header.jsp" %>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Product List</h2>
        <a href="products?action=new" class="btn btn-success">Add New Product</a>
    </div>

    <table class="table table-hover">
        <thead class="table-light">
            <tr>
                <th>Label</th>
                <th>Stock</th>
                <th>Threshold</th>
                <th>Price</th>
                <th>Supplier</th>
                <th>Last Updated</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="product" items="${listProduct}">
                <tr>
                    <td><c:out value="${product.label}"/></td>
                    <td class="${product.stockQuantity <= product.alertThreshold ? 'text-danger fw-bold' : ''}">
                        <c:out value="${product.stockQuantity}"/>
                    </td>
                    <td><c:out value="${product.alertThreshold}"/></td>
                    <td><fmt:formatNumber value="${product.unitPrice}" type="currency" currencySymbol="€"/></td>
                    <td><c:out value="${product.supplier.name}"/></td>
                    <td><c:out value="${product.lastUpdated}"/></td>
                    <td>
                        <a href="products?action=edit&id=${product.id}" class="btn btn-sm btn-outline-primary">Edit</a>
                        <a href="products?action=delete&id=${product.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div> <!-- Closing container -->
</body>
</html>
