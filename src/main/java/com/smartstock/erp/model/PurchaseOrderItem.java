package com.smartstock.erp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Entité représentant une ligne d'un bon de commande fournisseur.
 * Chaque ligne correspond à un produit commandé avec sa quantité et son prix unitaire.
 */
@Entity
@Table(name = "SS_PURCHASE_ORDER_ITEMS")
public class PurchaseOrderItem implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "poi_seq")
    @SequenceGenerator(name = "poi_seq", sequenceName = "SS_PURCHASE_ORDER_ITEMS_SEQ", allocationSize = 1)
    private Long id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "purchase_order_id", nullable = false)
    private PurchaseOrder purchaseOrder;

    @NotNull
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @NotNull
    @Min(value = 1, message = "La quantité commandée doit être au moins 1")
    @Column(name = "quantity_ordered", nullable = false)
    private Integer quantityOrdered;

    /**
     * Quantité effectivement reçue (peut être inférieure à quantityOrdered).
     */
    @Column(name = "quantity_received", nullable = false)
    private Integer quantityReceived = 0;

    @NotNull
    @DecimalMin(value = "0.0", inclusive = false, message = "Le prix unitaire doit être supérieur à zéro")
    @Column(name = "unit_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal unitPrice;

    // -------------------------------------------------------------------------
    // Méthodes métier
    // -------------------------------------------------------------------------

    /**
     * Calcule le sous-total de la ligne (quantité commandée × prix unitaire).
     */
    public BigDecimal getSubtotal() {
        if (unitPrice == null || quantityOrdered == null) return BigDecimal.ZERO;
        return unitPrice.multiply(BigDecimal.valueOf(quantityOrdered));
    }

    /**
     * Indique si la ligne a été entièrement reçue.
     */
    public boolean isFullyReceived() {
        return quantityReceived != null && quantityOrdered != null
                && quantityReceived >= quantityOrdered;
    }

    // -------------------------------------------------------------------------
    // Constructeurs
    // -------------------------------------------------------------------------

    public PurchaseOrderItem() {}

    public PurchaseOrderItem(Product product, int quantityOrdered, BigDecimal unitPrice) {
        this.product = product;
        this.quantityOrdered = quantityOrdered;
        this.unitPrice = unitPrice;
        this.quantityReceived = 0;
    }

    // -------------------------------------------------------------------------
    // Getters et Setters
    // -------------------------------------------------------------------------

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public PurchaseOrder getPurchaseOrder() { return purchaseOrder; }
    public void setPurchaseOrder(PurchaseOrder purchaseOrder) { this.purchaseOrder = purchaseOrder; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public Integer getQuantityOrdered() { return quantityOrdered; }
    public void setQuantityOrdered(Integer quantityOrdered) { this.quantityOrdered = quantityOrdered; }

    public Integer getQuantityReceived() { return quantityReceived; }
    public void setQuantityReceived(Integer quantityReceived) { this.quantityReceived = quantityReceived; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}
