package com.smartstock.erp.service;

import com.smartstock.erp.exception.ApplicationException;
import com.smartstock.erp.model.*;
import com.smartstock.erp.repository.ProductRepository;
import com.smartstock.erp.repository.PurchaseOrderRepository;
import com.smartstock.erp.repository.StockMovementRepository;
import com.smartstock.erp.repository.SupplierRepository;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Service métier pour la gestion des bons de commande fournisseurs.
 *
 * <p>Ce service orchestre la création, la mise à jour et la réception des bons
 * de commande. Lors de la réception d'une commande, il met automatiquement à
 * jour les stocks des produits concernés et enregistre les mouvements de stock.</p>
 */
@RequestScoped
public class PurchaseOrderService {

    @Inject
    private PurchaseOrderRepository orderRepository;

    @Inject
    private ProductRepository productRepository;

    @Inject
    private SupplierRepository supplierRepository;

    @Inject
    private StockMovementRepository movementRepository;

    // -------------------------------------------------------------------------
    // Création et mise à jour
    // -------------------------------------------------------------------------

    /**
     * Crée un nouveau bon de commande en statut DRAFT.
     *
     * @param supplierId          identifiant du fournisseur
     * @param expectedDelivery    date de livraison prévue (peut être null)
     * @param notes               notes complémentaires
     * @param operator            utilisateur créant le bon de commande
     * @return le bon de commande créé
     */
    public PurchaseOrder createOrder(Long supplierId, LocalDate expectedDelivery,
                                     String notes, User operator) {
        Supplier supplier = supplierRepository.findById(supplierId);
        if (supplier == null) {
            throw new ApplicationException("Fournisseur introuvable.");
        }

        PurchaseOrder order = new PurchaseOrder();
        order.setOrderNumber(orderRepository.generateNextOrderNumber());
        order.setSupplier(supplier);
        order.setExpectedDeliveryDate(expectedDelivery);
        order.setNotes(notes);
        order.setCreatedBy(operator);
        order.setStatus(PurchaseOrder.OrderStatus.DRAFT);

        return orderRepository.create(order);
    }

    /**
     * Ajoute une ligne de produit à un bon de commande en statut DRAFT.
     *
     * @param orderId         identifiant du bon de commande
     * @param productId       identifiant du produit
     * @param quantityOrdered quantité commandée
     * @param unitPrice       prix unitaire négocié
     * @return le bon de commande mis à jour
     */
    public PurchaseOrder addItem(Long orderId, Long productId, int quantityOrdered, BigDecimal unitPrice) {
        PurchaseOrder order = orderRepository.findById(orderId);
        if (order == null) {
            throw new ApplicationException("Bon de commande introuvable.");
        }
        if (order.getStatus() != PurchaseOrder.OrderStatus.DRAFT) {
            throw new ApplicationException("Impossible de modifier un bon de commande qui n'est pas en statut DRAFT.");
        }

        Product product = productRepository.findById(productId);
        if (product == null) {
            throw new ApplicationException("Produit introuvable.");
        }

        PurchaseOrderItem item = new PurchaseOrderItem(product, quantityOrdered, unitPrice);
        order.addItem(item);
        return orderRepository.update(order);
    }

    /**
     * Soumet un bon de commande (passage du statut DRAFT à SENT).
     *
     * @param orderId identifiant du bon de commande
     * @return le bon de commande mis à jour
     */
    public PurchaseOrder submitOrder(Long orderId) {
        PurchaseOrder order = orderRepository.findById(orderId);
        if (order == null) {
            throw new ApplicationException("Bon de commande introuvable.");
        }
        if (order.getStatus() != PurchaseOrder.OrderStatus.DRAFT) {
            throw new ApplicationException("Seul un bon de commande en statut DRAFT peut être soumis.");
        }
        if (order.getItems().isEmpty()) {
            throw new ApplicationException("Impossible de soumettre un bon de commande sans lignes.");
        }
        order.setStatus(PurchaseOrder.OrderStatus.SENT);
        return orderRepository.update(order);
    }

    /**
     * Enregistre la réception complète ou partielle d'un bon de commande.
     *
     * <p>Pour chaque ligne reçue, le stock du produit correspondant est mis à
     * jour et un mouvement de stock de type ENTRY est enregistré.</p>
     *
     * @param orderId  identifiant du bon de commande
     * @param operator utilisateur effectuant la réception
     * @return le bon de commande mis à jour
     */
    public PurchaseOrder receiveOrder(Long orderId, User operator) {
        PurchaseOrder order = orderRepository.findById(orderId);
        if (order == null) {
            throw new ApplicationException("Bon de commande introuvable.");
        }
        if (order.getStatus() == PurchaseOrder.OrderStatus.RECEIVED
                || order.getStatus() == PurchaseOrder.OrderStatus.CANCELLED) {
            throw new ApplicationException("Ce bon de commande ne peut plus être réceptionné.");
        }

        boolean allReceived = true;
        for (PurchaseOrderItem item : order.getItems()) {
            if (!item.isFullyReceived()) {
                int toReceive = item.getQuantityOrdered() - item.getQuantityReceived();
                Product product = item.getProduct();
                int oldQty = product.getStockQuantity();
                int newQty = oldQty + toReceive;

                product.setStockQuantity(newQty);
                productRepository.update(product);

                item.setQuantityReceived(item.getQuantityOrdered());

                // Enregistrement du mouvement de stock
                StockMovement movement = new StockMovement(
                        product,
                        StockMovement.MovementType.ENTRY,
                        toReceive,
                        oldQty,
                        newQty,
                        order.getOrderNumber(),
                        "Réception bon de commande " + order.getOrderNumber(),
                        operator
                );
                movementRepository.create(movement);
            }
            if (!item.isFullyReceived()) {
                allReceived = false;
            }
        }

        order.setStatus(allReceived
                ? PurchaseOrder.OrderStatus.RECEIVED
                : PurchaseOrder.OrderStatus.PARTIALLY_RECEIVED);
        order.setActualDeliveryDate(LocalDate.now());
        return orderRepository.update(order);
    }

    /**
     * Annule un bon de commande (seuls les statuts DRAFT et SENT sont annulables).
     *
     * @param orderId identifiant du bon de commande
     * @return le bon de commande annulé
     */
    public PurchaseOrder cancelOrder(Long orderId) {
        PurchaseOrder order = orderRepository.findById(orderId);
        if (order == null) {
            throw new ApplicationException("Bon de commande introuvable.");
        }
        if (order.getStatus() == PurchaseOrder.OrderStatus.RECEIVED
                || order.getStatus() == PurchaseOrder.OrderStatus.CANCELLED) {
            throw new ApplicationException("Ce bon de commande ne peut pas être annulé dans son état actuel.");
        }
        order.setStatus(PurchaseOrder.OrderStatus.CANCELLED);
        return orderRepository.update(order);
    }

    // -------------------------------------------------------------------------
    // Requêtes
    // -------------------------------------------------------------------------

    public List<PurchaseOrder> getAllOrders(int page, int size) {
        return orderRepository.findPaginatedWithDetails(page, size);
    }

    public long countAllOrders() {
        return orderRepository.count();
    }

    public PurchaseOrder getOrderById(Long id) {
        PurchaseOrder order = orderRepository.findById(id);
        if (order == null) {
            throw new ApplicationException("Bon de commande introuvable.");
        }
        return order;
    }
}
