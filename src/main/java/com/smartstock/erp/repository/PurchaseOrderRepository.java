package com.smartstock.erp.repository;

import com.smartstock.erp.model.PurchaseOrder;
import jakarta.enterprise.context.RequestScoped;
import jakarta.persistence.NoResultException;
import java.util.List;
import java.util.Optional;

/**
 * Repository pour la gestion des bons de commande fournisseurs.
 */
@RequestScoped
public class PurchaseOrderRepository extends GenericRepository<PurchaseOrder, Long> {

    public PurchaseOrderRepository() {
        super(PurchaseOrder.class);
    }

    /**
     * Récupère les bons de commande avec pagination, triés par date décroissante.
     */
    public List<PurchaseOrder> findPaginatedWithDetails(int page, int size) {
        return em.createQuery(
                        "SELECT po FROM PurchaseOrder po " +
                        "JOIN FETCH po.supplier " +
                        "ORDER BY po.createdAt DESC",
                        PurchaseOrder.class)
                .setFirstResult((page - 1) * size)
                .setMaxResults(size)
                .getResultList();
    }

    /**
     * Recherche un bon de commande par son numéro unique.
     */
    public Optional<PurchaseOrder> findByOrderNumber(String orderNumber) {
        try {
            PurchaseOrder po = em.createQuery(
                            "SELECT po FROM PurchaseOrder po " +
                            "JOIN FETCH po.supplier " +
                            "WHERE po.orderNumber = :orderNumber",
                            PurchaseOrder.class)
                    .setParameter("orderNumber", orderNumber)
                    .getSingleResult();
            return Optional.of(po);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    /**
     * Récupère les bons de commande d'un fournisseur spécifique.
     */
    public List<PurchaseOrder> findBySupplier(Long supplierId) {
        return em.createQuery(
                        "SELECT po FROM PurchaseOrder po " +
                        "JOIN FETCH po.supplier s " +
                        "WHERE s.id = :supplierId " +
                        "ORDER BY po.createdAt DESC",
                        PurchaseOrder.class)
                .setParameter("supplierId", supplierId)
                .getResultList();
    }

    /**
     * Récupère les bons de commande selon leur statut.
     */
    public List<PurchaseOrder> findByStatus(PurchaseOrder.OrderStatus status) {
        return em.createQuery(
                        "SELECT po FROM PurchaseOrder po " +
                        "JOIN FETCH po.supplier " +
                        "WHERE po.status = :status " +
                        "ORDER BY po.createdAt DESC",
                        PurchaseOrder.class)
                .setParameter("status", status)
                .getResultList();
    }

    /**
     * Génère le prochain numéro de bon de commande au format BC-YYYY-XXXX.
     */
    public String generateNextOrderNumber() {
        int year = java.time.LocalDate.now().getYear();
        String prefix = "BC-" + year + "-";
        try {
            Long maxSeq = em.createQuery(
                            "SELECT COUNT(po) FROM PurchaseOrder po WHERE po.orderNumber LIKE :prefix",
                            Long.class)
                    .setParameter("prefix", prefix + "%")
                    .getSingleResult();
            return prefix + String.format("%04d", maxSeq + 1);
        } catch (Exception e) {
            return prefix + "0001";
        }
    }

    /**
     * Compte les bons de commande par statut pour le tableau de bord.
     */
    public long countByStatus(PurchaseOrder.OrderStatus status) {
        return em.createQuery(
                        "SELECT COUNT(po) FROM PurchaseOrder po WHERE po.status = :status",
                        Long.class)
                .setParameter("status", status)
                .getSingleResult();
    }
}
