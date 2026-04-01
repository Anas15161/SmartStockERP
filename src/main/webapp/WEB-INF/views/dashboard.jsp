<%@ include file="/includes/header.jsp" %>
    <div class="row mb-5 animate-fade-up">
        <div class="col-md-8">
            <h2 class="fw-bold mb-1">Welcome back, ${sessionScope.user}!</h2>
            <p class="text-muted small">Here's what's happening with your inventory today.</p>
        </div>
        <div class="col-md-4 text-md-end d-flex align-items-center justify-content-md-end">
            <span class="badge bg-soft-primary text-primary px-3 py-2 rounded-pill small">
                <i class="bi bi-calendar3 me-2"></i>April 1, 2026
            </span>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="row g-4 mb-5 animate-fade-up">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 h-100 dash-card bg-glass">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-soft-primary rounded-circle p-2 me-3">
                        <i class="bi bi-box-seam fs-4 text-primary"></i>
                    </div>
                    <span class="text-muted small fw-semibold">Total Inventory</span>
                </div>
                <h3 class="fw-bold mb-1">${totalProducts}</h3>
                <span class="text-success small"><i class="bi bi-arrow-up-short"></i>+2.4% from last week</span>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 h-100 dash-card bg-glass">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-soft-success rounded-circle p-2 me-3">
                        <i class="bi bi-truck fs-4 text-success"></i>
                    </div>
                    <span class="text-muted small fw-semibold">Partners</span>
                </div>
                <h3 class="fw-bold mb-1">${totalSuppliers}</h3>
                <span class="text-muted small">Active suppliers</span>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 h-100 dash-card bg-glass">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-soft-danger rounded-circle p-2 me-3">
                        <i class="bi bi-exclamation-triangle fs-4 text-danger"></i>
                    </div>
                    <span class="text-muted small fw-semibold">Alerts</span>
                </div>
                <h3 class="fw-bold mb-1 ${lowStockCount > 0 ? 'text-danger' : ''}">${lowStockCount}</h3>
                <span class="text-muted small">Low stock items</span>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 h-100 dash-card bg-glass">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-soft-warning rounded-circle p-2 me-3">
                        <i class="bi bi-currency-dollar fs-4 text-warning"></i>
                    </div>
                    <span class="text-muted small fw-semibold">Valuation</span>
                </div>
                <h3 class="fw-bold mb-1">842K</h3>
                <span class="text-muted small">DH Total Value</span>
            </div>
        </div>
    </div>

    <div class="row g-4 animate-fade-up">
        <!-- Critical Items -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold">Critical Stock Items</h5>
                    <a href="products" class="btn btn-sm btn-link text-primary fw-semibold text-decoration-none">View All</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light smallest text-uppercase text-muted">
                            <tr>
                                <th class="ps-4">Product</th>
                                <th>In Stock</th>
                                <th>Min Level</th>
                                <th class="pe-4 text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${lowStockProducts}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-semibold text-dark">${p.label}</div>
                                        <div class="smallest text-muted">${p.supplier.name}</div>
                                    </td>
                                    <td><span class="badge bg-soft-danger text-danger rounded-pill">${p.stockQuantity}</span></td>
                                    <td class="text-muted small">${p.alertThreshold}</td>
                                    <td class="pe-4 text-end">
                                        <a href="products?action=edit&id=${p.id}" class="btn btn-sm btn-light rounded-pill px-3 smallest">Order More</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty lowStockProducts}">
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-muted italic">
                                        <i class="bi bi-check2-circle fs-1 text-success opacity-25 d-block mb-2"></i>
                                        All inventory levels are healthy.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Quick Actions & Trends -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">
                    <h6 class="fw-bold mb-3">Quick Actions</h6>
                    <div class="d-grid gap-2">
                        <a href="products?action=new" class="btn btn-primary rounded-pill text-start py-2">
                            <i class="bi bi-plus-circle me-2"></i>New Product
                        </a>
                        <a href="suppliers?action=new" class="btn btn-soft-success rounded-pill text-start py-2">
                            <i class="bi bi-person-plus me-2"></i>New Supplier
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="card border-0 shadow-sm bg-dark text-white overflow-hidden">
                <div class="card-body p-4 position-relative">
                    <div class="position-relative z-1">
                        <h6 class="text-uppercase smallest fw-bold opacity-50 mb-3">Storage Capacity</h6>
                        <h2 class="fw-bold mb-1">78%</h2>
                        <div class="progress bg-white bg-opacity-10 mt-3" style="height: 6px;">
                            <div class="progress-bar bg-primary" style="width: 78%"></div>
                        </div>
                        <p class="smallest mt-3 mb-0 opacity-75">4,200 / 6,000 units occupied</p>
                    </div>
                    <i class="bi bi-pie-chart-fill position-absolute end-0 bottom-0 opacity-10" style="font-size: 8rem; margin-right: -1rem; margin-bottom: -1rem;"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .bg-soft-primary { background-color: rgba(13, 110, 253, 0.1); }
    .bg-soft-success { background-color: rgba(25, 135, 84, 0.1); }
    .bg-soft-danger { background-color: rgba(220, 53, 69, 0.1); }
    .bg-soft-warning { background-color: rgba(255, 193, 7, 0.1); }
    .btn-soft-success { background-color: rgba(25, 135, 84, 0.1); color: #198754; border: none; }
    .btn-soft-success:hover { background-color: rgba(25, 135, 84, 0.2); }
    .dash-card { border-radius: 20px; transition: transform 0.2s; }
    .dash-card:hover { transform: translateY(-5px); }
    .bg-glass { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); }
    .smallest { font-size: 0.7rem; }
</style>
</body>
</html>
