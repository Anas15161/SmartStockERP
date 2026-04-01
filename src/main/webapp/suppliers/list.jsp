<%@ include file="/includes/header.jsp" %>
    <div class="row mb-5 align-items-center animate-fade-up">
        <div class="col-md-6">
            <h2 class="fw-bold mb-1"><i class="bi bi-truck me-2 text-success"></i>Supplier Network</h2>
            <p class="text-muted small">Manage your strategic partnerships and supply chain contacts.</p>
        </div>
        <div class="col-md-6 text-md-end">
            <div class="d-flex gap-2 justify-content-md-end">
                <div class="input-group w-50 d-none d-lg-flex">
                    <span class="input-group-text bg-white border-end-0 rounded-start-pill ps-3">
                        <i class="bi bi-search text-muted"></i>
                    </span>
                    <input type="text" id="supplierSearch" class="form-control border-start-0 rounded-end-pill" placeholder="Search by name, category...">
                </div>
                <a href="suppliers?action=new" class="btn btn-success rounded-pill px-4 shadow-sm text-white">
                    <i class="bi bi-plus-lg me-2"></i>New Supplier
                </a>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm animate-fade-up" style="border-radius: 20px; overflow: hidden;">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 border-0">
                <thead class="bg-light text-uppercase small fw-bold text-muted" style="background-color: #f8fafc !important;">
                    <tr>
                        <th class="ps-4 py-3">Supplier Name</th>
                        <th class="py-3">Contact Information</th>
                        <th class="py-3">Category</th>
                        <th class="py-3">Business Address</th>
                        <th class="pe-4 py-3 text-end">Management</th>
                    </tr>
                </thead>
                <tbody class="border-top-0">
                    <c:forEach var="supplier" items="${listSupplier}">
                        <tr class="supplier-row transition-smooth">
                            <td class="ps-4 py-4">
                                <div class="d-flex align-items-center">
                                    <div class="bg-soft-success rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                                        <span class="fw-bold text-success">${supplier.name.substring(0,1).toUpperCase()}</span>
                                    </div>
                                    <div class="fw-bold text-dark"><c:out value="${supplier.name}"/></div>
                                </div>
                            </td>
                            <td class="py-4">
                                <div class="d-flex flex-column">
                                    <span class="text-dark small"><i class="bi bi-envelope me-2 text-muted"></i><c:out value="${supplier.email}"/></span>
                                </div>
                            </td>
                            <td class="py-4">
                                <span class="badge bg-soft-info text-info rounded-pill px-3 py-2 border border-info border-opacity-10 small fw-semibold">
                                    <c:out value="${supplier.category}"/>
                                </span>
                            </td>
                            <td class="py-4">
                                <span class="text-muted small"><i class="bi bi-geo-alt me-1"></i><c:out value="${supplier.address}"/></span>
                            </td>
                            <td class="pe-4 py-4 text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="suppliers?action=edit&id=${supplier.id}" class="btn btn-icon-only rounded-circle bg-soft-primary text-primary" title="Edit">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                    <a href="suppliers?action=delete&id=${supplier.id}" class="btn btn-icon-only rounded-circle bg-soft-danger text-danger" 
                                       onclick="return confirm('Remove this supplier? This will affect related products.')" title="Delete">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listSupplier}">
                        <tr>
                            <td colspan="5" class="text-center py-5">
                                <i class="bi bi-people display-1 text-muted opacity-25 d-block mb-3"></i>
                                <h5 class="text-muted">No suppliers registered yet</h5>
                                <a href="suppliers?action=new" class="btn btn-success text-white btn-sm mt-2 rounded-pill px-4">Add your first supplier</a>
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
                <span class="fw-bold">${totalItems}</span> suppliers
            </div>
            <nav>
                <ul class="pagination pagination-sm mb-0 gap-1">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link rounded-pill border-0 px-3 bg-glass shadow-sm" href="suppliers?page=${currentPage - 1}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link rounded-pill border-0 px-3 ${currentPage == i ? 'shadow-sm' : 'bg-glass shadow-sm'}" href="suppliers?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link rounded-pill border-0 px-3 bg-glass shadow-sm" href="suppliers?page=${currentPage + 1}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<style>
    .bg-soft-primary { background-color: rgba(13, 110, 253, 0.1); }
    .bg-soft-info { background-color: rgba(13, 202, 240, 0.1); }
    .bg-soft-danger { background-color: rgba(220, 53, 69, 0.1); }
    .bg-soft-success { background-color: rgba(25, 135, 84, 0.1); }
    .btn-icon-only { width: 36px; height: 36px; padding: 0; display: flex; align-items: center; justify-content: center; transition: all 0.2s; border: none; }
    .btn-icon-only:hover { filter: brightness(0.9); transform: scale(1.1); }
    .supplier-row:hover { background-color: #f8fafc !important; }
    .transition-smooth { transition: all 0.2s ease-in-out; }
    .rounded-start-pill { border-top-left-radius: 50rem !important; border-bottom-left-radius: 50rem !important; }
    .rounded-end-pill { border-top-right-radius: 50rem !important; border-bottom-right-radius: 50rem !important; }
</style>

<script>
    document.getElementById('supplierSearch').addEventListener('keyup', function() {
        let value = this.value.toLowerCase();
        let rows = document.querySelectorAll('.supplier-row');
        rows.forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(value) ? '' : 'none';
        });
    });
</script>
</body>
</html>
