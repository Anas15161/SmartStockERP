<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStock ERP | Intelligent Supply Chain Ecosystem</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .hero-wallpaper {
            background-image: url('https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=2070&auto=format&fit=crop');
            min-height: 100vh;
            display: flex;
            align-items: center;
            margin-top: -80px; /* Offset for transparent nav */
        }

        .floating-badge {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            padding: 10px 24px;
            border-radius: 100px;
            border: 1px solid rgba(11, 94, 158, 0.1);
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            color: var(--brand-blue);
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .hero-title {
            font-size: clamp(2.5rem, 5vw, 4.5rem);
            line-height: 1.1;
            margin-bottom: 1.5rem;
        }

        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: 24px;
            text-align: center;
            border-bottom: 4px solid var(--brand-blue);
        }

        .icon-box {
            width: 60px; height: 60px;
            background: #f1f5f9;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            transition: var(--transition-smooth);
        }

        .card:hover .icon-box {
            background: var(--brand-blue);
            color: white !important;
            transform: rotate(10deg);
        }
    </style>
</head>
<body>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg fixed-top navbar-light" id="mainNav">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center fw-800" href="#">
                <img src="${pageContext.request.contextPath}/assets/logo.png" alt="SmartStock ERP" style="height: 38px;">
            </a>
            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navContent">
                <ul class="navbar-nav ms-auto align-items-center gap-2">
                    <li class="nav-item"><a class="nav-link px-3" href="#home">Ecosystem</a></li>
                    <li class="nav-item"><a class="nav-link px-3" href="#features">Solutions</a></li>
                    <li class="nav-item"><a class="nav-link px-3" href="#pricing">Pricing</a></li>
                    <li class="nav-item ms-lg-4">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a class="btn btn-primary px-4 shadow" href="dashboard">Launch Terminal <i class="bi bi-cpu ms-2"></i></a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-outline-dark px-4 me-2" href="login.jsp">Sign In</a>
                                <a class="btn btn-primary px-4 shadow" href="login.jsp">Deploy Now <i class="bi bi-rocket-takeoff ms-2"></i></a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-wallpaper" id="home">
        <div class="container hero-content">
            <div class="row align-items-center">
                <div class="col-lg-7" data-aos="fade-right">

                    <h1 class="hero-title fw-800">
                        Intelligent <span class="text-gradient-blue">Inventory</span> <br>
                        Management for Excellence.
                    </h1>
                    <p class="lead fw-600 mb-5 pe-lg-5" style="color: #334155; line-height: 1.8; text-shadow: 0 0 20px rgba(255,255,255,0.5);">
                        The robust Jakarta EE 10 backbone for modern enterprises. Orchestrate products,
                        suppliers, and stocks with high-tier precision and Hibernate 6 performance.
                    </p>
                    <div class="d-flex gap-3">
                        <a href="login.jsp" class="btn btn-primary btn-lg px-5 py-3 shadow-lg">Start Building Free</a>
                        <a href="#features" class="btn btn-outline-secondary btn-lg px-4 py-3">
                            <i class="bi bi-play-circle me-2"></i> Watch Demo
                        </a>
                    </div>
                </div>
                <div class="col-lg-5 d-none d-lg-block" data-aos="zoom-in" data-aos-delay="200">
                    <div class="glass-card p-4 animate-float">
                        <div class="d-flex justify-content-between mb-4">
                            <span class="fw-bold"><i class="bi bi-graph-up-arrow text-success me-2"></i>Live Stock Velocity</span>
                            <span class="badge bg-soft-success rounded-pill">+24.5%</span>
                        </div>
                        <div class="progress mb-3" style="height: 8px;">
                            <div class="progress-bar bg-primary" style="width: 75%"></div>
                        </div>
                        <div class="d-flex justify-content-between small text-muted mb-4">
                            <span>Warehouse Capacity</span>
                            <span>75% Optimal</span>
                        </div>
                        <div class="p-3 bg-white rounded-3 border">
                            <div class="d-flex gap-3 align-items-center">
                                <div class="bg-soft-primary p-2 rounded"><i class="bi bi-box-seam text-primary"></i></div>
                                <div>
                                    <div class="fw-bold small">Latest Shipment</div>
                                    <div class="smallest text-muted">SKU-90210 Arrived</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="py-5">
        <div class="container py-5">
            <div class="row g-4">
                <div class="col-md-3" data-aos="fade-up">
                    <div class="stat-card">
                        <div class="display-5 fw-800 text-primary">99.9%</div>
                        <div class="small text-muted fw-bold">UPTIME GUARANTEE</div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card" style="border-color: var(--brand-green);">
                        <div class="display-5 fw-800 text-success">15M+</div>
                        <div class="small text-muted fw-bold">SKUs MANAGED</div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="display-5 fw-800 text-primary">2.4s</div>
                        <div class="small text-muted fw-bold">AVG. PROCESSING</div>
                    </div>
                </div>
                <div class="col-md-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card" style="border-color: var(--brand-green);">
                        <div class="display-5 fw-800 text-success">50k+</div>
                        <div class="small text-muted fw-bold">ACTIVE WAREHOUSES</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Core Solutions -->
    <section class="py-5 bg-white" id="features">
        <div class="container py-5">
            <div class="text-center mb-5">
                <h6 class="text-primary fw-bold text-uppercase tracking-widest">Solutions Ecosystem</h6>
                <h2 class="display-5 fw-800">Precision Architecture</h2>
            </div>
            <div class="row g-4">
                <div class="col-md-4" data-aos="fade-up">
                    <div class="card p-5 h-100 border-0 shadow-sm text-center">
                        <div class="icon-box text-primary fs-3"><i class="bi bi-box-seam"></i></div>
                        <h5 class="fw-bold mb-3">Product Lifecycle</h5>
                        <p class="text-muted small">Advanced JPA-backed inventory tracking with sub-second synchronization across all nodes.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="card p-5 h-100 border-0 shadow-sm text-center">
                        <div class="icon-box text-success fs-3"><i class="bi bi-people"></i></div>
                        <h5 class="fw-bold mb-3">Supplier Network</h5>
                        <p class="text-muted small">Comprehensive supplier relationship management integrated directly into your supply chain ledger.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="card p-5 h-100 border-0 shadow-sm text-center">
                        <div class="icon-box text-warning fs-3"><i class="bi bi-cloud-arrow-up"></i></div>
                        <h5 class="fw-bold mb-3">REST Interop</h5>
                        <p class="text-muted small">Native JAX-RS endpoints ensuring your data is accessible via mobile, web, or third-party integrations.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Pricing -->
    <section class="py-5" id="pricing" style="background: #f1f5f9;">
        <div class="container py-5 text-center">
            <h2 class="display-5 fw-800 mb-5">Scale Your Enterprise</h2>
            <div class="row g-4 justify-content-center">
                <div class="col-lg-4" data-aos="zoom-in">
                    <div class="card p-5 h-100 border-0 shadow-sm">
                        <h6 class="text-muted text-uppercase fw-bold small">Lite Edition</h6>
                        <div class="display-5 fw-800 my-4">290 DH <span class="fs-6 text-muted">/mo</span></div>
                        <ul class="list-unstyled text-start mb-5 gap-3 d-grid">
                            <li><i class="bi bi-check-circle-fill text-primary me-2"></i> 1,000 Stock Keeping Units</li>
                            <li><i class="bi bi-check-circle-fill text-primary me-2"></i> 3 Management Terminals</li>
                            <li><i class="bi bi-dash-circle text-muted me-2"></i> AI Prediction Disabled</li>
                        </ul>
                        <a href="login.jsp" class="btn btn-outline-primary w-100 py-3">Select Lite</a>
                    </div>
                </div>
                <div class="col-lg-4" data-aos="zoom-in" data-aos-delay="100">
                    <div class="card p-5 h-100 border-0 shadow-lg" style="background: var(--brand-blue); color: white;">
                        <h6 class="text-uppercase fw-bold small opacity-75">Enterprise Pro</h6>
                        <div class="display-5 fw-800 my-4">890 DH <span class="fs-6 opacity-75">/mo</span></div>
                        <ul class="list-unstyled text-start mb-5 gap-3 d-grid">
                            <li><i class="bi bi-check-circle-fill text-success me-2"></i> Unlimited Infrastructure</li>
                            <li><i class="bi bi-check-circle-fill text-success me-2"></i> Global Node Replication</li>
                            <li><i class="bi bi-check-circle-fill text-success me-2"></i> Full Predictive Engine</li>
                        </ul>
                        <a href="login.jsp" class="btn btn-light w-100 py-3 fw-bold text-primary">Deploy Pro Now</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="pt-5 border-top">
        <div class="container py-5">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <img src="${pageContext.request.contextPath}/assets/logo.png" alt="SmartStock ERP" style="height: 32px;" class="mb-4">
                    <p class="text-muted small" style="max-width: 400px;">SmartStock ERP is the definitive ecosystem for industrial performance. Built on the Jakarta EE 10 foundation for the 2026 digital landscape.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <div class="d-flex gap-4 justify-content-md-end fs-4 mb-4">
                        <a href="#" class="text-primary"><i class="bi bi-linkedin"></i></a>
                        <a href="#" class="text-dark"><i class="bi bi-github"></i></a>
                        <a href="#" class="text-info"><i class="bi bi-twitter-x"></i></a>
                    </div>
                    <p class="text-muted small">&copy; 2026 SmartStock ERP Global. Natural intelligence in logistics.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@next/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 1000, once: true });
        window.onscroll = function() {
            var nav = document.getElementById('mainNav');
            if (window.pageYOffset > 50) {
                nav.classList.add("scrolled");
            } else {
                nav.classList.remove("scrolled");
            }
        };
    </script>
</body>
</html>
