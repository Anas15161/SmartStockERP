<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartStock ERP - Optimisez votre Supply Chain</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #0a58ca;
            --secondary-blue: #003366;
            --success-green: #198754;
            --light-bg: #f8f9fa;
            --dark-footer: #1a1a1a;
            --transition-smooth: all 0.3s ease-in-out;
        }

        body {
            font-family: 'Inter', sans-serif;
            overflow-x: hidden;
            color: #333;
        }

        /* --- Navbar --- */
        .navbar {
            transition: var(--transition-smooth);
            padding: 1rem 0;
            background: transparent;
        }

        .navbar.scrolled {
            background: white !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 0.5rem 0;
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary-blue) !important;
            font-size: 1.5rem;
        }

        .nav-link {
            font-weight: 500;
            color: #444 !important;
            margin: 0 10px;
        }

        .nav-link:hover {
            color: var(--primary-blue) !important;
        }

        /* --- Hero Section --- */
        .hero {
            position: relative;
            height: 100vh;
            min-height: 600px;
            display: flex;
            align-items: center;
            background: linear-gradient(rgba(0, 51, 102, 0.7), rgba(0, 51, 102, 0.7)), 
                        url('https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed; /* Effet Parallaxe */
            color: white;
            text-align: center;
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .hero p {
            font-size: 1.25rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        /* --- Stats Banner --- */
        .stats-banner {
            background: white;
            padding: 2rem 0;
            margin-top: -50px;
            position: relative;
            z-index: 10;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .stat-item h3 {
            color: var(--primary-blue);
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 0;
        }

        /* --- Features Section --- */
        .section-padding {
            padding: 100px 0;
        }

        .feature-card {
            padding: 40px;
            border-radius: 15px;
            background: white;
            transition: var(--transition-smooth);
            height: 100%;
            border: 1px solid #eee;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
        }

        .feature-icon {
            font-size: 3rem;
            color: var(--primary-blue);
            margin-bottom: 20px;
        }

        /* --- API Section --- */
        .api-section {
            background-color: var(--light-bg);
            border-left: 5px solid var(--primary-blue);
        }

        .code-snippet {
            background: #2d3436;
            color: #fab1a0;
            padding: 20px;
            border-radius: 10px;
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.9rem;
        }

        /* --- Pricing Section --- */
        .pricing-card {
            border: none;
            border-radius: 20px;
            transition: var(--transition-smooth);
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .pricing-card:hover {
            transform: scale(1.05);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }

        .pricing-header {
            background: white;
            padding: 30px;
            text-align: center;
        }

        .price {
            font-size: 3rem;
            font-weight: 700;
            color: var(--secondary-blue);
        }

        .btn-success-custom {
            background-color: var(--success-green);
            border: none;
            padding: 12px 30px;
            font-weight: 600;
        }

        /* --- Scroll Reveal Init --- */
        .reveal {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s ease-out;
        }

        .reveal.active {
            opacity: 1;
            transform: translateY(0);
        }

        /* --- Footer --- */
        footer {
            background: var(--dark-footer);
            color: white;
            padding: 60px 0 30px;
        }

        footer a {
            color: #bbb;
            text-decoration: none;
            transition: var(--transition-smooth);
        }

        footer a:hover {
            color: white;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg fixed-top" id="mainNavbar">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo" height="40" class="me-2">
                SmartStock ERP
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="#accueil">Accueil</a></li>
                    <li class="nav-item"><a class="nav-link" href="#features">Fonctionnalités</a></li>
                    <li class="nav-item"><a class="nav-link" href="#api">API</a></li>
                    <li class="nav-item"><a class="nav-link" href="#tarifs">Tarifs</a></li>
                    <li class="nav-item ms-lg-3">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a class="btn btn-primary rounded-pill px-4" href="${pageContext.request.contextPath}/dashboard">Tableau de bord</a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-outline-primary rounded-pill px-4 me-2" href="${pageContext.request.contextPath}/login.jsp">Connexion</a>
                                <a class="btn btn-primary rounded-pill px-4" href="${pageContext.request.contextPath}/login.jsp">Essai gratuit</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero" id="accueil">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <h1 class="display-3">Optimisez votre supply chain avec SmartStock ERP</h1>
                    <p class="lead">Une architecture J2EE robuste pour une gestion de stocks intelligente, une traçabilité totale et une intégration API transparente.</p>
                    <div class="d-grid gap-3 d-sm-flex justify-content-sm-center">
                        <a href="#features" class="btn btn-primary btn-lg px-5 py-3 rounded-pill">Découvrir les fonctions</a>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light btn-lg px-5 py-3 rounded-pill">Accéder au Dashboard</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-light btn-lg px-5 py-3 rounded-pill">Démarrer maintenant</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Counter Section -->
    <div class="container" id="counters">
        <div class="stats-banner">
            <div class="row text-center">
                <div class="col-md-4 stat-item">
                    <h3 class="counter" data-target="15000">0</h3>
                    <p class="text-muted fw-bold">Produits Gérés</p>
                </div>
                <div class="col-md-4 stat-item">
                    <h3 class="counter" data-target="450">0</h3>
                    <p class="text-muted fw-bold">Fournisseurs Actifs</p>
                </div>
                <div class="col-md-4 stat-item">
                    <h3 class="counter" data-target="250000">0</h3>
                    <p class="text-muted fw-bold">Transactions / mois</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <section class="section-padding" id="features">
        <div class="container">
            <div class="text-center mb-5 reveal">
                <h2 class="fw-bold">Pourquoi choisir SmartStock ERP ?</h2>
                <div class="bg-primary mx-auto mb-4" style="height: 3px; width: 60px;"></div>
            </div>
            <div class="row g-4">
                <div class="col-md-4 reveal">
                    <div class="feature-card text-center">
                        <i class="fas fa-chart-line feature-icon"></i>
                        <h4>Tableau de Bord Intelligent</h4>
                        <p class="text-muted">Visualisez vos KPIs en temps réel grâce à nos algorithmes de prédiction basés sur vos historiques de ventes.</p>
                    </div>
                </div>
                <div class="col-md-4 reveal">
                    <div class="feature-card text-center">
                        <i class="fas fa-layer-group feature-icon"></i>
                        <h4>Architecture MVC2</h4>
                        <p class="text-muted">Une séparation stricte entre données et présentation pour une maintenance facilitée et une scalabilité accrue.</p>
                    </div>
                </div>
                <div class="col-md-4 reveal">
                    <div class="feature-card text-center">
                        <i class="fas fa-shield-halved feature-icon"></i>
                        <h4>Audit Technique</h4>
                        <p class="text-muted">Journalisation complète des actions et gestion fine des permissions via des filtres de sécurité robustes.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- API & Integration Section -->
    <section class="section-padding api-section" id="api">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 mb-4 mb-lg-0 reveal">
                    <span class="badge bg-primary mb-3">Interopérabilité SOA</span>
                    <h2 class="fw-bold mb-4">API REST Intégrée (JAX-RS)</h2>
                    <p class="lead">Connectez vos terminaux mobiles ou vos partenaires logistiques directement à votre instance ERP.</p>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i> Format JSON standardisé</li>
                        <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i> Authentification JWT sécurisée</li>
                        <li class="mb-2"><i class="fas fa-check-circle text-success me-2"></i> Documentation Swagger disponible</li>
                    </ul>
                </div>
                <div class="col-lg-6 reveal">
                    <div class="code-snippet">
                        <span style="color: #55efc4;">GET</span> /api/products/stock<br>
                        {<br>
                        &nbsp;&nbsp;"id": "SKU-9921",<br>
                        &nbsp;&nbsp;"label": "Module SmartSensor",<br>
                        &nbsp;&nbsp;"quantity": 450,<br>
                        &nbsp;&nbsp;"status": "IN_STOCK"<br>
                        }
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Pricing Section -->
    <section class="section-padding" id="tarifs">
        <div class="container">
            <div class="text-center mb-5 reveal">
                <h2 class="fw-bold">Plans & Tarification</h2>
                <p class="text-muted">Une solution adaptée à la taille de votre entrepôt.</p>
            </div>
            <div class="row g-4">
                <!-- Plan 1 -->
                <div class="col-md-4 reveal">
                    <div class="card pricing-card h-100">
                        <div class="pricing-header">
                            <h5 class="text-uppercase text-muted">Starter</h5>
                            <div class="price">29€<small class="fs-6 text-muted">/mois</small></div>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled mb-4">
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Jusqu'à 500 produits</li>
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> 2 Utilisateurs</li>
                                <li class="mb-2 text-muted"><i class="fas fa-times me-2"></i> API REST</li>
                            </ul>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-primary w-100 py-2">Choisir Starter</a>
                        </div>
                    </div>
                </div>
                <!-- Plan 2 (Featured) -->
                <div class="col-md-4 reveal">
                    <div class="card pricing-card h-100 border-primary border-2">
                        <div class="pricing-header bg-primary text-white">
                            <h5 class="text-uppercase">Pro</h5>
                            <div class="price text-white">89€<small class="fs-6 opacity-75">/mois</small></div>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled mb-4">
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Produits illimités</li>
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> 10 Utilisateurs</li>
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> API REST incluse</li>
                            </ul>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-success-custom text-white w-100 py-2">Choisir Pro</a>
                        </div>
                    </div>
                </div>
                <!-- Plan 3 -->
                <div class="col-md-4 reveal">
                    <div class="card pricing-card h-100">
                        <div class="pricing-header">
                            <h5 class="text-uppercase text-muted">Enterprise</h5>
                            <div class="price">Sur devis</div>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled mb-4">
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Utilisateurs illimités</li>
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Support 24/7</li>
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Installation On-Premise</li>
                            </ul>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-primary w-100 py-2">Contacter l'équipe</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h5 class="fw-bold mb-4">SmartStock ERP</h5>
                    <p class="text-muted small">Solution ERP spécialisée dans la supply chain, développée pour la performance et la fiabilité industrielle.</p>
                </div>
                <div class="col-md-2 mb-4">
                    <h6 class="fw-bold mb-4">Liens Rapides</h6>
                    <ul class="list-unstyled small">
                        <li><a href="#accueil">Accueil</a></li>
                        <li><a href="#features">Fonctionnalités</a></li>
                        <li><a href="#tarifs">Tarifs</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4">
                    <h6 class="fw-bold mb-4">Technologie</h6>
                    <ul class="list-unstyled small">
                        <li>Java Enterprise Edition</li>
                        <li>Hibernate / JPA</li>
                        <li>JAX-RS (REST API)</li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4">
                    <h6 class="fw-bold mb-4">Contact</h6>
                    <p class="text-muted small"><i class="fas fa-envelope me-2"></i> contact@smartstock.tech</p>
                    <div class="mt-3">
                        <a href="#" class="me-3"><i class="fab fa-linkedin fa-lg"></i></a>
                        <a href="#" class="me-3"><i class="fab fa-github fa-lg"></i></a>
                    </div>
                </div>
            </div>
            <hr class="mt-4 border-secondary">
            <div class="text-center text-muted small mt-4">
                &copy; 2026 SmartStock ERP. Tous droits réservés.
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', () => {

            // 1. Navbar Change on Scroll
            const navbar = document.getElementById('mainNavbar');
            window.addEventListener('scroll', () => {
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            });

            // 2. Smooth Scrolling for Navbar Links
            document.querySelectorAll('a.nav-link, a.btn').forEach(anchor => {
                anchor.addEventListener('click', function(e) {
                    const href = this.getAttribute('href');
                    if (href && href.startsWith('#')) {
                        e.preventDefault();
                        const targetId = href.substring(1);
                        const targetElement = document.getElementById(targetId);
                        if (targetElement) {
                            window.scrollTo({
                                top: targetElement.offsetTop - 70,
                                behavior: 'smooth'
                            });
                        }
                    }
                });
            });

            // 3. Scroll Reveal Animations (IntersectionObserver)
            const revealElements = document.querySelectorAll('.reveal');
            const revealObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('active');
                    }
                });
            }, { threshold: 0.1 });

            revealElements.forEach(el => revealObserver.observe(el));

            // 4. Dynamic Counters Animation
            const counters = document.querySelectorAll('.counter');
            const speed = 200;

            const animateCounter = (counter) => {
                const target = +counter.getAttribute('data-target');
                const count = +counter.innerText;
                const increment = target / speed;

                if (count < target) {
                    counter.innerText = Math.ceil(count + increment);
                    setTimeout(() => animateCounter(counter), 1);
                } else {
                    counter.innerText = target.toLocaleString();
                }
            };

            // Trigger counters when they come into view
            const counterSection = document.getElementById('counters');
            let started = false;
            const counterObserver = new IntersectionObserver((entries) => {
                if (entries[0] && entries[0].isIntersecting && !started) {
                    counters.forEach(counter => animateCounter(counter));
                    started = true;
                }
            }, { threshold: 0.5 });

            if (counterSection) counterObserver.observe(counterSection);
        });
    </script>
</body>
</html>
