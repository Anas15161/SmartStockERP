<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Présentation Interactive | SmartStock ERP</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        body, html { height: 100%; overflow: hidden; background: #0f172a; }
        
        .slide-container {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.8s cubic-bezier(0.645, 0.045, 0.355, 1);
        }

        .slide {
            min-width: 100vw;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4rem;
            color: white;
            position: relative;
        }

        .slide-content {
            max-width: 1200px;
            width: 100%;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
        }

        @media (max-width: 992px) {
            .slide-content { grid-template-columns: 1fr; text-align: center; }
            .browser-mockup { display: none; }
        }

        .browser-mockup {
            background: #f1f5f9;
            border-radius: 12px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.5);
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .browser-header {
            background: #e2e8f0;
            padding: 10px 15px;
            display: flex;
            gap: 6px;
        }

        .dot { width: 10px; height: 10px; border-radius: 50%; background: #cbd5e1; }
        .dot.red { background: #ff5f56; }
        .dot.yellow { background: #ffbd2e; }
        .dot.green { background: #27c93f; }

        .browser-body {
            background: white;
            padding: 1rem;
            min-height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .slide-nav {
            position: fixed;
            bottom: 40px;
            right: 40px;
            display: flex;
            gap: 15px;
            z-index: 1000;
        }

        .nav-btn {
            width: 60px; height: 60px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.1);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .nav-btn:hover { background: var(--brand-blue); border-color: var(--brand-blue); }

        .slide-indicator {
            position: fixed;
            bottom: 40px;
            left: 40px;
            color: rgba(255,255,255,0.5);
            font-weight: 800;
            font-size: 1.5rem;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin-top: 2rem;
        }

        .feature-list li {
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .feature-list i { color: var(--brand-green); }
        
        .bg-gradient-1 { background: radial-gradient(circle at 10% 20%, #0f172a 0%, #1e293b 100%); }
        .bg-gradient-2 { background: radial-gradient(circle at 90% 80%, #074a7d 0%, #0f172a 100%); }
        .bg-gradient-3 { background: radial-gradient(circle at 10% 80%, #064e3b 0%, #0f172a 100%); }
    </style>
</head>
<body>

    <div class="slide-indicator" id="slideNum">01 / 05</div>

    <div class="slide-container" id="container">
        <!-- Slide 1: Introduction -->
        <section class="slide bg-gradient-1">
            <div class="slide-content">
                <div>
                    <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo" style="height: 80px;" class="mb-4">
                    <h1 class="display-3 fw-800 mb-4">SmartStock <span class="text-success">ERP</span></h1>
                    <p class="lead opacity-75">Système de gestion d'inventaire intelligent conçu pour l'excellence industrielle et la performance logistique.</p>
                    <ul class="feature-list">
                        <li><i class="bi bi-check-circle-fill"></i> Architecture Jakarta EE 10 (Robustesse)</li>
                        <li><i class="bi bi-check-circle-fill"></i> Interface Moderne & Responsive</li>
                        <li><i class="bi bi-check-circle-fill"></i> Sécurité de Niveau Entreprise</li>
                    </ul>
                </div>
                <div class="browser-mockup">
                    <div class="browser-header">
                        <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                    </div>
                    <div class="browser-body">
                        <img src="${pageContext.request.contextPath}/assets/logo.png" style="width: 200px; filter: grayscale(1); opacity: 0.1;">
                    </div>
                </div>
            </div>
        </section>

        <!-- Slide 2: Dashboard -->
        <section class="slide bg-gradient-2">
            <div class="slide-content">
                <div>
                    <h2 class="display-4 fw-800 mb-4">Terminal de <span class="text-info">Contrôle</span></h2>
                    <p class="lead">Le cerveau du système. Visualisez l'état global de votre entreprise en une seconde.</p>
                    <ul class="feature-list">
                        <li><i class="bi bi-graph-up-arrow"></i> Statistiques en temps réel (Produits, Fournisseurs)</li>
                        <li><i class="bi bi-lightning-charge"></i> Accès rapide aux actions critiques</li>
                        <li><i class="bi bi-bell"></i> Alertes de stock bas automatisées</li>
                    </ul>
                </div>
                <div class="browser-mockup">
                    <div class="browser-header">
                        <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                    </div>
                    <div class="browser-body bg-light d-block p-4">
                        <div class="row g-2">
                            <div class="col-6"><div class="p-3 bg-white rounded shadow-sm border-start border-primary border-4 text-dark small fw-bold">PRODUITS: 154</div></div>
                            <div class="col-6"><div class="p-3 bg-white rounded shadow-sm border-start border-success border-4 text-dark small fw-bold">PARTENAIRES: 42</div></div>
                            <div class="col-12 mt-3"><div class="p-4 bg-white rounded shadow-sm text-center text-muted small"><i class="bi bi-activity me-2"></i>Graphique d'activité</div></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Slide 3: Gestion Inventaire -->
        <section class="slide bg-gradient-3">
            <div class="slide-content">
                <div>
                    <h2 class="display-4 fw-800 mb-4">Gestion de <span class="text-success">l'Inventaire</span></h2>
                    <p class="lead">Un module CRUD ultra-puissant pour maîtriser chaque unité de votre stock.</p>
                    <ul class="feature-list">
                        <li><i class="bi bi-plus-circle"></i> Ajout rapide avec validation stricte</li>
                        <li><i class="bi bi-pencil-square"></i> Mise à jour dynamique des quantités</li>
                        <li><i class="bi bi-trash"></i> Suppression sécurisée avec confirmation</li>
                        <li><i class="bi bi-funnel"></i> Tri et filtrage par prix et quantité</li>
                    </ul>
                </div>
                <div class="browser-mockup">
                    <div class="browser-header">
                        <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                    </div>
                    <div class="browser-body bg-light d-block p-3">
                        <div class="table-responsive bg-white rounded shadow-sm p-2" style="font-size: 10px;">
                            <table class="table table-sm text-dark">
                                <thead class="table-dark"><tr><th>Nom</th><th>Prix</th><th>Qte</th></tr></thead>
                                <tbody>
                                    <tr><td>MacBook Pro</td><td>25000 DH</td><td>12</td></tr>
                                    <tr><td>iPhone 15</td><td>12000 DH</td><td>45</td></tr>
                                    <tr><td>Logitech MX</td><td>1200 DH</td><td>8</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Slide 4: Partenaires -->
        <section class="slide bg-gradient-2">
            <div class="slide-content">
                <div>
                    <h2 class="display-4 fw-800 mb-4">Réseau <span class="text-warning">Partenaires</span></h2>
                    <p class="lead">Gérez vos relations fournisseurs pour une chaîne d'approvisionnement fluide.</p>
                    <ul class="feature-list">
                        <li><i class="bi bi-person-badge"></i> Profils détaillés (Email, Téléphone)</li>
                        <li><i class="bi bi-link-45deg"></i> Association directe avec les produits</li>
                        <li><i class="bi bi-envelope-at"></i> Communication facilitée</li>
                    </ul>
                </div>
                <div class="browser-mockup">
                    <div class="browser-header">
                        <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                    </div>
                    <div class="browser-body bg-light d-block p-3">
                        <div class="d-flex flex-wrap gap-2">
                            <div class="p-2 bg-white rounded shadow-sm text-dark small fw-bold" style="width: 48%;"><i class="bi bi-building me-2"></i>Tech Corp</div>
                            <div class="p-2 bg-white rounded shadow-sm text-dark small fw-bold" style="width: 48%;"><i class="bi bi-building me-2"></i>Global Logis</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Slide 5: Persistance -->
        <section class="slide bg-gradient-1">
            <div class="slide-content">
                <div>
                    <h2 class="display-4 fw-800 mb-4">Robustesse <span class="text-primary">JPA/Hibernate</span></h2>
                    <p class="lead">La persistance des données au cœur du système pour une sécurité maximale.</p>
                    <ul class="feature-list">
                        <li><i class="bi bi-database-check"></i> Transactions ACID sécurisées</li>
                        <li><i class="bi bi-shield-shaded"></i> Protection contre les injections SQL</li>
                        <li><i class="bi bi-cpu-fill"></i> Mapping Objet-Relationnel (ORM) haute performance</li>
                    </ul>
                </div>
                <div class="browser-mockup">
                    <div class="browser-header">
                        <div class="dot red"></div><div class="dot yellow"></div><div class="dot green"></div>
                    </div>
                    <div class="browser-body bg-dark d-block p-3 text-white">
                        <code style="font-size: 10px; color: #a5d6ff;">@Entity<br>public class Product {<br>&nbsp;&nbsp;@Id @GeneratedValue<br>&nbsp;&nbsp;private Long id;<br>&nbsp;&nbsp;private String name;<br>&nbsp;&nbsp;private Double price;<br>}</code>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <div class="slide-nav">
        <div class="nav-btn" onclick="prevSlide()"><i class="bi bi-arrow-left fs-3"></i></div>
        <div class="nav-btn" onclick="nextSlide()"><i class="bi bi-arrow-right fs-3"></i></div>
        <a href="${pageContext.request.contextPath}/documentation.jsp" class="nav-btn" title="Retour Documentation"><i class="bi bi-journal-text fs-3"></i></a>
    </div>

    <script>
        let currentSlide = 0;
        const totalSlides = 5;
        const container = document.getElementById('container');
        const slideNum = document.getElementById('slideNum');

        function updateSlide() {
            container.style.transform = `translateX(-${currentSlide * 100}vw)`;
            slideNum.innerText = `0${currentSlide + 1} / 05`;
        }

        function nextSlide() {
            if (currentSlide < totalSlides - 1) {
                currentSlide++;
                updateSlide();
            }
        }

        function prevSlide() {
            if (currentSlide > 0) {
                currentSlide--;
                updateSlide();
            }
        }

        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowRight') nextSlide();
            if (e.key === 'ArrowLeft') prevSlide();
        });
    </script>
</body>
</html>
