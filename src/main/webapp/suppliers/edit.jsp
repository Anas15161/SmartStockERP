<%@ include file="/includes/header.jsp" %>
    <div class="mb-4">
        <h2><i class="bi bi-pencil-square me-2"></i>Edit Supplier: ${supplier.name}</h2>
        <p class="text-muted">ID: # ${supplier.id}</p>
    </div>
    <hr>
    
    <form action="suppliers?action=update" method="post" class="mt-4">
        <input type="hidden" name="id" value="${supplier.id}"/>
        
        <div class="row g-3">
            <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Supplier Name</label>
                <input type="text" name="name" class="form-control ${not empty errors.name ? 'is-invalid' : ''}" 
                       value="${supplier.name}" required>
                <c:if test="${not empty errors.name}">
                    <div class="invalid-feedback">${errors.name}</div>
                </c:if>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Email Address</label>
                <input type="email" name="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                       value="${supplier.email}" required>
                <c:if test="${not empty errors.email}">
                    <div class="invalid-feedback">${errors.email}</div>
                </c:if>
            </div>
        </div>

        <div class="row g-3">
            <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Category</label>
                <input type="text" name="category" class="form-control" value="${supplier.category}">
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label fw-bold">Full Address</label>
                <input type="text" name="address" class="form-control" value="${supplier.address}">
            </div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary px-5">Save Changes</button>
            <a href="suppliers" class="btn btn-link text-secondary">Cancel and return</a>
        </div>
    </form>
</div>
</body>
</html>
