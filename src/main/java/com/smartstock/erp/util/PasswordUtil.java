package com.smartstock.erp.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Utilitaire pour le hachage et la vérification des mots de passe avec BCrypt.
 *
 * <p>BCrypt est un algorithme de hachage adaptatif conçu spécifiquement pour
 * les mots de passe. Il intègre automatiquement un "salt" aléatoire et un
 * facteur de coût configurable, rendant les attaques par force brute très
 * coûteuses en temps de calcul.</p>
 */
public final class PasswordUtil {

    /**
     * Facteur de coût BCrypt (log2 du nombre d'itérations).
     * Une valeur de 12 représente 2^12 = 4096 itérations.
     */
    private static final int BCRYPT_COST = 12;

    private PasswordUtil() {
        throw new UnsupportedOperationException("Classe utilitaire non instanciable");
    }

    /**
     * Hache un mot de passe en clair avec BCrypt.
     *
     * @param plainPassword le mot de passe en clair
     * @return le hash BCrypt du mot de passe
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Le mot de passe ne peut pas être vide");
        }
        return BCrypt.withDefaults().hashToString(BCRYPT_COST, plainPassword.toCharArray());
    }

    /**
     * Vérifie si un mot de passe en clair correspond à un hash BCrypt.
     *
     * @param plainPassword  le mot de passe en clair saisi par l'utilisateur
     * @param hashedPassword le hash stocké en base de données
     * @return true si le mot de passe correspond au hash, false sinon
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            BCrypt.Result result = BCrypt.verifyer().verify(plainPassword.toCharArray(), hashedPassword);
            return result.verified;
        } catch (Exception e) {
            // En cas de hash malformé, on retourne false sans lever d'exception
            return false;
        }
    }
}
