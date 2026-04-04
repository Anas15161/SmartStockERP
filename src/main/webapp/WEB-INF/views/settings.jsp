<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../../includes/header.jsp" />

<div class="row mb-5">
    <div class="col-md-8">
        <div class="d-flex align-items-center gap-3">
            <div class="bg-soft-primary p-3 rounded-4">
                <i class="bi bi-gear fs-3 text-primary"></i>
            </div>
            <div>
                <h2 class="fw-800 mb-0">System Configuration</h2>
                <p class="text-muted mb-0">Adjust core parameters for inventory and quotes (devis).</p>
            </div>
        </div>
    </div>
</div>

<c:if test="${param.success}">
    <div class="alert alert-success border-0 shadow-sm rounded-4 mb-4 py-3 animate-fade-in">
        <div class="d-flex align-items-center">
            <i class="bi bi-check-circle-fill fs-4 me-3"></i>
            <div>
                <h6 class="fw-bold mb-0">Settings Updated Successfully!</h6>
                <p class="small mb-0">All system parameters have been persisted to the database.</p>
            </div>
        </div>
    </div>
</c:if>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm rounded-4 p-4">
            <form action="${pageContext.request.contextPath}/settings" method="POST">
                <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                    <h5 class="fw-bold text-primary mb-0"><i class="bi bi-gear-wide-connected me-2"></i>Global Configuration</h5>
                    <button type="submit" class="btn btn-primary btn-sm px-4 rounded-pill fw-bold">
                        <i class="bi bi-save me-1"></i> QUICK SAVE
                    </button>
                </div>
                
                <div class="row g-4">
                    <!-- General Settings -->
                    <div class="col-12 mt-4">
                        <h6 class="fw-bold text-uppercase smallest tracking-wider text-muted mb-3">General Infrastructure</h6>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label smallest fw-800 text-muted text-uppercase tracking-wider">Company Identity</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-patch-check text-muted"></i></span>
                            <input type="text" class="form-control" name="company_name" 
                                   value="${settings.company_name}" placeholder="SmartStock ERP">
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label smallest fw-800 text-muted text-uppercase tracking-wider">Base Currency</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-currency-exchange text-muted"></i></span>
                            <input type="text" class="form-control" name="currency" 
                                   value="${settings.currency}" placeholder="DH">
                        </div>
                    </div>

                    <!-- Products & Quotes (Devis) -->
                    <div class="col-12 border-bottom pb-2 mb-2 mt-5">
                        <h5 class="fw-bold text-success"><i class="bi bi-file-earmark-text me-2"></i>Inventory & Quotes (Devis)</h5>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label smallest fw-800 text-muted text-uppercase tracking-wider">Quote Numbering Prefix</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0"><i class="bi bi-hash text-muted"></i></span>
                            <input type="text" class="form-control bg-light border-0" name="quote_prefix" 
                                   value="${settings.quote_prefix}" placeholder="QT-">
                        </div>
                        <div class="form-text smallest">Example: QT-2026-001</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label smallest fw-800 text-muted text-uppercase tracking-wider">Default VAT Rate (%)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0"><i class="bi bi-percent text-muted"></i></span>
                            <input type="number" class="form-control bg-light border-0" name="quote_tax_rate" 
                                   value="${settings.quote_tax_rate}" placeholder="20">
                        </div>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label smallest fw-800 text-muted text-uppercase tracking-wider">Stock Alert Threshold (Default)</label>
                        <div class="input-group" style="max-width: 300px;">
                            <span class="input-group-text bg-light border-0"><i class="bi bi-bell text-muted"></i></span>
                            <input type="number" class="form-control bg-light border-0" name="stock_alert_threshold_default" 
                                   value="${settings.stock_alert_threshold_default}" placeholder="10">
                        </div>
                        <div class="form-text smallest">Products will flag "Low Stock" when below this quantity.</div>
                    </div>

                    <!-- Aesthetics -->
                    <div class="col-12 border-bottom pb-2 mb-2 mt-5">
                        <h5 class="fw-bold text-info"><i class="bi bi-palette me-2"></i>Visual Identity</h5>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label smallest fw-800 text-muted text-uppercase tracking-wider">Primary Theme Color</label>
                        <div class="d-flex gap-3 align-items-center">
                            <input type="color" class="form-control form-control-color border-0 p-1" name="theme_color" 
                                   value="${settings.theme_color}" style="width: 60px; height: 60px; border-radius: 12px;">
                            <div class="smallest text-muted">This color will be applied to the primary dashboard elements.</div>
                        </div>
                    </div>

                    <div class="col-12 mt-5">
                        <button type="submit" class="btn btn-success px-5 py-3 shadow-lg fw-bold">
                            <i class="bi bi-cloud-check-fill me-2"></i> SAVE ALL SETTINGS
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-gradient-blue text-white">
            <h6 class="fw-800 text-uppercase mb-3 opacity-75 smallest">Infrastructure Health</h6>
            <div class="d-flex align-items-center gap-3 mb-4">
                <div class="fs-1"><i class="bi bi-cpu"></i></div>
                <div>
                    <div class="fw-bold">Cluster Status</div>
                    <div class="badge bg-success rounded-pill">ONLINE / STABLE</div>
                </div>
            </div>
            <div class="smallest opacity-75 mb-0">Last settings synchronization: <br> Just now</div>
        </div>
        
        <div class="card border-0 shadow-sm rounded-4 p-4 border-start border-primary border-4">
            <h6 class="fw-bold mb-3"><i class="bi bi-info-circle text-primary me-2"></i>Documentation Tip</h6>
            <p class="text-muted small mb-0">
                These settings are stored in the <code>GLOBAL_SETTINGS</code> table and are cached by the Jakarta EE container for optimal performance.
            </p>
        </div>
    </div>
</div>

<jsp:include page="../../includes/footer.jsp" />
