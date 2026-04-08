package com.smartstock.erp.repository;

import com.smartstock.erp.model.StockMovement;
import jakarta.enterprise.context.RequestScoped;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Repository pour la gestion des mouvements de stock.
 * Fournit des méthodes de requête spécialisées pour l'historique et les rapports.
 */
@RequestScoped
public class StockMovementRepository extends GenericRepository<StockMovement, Long> {

    public StockMovementRepository() {
        super(StockMovement.class);
    }

    /**
     * Récupère les derniers mouvements de stock, triés par date décroissante.
     *
     * @param limit nombre maximum de mouvements à retourner
     * @return liste des mouvements les plus récents
     */
    public List<StockMovement> findRecent(int limit) {
        return em.createQuery(
                        "SELECT sm FROM StockMovement sm " +
                        "JOIN FETCH sm.product " +
                        "ORDER BY sm.movementDate DESC",
                        StockMovement.class)
                .setMaxResults(limit)
                .getResultList();
    }

    /**
     * Récupère tous les mouvements d'un produit spécifique, triés par date décroissante.
     *
     * @param productId l'identifiant du produit
     * @return liste des mouvements du produit
     */
    public List<StockMovement> findByProductId(Long productId) {
        return em.createQuery(
                        "SELECT sm FROM StockMovement sm " +
                        "JOIN FETCH sm.product p " +
                        "WHERE p.id = :productId " +
                        "ORDER BY sm.movementDate DESC",
                        StockMovement.class)
                .setParameter("productId", productId)
                .getResultList();
    }

    /**
     * Récupère les mouvements dans une plage de dates donnée, avec pagination.
     *
     * @param from  date de début (inclusive)
     * @param to    date de fin (inclusive)
     * @param page  numéro de page (commence à 1)
     * @param size  nombre d'éléments par page
     * @return liste paginée des mouvements dans la plage de dates
     */
    public List<StockMovement> findByDateRange(LocalDateTime from, LocalDateTime to, int page, int size) {
        return em.createQuery(
                        "SELECT sm FROM StockMovement sm " +
                        "JOIN FETCH sm.product " +
                        "WHERE sm.movementDate BETWEEN :from AND :to " +
                        "ORDER BY sm.movementDate DESC",
                        StockMovement.class)
                .setParameter("from", from)
                .setParameter("to", to)
                .setFirstResult((page - 1) * size)
                .setMaxResults(size)
                .getResultList();
    }

    /**
     * Compte le nombre de mouvements dans une plage de dates.
     */
    public long countByDateRange(LocalDateTime from, LocalDateTime to) {
        return em.createQuery(
                        "SELECT COUNT(sm) FROM StockMovement sm " +
                        "WHERE sm.movementDate BETWEEN :from AND :to",
                        Long.class)
                .setParameter("from", from)
                .setParameter("to", to)
                .getSingleResult();
    }

    /**
     * Récupère tous les mouvements avec pagination (pour la liste globale).
     */
    public List<StockMovement> findPaginatedWithDetails(int page, int size) {
        return em.createQuery(
                        "SELECT sm FROM StockMovement sm " +
                        "JOIN FETCH sm.product " +
                        "ORDER BY sm.movementDate DESC",
                        StockMovement.class)
                .setFirstResult((page - 1) * size)
                .setMaxResults(size)
                .getResultList();
    }
}
