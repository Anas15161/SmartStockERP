# Audit et Plan d'Action - SmartStockERP

## 1. Audit du Code et de l'Architecture Actuelle

### 1.1 Architecture Actuelle
Le projet SmartStockERP est une application web Java basée sur Jakarta EE 10. Il utilise les technologies suivantes :
- **Backend :** Servlets, CDI (Weld), JPA (Hibernate 6.4)
- **Frontend :** JSP, JSTL, HTML/CSS (Bootstrap)
- **Base de données :** Oracle Database (via JDBC)
- **Serveur d'application cible :** Tomcat (avec Weld) ou GlassFish/Payara.

L'architecture actuelle est un MVC basique (Modèle-Vue-Contrôleur) où :
- Les **Modèles** (`Product`, `Supplier`, `GlobalSetting`) sont des entités JPA.
- Les **Vues** sont des fichiers JSP (`.jsp`).
- Les **Contrôleurs** sont des Servlets (`ProductServlet`, `SupplierServlet`, `LoginServlet`, etc.).
- L'accès aux données est géré par des **Repositories** (`GenericRepository`, `ProductRepository`, etc.) injectés via CDI (`@Inject`).

### 1.2 Points Forts
- Utilisation de Jakarta EE 10 et Hibernate 6.4 (technologies modernes).
- Bonne séparation des couches (Modèles, Repositories, Servlets).
- Utilisation de CDI pour l'injection de dépendances (`@Inject`).
- Utilisation de Bean Validation (`@NotNull`, `@Min`, etc.) sur les entités.
- Implémentation d'un `GenericRepository` pour mutualiser le code CRUD.

### 1.3 Faiblesses et Problèmes Identifiés (Audit)

#### A. Sécurité
1. **Authentification codée en dur :** Le `LoginServlet` vérifie les identifiants avec des chaînes codées en dur (`"admin@smartstock.com"` et `"admin123"`). Il n'y a aucune vérification en base de données.
2. **Absence de hachage des mots de passe :** Les mots de passe ne sont pas hachés.
3. **Absence de contrôle d'accès basé sur les rôles (RBAC) :** Le `AuthenticationFilter` vérifie uniquement la présence d'un attribut `user` en session, sans distinguer les rôles (Admin, Utilisateur standard).
4. **Gestion des sessions :** La gestion des sessions pourrait être renforcée (timeout, invalidation correcte).

#### B. Architecture et Clean Code
1. **Logique métier dans les Servlets :** Les Servlets (ex: `ProductServlet`, `SupplierServlet`) contiennent de la logique métier (validation manuelle, gestion de la pagination, construction de filtres de recherche complexes). Cette logique devrait être extraite dans une couche **Service**.
2. **Gestion des exceptions :** Les exceptions sont souvent relancées sous forme de `ServletException` sans traitement spécifique ni message convivial pour l'utilisateur.
3. **Redondance dans les Servlets :** La structure `doGet`/`doPost` avec un `switch` sur le paramètre `action` est répétitive et peu maintenable à long terme. L'utilisation d'un framework MVC plus robuste (comme Spring MVC ou Jakarta MVC) ou d'un contrôleur frontal (Front Controller) serait préférable, mais dans le cadre de Jakarta EE classique, l'introduction d'une couche Service est le minimum requis.

#### C. Performance
1. **Pagination manuelle :** La pagination est implémentée dans les repositories, ce qui est bien, mais le comptage total (`count()`) est exécuté à chaque requête de liste, ce qui peut être coûteux sur de grandes tables.
2. **Filtres de recherche :** La méthode `countFiltered` et `findFiltered` dans `ProductRepository` concatène des chaînes HQL manuellement, ce qui peut être source d'erreurs et moins performant/sécurisé que l'utilisation de l'API Criteria de JPA.

## 2. Plan d'Action Proposé

### Phase 1 : Implémentation de l'Authentification Sécurisée (Oracle & RBAC)
1. **Création des entités de sécurité :** Créer les entités `User` et `Role` (relation Many-To-Many ou Many-To-One selon le besoin).
2. **Scripts SQL Oracle :** Créer les scripts de création de tables et d'insertion de données de test (utilisateurs admin et standard).
3. **Intégration de BCrypt :** Ajouter la dépendance `jbcrypt` (ou équivalent) pour le hachage des mots de passe.
4. **Mise à jour du LoginServlet :** Modifier le servlet pour vérifier les identifiants en base de données via un `UserRepository` et un `UserService`.
5. **Amélioration du Filtre de Sécurité :** Mettre à jour `AuthenticationFilter` pour gérer les rôles (RBAC) et restreindre l'accès à certaines pages selon le rôle de l'utilisateur.

### Phase 2 : Refactorisation de l'Architecture (Couche Service)
1. **Création de la couche Service :** Créer des interfaces et implémentations de services (`ProductService`, `SupplierService`, `UserService`).
2. **Déplacement de la logique :** Déplacer la logique métier (validation, règles de gestion) des Servlets vers les Services. Les Servlets ne feront plus qu'appeler les Services et rediriger vers les vues.

### Phase 3 : Ajout des Nouvelles Fonctionnalités ERP
1. **Dashboard Interactif :**
   - Améliorer `DashboardServlet` et `dashboard.jsp`.
   - Ajouter des graphiques (via Chart.js par exemple) pour la valeur du stock, les alertes de rupture, etc.
2. **Gestion des Fournisseurs et Bons de Commande :**
   - Créer l'entité `PurchaseOrder` (Bon de commande) et `PurchaseOrderItem` (Ligne de commande).
   - Créer les Repositories, Services, Servlets et JSP associés.
3. **Historique des Mouvements de Stock :**
   - Créer l'entité `StockMovement` (Entrée/Sortie, Quantité, Date, Utilisateur, Produit).
   - Mettre à jour `ProductService` pour enregistrer un mouvement à chaque modification de stock.
   - Créer une vue pour consulter l'historique.
4. **Exportation de Rapports (PDF) :**
   - Intégrer une librairie Java (ex: iText ou Apache PDFBox) pour générer des rapports PDF (Inventaire, Bons de commande).
   - Créer un `ReportServlet` pour télécharger ces rapports.

## 3. Prochaines Étapes Immédiates
Pour commencer, je vais :
1. Configurer la connexion Oracle dans le projet (vérifier `persistence.xml`).
2. Créer les entités `User` et `Role` pour l'authentification.
3. Mettre en place le hachage des mots de passe et le login sécurisé.

Ce plan vous convient-il pour démarrer l'implémentation ?
