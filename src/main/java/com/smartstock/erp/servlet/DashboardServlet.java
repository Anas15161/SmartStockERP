package com.smartstock.erp.servlet;

import com.smartstock.erp.model.Product;
import com.smartstock.erp.model.PurchaseOrder;
import com.smartstock.erp.model.StockMovement;
import com.smartstock.erp.repository.PurchaseOrderRepository;
import com.smartstock.erp.repository.StockMovementRepository;
import com.smartstock.erp.service.ProductService;
import com.smartstock.erp.repository.ProductRepository;
import com.smartstock.erp.repository.SupplierRepository;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet du tableau de bord principal de SmartStockERP.
 *
 * <p>Collecte et expose les statistiques clés pour le dashboard :</p>
 * <ul>
 *   <li>Nombre total de produits et fournisseurs</li>
 *   <li>Valeur totale du stock (somme quantité × prix unitaire)</li>
 *   <li>Produits en rupture de stock et en stock faible</li>
 *   <li>Nombre de bons de commande en attente</li>
 *   <li>Derniers mouvements de stock</li>
 * </ul>
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Inject
    private ProductRepository productRepository;

    @Inject
    private SupplierRepository supplierRepository;

    @Inject
    private StockMovementRepository movementRepository;

    @Inject
    private PurchaseOrderRepository orderRepository;

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Statistiques générales ---
        long totalProducts  = productRepository.count();
        long totalSuppliers = supplierRepository.count();

        // --- Statistiques de stock ---
        List<Product> lowStockProducts   = productService.getLowStockProducts();
        List<Product> outOfStockProducts = productService.getOutOfStockProducts();
        BigDecimal totalStockValue       = productService.calculateTotalStockValue();

        // --- Bons de commande en attente ---
        long pendingOrders = orderRepository.countByStatus(PurchaseOrder.OrderStatus.SENT)
                + orderRepository.countByStatus(PurchaseOrder.OrderStatus.PARTIALLY_RECEIVED);

        // --- Derniers mouvements de stock (10 derniers) ---
        List<StockMovement> recentMovements = movementRepository.findRecent(10);

        // --- Exposition des attributs pour la JSP ---
        request.setAttribute("totalProducts",      totalProducts);
        request.setAttribute("totalSuppliers",     totalSuppliers);
        request.setAttribute("totalStockValue",    totalStockValue != null ? totalStockValue : BigDecimal.ZERO);
        request.setAttribute("lowStockCount",      (long) lowStockProducts.size());
        request.setAttribute("outOfStockCount",    (long) outOfStockProducts.size());
        request.setAttribute("lowStockProducts",   lowStockProducts);
        request.setAttribute("outOfStockProducts", outOfStockProducts);
        request.setAttribute("pendingOrders",      pendingOrders);
        request.setAttribute("recentMovements",    recentMovements);

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}
