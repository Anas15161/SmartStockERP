package com.smartstock.erp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entité représentant un mouvement de stock (entrée ou sortie).
 * Chaque modification de la quantité en stock d'un produit génère un enregistrement
 * dans cette table, garantissant la traçabilité complète des flux de marchandises.
 */
@Entity
@Table(name = "SS_STOCK_MOVEMENTS", indexes = {
        @Index(name = "IDX_SM_PRODUCT", columnList = "product_id"),
        @Index(name = "IDX_SM_DATE", columnList = "movement_date")
})
public class StockMovement implements Serializable {

    /**
     * Types de mouvements de stock possibles.
     */
    public enum MovementType {
        /** Entrée de marchandises (réception commande, inventaire positif) */
        ENTRY,
        /** Sortie de marchandises (vente, consommation, inventaire négatif) */
        EXIT,
        /** Ajustement manuel de l'inventaire */
        ADJUSTMENT
    }

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sm_seq")
    @SequenceGenerator(name = "sm_seq", sequenceName = "SS_STOCK_MOVEMENTS_SEQ", allocationSize = 1)
    private Long id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "movement_type", nullable = false, length = 20)
    private MovementType movementType;

    /**
     * Quantité du mouvement (toujours positive, le type détermine le sens).
     */
    @NotNull
    @Min(value = 1, message = "La quantité du mouvement doit être au moins 1")
    @Column(name = "quantity", nullable = false)
    private Integer quantity;

    /**
     * Quantité en stock avant le mouvement (pour l'audit).
     */
    @Column(name = "quantity_before", nullable = false)
    private Integer quantityBefore;

    /**
     * Quantité en stock après le mouvement (pour l'audit).
     */
    @Column(name = "quantity_after", nullable = false)
    private Integer quantityAfter;

    @Column(name = "movement_date", nullable = false)
    private LocalDateTime movementDate;

    /**
     * Référence optionnelle (ex: numéro de bon de commande, numéro de vente).
     */
    @Column(name = "reference", length = 100)
    private String reference;

    /**
     * Notes ou commentaires sur le mouvement.
     */
    @Column(name = "notes", length = 500)
    private String notes;

    /**
     * Utilisateur ayant effectué le mouvement (pour la traçabilité).
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "performed_by")
    private User performedBy;

    // -------------------------------------------------------------------------
    // Hooks JPA
    // -------------------------------------------------------------------------

    @PrePersist
    protected void onCreate() {
        if (this.movementDate == null) {
            this.movementDate = LocalDateTime.now();
        }
    }

    // -------------------------------------------------------------------------
    // Constructeurs
    // -------------------------------------------------------------------------

    public StockMovement() {}

    public StockMovement(Product product, MovementType type, int quantity,
                         int quantityBefore, int quantityAfter, String reference,
                         String notes, User performedBy) {
        this.product = product;
        this.movementType = type;
        this.quantity = quantity;
        this.quantityBefore = quantityBefore;
        this.quantityAfter = quantityAfter;
        this.reference = reference;
        this.notes = notes;
        this.performedBy = performedBy;
        this.movementDate = LocalDateTime.now();
    }

    // -------------------------------------------------------------------------
    // Getters et Setters
    // -------------------------------------------------------------------------

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public MovementType getMovementType() { return movementType; }
    public void setMovementType(MovementType movementType) { this.movementType = movementType; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Integer getQuantityBefore() { return quantityBefore; }
    public void setQuantityBefore(Integer quantityBefore) { this.quantityBefore = quantityBefore; }

    public Integer getQuantityAfter() { return quantityAfter; }
    public void setQuantityAfter(Integer quantityAfter) { this.quantityAfter = quantityAfter; }

    public LocalDateTime getMovementDate() { return movementDate; }
    public void setMovementDate(LocalDateTime movementDate) { this.movementDate = movementDate; }

    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public User getPerformedBy() { return performedBy; }
    public void setPerformedBy(User performedBy) { this.performedBy = performedBy; }
}
