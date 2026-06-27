# 📦 SmartStockERP — Système de Gestion de Stocks & Approvisionnements (Jakarta EE 10)

SmartStockERP est un progiciel de gestion intégré (ERP) de nouvelle génération conçu pour optimiser, tracer et sécuriser l'intégralité du cycle de vie des stocks et des approvisionnements au sein d'une entreprise. Développé en Java/Jakarta EE 10 selon une architecture N-Tiers, ce projet est relié à une base de données Oracle et propose des fonctionnalités modernes de pilotage opérationnel, de sécurité et d'analyse financière.

---

## 🚀 Fonctionnalités Majeures

### 1. Architecture N-Tiers & Clean Code
*   **Couche de Présentation** : Servlets MVC et pages JSP dynamiques, stylisées en Vanilla CSS moderne.
*   **Couche Métier (Service)** : Centralise la logique d'entreprise (calculs financiers, seuils d'alertes, automatisation des mouvements).
*   **Couche de Persistance (Repository)** : Opérations CRUD génériques et requêtes personnalisées via JPA/Hibernate.
*   **Injection de Dépendances (CDI)** : Découplage complet via l'injection contextuelle (`@Inject`).

### 2. Sécurité d'Entreprise & Contrôle d'Accès (RBAC)
*   **Authentification Robuste** : Gestion des sessions utilisateurs avec protection intégrée contre la fixation de session.
*   **Hachage Cryptographique** : Stockage sécurisé des mots de passe avec **BCrypt** (facteur de coût de 12 / 4096 itérations).
*   **Contrôle d'Accès (Role-Based Access Control)** : Filtrage automatique des requêtes (`AuthenticationFilter`) pour restreindre les vues critiques aux administrateurs.
*   **Déconnexion Sécurisée** : Invalidation stricte côté serveur et suppression du cookie de session `JSESSIONID` côté client.

### 3. Gestion & Traçabilité des Mouvements de Stock
*   **Historique exhaustif** des Entrées, Sorties et Ajustements.
*   **Création automatique** d'enregistrements de traçabilité horodatés pour chaque modification de stock, liant l'opération à l'utilisateur responsable.
*   **Suivi en temps réel** des niveaux de stock avec détection automatique des ruptures et des seuils d'alerte.

### 4. Cycle de vie des Bons de Commande Fournisseurs
*   **Gestion complète des commandes** (Brouillon, Envoyé, Partiellement Reçu, Reçu, Annulé).
*   **Relation One-To-Many** entre la commande (`PurchaseOrder`) et les articles commandés (`PurchaseOrderItem`).
*   **Intégration automatique** : la réception d'une commande met à jour automatiquement les stocks et génère l'historique des mouvements associés.

### 5. Reporting Professionnel & Export PDF
*   **Génération à la volée** de rapports PDF haut de gamme via la bibliothèque **iText 7**.
*   **Types de rapports** :
    *   Inventaire complet et valorisation financière globale du stock.
    *   Rapport ciblé des alertes de stock (produits sous le seuil critique ou en rupture).
    *   Historique détaillé de traçabilité des mouvements.
    *   Bon de commande officiel prêt à l'envoi fournisseur avec calculs HT/TTC automatiques.

### 6. Tableau de bord Interactif (Dashboard)
*   Visualisation graphique de la répartition du stock (Sain, Faible, Rupture) via **Chart.js**.
*   Affichage en temps réel des indicateurs financiers (valeur totale du stock, commandes actives).
*   Flux d'activité affichant les 10 derniers mouvements de stock.

---

## 🛠️ Technologies & Dépendances

*   **Langage** : Java 17
*   **Spécification** : Jakarta EE 10 (Web Profile)
*   **Implémentation JPA** : Hibernate ORM 6.4.4.Final
*   **Base de Données** : Oracle Database (compatibilité avec Oracle XE / XEPDB1)
*   **Moteur CDI** : JBoss Weld (Servlet Core 5.1.2.Final)
*   **Services REST** : JAX-RS / Jersey 3.1.5
*   **Sécurité** : `at.favre.lib:bcrypt` (0.10.2)
*   **Reporting** : iText 7 (Core 8.0.4)
*   **Frontend** : JSP, Vanilla CSS (Layout responsive), Chart.js (CDN), FontAwesome.

---

## 📂 Structure du Projet

```bash
SmartStockERP/
├── .mvn/                      # Configuration du Maven Wrapper
├── src/
│   ├── main/
│   │   ├── java/              # Code source Java (Classes, Servlets, Services)
│   │   │   └── com/smartstock/erp/
│   │   │       ├── config/    # Configuration d'amorçage CDI et JPA
│   │   │       ├── exception/ # Exception métier globale
│   │   │       ├── model/     # Entités JPA (Product, Supplier, User, Role, StockMovement...)
│   │   │       ├── repository/# Couche d'accès aux données (JPA Repositories)
│   │   │       ├── resource/  # Endpoints d'API JAX-RS
│   │   │       ├── service/   # Couche de logique métier (Services)
│   │   │       ├── servlet/   # Contrôleurs MVC (Servlets) et filtres de sécurité
│   │   │       └── util/      # Utilitaires (Génération PDF, Hachage BCrypt)
│   │   ├── resources/         # Ressources de configuration
│   │   │   ├── META-INF/
│   │   │   │   └── persistence.xml # Unité de persistance JPA
│   │   │   └── sql/           # Scripts d'initialisation de base de données
│   │   └── webapp/            # Fichiers Web (JSP, CSS, WEB-INF)
│   │       ├── css/           # Feuilles de style (style.css, layout.css)
│   │       ├── WEB-INF/       # web.xml, beans.xml et fragments JSP
│   │       └── products/      # Pages de gestion des produits
│   └── test/                  # Tests unitaires et d'intégration
├── pom.xml                    # Fichier de build Maven
└── README.md                  # Ce fichier
```

---

## ⚙️ Configuration & Installation

### 1. Prérequis
*   **Java JDK 17** installé et configuré.
*   Une instance **Oracle Database** active.
*   **Apache Tomcat 10.x** (compatible avec Jakarta EE 10).

### 2. Initialisation de la Base de Données
Exécutez les scripts SQL fournis dans l'ordre pour configurer le schéma de sécurité et les données d'initialisation :
1.  Connectez-vous à votre instance Oracle et jouez le fichier :
    ```sql
    src/main/resources/sql/01_security_schema.sql
    ```
2.  Générez les mots de passe et insérez les administrateurs initiaux en jouant le fichier :
    ```sql
    src/main/resources/sql/02_generate_passwords.sql
    ```

### 3. Configuration de la Persistance JPA
Vérifiez et adaptez les informations de connexion de votre base de données Oracle dans le fichier :
`src/main/resources/META-INF/persistence.xml`

```xml
<properties>
    <property name="jakarta.persistence.jdbc.url" value="jdbc:oracle:thin:@localhost:1521/XEPDB1" />
    <property name="jakarta.persistence.jdbc.user" value="VOTRE_USER" />
    <property name="jakarta.persistence.jdbc.password" value="VOTRE_PASSWORD" />
</properties>
```

### 4. Compilation et Packaging
Utilisez le Maven Wrapper inclus pour compiler et packager l'application en fichier WAR :
```bash
# Sous Linux/macOS
./mvnw clean package

# Sous Windows
mvnw.cmd clean package
```
Le fichier généré `target/smartstock-erp.war` est prêt à être déployé sur votre serveur Tomcat 10.

---

## 🔑 Identifiants d'Accès Initial

Après le déploiement, vous pouvez vous connecter avec les identifiants d'administration par défaut générés :

*   **Identifiant** : `admin@smartstock.com`
*   **Mot de passe** : `Admin@2024!`
