<%@ include file="/includes/header.jsp" %>
    <div class="row mb-4">
        <div class="col-md-12">
            <h2 class="fw-bold"><i class="bi bi-speedometer2 me-2"></i>Inventory Dashboard</h2>
            <p class="text-muted">Overview of your current stock and supplier performance.</p>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- Total Products Card -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm bg-primary text-white h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Total Products</h6>
                            <h2 class="display-5 fw-bold mb-0">${totalProducts}</h2>
                        </div>
                        <i class="bi bi-box-seam display-4 opacity-50"></i>
                    </div>
                    <a href="products" class="text-white text-decoration-none small stretched-link">
                        View Details <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Total Suppliers Card -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm bg-success text-white h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Active Suppliers</h6>
                            <h2 class="display-5 fw-bold mb-0">${totalSuppliers}</h2>
                        </div>
                        <i class="bi bi-truck display-4 opacity-50"></i>
                    </div>
                    <a href="suppliers" class="text-white text-decoration-none small stretched-link">
                        Manage Suppliers <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Low Stock Alert Card -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm ${lowStockCount > 0 ? 'bg-danger' : 'bg-dark'} text-white h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-uppercase mb-1">Stock Alerts</h6>
                            <h2 class="display-5 fw-bold mb-0">${lowStockCount}</h2>
                        </div>
                        <i class="bi bi-exclamation-triangle display-4 opacity-50"></i>
                    </div>
                    <p class="small mb-0">Products below threshold</p>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="card-title mb-0 fw-bold text-danger">
                        <i class="bi bi-bell me-2"></i>Critical Stock Items
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th>Product</th>
                                    <th>Stock</th>
                                    <th>Threshold</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${lowStockProducts}">
                                    <tr>
                                        <td>${p.label}</td>
                                        <td class="fw-bold">${p.stockQuantity}</td>
                                        <td>${p.alertThreshold}</td>
                                        <td>
                                            <span class="badge bg-danger">Critical</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty lowStockProducts}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted italic">
                                            All stock levels are currently healthy.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="card-title mb-0 fw-bold text-primary">
                        <i class="bi bi-lightning-charge me-2"></i>Quick Actions
                    </h5>
                </div>
                <div class="card-body d-grid gap-2">
                    <a href="products?action=new" class="btn btn-outline-primary text-start">
                        <i class="bi bi-plus-lg me-2"></i>Create New Product
                    </a>
                    <a href="suppliers?action=new" class="btn btn-outline-success text-start">
                        <i class="bi bi-plus-lg me-2"></i>Add New Supplier
                    </a>
                    <hr>
                    <a href="logout" class="btn btn-outline-secondary text-start">
                        <i class="bi bi-box-arrow-right me-2"></i>Logout System
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
