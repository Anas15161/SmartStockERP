<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Product Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <h2>Products</h2>
    <a href="products?action=new" class="btn btn-success mb-3">Add New Product</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Label</th>
                <th>Stock</th>
                <th>Alert Threshold</th>
                <th>Price</th>
                <th>Supplier</th>
                <th>Last Updated</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="product" items="${listProduct}">
                <tr>
                    <td><c:out value="${product.id}"/></td>
                    <td><c:out value="${product.label}"/></td>
                    <td><c:out value="${product.stockQuantity}"/></td>
                    <td><c:out value="${product.alertThreshold}"/></td>
                    <td><c:out value="${product.unitPrice}"/></td>
                    <td><c:out value="${product.supplier.name}"/></td>
                    <td><c:out value="${product.lastUpdated}"/></td>
                    <td>
                        <a href="products?action=edit&id=${product.id}" class="btn btn-primary btn-sm">Edit</a>
                        <a href="products?action=delete&id=${product.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
