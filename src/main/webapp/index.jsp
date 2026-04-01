<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStock ERP | Next-Gen Supply Chain Intelligence</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        :root {
            --accent-blue: #0b5e9e;
            --accent-green: #4caf50;
            --light-bg: #f8fafc;
            --text-dark: #0f172a;
        }

        body {
            background-color: white;
            color: var(--text-dark);
        }

        .hero-section {
            padding: 160px 0 100px;
            background: radial-gradient(circle at 10% 20%, rgba(11, 94, 158, 0.03) 0%, transparent 40%),
                        radial-gradient(circle at 90% 80%, rgba(76, 175, 80, 0.03) 0%, transparent 40%);
        }

        .hero-badge {
            background: #e0f2fe;
            color: var(--accent-blue);
            padding: 8px 20px;
            border-radius: 100px;
            font-weight: 700;
            font-size: 0.8rem;
            display: inline-block;
            margin-bottom: 2rem;
            border: 1px solid rgba(11, 94, 158, 0.1);
        }

        .feature-icon-box {
            width: 64px; height: 64px;
            border-radius: 18px;
            background: var(--accent-blue);
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 1.5rem;
            box-shadow: 0 10px 20px rgba(11, 94, 158, 0.2);
        }

        .code-window {
            background: #1e293b;
            color: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            font-family: 'Courier New', monospace;
        }

        .navbar.scrolled {
            background: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05) !important;
        }

        .plan-pro {
            border: 2px solid var(--accent-blue) !important;
            transform: scale(1.05);
            z-index: 2;
        }
        
        .popular-badge {
            position: absolute;
            top: 20px;
            right: -30px;
            background: var(--accent-blue);
            color: white;
            padding: 5px 40px;
            transform: rotate(45deg);
            font-size: 0.7rem;
            font-weight: 800;
        }
        
        footer {
            background: #f1f5f9;
            padding: 80px 0 40px;
            border-top: 1px solid var(--border-color);
        }
    </style>
</head>
<body>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg fixed-top navbar-light bg-transparent" id="mainNav">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center fw-800" href="#">
                <i class="bi bi-box-seam-fill me-2" style="color: var(--accent-blue);"></i>SmartStock<span style="color: var(--accent-blue);">ERP</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navContent">
                <ul class="navbar-nav ms-auto align-items-center gap-2">
                    <li class="nav-item"><a class="nav-link px-3" href="#home">Platform</a></li>
                    <li class="nav-item"><a class="nav-link px-3" href="#features">Solutions</a></li>
                    <li class="nav-item"><a class="nav-link px-3" href="#pricing">Pricing</a></li>
                    <li class="nav-item ms-lg-4">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a class="btn btn-primary px-4" href="dashboard">Launch Console</a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-outline-primary px-4 me-2" href="login.jsp">Sign In</a>
                                <a class="btn btn-primary px-4" href="login.jsp">Start Free</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero -->
    <section class="hero-section text-center" id="home">
        <div class="container">
            <div class="hero-badge" data-aos="fade-down">ENTERPRISE EDITION 2026</div>
            <h1 class="display-3 fw-800 mb-4" data-aos="fade-up">
                Professional <span style="color: var(--accent-blue);">Inventory</span> <br>
                For Modern Businesses
            </h1>
            <p class="text-muted mb-5 mx-auto" style="max-width: 650px;" data-aos="fade-up" data-aos-delay="100">
                A natural, high-performance J2EE ecosystem designed to optimize your warehouse operations, 
                suppliers, and supply chain intelligence.
            </p>
            <div class="d-flex gap-3 justify-content-center" data-aos="fade-up" data-aos-delay="200">
                <a href="login.jsp" class="btn btn-primary btn-lg px-5 py-3 shadow-lg">Get Started Free</a>
                <a href="#features" class="btn btn-outline-secondary btn-lg px-5 py-3">Explore Features</a>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section class="py-5" id="features">
        <div class="container py-5">
            <div class="row g-4">
                <div class="col-md-4" data-aos="fade-up">
                    <div class="card p-5 h-100 border-0 shadow-sm">
                        <div class="feature-icon-box"><i class="bi bi-speedometer2 text-white fs-3"></i></div>
                        <h5 class="fw-bold">Real-time Analytics</h5>
                        <p class="text-muted small">Monitor your stock levels with sub-second accuracy and automated alerts.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="card p-5 h-100 border-0 shadow-sm">
                        <div class="feature-icon-box" style="background: var(--accent-green);"><i class="bi bi-people text-white fs-3"></i></div>
                        <h5 class="fw-bold">Supplier Portal</h5>
                        <p class="text-muted small">Maintain strategic relationships with a unified portal for partner management.</p>
                    </div>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="card p-5 h-100 border-0 shadow-sm">
                        <div class="feature-icon-box" style="background: #f59e0b;"><i class="bi bi-shield-lock text-white fs-3"></i></div>
                        <h5 class="fw-bold">Secure Audits</h5>
                        <p class="text-muted small">Full traceability with immutable logs powered by enterprise-grade JPA/Hibernate.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Pricing -->
    <section class="py-5 bg-light" id="pricing">
        <div class="container py-5 text-center">
            <h2 class="fw-800 mb-5">Professional Pricing Plans</h2>
            <div class="row g-4 justify-content-center">
                <div class="col-lg-4" data-aos="zoom-in">
                    <div class="card p-5 h-100 border-0 shadow-sm">
                        <h6 class="text-muted uppercase fw-bold">Starter</h6>
                        <div class="display-4 fw-800 my-3">290 DH <span class="fs-6 text-muted">/mo</span></div>
                        <ul class="list-unstyled text-start mt-4 mb-5">
                            <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i> 500 Products</li>
                            <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i> 2 Users</li>
                            <li class="mb-2 text-muted"><i class="bi bi-x text-danger me-2"></i> Advanced API</li>
                        </ul>
                        <a href="login.jsp" class="btn btn-outline-primary w-100 py-3 rounded-pill">Select Plan</a>
                    </div>
                </div>
                <div class="col-lg-4" data-aos="zoom-in" data-aos-delay="100">
                    <div class="card p-5 h-100 plan-pro shadow-lg position-relative">
                        <div class="popular-badge">Preferred</div>
                        <h6 class="text-muted uppercase fw-bold">Professional</h6>
                        <div class="display-4 fw-800 my-3" style="color: var(--accent-blue);">890 DH <span class="fs-6 text-muted">/mo</span></div>
                        <ul class="list-unstyled text-start mt-4 mb-5">
                            <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i> Unlimited Products</li>
                            <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i> 10 Users</li>
                            <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i> REST API Included</li>
                            <li class="mb-2"><i class="bi bi-check2 text-success me-2"></i> AI Demand Prediction</li>
                        </ul>
                        <a href="login.jsp" class="btn btn-primary w-100 py-3 rounded-pill">Get Started Now</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5 class="fw-800 mb-4" style="color: var(--accent-blue);">SmartStock ERP</h5>
                    <p class="text-muted small">Industrial performance, natural intelligence. Build your warehouse ecosystem on the foundation of 2026 ERP technology.</p>
                </div>
                <div class="col-md-2 offset-md-2">
                    <h6 class="fw-bold mb-4">Product</h6>
                    <ul class="list-unstyled small text-muted">
                        <li class="mb-2">Features</li>
                        <li class="mb-2">Pricing</li>
                        <li class="mb-2">Console</li>
                    </ul>
                </div>
                <div class="col-md-4 text-md-end">
                    <h6 class="fw-bold mb-4">Global Network</h6>
                    <div class="d-flex gap-3 justify-content-md-end fs-4">
                        <i class="bi bi-linkedin" style="color: var(--accent-blue);"></i>
                        <i class="bi bi-github"></i>
                        <i class="bi bi-twitter-x"></i>
                    </div>
                </div>
            </div>
            <hr class="my-5 opacity-10">
            <p class="text-center text-muted small">&copy; 2026 SmartStock ERP Global. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@next/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 800, once: true });
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
