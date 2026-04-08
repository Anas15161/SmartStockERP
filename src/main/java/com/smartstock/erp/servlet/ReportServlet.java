package com.smartstock.erp.servlet;

import com.smartstock.erp.model.Product;
import com.smartstock.erp.model.PurchaseOrder;
import com.smartstock.erp.model.StockMovement;
import com.smartstock.erp.repository.ProductRepository;
import com.smartstock.erp.repository.PurchaseOrderRepository;
import com.smartstock.erp.repository.StockMovementRepository;
import com.smartstock.erp.service.ProductService;
import com.smartstock.erp.util.PdfReportGenerator;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet pour la génération et le téléchargement de rapports PDF.
 *
 * <p>Rapports disponibles :</p>
 * <ul>
 *   <li>{@code inventory} - Rapport d'inventaire complet (tous les produits)</li>
 *   <li>{@code low-stock} - Rapport des produits en stock faible ou rupture</li>
 *   <li>{@code movements} - Rapport des mouvements de stock récents</li>
 *   <li>{@code purchase-order} - Bon de commande spécifique (paramètre {@code id})</li>
 * </ul>
 */
@WebServlet(name = "ReportServlet", urlPatterns = {"/reports"})
public class ReportServlet extends HttpServlet {

    @Inject
    private ProductRepository productRepository;

    @Inject
    private StockMovementRepository movementRepository;

    @Inject
    private PurchaseOrderRepository orderRepository;

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        if (type == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Paramètre 'type' manquant.");
            return;
        }

        try {
            switch (type) {
                case "inventory":
                    generateInventoryReport(request, response);
                    break;
                case "low-stock":
                    generateLowStockReport(request, response);
                    break;
                case "movements":
                    generateMovementsReport(request, response);
                    break;
                case "purchase-order":
                    generatePurchaseOrderReport(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                            "Type de rapport non reconnu : " + type);
            }
        } catch (Exception e) {
            throw new ServletException("Erreur lors de la génération du rapport : " + e.getMessage(), e);
        }
    }

    // -------------------------------------------------------------------------
    // Générateurs de rapports
    // -------------------------------------------------------------------------

    private void generateInventoryReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Product> products = productRepository.findAll();
        BigDecimal totalValue  = productService.calculateTotalStockValue();

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"rapport-inventaire.pdf\"");

        try (OutputStream out = response.getOutputStream()) {
            PdfReportGenerator.generateInventoryReport(products, totalValue, out);
        }
    }

    private void generateLowStockReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Product> lowStock   = productService.getLowStockProducts();
        List<Product> outOfStock = productService.getOutOfStockProducts();

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"rapport-alertes-stock.pdf\"");

        try (OutputStream out = response.getOutputStream()) {
            PdfReportGenerator.generateLowStockReport(lowStock, outOfStock, out);
        }
    }

    private void generateMovementsReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<StockMovement> movements = movementRepository.findRecent(100);

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"rapport-mouvements-stock.pdf\"");

        try (OutputStream out = response.getOutputStream()) {
            PdfReportGenerator.generateMovementsReport(movements, out);
        }
    }

    private void generatePurchaseOrderReport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Paramètre 'id' manquant.");
            return;
        }
        Long orderId = Long.parseLong(idParam);
        PurchaseOrder order = orderRepository.findById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bon de commande introuvable.");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"bon-commande-" + order.getOrderNumber() + ".pdf\"");

        try (OutputStream out = response.getOutputStream()) {
            PdfReportGenerator.generatePurchaseOrderReport(order, out);
        }
    }
}
