<%@ include file="/includes/header.jsp" %>
    <div class="mb-4">
        <h2><i class="bi bi-plus-circle me-2"></i>Add New Supplier</h2>
        <p class="text-muted">Register a new partner in your system.</p>
    </div>
    <hr>
    
    <form action="suppliers?action=insert" method="post" class="mt-4">
        <div class="row g-3">
            <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Supplier Name</label>
                <input type="text" name="name" class="form-control ${not empty errors.name ? 'is-invalid' : ''}" 
                       value="${supplier.name}" required placeholder="e.g. Global Tech Solutions">
                <c:if test="${not empty errors.name}">
                    <div class="invalid-feedback">${errors.name}</div>
                </c:if>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Email Address</label>
                <input type="email" name="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                       value="${supplier.email}" required placeholder="contact@supplier.com">
                <c:if test="${not empty errors.email}">
                    <div class="invalid-feedback">${errors.email}</div>
                </c:if>
            </div>
        </div>

        <div class="row g-3">
            <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Category</label>
                <input type="text" name="category" class="form-control" value="${supplier.category}" 
                       placeholder="e.g. Electronics, Raw Materials">
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Full Address</label>
                <input type="text" name="address" class="form-control" value="${supplier.address}" 
                       placeholder="123 Business St, City, Country">
            </div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary px-5">Register Supplier</button>
            <a href="suppliers" class="btn btn-link text-secondary">Cancel and return</a>
        </div>
    </form>
</div>
</body>
</html>
