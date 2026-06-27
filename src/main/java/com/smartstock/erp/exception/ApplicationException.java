package com.smartstock.erp.exception;

/**
 * Exception métier générique pour SmartStockERP.
 * Utilisée pour signaler des erreurs de logique applicative (règles métier violées,
 * données invalides, etc.) sans exposer les détails techniques à la couche présentation.
 */
public class ApplicationException extends RuntimeException {

    private final String userMessage;

    public ApplicationException(String userMessage) {
        super(userMessage);
        this.userMessage = userMessage;
    }

    public ApplicationException(String userMessage, Throwable cause) {
        super(userMessage, cause);
        this.userMessage = userMessage;
    }

    /**
     * Retourne le message destiné à être affiché à l'utilisateur final.
     */
    public String getUserMessage() {
        return userMessage;
    }
}
