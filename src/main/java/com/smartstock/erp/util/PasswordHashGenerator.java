package com.smartstock.erp.util;

/**
 * Utilitaire en ligne de commande pour générer des hashes BCrypt.
 *
 * <p>Utilisation :</p>
 * <pre>
 *   java -cp smartstock-erp.war com.smartstock.erp.util.PasswordHashGenerator "monMotDePasse"
 * </pre>
 *
 * <p>Cet utilitaire est destiné à être utilisé lors de la configuration initiale
 * de la base de données pour générer les hashes des mots de passe administrateurs.</p>
 */
public class PasswordHashGenerator {

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: PasswordHashGenerator <password> [password2] ...");
            System.out.println("Exemple: PasswordHashGenerator Admin@2024! Manager@2024!");
            System.exit(1);
        }

        System.out.println("=== SmartStockERP - Générateur de Hash BCrypt ===");
        System.out.println("Facteur de coût : 12 (2^12 = 4096 itérations)");
        System.out.println();

        for (String password : args) {
            String hash = PasswordUtil.hash(password);
            System.out.println("Mot de passe : " + password);
            System.out.println("Hash BCrypt  : " + hash);
            System.out.println("Vérification : " + PasswordUtil.verify(password, hash));
            System.out.println("---");
        }
    }
}
