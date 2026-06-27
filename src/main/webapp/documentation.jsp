<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documentation Technique | SmartStock ERP</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        :root {
            --doc-sidebar-width: 280px;
        }
        
        body { background-color: #f1f5f9; }

        .doc-header {
            background: linear-gradient(135deg, var(--brand-blue-dark) 0%, var(--brand-blue) 100%);
            padding: 80px 0;
            color: white;
            border-bottom: 4px solid var(--brand-green);
        }

        .tech-badge {
            background: white;
            padding: 15px 25px;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            display: flex;
            align-items: center;
            gap: 15px;
            transition: var(--transition-smooth);
            border: 1px solid transparent;
        }

        .tech-badge:hover {
            border-color: var(--brand-blue);
            transform: translateY(-5px);
        }

        .folder-tree {
            font-family: 'Courier New', monospace;
            background: #1e293b;
            color: #e2e8f0;
            padding: 30px;
            border-radius: 16px;
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .folder-tree .dir { color: #3b82f6; font-weight: bold; }
        .folder-tree .file { color: #10b981; }
        .folder-tree .comment { color: #64748b; font-style: italic; }

        .doc-section { padding: 60px 0; border-bottom: 1px solid #e2e8f0; }
        .doc-section:last-child { border: none; }

        .sticky-toc {
            position: sticky;
            top: 100px;
            background: white;
            padding: 25px;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
        }

        .toc-link {
            display: block;
            padding: 8px 0;
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
        }

        .toc-link:hover { color: var(--brand-blue); transform: translateX(5px); }
    </style>
</head>
<body>

    <jsp:include page="includes/header.jsp" />

    <header class="doc-header">
        <div class="container text-center">
            <img src="${pageContext.request.contextPath}/assets/logo.png" alt="Logo" style="height: 100px; margin-bottom: 2rem;">
            <h1 class="display-4 fw-800">Documentation Technique</h1>
            <p class="lead opacity-75">Architecture, Technologies et Guide de Déploiement de SmartStock ERP</p>
        </div>
    </header>

    <main class="container py-5">
        <div class="row">
            <!-- Table des matières -->
            <div class="col-lg-3 d-none d-lg-block">
                <div class="sticky-toc">
                    <h6 class="fw-800 text-uppercase mb-3">Navigation</h6>
                    <a href="#overview" class="toc-link">1. Aperçu du Projet</a>
                    <a href="#tech-stack" class="toc-link">2. Stack Technologique</a>
                    <a href="#architecture" class="toc-link">3. Architecture des Dossiers</a>
                    <a href="#features" class="toc-link">4. Fonctionnalités Clés</a>
                    <a href="#deployment" class="toc-link">5. Installation & Déploiement</a>
                </div>
            </div>

            <!-- Contenu principal -->
            <div class="col-lg-9">
                <!-- Aperçu -->
                <section id="overview" class="doc-section pt-0" data-aos="fade-up">
                    <h2 class="fw-800 mb-4 text-gradient-blue">1. Aperçu du Projet</h2>
                    <p class="lead text-muted">
                        SmartStock ERP est une solution de gestion de stock nouvelle génération conçue pour les entreprises modernes. 
                        Elle combine la robustesse de l'architecture J2EE avec une interface utilisateur dynamique pour offrir une traçabilité totale et une intelligence logistique en temps réel.
                    </p>
                    <div class="card border-0 shadow-sm p-4 mt-4 bg-white">
                        <h5 class="fw-bold mb-3"><i class="bi bi-bullseye text-primary me-2"></i>Mission</h5>
                        <p class="mb-0">Optimiser les flux de marchandises, automatiser la gestion des fournisseurs et fournir des outils analytiques précis pour la prise de décision stratégique.</p>
                    </div>
                </section>

                <!-- Stack Technique -->
                <section id="tech-stack" class="doc-section" data-aos="fade-up">
                    <h2 class="fw-800 mb-4 text-gradient-blue">2. Stack Technologique</h2>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="tech-badge">
                                <div class="fs-1 text-primary"><i class="bi bi-code-square"></i></div>
                                <div>
                                    <h6 class="fw-bold mb-1">Backend Jakarta EE 10</h6>
                                    <p class="smallest text-muted mb-0">Servlet 6.0, JSP 3.1, CDI 4.0</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="tech-badge">
                                <div class="fs-1 text-success"><i class="bi bi-database"></i></div>
                                <div>
                                    <h6 class="fw-bold mb-1">Persistance & Données</h6>
                                    <p class="smallest text-muted mb-0">JPA, Hibernate, Oracle Database</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="tech-badge">
                                <div class="fs-1 text-info"><i class="bi bi-palette"></i></div>
                                <div>
                                    <h6 class="fw-bold mb-1">Frontend UI/UX</h6>
                                    <p class="smallest text-muted mb-0">Bootstrap 5, AOS, FontAwesome</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="tech-badge">
                                <div class="fs-1 text-warning"><i class="bi bi-tools"></i></div>
                                <div>
                                    <h6 class="fw-bold mb-1">Build & Gestion</h6>
                                    <p class="smallest text-muted mb-0">Maven 3.x, Git</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Architecture -->
                <section id="architecture" class="doc-section" data-aos="fade-up">
                    <h2 class="fw-800 mb-4 text-gradient-blue">3. Architecture des Dossiers</h2>
                    <div class="folder-tree">
                        <div><span class="dir">SmartStockERP/</span></div>
                        <div>├── <span class="dir">src/main/java/com/smartstock/erp/</span> <span class="comment">// Cœur de l'application</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;├── <span class="dir">config/</span> <span class="comment">// Configuration JPA et Injection</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;├── <span class="dir">model/</span> <span class="comment">// Entités Product, Supplier (POJOs)</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;├── <span class="dir">repository/</span> <span class="comment">// Couche d'accès aux données (DAO)</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;├── <span class="dir">servlet/</span> <span class="comment">// Contrôleurs MVC</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;└── <span class="dir">resource/</span> <span class="comment">// Endpoints RESTful (Jakarta RS)</span></div>
                        <div>├── <span class="dir">src/main/resources/</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;└── <span class="dir">META-INF/</span> <span class="file">persistence.xml</span> <span class="comment">// Config DB</span></div>
                        <div>├── <span class="dir">src/main/webapp/</span> <span class="comment">// Ressources Web</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;├── <span class="dir">assets/</span> <span class="comment">// Images et logos</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;├── <span class="dir">css/</span> <span class="comment">// Styles personnalisés</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;├── <span class="dir">includes/</span> <span class="comment">// Fragments (header, footer)</span></div>
                        <div>│&nbsp;&nbsp;&nbsp;└── <span class="dir">WEB-INF/</span> <span class="comment">// Config Web & Vues Dashboard</span></div>
                        <div>└── <span class="file">pom.xml</span> <span class="comment">// Dépendances Maven</span></div>
                    </div>
                </section>

                <!-- Features -->
                <section id="features" class="doc-section" data-aos="fade-up">
                    <h2 class="fw-800 mb-4 text-gradient-blue">4. Fonctionnalités Clés</h2>
                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="card h-100 p-4 border-0 shadow-sm text-center">
                                <i class="bi bi-box-seam text-primary fs-2 mb-3"></i>
                                <h6 class="fw-bold">Gestion Stock</h6>
                                <p class="smallest text-muted">CRUD complet, alertes de seuil critique et catégorisation intelligente.</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card h-100 p-4 border-0 shadow-sm text-center">
                                <i class="bi bi-people text-success fs-2 mb-3"></i>
                                <h6 class="fw-bold">Portail Fournisseurs</h6>
                                <p class="smallest text-muted">Suivi des partenaires, historiques d'achats et gestion des contacts.</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card h-100 p-4 border-0 shadow-sm text-center">
                                <i class="bi bi-shield-lock text-warning fs-2 mb-3"></i>
                                <h6 class="fw-bold">Sécurité RBAC</h6>
                                <p class="smallest text-muted">Filtrage d'authentification robuste et sessions sécurisées.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Installation -->
                <section id="deployment" class="doc-section" data-aos="fade-up">
                    <h2 class="fw-800 mb-4 text-gradient-blue">5. Installation & Déploiement</h2>
                    <ol class="list-group list-group-numbered border-0 shadow-sm">
                        <li class="list-group-item d-flex justify-content-between align-items-start border-0 p-4">
                            <div class="ms-2 me-auto">
                                <div class="fw-bold">Prérequis</div>
                                JDK 1.8+, Maven 3.x, Serveur Tomcat 10+ et Oracle Database 8.0.
                            </div>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-start border-0 p-4">
                            <div class="ms-2 me-auto">
                                <div class="fw-bold">Configuration Base de Données</div>
                                Éditez <span class="text-primary fw-bold">persistence.xml</span> avec vos identifiants Oracle Database.
                            </div>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-start border-0 p-4">
                            <div class="ms-2 me-auto">
                                <div class="fw-bold">Build & Run</div>
                                Exécutez <code class="bg-light p-1">mvn clean install</code> puis déployez le fichier WAR sur Tomcat.
                            </div>
                        </li>
                    </ol>
                </section>
            </div>
        </div>
    </main>

    <footer class="bg-white border-top py-4 mt-5">
        <div class="container text-center">
            <p class="text-muted small mb-0">&copy; 2026 SmartStock ERP | Documentation Technique Officielle</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@next/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 800, once: true });
    </script>
</body>
</html>
