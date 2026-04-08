package com.smartstock.erp.service;

import com.smartstock.erp.exception.ApplicationException;
import com.smartstock.erp.model.Product;
import com.smartstock.erp.model.StockMovement;
import com.smartstock.erp.model.User;
import com.smartstock.erp.repository.ProductRepository;
import com.smartstock.erp.repository.StockMovementRepository;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import java.math.BigDecimal;
import java.util.List;

/**
 * Service métier pour la gestion des produits et des mouvements de stock.
 *
 * <p>Ce service centralise toute la logique métier liée aux produits :
 * création, modification, suppression, et gestion des quantités en stock
 * avec traçabilité complète via {@link StockMovement}.</p>
 */
@RequestScoped
public class ProductService {

    @Inject
    private ProductRepository productRepository;

    @Inject
    private StockMovementRepository movementRepository;

    // -------------------------------------------------------------------------
    // CRUD Produits
    // -------------------------------------------------------------------------

    /**
     * Crée un nouveau produit après validation des règles métier.
     *
     * @param product  l'entité produit à persister
     * @param operator l'utilisateur effectuant l'opération (pour la traçabilité)
     * @return le produit créé avec son identifiant généré
     */
    public Product createProduct(Product product, User operator) {
        validateProduct(product);
        Product saved = productRepository.create(product);

        // Enregistrement du mouvement initial si le stock de départ est > 0
        if (saved.getStockQuantity() != null && saved.getStockQuantity() > 0) {
            StockMovement movement = new StockMovement(
                    saved,
                    StockMovement.MovementType.ENTRY,
                    saved.getStockQuantity(),
                    0,
                    saved.getStockQuantity(),
                    "INIT-" + saved.getId(),
                    "Stock initial à la création du produit",
                    operator
            );
            movementRepository.create(movement);
        }
        return saved;
    }

    /**
     * Met à jour un produit existant et enregistre un mouvement de stock
     * si la quantité a changé.
     *
     * @param product  l'entité produit avec les nouvelles valeurs
     * @param operator l'utilisateur effectuant la modification
     * @return le produit mis à jour
     */
    public Product updateProduct(Product product, User operator) {
        validateProduct(product);

        Product existing = productRepository.findById(product.getId());
        if (existing == null) {
            throw new ApplicationException("Produit introuvable avec l'identifiant : " + product.getId());
        }

        int oldQuantity = existing.getStockQuantity();
        int newQuantity = product.getStockQuantity();

        Product updated = productRepository.update(product);

        // Enregistrement d'un mouvement si la quantité a changé
        if (oldQuantity != newQuantity) {
            int diff = Math.abs(newQuantity - oldQuantity);
            StockMovement.MovementType type = newQuantity > oldQuantity
                    ? StockMovement.MovementType.ENTRY
                    : StockMovement.MovementType.EXIT;

            StockMovement movement = new StockMovement(
                    updated,
                    type,
                    diff,
                    oldQuantity,
                    newQuantity,
                    "ADJ-" + updated.getId(),
                    "Ajustement manuel du stock",
                    operator
            );
            movementRepository.create(movement);
        }
        return updated;
    }

    /**
     * Effectue une entrée de stock pour un produit (réception de marchandises).
     *
     * @param productId identifiant du produit
     * @param quantity  quantité à ajouter (doit être positive)
     * @param reference référence du document source (ex: numéro de bon de commande)
     * @param notes     notes complémentaires
     * @param operator  utilisateur effectuant l'opération
     * @return le produit mis à jour
     */
    public Product addStock(Long productId, int quantity, String reference, String notes, User operator) {
        if (quantity <= 0) {
            throw new ApplicationException("La quantité d'entrée doit être positive.");
        }
        Product product = productRepository.findById(productId);
        if (product == null) {
            throw new ApplicationException("Produit introuvable.");
        }

        int oldQty = product.getStockQuantity();
        int newQty = oldQty + quantity;
        product.setStockQuantity(newQty);
        productRepository.update(product);

        StockMovement movement = new StockMovement(
                product,
                StockMovement.MovementType.ENTRY,
                quantity,
                oldQty,
                newQty,
                reference,
                notes,
                operator
        );
        movementRepository.create(movement);
        return product;
    }

    /**
     * Effectue une sortie de stock pour un produit.
     *
     * @param productId identifiant du produit
     * @param quantity  quantité à retirer (doit être positive)
     * @param reference référence du document source
     * @param notes     notes complémentaires
     * @param operator  utilisateur effectuant l'opération
     * @return le produit mis à jour
     * @throws ApplicationException si le stock est insuffisant
     */
    public Product removeStock(Long productId, int quantity, String reference, String notes, User operator) {
        if (quantity <= 0) {
            throw new ApplicationException("La quantité de sortie doit être positive.");
        }
        Product product = productRepository.findById(productId);
        if (product == null) {
            throw new ApplicationException("Produit introuvable.");
        }
        if (product.getStockQuantity() < quantity) {
            throw new ApplicationException(
                    "Stock insuffisant pour le produit '" + product.getLabel() +
                    "'. Stock disponible : " + product.getStockQuantity() +
                    ", quantité demandée : " + quantity);
        }

        int oldQty = product.getStockQuantity();
        int newQty = oldQty - quantity;
        product.setStockQuantity(newQty);
        productRepository.update(product);

        StockMovement movement = new StockMovement(
                product,
                StockMovement.MovementType.EXIT,
                quantity,
                oldQty,
                newQty,
                reference,
                notes,
                operator
        );
        movementRepository.create(movement);
        return product;
    }

    /**
     * Supprime un produit de la base de données.
     *
     * @param productId identifiant du produit à supprimer
     */
    public void deleteProduct(Long productId) {
        Product product = productRepository.findById(productId);
        if (product == null) {
            throw new ApplicationException("Produit introuvable avec l'identifiant : " + productId);
        }
        productRepository.delete(productId);
    }

    // -------------------------------------------------------------------------
    // Statistiques pour le Dashboard
    // -------------------------------------------------------------------------

    /**
     * Calcule la valeur totale du stock (somme de stockQuantity × unitPrice).
     *
     * @return la valeur totale du stock
     */
    public BigDecimal calculateTotalStockValue() {
        return productRepository.calculateTotalStockValue();
    }

    /**
     * Récupère les produits en rupture de stock (quantité <= 0).
     */
    public List<Product> getOutOfStockProducts() {
        return productRepository.findByStatus("out");
    }

    /**
     * Récupère les produits avec un stock faible (0 < quantité <= seuil d'alerte).
     */
    public List<Product> getLowStockProducts() {
        return productRepository.findLowStockProducts();
    }

    // -------------------------------------------------------------------------
    // Validation interne
    // -------------------------------------------------------------------------

    private void validateProduct(Product product) {
        if (product.getLabel() == null || product.getLabel().isBlank()) {
            throw new ApplicationException("Le libellé du produit est obligatoire.");
        }
        if (product.getUnitPrice() == null || product.getUnitPrice().compareTo(BigDecimal.ZERO) <= 0) {
            throw new ApplicationException("Le prix unitaire doit être supérieur à zéro.");
        }
        if (product.getStockQuantity() == null || product.getStockQuantity() < 0) {
            throw new ApplicationException("La quantité en stock ne peut pas être négative.");
        }
    }
}
