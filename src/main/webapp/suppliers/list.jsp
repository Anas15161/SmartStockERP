<%@ include file="/includes/header.jsp" %>
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2><i class="bi bi-truck me-2"></i>Suppliers Management</h2>
    <a href="suppliers?action=new" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>Add New Supplier
    </a>
</div>

<table class="table table-hover table-striped">
    <thead class="table-dark">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Category</th>
        <th>Address</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="supplier" items="${listSupplier}">
        <tr>
            <td>${supplier.id}</td>
            <td class="fw-bold">${supplier.name}</td>
            <td>${supplier.email}</td>
            <td><span class="badge bg-info text-dark">${supplier.category}</span></td>
            <td>${supplier.address}</td>
            <td>
                <a href="suppliers?action=edit&id=${supplier.id}" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-pencil"></i>
                </a>
                <a href="suppliers?action=delete&id=${supplier.id}" class="btn btn-sm btn-outline-danger" 
                   onclick="return confirm('Are you sure you want to delete this supplier?')">
                    <i class="bi bi-trash"></i>
                </a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</div>
</body>
</html>
