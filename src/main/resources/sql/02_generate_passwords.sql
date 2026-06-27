-- =============================================================================
-- SmartStockERP - Script de mise à jour des mots de passe
-- 
-- IMPORTANT : Ce script utilise des hashes BCrypt pré-calculés.
-- Pour générer vos propres hashes, utilisez l'utilitaire Java fourni :
--   java -cp smartstock-erp.war com.smartstock.erp.util.PasswordHashGenerator
--
-- Mots de passe par défaut (À CHANGER EN PRODUCTION) :
--   admin@smartstock.com   -> Admin@2024!
--   manager@smartstock.com -> Manager@2024!
--   operator@smartstock.com -> Operator@2024!
-- =============================================================================

-- Mise à jour du mot de passe admin (Admin@2024!)
UPDATE SS_USERS
SET password_hash = '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/HS.iK2i'
WHERE email = 'admin@smartstock.com';

-- Mise à jour du mot de passe manager (Manager@2024!)
UPDATE SS_USERS
SET password_hash = '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uADR.J53W'
WHERE email = 'manager@smartstock.com';

COMMIT;

-- Vérification
SELECT u.id, u.full_name, u.email, u.is_active, r.role_name
FROM SS_USERS u
JOIN SS_ROLES r ON u.role_id = r.id
ORDER BY u.id;
