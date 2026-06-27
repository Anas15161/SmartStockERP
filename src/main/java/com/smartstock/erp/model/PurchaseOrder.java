package com.smartstock.erp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entité représentant un bon de commande fournisseur.
 * Un bon de commande est émis vers un fournisseur et contient une ou plusieurs
 * lignes de commande ({@link PurchaseOrderItem}).
 */
@Entity
@Table(name = "SS_PURCHASE_ORDERS", indexes = {
        @Index(name = "IDX_PO_SUPPLIER", columnList = "supplier_id"),
        @Index(name = "IDX_PO_STATUS", columnList = "status"),
        @Index(name = "IDX_PO_NUMBER", columnList = "order_number", unique = true)
})
public class PurchaseOrder implements Serializable {

    /**
     * Statuts possibles d'un bon de commande.
     */
    public enum OrderStatus {
        /** Bon de commande en cours de rédaction */
        DRAFT,
        /** Bon de commande envoyé au fournisseur */
        SENT,
        /** Commande partiellement reçue */
        PARTIALLY_RECEIVED,
        /** Commande entièrement reçue */
        RECEIVED,
        /** Commande annulée */
        CANCELLED
    }

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "po_seq")
    @SequenceGenerator(name = "po_seq", sequenceName = "SS_PURCHASE_ORDERS_SEQ", allocationSize = 1)
    private Long id;

    /**
     * Numéro unique du bon de commande (ex: BC-2024-0001).
     */
    @NotNull
    @Column(name = "order_number", nullable = false, unique = true, length = 50)
    private String orderNumber;

    @NotNull
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "supplier_id", nullable = false)
    private Supplier supplier;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 30)
    private OrderStatus status = OrderStatus.DRAFT;

    @Column(name = "order_date", nullable = false)
    private LocalDate orderDate;

    @Column(name = "expected_delivery_date")
    private LocalDate expectedDeliveryDate;

    @Column(name = "actual_delivery_date")
    private LocalDate actualDeliveryDate;

    /**
     * Montant total HT calculé à partir des lignes de commande.
     */
    @Column(name = "total_amount_ht", precision = 12, scale = 2)
    private BigDecimal totalAmountHT = BigDecimal.ZERO;

    /**
     * Taux de TVA applicable (en pourcentage, ex: 20.0 pour 20%).
     */
    @Column(name = "tax_rate", precision = 5, scale = 2)
    private BigDecimal taxRate = BigDecimal.valueOf(20.0);

    @Column(name = "notes", length = 1000)
    private String notes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Lignes de commande associées à ce bon de commande.
     */
    @OneToMany(mappedBy = "purchaseOrder", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<PurchaseOrderItem> items = new ArrayList<>();

    // -------------------------------------------------------------------------
    // Hooks JPA
    // -------------------------------------------------------------------------

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        if (this.orderDate == null) {
            this.orderDate = LocalDate.now();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // -------------------------------------------------------------------------
    // Méthodes métier
    // -------------------------------------------------------------------------

    /**
     * Recalcule le montant total HT à partir des lignes de commande.
     */
    public void recalculateTotal() {
        this.totalAmountHT = items.stream()
                .map(PurchaseOrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Retourne le montant total TTC.
     */
    public BigDecimal getTotalAmountTTC() {
        if (totalAmountHT == null) return BigDecimal.ZERO;
        BigDecimal taxMultiplier = BigDecimal.ONE.add(
                taxRate.divide(BigDecimal.valueOf(100)));
        return totalAmountHT.multiply(taxMultiplier).setScale(2, java.math.RoundingMode.HALF_UP);
    }

    public void addItem(PurchaseOrderItem item) {
        items.add(item);
        item.setPurchaseOrder(this);
        recalculateTotal();
    }

    public void removeItem(PurchaseOrderItem item) {
        items.remove(item);
        item.setPurchaseOrder(null);
        recalculateTotal();
    }

    // -------------------------------------------------------------------------
    // Constructeurs
    // -------------------------------------------------------------------------

    public PurchaseOrder() {}

    // -------------------------------------------------------------------------
    // Getters et Setters
    // -------------------------------------------------------------------------

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }

    public Supplier getSupplier() { return supplier; }
    public void setSupplier(Supplier supplier) { this.supplier = supplier; }

    public OrderStatus getStatus() { return status; }
    public void setStatus(OrderStatus status) { this.status = status; }

    public LocalDate getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDate orderDate) { this.orderDate = orderDate; }

    public LocalDate getExpectedDeliveryDate() { return expectedDeliveryDate; }
    public void setExpectedDeliveryDate(LocalDate expectedDeliveryDate) { this.expectedDeliveryDate = expectedDeliveryDate; }

    public LocalDate getActualDeliveryDate() { return actualDeliveryDate; }
    public void setActualDeliveryDate(LocalDate actualDeliveryDate) { this.actualDeliveryDate = actualDeliveryDate; }

    public BigDecimal getTotalAmountHT() { return totalAmountHT; }
    public void setTotalAmountHT(BigDecimal totalAmountHT) { this.totalAmountHT = totalAmountHT; }

    public BigDecimal getTaxRate() { return taxRate; }
    public void setTaxRate(BigDecimal taxRate) { this.taxRate = taxRate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public User getCreatedBy() { return createdBy; }
    public void setCreatedBy(User createdBy) { this.createdBy = createdBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }

    public List<PurchaseOrderItem> getItems() { return items; }
    public void setItems(List<PurchaseOrderItem> items) { this.items = items; }
}
