-- =============================================================================
-- SmartStockERP - Script de création du schéma de sécurité (RBAC)
-- Base de données : Oracle Database 23c Free (XE) / XEPDB1
-- Utilisateur     : smartstock
-- Version         : 2.0
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. SÉQUENCES
-- -----------------------------------------------------------------------------

-- Séquence pour la table SS_ROLES
CREATE SEQUENCE SS_ROLES_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Séquence pour la table SS_USERS
CREATE SEQUENCE SS_USERS_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Séquence pour la table SS_STOCK_MOVEMENTS
CREATE SEQUENCE SS_STOCK_MOVEMENTS_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Séquence pour la table SS_PURCHASE_ORDERS
CREATE SEQUENCE SS_PURCHASE_ORDERS_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Séquence pour la table SS_PURCHASE_ORDER_ITEMS
CREATE SEQUENCE SS_PURCHASE_ORDER_ITEMS_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- -----------------------------------------------------------------------------
-- 2. TABLE SS_ROLES (Rôles utilisateurs)
-- -----------------------------------------------------------------------------

CREATE TABLE SS_ROLES (
    id          NUMBER(19)      NOT NULL,
    role_name   VARCHAR2(50)    NOT NULL,
    description VARCHAR2(255),
    CONSTRAINT PK_SS_ROLES PRIMARY KEY (id),
    CONSTRAINT UQ_SS_ROLES_NAME UNIQUE (role_name)
);

COMMENT ON TABLE  SS_ROLES              IS 'Table des rôles utilisateurs pour le contrôle d''accès basé sur les rôles (RBAC)';
COMMENT ON COLUMN SS_ROLES.role_name    IS 'Nom unique du rôle (ex: ADMIN, MANAGER, OPERATOR)';
COMMENT ON COLUMN SS_ROLES.description IS 'Description des permissions associées à ce rôle';

-- -----------------------------------------------------------------------------
-- 3. TABLE SS_USERS (Utilisateurs du système)
-- -----------------------------------------------------------------------------

CREATE TABLE SS_USERS (
    id              NUMBER(19)      NOT NULL,
    full_name       VARCHAR2(100)   NOT NULL,
    email           VARCHAR2(150)   NOT NULL,
    password_hash   VARCHAR2(255)   NOT NULL,
    is_active       NUMBER(1)       DEFAULT 1 NOT NULL,
    last_login      TIMESTAMP,
    created_at      TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at      TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    role_id         NUMBER(19)      NOT NULL,
    CONSTRAINT PK_SS_USERS          PRIMARY KEY (id),
    CONSTRAINT UQ_SS_USERS_EMAIL    UNIQUE (email),
    CONSTRAINT FK_SS_USERS_ROLE     FOREIGN KEY (role_id) REFERENCES SS_ROLES(id),
    CONSTRAINT CHK_SS_USERS_ACTIVE  CHECK (is_active IN (0, 1))
);

CREATE INDEX IDX_USERS_EMAIL   ON SS_USERS (email);
CREATE INDEX IDX_USERS_ROLE    ON SS_USERS (role_id);
CREATE INDEX IDX_USERS_ACTIVE  ON SS_USERS (is_active);

COMMENT ON TABLE  SS_USERS                IS 'Table des utilisateurs du système SmartStockERP';
COMMENT ON COLUMN SS_USERS.email          IS 'Adresse e-mail unique servant d''identifiant de connexion';
COMMENT ON COLUMN SS_USERS.password_hash  IS 'Hash BCrypt du mot de passe (jamais en clair)';
COMMENT ON COLUMN SS_USERS.is_active      IS '1 = compte actif, 0 = compte désactivé';

-- -----------------------------------------------------------------------------
-- 4. TABLE SS_STOCK_MOVEMENTS (Historique des mouvements de stock)
-- -----------------------------------------------------------------------------

CREATE TABLE SS_STOCK_MOVEMENTS (
    id              NUMBER(19)      NOT NULL,
    product_id      NUMBER(19)      NOT NULL,
    movement_type   VARCHAR2(20)    NOT NULL,
    quantity        NUMBER(10)      NOT NULL,
    quantity_before NUMBER(10)      NOT NULL,
    quantity_after  NUMBER(10)      NOT NULL,
    movement_date   TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    reference       VARCHAR2(100),
    notes           VARCHAR2(500),
    performed_by    NUMBER(19),
    CONSTRAINT PK_SS_STOCK_MOVEMENTS        PRIMARY KEY (id),
    CONSTRAINT FK_SM_PRODUCT                FOREIGN KEY (product_id)   REFERENCES PRODUCTS(id),
    CONSTRAINT FK_SM_USER                   FOREIGN KEY (performed_by) REFERENCES SS_USERS(id),
    CONSTRAINT CHK_SM_TYPE                  CHECK (movement_type IN ('ENTRY', 'EXIT', 'ADJUSTMENT')),
    CONSTRAINT CHK_SM_QUANTITY              CHECK (quantity > 0),
    CONSTRAINT CHK_SM_QTY_BEFORE            CHECK (quantity_before >= 0),
    CONSTRAINT CHK_SM_QTY_AFTER             CHECK (quantity_after >= 0)
);

CREATE INDEX IDX_SM_PRODUCT ON SS_STOCK_MOVEMENTS (product_id);
CREATE INDEX IDX_SM_DATE    ON SS_STOCK_MOVEMENTS (movement_date);
CREATE INDEX IDX_SM_TYPE    ON SS_STOCK_MOVEMENTS (movement_type);

COMMENT ON TABLE  SS_STOCK_MOVEMENTS              IS 'Historique complet des mouvements de stock (entrées, sorties, ajustements)';
COMMENT ON COLUMN SS_STOCK_MOVEMENTS.movement_type IS 'ENTRY=entrée, EXIT=sortie, ADJUSTMENT=ajustement manuel';
COMMENT ON COLUMN SS_STOCK_MOVEMENTS.quantity      IS 'Quantité du mouvement (toujours positive)';
COMMENT ON COLUMN SS_STOCK_MOVEMENTS.reference     IS 'Référence du document source (ex: numéro de bon de commande)';

-- -----------------------------------------------------------------------------
-- 5. TABLE SS_PURCHASE_ORDERS (Bons de commande fournisseurs)
-- -----------------------------------------------------------------------------

CREATE TABLE SS_PURCHASE_ORDERS (
    id                      NUMBER(19)      NOT NULL,
    order_number            VARCHAR2(50)    NOT NULL,
    supplier_id             NUMBER(19)      NOT NULL,
    status                  VARCHAR2(30)    DEFAULT 'DRAFT' NOT NULL,
    order_date              DATE            DEFAULT SYSDATE NOT NULL,
    expected_delivery_date  DATE,
    actual_delivery_date    DATE,
    total_amount_ht         NUMBER(12,2)    DEFAULT 0,
    tax_rate                NUMBER(5,2)     DEFAULT 20.00,
    notes                   VARCHAR2(1000),
    created_by              NUMBER(19),
    created_at              TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at              TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT PK_SS_PURCHASE_ORDERS        PRIMARY KEY (id),
    CONSTRAINT UQ_PO_ORDER_NUMBER           UNIQUE (order_number),
    CONSTRAINT FK_PO_SUPPLIER               FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(id),
    CONSTRAINT FK_PO_CREATED_BY             FOREIGN KEY (created_by)  REFERENCES SS_USERS(id),
    CONSTRAINT CHK_PO_STATUS                CHECK (status IN ('DRAFT','SENT','PARTIALLY_RECEIVED','RECEIVED','CANCELLED'))
);

CREATE INDEX IDX_PO_SUPPLIER ON SS_PURCHASE_ORDERS (supplier_id);
CREATE INDEX IDX_PO_STATUS   ON SS_PURCHASE_ORDERS (status);
CREATE INDEX IDX_PO_NUMBER   ON SS_PURCHASE_ORDERS (order_number);

-- -----------------------------------------------------------------------------
-- 6. TABLE SS_PURCHASE_ORDER_ITEMS (Lignes de bons de commande)
-- -----------------------------------------------------------------------------

CREATE TABLE SS_PURCHASE_ORDER_ITEMS (
    id                  NUMBER(19)      NOT NULL,
    purchase_order_id   NUMBER(19)      NOT NULL,
    product_id          NUMBER(19)      NOT NULL,
    quantity_ordered    NUMBER(10)      NOT NULL,
    quantity_received   NUMBER(10)      DEFAULT 0 NOT NULL,
    unit_price          NUMBER(10,2)    NOT NULL,
    CONSTRAINT PK_SS_PURCHASE_ORDER_ITEMS   PRIMARY KEY (id),
    CONSTRAINT FK_POI_ORDER                 FOREIGN KEY (purchase_order_id) REFERENCES SS_PURCHASE_ORDERS(id) ON DELETE CASCADE,
    CONSTRAINT FK_POI_PRODUCT               FOREIGN KEY (product_id)        REFERENCES PRODUCTS(id),
    CONSTRAINT CHK_POI_QTY_ORDERED          CHECK (quantity_ordered > 0),
    CONSTRAINT CHK_POI_QTY_RECEIVED         CHECK (quantity_received >= 0),
    CONSTRAINT CHK_POI_PRICE                CHECK (unit_price > 0)
);

-- =============================================================================
-- 7. DONNÉES INITIALES (Rôles et utilisateur administrateur)
-- =============================================================================

-- Insertion des rôles
INSERT INTO SS_ROLES (id, role_name, description)
VALUES (SS_ROLES_SEQ.NEXTVAL, 'ADMIN', 'Administrateur système : accès complet à toutes les fonctionnalités');

INSERT INTO SS_ROLES (id, role_name, description)
VALUES (SS_ROLES_SEQ.NEXTVAL, 'MANAGER', 'Responsable de stock : gestion des produits, fournisseurs et commandes');

INSERT INTO SS_ROLES (id, role_name, description)
VALUES (SS_ROLES_SEQ.NEXTVAL, 'OPERATOR', 'Opérateur : consultation et saisie des mouvements de stock uniquement');

-- Insertion de l'utilisateur administrateur par défaut
-- Mot de passe : Admin@2024! (hash BCrypt généré avec cost=12)
-- IMPORTANT : Changer ce mot de passe immédiatement après la première connexion !
INSERT INTO SS_USERS (id, full_name, email, password_hash, is_active, role_id)
VALUES (
    SS_USERS_SEQ.NEXTVAL,
    'Administrateur Système',
    'admin@smartstock.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/HS.iK2i',
    1,
    (SELECT id FROM SS_ROLES WHERE role_name = 'ADMIN')
);

-- Insertion d'un utilisateur manager de démonstration
-- Mot de passe : Manager@2024!
INSERT INTO SS_USERS (id, full_name, email, password_hash, is_active, role_id)
VALUES (
    SS_USERS_SEQ.NEXTVAL,
    'Responsable Stock',
    'manager@smartstock.com',
    '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uADR.J53W',
    1,
    (SELECT id FROM SS_ROLES WHERE role_name = 'MANAGER')
);

COMMIT;
