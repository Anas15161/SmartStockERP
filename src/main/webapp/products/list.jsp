<%@ include file="/includes/header.jsp" %>
    <div class="row mb-5 align-items-center animate-fade-up">
        <div class="col-md-6">
            <h2 class="fw-bold mb-1"><i class="bi bi-box-seam-fill me-2" style="color: var(--brand-blue);"></i>Product Inventory</h2>
            <p class="text-muted small">Real-time tracking of global stock levels.</p>
        </div>
        <div class="col-md-6 text-md-end">
            <form action="products" method="GET" id="filterForm" class="d-flex gap-2 justify-content-md-end align-items-center">
                <input type="hidden" name="view" value="${param.view != null ? param.view : 'list'}">
                
                <div class="btn-group me-2 bg-light p-1 rounded-pill shadow-sm" style="border: 1px solid var(--glass-border);">
                    <a href="products?view=list&page=1&search=${param.search}&status=${param.status}&supplierId=${param.supplierId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" class="btn btn-sm rounded-pill px-3 ${param.view != 'grid' ? 'btn-primary shadow-sm' : 'btn-light text-muted border-0'}">
                        <i class="bi bi-list-ul"></i>
                    </a>
                    <a href="products?view=grid&page=1&search=${param.search}&status=${param.status}&supplierId=${param.supplierId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" class="btn btn-sm rounded-pill px-3 ${param.view == 'grid' ? 'btn-primary shadow-sm' : 'btn-light text-muted border-0'}">
                        <i class="bi bi-grid-3x3-gap"></i>
                    </a>
                </div>

                <!-- Filters Dropdown -->
                <div class="dropdown me-1">
                    <button class="btn btn-light rounded-pill px-3 shadow-sm border border-opacity-10 btn-sm" type="button" data-bs-toggle="dropdown" data-bs-auto-close="outside">
                        <i class="bi bi-funnel me-1"></i> 
                        <c:if test="${not empty param.status or not empty param.supplierId or not empty param.minPrice or not empty param.maxPrice}">
                            <span class="badge bg-primary rounded-circle p-1" style="font-size: 0.5rem; vertical-align: top;">&nbsp;</span>
                        </c:if>
                        Filters
                    </button>
                    <div class="dropdown-menu p-3 shadow-lg border-0" style="width: 280px; border-radius: 20px;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="fw-bold mb-0 small">Advanced Filters</h6>
                            <a href="products?view=${param.view}" class="btn btn-link btn-sm text-decoration-none smallest p-0">Clear All</a>
                        </div>
                        
                        <div class="mb-3">
                            <label class="smallest text-muted fw-bold text-uppercase">Price Range (DH)</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="number" name="minPrice" id="minPrice" value="${param.minPrice}" class="form-control form-control-sm rounded-3 border-light bg-light" placeholder="Min">
                                </div>
                                <div class="col-6">
                                    <input type="number" name="maxPrice" id="maxPrice" value="${param.maxPrice}" class="form-control form-control-sm rounded-3 border-light bg-light" placeholder="Max">
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="smallest text-muted fw-bold text-uppercase">Stock Status</label>
                            <select name="status" id="statusFilter" class="form-select form-select-sm rounded-3 border-light bg-light" onchange="this.form.submit()">
                                <option value="all" ${param.status == 'all' ? 'selected' : ''}>All Statuses</option>
                                <option value="healthy" ${param.status == 'healthy' ? 'selected' : ''}>Healthy</option>
                                <option value="low" ${param.status == 'low' ? 'selected' : ''}>Low Stock</option>
                                <option value="out" ${param.status == 'out' ? 'selected' : ''}>Out of Stock</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="smallest text-muted fw-bold text-uppercase">Supplier</label>
                            <input type="text" name="supplierName" value="${param.supplierName}" class="form-control form-control-sm rounded-3 border-light bg-light" 
                                   list="supplierList" placeholder="Search supplier...">
                            <datalist id="supplierList">
                                <c:forEach var="supplier" items="${listSupplier}">
                                    <option value="${supplier.name}">
                                </c:forEach>
                            </datalist>
                        </div>
                        
                        <div class="mt-2">
                            <button type="submit" class="btn btn-primary btn-sm w-100 rounded-pill fw-bold">Apply Filters</button>
                        </div>
                    </div>
                </div>

                <div class="input-group w-50 d-none d-lg-flex">
                    <span class="input-group-text bg-transparent border-end-0 rounded-start-pill ps-3" style="border-color: var(--glass-border);">
                        <i class="bi bi-search text-dim"></i>
                    </span>
                    <input type="text" name="search" value="${param.search}" id="productSearch" class="form-control border-start-0 rounded-end-pill" placeholder="Quick search SKU/Name...">
                </div>
                <a href="products?action=new" class="btn btn-primary rounded-pill px-4 shadow-sm">
                    <i class="bi bi-plus-lg me-2"></i>New
                </a>
            </form>
        </div>
    </div>

    <c:choose>
        <c:when test="${param.view == 'grid'}">
            <!-- Grid View -->
            <div class="row g-4 animate-fade-up" id="productGrid">
                <c:forEach var="product" items="${listProduct}">
                    <c:set var="statusValue" value="${product.stockQuantity <= 0 ? 'out' : (product.stockQuantity <= product.alertThreshold ? 'low' : 'healthy')}"/>
                    <div class="col-sm-6 col-lg-4 col-xl-3 product-card-item" 
                         data-price="${product.unitPrice}" 
                         data-status="${statusValue}" 
                         data-supplier="${product.supplier.name}">
                        <div class="card h-100 border-0 shadow-sm transition-smooth product-card-hover rounded-4 overflow-hidden">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="bg-soft-primary rounded-3 p-2 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                                        <i class="bi bi-box2 text-primary opacity-75 fs-5"></i>
                                    </div>
                                    <div class="dropdown">
                                        <button class="btn btn-icon-only rounded-circle bg-light border-0" type="button" data-bs-toggle="dropdown">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                        <ul class="dropdown-menu shadow border-0 p-2" style="border-radius: 12px;">
                                            <li><a class="dropdown-item rounded-2 py-2 small" href="products?action=edit&id=${product.id}"><i class="bi bi-pencil-square me-2 text-primary"></i>Edit details</a></li>
                                            <li><a class="dropdown-item rounded-2 py-2 small text-danger" href="products?action=delete&id=${product.id}" onclick="return confirm('Archive this product?')"><i class="bi bi-archive me-2"></i>Archive Item</a></li>
                                        </ul>
                                    </div>
                                </div>
                                
                                <h5 class="fw-bold text-dark mb-1 text-truncate"><c:out value="${product.label}"/></h5>
                                <div class="text-muted smallest opacity-75 mb-3">ID: #SKU-<c:out value="${product.id}"/></div>
                                
                                <div class="mb-3">
                                    <span class="badge bg-soft-info text-info rounded-pill px-3 py-1 smaller fw-semibold">
                                        <i class="bi bi-truck me-1"></i><c:out value="${product.supplier.name}"/>
                                    </span>
                                </div>

                                <div class="d-flex justify-content-between align-items-end mb-2">
                                    <div class="smallest text-muted text-uppercase fw-bold tracking-wider">Inventory</div>
                                    <div class="fw-bold <c:if test="${product.stockQuantity <= product.alertThreshold}">text-danger</c:if>">
                                        <c:out value="${product.stockQuantity}"/> units
                                    </div>
                                </div>
                                <div class="progress mb-3" style="height: 6px; border-radius: 3px; background-color: #f1f5f9;">
                                    <c:set var="percent" value="${(product.stockQuantity / (product.alertThreshold * 5)) * 100}"/>
                                    <div class="progress-bar <c:choose>
                                        <c:when test="${product.stockQuantity <= product.alertThreshold}">bg-danger</c:when>
                                        <c:when test="${product.stockQuantity <= product.alertThreshold * 2}">bg-warning</c:when>
                                        <c:otherwise>bg-success</c:otherwise>
                                    </c:choose>" 
                                    role="progressbar" style="width: ${percent > 100 ? 100 : percent}%"></div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                    <div class="fw-bold fs-5 text-dark">
                                        <fmt:formatNumber value="${product.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/> 
                                        <span class="smallest text-muted fw-normal">DH</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${product.stockQuantity <= 0}">
                                            <span class="smallest fw-bold text-danger"><i class="bi bi-exclamation-circle me-1"></i>Out of Stock</span>
                                        </c:when>
                                        <c:when test="${product.stockQuantity <= product.alertThreshold}">
                                            <span class="smallest fw-bold text-warning"><i class="bi bi-exclamation-triangle me-1"></i>Low Stock</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="smallest fw-bold text-success"><i class="bi bi-check-circle me-1"></i>In Stock</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty listProduct}">
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-inbox display-1 text-muted opacity-25 d-block mb-3"></i>
                        <h5 class="text-muted">No products found in the warehouse</h5>
                        <a href="products?action=new" class="btn btn-primary btn-sm mt-2 rounded-pill px-4">Start by adding one</a>
                    </div>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Table View -->
            <div class="card border-0 shadow-sm animate-fade-up">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-transparent text-uppercase small fw-bold">
                            <tr>
                                <th class="ps-4 py-3">Product Details</th>
                                <th class="py-3">Category / Supplier</th>
                                <th class="py-3">Stock Level</th>
                                <th class="py-3">Unit Price</th>
                                <th class="py-3">Status</th>
                                <th class="pe-4 py-3 text-end">Management</th>
                            </tr>
                        </thead>
                        <tbody class="border-top-0">
                            <c:forEach var="product" items="${listProduct}">
                                <c:set var="statusValue" value="${product.stockQuantity <= 0 ? 'out' : (product.stockQuantity <= product.alertThreshold ? 'low' : 'healthy')}"/>
                                <tr class="product-row transition-smooth" 
                                    data-price="${product.unitPrice}"
                                    data-status="${statusValue}"
                                    data-supplier="${product.supplier.name}">
                                    <td class="ps-4 py-4">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-light rounded-3 p-2 me-3 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                                <i class="bi bi-box2 fs-4 text-primary opacity-50"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-dark mb-0"><c:out value="${product.label}"/></div>
                                                <div class="text-muted smallest opacity-75">ID: #SKU-<c:out value="${product.id}"/></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="py-4">
                                        <span class="badge bg-soft-info text-info rounded-pill px-3 py-2 small fw-semibold">
                                            <i class="bi bi-truck me-1"></i><c:out value="${product.supplier.name}"/>
                                        </span>
                                    </td>
                                    <td class="py-4">
                                        <div class="d-flex flex-column">
                                            <span class="fw-bold fs-5 <c:if test="${product.stockQuantity <= product.alertThreshold}">text-danger</c:if>">
                                                <c:out value="${product.stockQuantity}"/>
                                            </span>
                                            <div class="progress mt-1" style="height: 4px; width: 80px; background-color: #e2e8f0;">
                                                <c:set var="percent" value="${(product.stockQuantity / (product.alertThreshold * 5)) * 100}"/>
                                                <div class="progress-bar <c:choose>
                                                    <c:when test="${product.stockQuantity <= product.alertThreshold}">bg-danger</c:when>
                                                    <c:when test="${product.stockQuantity <= product.alertThreshold * 2}">bg-warning</c:when>
                                                    <c:otherwise>bg-success</c:otherwise>
                                                </c:choose>" 
                                                role="progressbar" style="width: ${percent > 100 ? 100 : percent}%"></div>
                                            </div>
                                            <span class="smallest text-muted mt-1">Min: ${product.alertThreshold}</span>
                                        </div>
                                    </td>
                                    <td class="py-4">
                                        <div class="fw-bold text-dark">
                                            <fmt:formatNumber value="${product.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/> 
                                            <span class="smallest text-muted">DH</span>
                                        </div>
                                    </td>
                                    <td class="py-4">
                                        <c:choose>
                                            <c:when test="${product.stockQuantity <= 0}">
                                                <span class="badge bg-soft-danger text-danger rounded-pill px-3 py-2 border border-danger border-opacity-10">Out of Stock</span>
                                            </c:when>
                                            <c:when test="${product.stockQuantity <= product.alertThreshold}">
                                                <span class="badge bg-soft-warning text-warning rounded-pill px-3 py-2 border border-warning border-opacity-10">Low Stock</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-soft-success text-success rounded-pill px-3 py-2 border border-success border-opacity-10">Healthy</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="pe-4 py-4 text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-icon-only rounded-circle bg-light border-0" type="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-three-dots-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu shadow border-0 p-2" style="border-radius: 12px;">
                                                <li><a class="dropdown-item rounded-2 py-2" href="products?action=edit&id=${product.id}"><i class="bi bi-pencil-square me-2 text-primary"></i>Edit details</a></li>
                                                <li><a class="dropdown-item rounded-2 py-2 text-danger" href="products?action=delete&id=${product.id}" onclick="return confirm('Archive this product?')"><i class="bi bi-archive me-2"></i>Archive Item</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listProduct}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <i class="bi bi-inbox display-1 text-muted opacity-25 d-block mb-3"></i>
                                        <h5 class="text-muted">No products found in the warehouse</h5>
                                        <a href="products?action=new" class="btn btn-primary btn-sm mt-2 rounded-pill px-4">Start by adding one</a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-between align-items-center mt-4 animate-fade-up">
            <div class="text-muted small">
                Showing <span class="fw-bold">${(currentPage - 1) * 10 + 1}</span> to 
                <span class="fw-bold">${currentPage * 10 > totalItems ? totalItems : currentPage * 10}</span> of 
                <span class="fw-bold">${totalItems}</span> products
            </div>
            <nav>
                <ul class="pagination pagination-sm mb-0 gap-1">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link rounded-pill border-0 px-3 bg-glass shadow-sm" href="products?page=${currentPage - 1}&view=${param.view}&search=${param.search}&status=${param.status}&supplierName=${param.supplierName}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link rounded-pill border-0 px-3 ${currentPage == i ? 'shadow-sm' : 'bg-glass shadow-sm'}" href="products?page=${i}&view=${param.view}&search=${param.search}&status=${param.status}&supplierName=${param.supplierName}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link rounded-pill border-0 px-3 bg-glass shadow-sm" href="products?page=${currentPage + 1}&view=${param.view}&search=${param.search}&status=${param.status}&supplierName=${param.supplierName}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<style>
    .bg-soft-info { background-color: rgba(13, 202, 240, 0.1); }
    .bg-soft-danger { background-color: rgba(220, 53, 69, 0.1); }
    .bg-soft-warning { background-color: rgba(255, 193, 7, 0.1); }
    .bg-soft-success { background-color: rgba(25, 135, 84, 0.1); }
    .bg-soft-primary { background-color: rgba(11, 94, 158, 0.1); }
    .smallest { font-size: 0.75rem; }
    .smaller { font-size: 0.8rem; }
    .btn-icon-only { width: 32px; height: 32px; padding: 0; line-height: 32px; transition: all 0.2s; }
    .btn-icon-only:hover { background-color: #e2e8f0 !important; }
    .product-row:hover { background-color: #f8fafc !important; }
    .product-card-hover:hover { transform: translateY(-5px); box-shadow: 0 1rem 3rem rgba(0,0,0,.1) !important; }
    .transition-smooth { transition: all 0.2s ease-in-out; }
    .rounded-start-pill { border-top-left-radius: 50rem !important; border-bottom-left-radius: 50rem !important; }
    .rounded-end-pill { border-top-right-radius: 50rem !important; border-bottom-right-radius: 50rem !important; }
</style>

</body>
</html>
