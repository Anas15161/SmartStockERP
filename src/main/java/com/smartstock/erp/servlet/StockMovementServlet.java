package com.smartstock.erp.servlet;

import com.smartstock.erp.exception.ApplicationException;
import com.smartstock.erp.model.StockMovement;
import com.smartstock.erp.model.User;
import com.smartstock.erp.repository.ProductRepository;
import com.smartstock.erp.repository.StockMovementRepository;
import com.smartstock.erp.service.ProductService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet pour la consultation et la gestion de l'historique des mouvements de stock.
 *
 * <p>Ce servlet expose les fonctionnalités suivantes :</p>
 * <ul>
 *   <li>Liste paginée de tous les mouvements de stock</li>
 *   <li>Filtrage par produit</li>
 *   <li>Saisie manuelle d'une entrée ou sortie de stock</li>
 * </ul>
 */
@WebServlet(name = "StockMovementServlet", urlPatterns = {"/stock-movements"})
public class StockMovementServlet extends HttpServlet {

    @Inject
    private StockMovementRepository movementRepository;

    @Inject
    private ProductRepository productRepository;

    @Inject
    private ProductService productService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    showNewMovementForm(request, response);
                    break;
                default:
                    listMovements(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            recordMovement(request, response);
        } catch (ApplicationException e) {
            request.setAttribute("error", e.getUserMessage());
            showNewMovementForm(request, response);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listMovements(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int size = 20;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
        }

        // Filtrage par produit
        String productIdParam = request.getParameter("productId");
        List<StockMovement> movements;
        long totalItems;

        if (productIdParam != null && !productIdParam.isEmpty()) {
            Long productId = Long.parseLong(productIdParam);
            movements = movementRepository.findByProductId(productId);
            totalItems = movements.size();
            request.setAttribute("selectedProduct", productRepository.findById(productId));
        } else {
            movements = movementRepository.findPaginatedWithDetails(page, size);
            totalItems = movementRepository.count();
        }

        int totalPages = (int) Math.ceil((double) totalItems / size);

        request.setAttribute("movements",    movements);
        request.setAttribute("currentPage",  page);
        request.setAttribute("totalPages",   totalPages);
        request.setAttribute("totalItems",   totalItems);
        request.setAttribute("listProducts", productRepository.findAll());

        request.getRequestDispatcher("/WEB-INF/views/stock-movements/list.jsp").forward(request, response);
    }

    private void showNewMovementForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("listProducts", productRepository.findAll());
        request.getRequestDispatcher("/WEB-INF/views/stock-movements/new.jsp").forward(request, response);
    }

    private void recordMovement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long productId  = Long.parseLong(request.getParameter("productId"));
        String typeStr  = request.getParameter("movementType");
        int quantity    = Integer.parseInt(request.getParameter("quantity"));
        String reference = request.getParameter("reference");
        String notes    = request.getParameter("notes");

        User currentUser = (User) request.getSession(false)
                .getAttribute(LoginServlet.SESSION_USER_KEY);

        if ("ENTRY".equals(typeStr)) {
            productService.addStock(productId, quantity, reference, notes, currentUser);
        } else if ("EXIT".equals(typeStr)) {
            productService.removeStock(productId, quantity, reference, notes, currentUser);
        } else {
            throw new ApplicationException("Type de mouvement invalide : " + typeStr);
        }

        response.sendRedirect(request.getContextPath() + "/stock-movements");
    }
}
