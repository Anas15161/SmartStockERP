# Guide des fichiers et dossiers — SmartStockERP

Ce document explique l’utilité des principaux fichiers et dossiers du dépôt.

## Racine du projet

- `pom.xml` : fichier de configuration Maven (dépendances, build, plugins).
- `mvnw` / `mvnw.cmd` : scripts Maven Wrapper (Linux/macOS et Windows).
- `.mvn/wrapper/` : fichiers internes du Maven Wrapper.
- `.gitignore` : liste des fichiers/dossiers ignorés par Git.
- `.idea/` : configuration locale IntelliJ IDEA (non fonctionnelle pour l’application en production).
- `logo.png` : ressource image du projet.

## Documentation et livrables

- `presentation.html` : présentation du projet en HTML.
- `database_guide.html` : guide sur la base de données.
- `data_scope.html` : description du périmètre des données.
- `document.tex` : document LaTeX principal.
- `rapport_smartstock.tex` : rapport SmartStock (version 1).
- `rapport_smartstock_v2.tex` : rapport SmartStock (version 2).
- `rapport_professionnel_smartstock.tex` : rapport professionnel.

## Code source Java

### `src/main/java/com/smartstock/erp/`

- `JaxRsApplication.java` : point d’entrée/configuration JAX-RS pour les API REST.

### `src/main/java/com/smartstock/erp/model/`

- `Product.java` : entité métier Produit.
- `Supplier.java` : entité métier Fournisseur.
- `GlobalSetting.java` : entité des paramètres globaux.

### `src/main/java/com/smartstock/erp/repository/`

- `GenericRepository.java` : opérations CRUD génériques.
- `ProductRepository.java` : accès données pour les produits.
- `SupplierRepository.java` : accès données pour les fournisseurs.
- `GlobalSettingRepository.java` : accès données pour les paramètres globaux.

### `src/main/java/com/smartstock/erp/config/`

- `EntityManagerProducer.java` : production/injection de l’`EntityManager`.
- `ValidationProducer.java` : production/injection des composants de validation.
- `AppContextListener.java` : initialisation et cycle de vie du contexte applicatif.

### `src/main/java/com/smartstock/erp/servlet/`

- `LoginServlet.java` : gestion de la connexion utilisateur.
- `LogoutServlet.java` : gestion de la déconnexion.
- `DashboardServlet.java` : affichage/chargement du tableau de bord.
- `ProductServlet.java` : endpoints/actions web pour les produits.
- `SupplierServlet.java` : endpoints/actions web pour les fournisseurs.
- `SettingsServlet.java` : gestion des paramètres de l’application.
- `AuthenticationFilter.java` : filtre d’authentification (protection des routes).
- `SettingsFilter.java` : filtre lié aux paramètres globaux.

### `src/main/java/com/smartstock/erp/resource/`

- `HelloResource.java` : endpoint REST de test/hello.
- `ProductResource.java` : API REST liée aux produits.

## Ressources et configuration

### `src/main/resources/META-INF/`

- `persistence.xml` : configuration JPA (unité de persistance, datasource, provider).

## Vue web (JSP/CSS)

### `src/main/webapp/`

- `index.jsp` : page d’accueil.
- `login.jsp` : page de connexion.
- `documentation.jsp` : page de documentation intégrée.
- `presentation.jsp` : page de présentation.
- `css/style.css` : styles CSS globaux.
- `assets/logo.png` : logo côté interface web.
- `includes/header.jsp` : fragment réutilisable d’en-tête.

### `src/main/webapp/products/`

- `list.jsp` : liste des produits.
- `add.jsp` : création d’un produit.
- `edit.jsp` : modification d’un produit.
- `form.jsp` : formulaire partagé produit (si utilisé).

### `src/main/webapp/suppliers/`

- `list.jsp` : liste des fournisseurs.
- `add.jsp` : création d’un fournisseur.
- `edit.jsp` : modification d’un fournisseur.

### `src/main/webapp/WEB-INF/`

- `web.xml` : configuration du déploiement Java web (servlets, filtres, mappings).
- `beans.xml` : activation/configuration CDI.
- `views/dashboard.jsp` : vue tableau de bord (zone protégée).
- `views/settings.jsp` : vue paramètres (zone protégée).

---

## Résumé de l’architecture

Le projet est une application web Java (Servlet/JSP + JPA/CDI + JAX-RS) structurée en couches :

- **Model** : entités métier (`model/`)
- **Repository** : accès base de données (`repository/`)
- **Servlet/Resource** : logique web MVC + endpoints REST (`servlet/`, `resource/`)
- **View** : interfaces JSP/CSS (`src/main/webapp/`)
- **Configuration** : bootstrap, persistence, CDI (`config/`, `WEB-INF/`, `persistence.xml`)
