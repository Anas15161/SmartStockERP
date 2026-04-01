<%@ include file="/includes/header.jsp" %>
    <div class="row mb-5 align-items-center animate-fade-up">
        <div class="col-md-6">
            <h2 class="fw-bold mb-1"><i class="bi bi-box-seam-fill me-2" style="color: var(--brand-blue);"></i>Product Inventory</h2>
            <p class="text-muted small">Real-time tracking of global stock levels.</p>
        </div>
        <div class="col-md-6 text-md-end">
            <div class="d-flex gap-2 justify-content-md-end">
                <div class="input-group w-50 d-none d-lg-flex">
                    <span class="input-group-text bg-transparent border-end-0 rounded-start-pill ps-3" style="border-color: var(--glass-border);">
                        <i class="bi bi-search text-dim"></i>
                    </span>
                    <input type="text" id="productSearch" class="form-control border-start-0 rounded-end-pill" placeholder="Quick search SKU/Name...">
                </div>
                <a href="products?action=new" class="btn btn-primary rounded-pill px-4 shadow-sm">
                    <i class="bi bi-plus-lg me-2"></i>New Product
                </a>
            </div>
        </div>
    </div>

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
                        <tr class="product-row transition-smooth">
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
                        <a class="page-link rounded-pill border-0 px-3 bg-glass shadow-sm" href="products?page=${currentPage - 1}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link rounded-pill border-0 px-3 ${currentPage == i ? 'shadow-sm' : 'bg-glass shadow-sm'}" href="products?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link rounded-pill border-0 px-3 bg-glass shadow-sm" href="products?page=${currentPage + 1}">
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
    .smallest { font-size: 0.75rem; }
    .btn-icon-only { width: 32px; height: 32px; padding: 0; line-height: 32px; transition: all 0.2s; }
    .btn-icon-only:hover { background-color: #e2e8f0 !important; }
    .product-row:hover { background-color: #f8fafc !important; }
    .transition-smooth { transition: all 0.2s ease-in-out; }
    .rounded-start-pill { border-top-left-radius: 50rem !important; border-bottom-left-radius: 50rem !important; }
    .rounded-end-pill { border-top-right-radius: 50rem !important; border-bottom-right-radius: 50rem !important; }
</style>

<script>
    document.getElementById('productSearch').addEventListener('keyup', function() {
        let value = this.value.toLowerCase();
        let rows = document.querySelectorAll('.product-row');
        rows.forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(value) ? '' : 'none';
        });
    });
</script>
</body>
</html>
