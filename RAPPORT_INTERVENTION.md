# Rapport d'Intervention : SmartStockERP v2.0

**Date :** 8 Avril 2026  
**Auteur :** Manus AI (Architecte Logiciel Senior)  
**Projet :** SmartStockERP (Java/Jakarta EE 10)

---

## 1. Résumé de l'intervention

L'objectif de cette mission était d'auditer, de refactoriser et d'améliorer le projet **SmartStockERP**. Le système a été transformé d'un prototype monolithique en une véritable application d'entreprise N-Tiers, intégrant une sécurité robuste via Oracle Database et de nouvelles fonctionnalités métier critiques pour la gestion de stock.

## 2. Refactorisation Architecturale (Clean Code)

L'architecture initiale présentait un fort couplage entre la couche de présentation (Servlets) et la couche d'accès aux données (Repositories JPA). Pour résoudre ce problème, une couche Service (Business Layer) a été introduite avec la création des classes `ProductService`, `SupplierService`, `UserService` et `PurchaseOrderService`. Cette nouvelle couche centralise désormais toute la logique métier, telle que le calcul des totaux, la vérification des seuils d'alerte et la gestion transactionnelle. 

De plus, la gestion des exceptions a été centralisée via la création de la classe `ApplicationException`, qui permet d'encapsuler les erreurs métier et de les remonter proprement jusqu'à l'interface utilisateur. L'injection de dépendances (CDI) a été généralisée avec l'utilisation de l'annotation `@Inject` pour lier les Servlets aux Services, et les Services aux Repositories, favorisant ainsi le découplage et la testabilité du code.

## 3. Implémentation de la Sécurité (Oracle & RBAC)

La sécurité codée en dur a été entièrement remplacée par un système d'authentification et d'autorisation professionnel. La modélisation de la base de données a été enrichie avec la création des entités JPA `User` et `Role`. Des scripts SQL Oracle (`01_security_schema.sql` et `02_generate_passwords.sql`) ont été rédigés pour générer les tables, les séquences, les contraintes d'intégrité et insérer les données initiales.

Le hachage des mots de passe a été sécurisé grâce à l'intégration de la bibliothèque `at.favre.lib:bcrypt` (version 0.10.2) dans le `pom.xml`. La classe `PasswordUtil` a été implémentée avec un facteur de coût de 12 (4096 itérations), garantissant une protection solide contre les attaques par force brute. Un utilitaire en ligne de commande, `PasswordHashGenerator`, a également été créé pour générer les empreintes des mots de passe lors de la configuration initiale.

La sécurisation des sessions et des routes a été renforcée. Le `LoginServlet` a été refactorisé pour vérifier les identifiants en base de données et implémenter une protection contre la fixation de session, en invalidant l'ancienne session avant la création de la nouvelle. Le `LogoutServlet` assure désormais une invalidation stricte de la session côté serveur et la suppression du cookie `JSESSIONID` côté client. Enfin, un `AuthenticationFilter` a été mis en place pour le contrôle d'accès basé sur les rôles (RBAC), protégeant les routes et réservant des zones spécifiques (comme `/admin`) au rôle `ADMIN`.

## 4. Nouvelles Fonctionnalités ERP

Pour rendre l'ERP pleinement opérationnel, quatre modules majeurs ont été développés.

Le **tableau de bord interactif** (Dashboard) a été repensé avec la création d'un `DashboardServlet` qui agrège les statistiques via la couche Service. Une interface moderne et responsive (`dashboard.jsp`) a été développée, incluant une barre de navigation latérale (`sidebar.jsp`) et un fichier CSS dédié (`layout.css`). La bibliothèque Chart.js a été intégrée pour visualiser graphiquement la répartition du stock (Sain, Faible, Rupture). Le tableau de bord affiche également les alertes critiques et les 10 derniers mouvements de stock en temps réel.

L'**historique des mouvements de stock** a été implémenté avec la création de l'entité `StockMovement`, permettant de tracer chaque modification (Entrée, Sortie, Ajustement). Le `StockMovementServlet` et les vues JSP associées ont été développés pour gérer cet historique. Toute modification de la quantité d'un produit (via `ProductService.addStock` ou `removeStock`) génère désormais automatiquement un enregistrement de traçabilité horodaté, lié à l'utilisateur ayant effectué l'opération.

La **gestion des bons de commande fournisseurs** a été ajoutée avec la création des entités `PurchaseOrder` et `PurchaseOrderItem` (relation One-To-Many). Un cycle de vie complet a été défini pour les commandes, passant de l'état *Brouillon* à *Envoyé*, puis *Partiellement Reçu*, *Reçu* ou *Annulé*. La réception d'une commande met automatiquement à jour les niveaux de stock via la couche Service et génère les mouvements de stock correspondants.

L'**exportation de rapports PDF professionnels** a été rendue possible grâce à l'intégration de la bibliothèque iText 7. La classe `PdfReportGenerator` a été créée pour générer à la volée (en streaming HTTP direct) des documents stylisés. Les rapports disponibles incluent un rapport d'inventaire complet avec valorisation financière, un rapport des alertes de stock, un rapport de traçabilité des mouvements, et un bon de commande officiel prêt à être envoyé au fournisseur (avec calculs HT/TTC).

## 5. Instructions de déploiement

Pour déployer cette nouvelle version, veuillez suivre les étapes résumées dans le tableau ci-dessous :

| Étape | Action requise | Détails |
| :--- | :--- | :--- |
| **1. Base de données Oracle** | Exécution du script SQL | Exécutez le script `src/main/resources/sql/01_security_schema.sql` dans votre instance Oracle (XEPDB1). |
| **2. Configuration JPA** | Vérification des paramètres | Assurez-vous que les paramètres de connexion dans `src/main/resources/META-INF/persistence.xml` correspondent à votre environnement. |
| **3. Compilation** | Build Maven | Exécutez `mvn clean install` pour télécharger les nouvelles dépendances (BCrypt, iText 7) et packager le fichier WAR. |
| **4. Connexion** | Test de l'application | Utilisez le compte administrateur par défaut : `admin@smartstock.com` avec le mot de passe `Admin@2024!`. |

## Conclusion

Le projet SmartStockERP dispose désormais d'une architecture N-Tiers solide, d'une sécurité conforme aux standards de l'industrie (BCrypt, RBAC, Sessions sécurisées) et d'un ensemble de fonctionnalités couvrant l'intégralité du cycle de vie des stocks (Commandes, Traçabilité, Reporting). Le code est documenté, modulaire et prêt pour de futures évolutions.
