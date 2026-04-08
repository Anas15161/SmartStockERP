package com.smartstock.erp.servlet;

import com.smartstock.erp.exception.ApplicationException;
import com.smartstock.erp.model.PurchaseOrder;
import com.smartstock.erp.model.User;
import com.smartstock.erp.repository.ProductRepository;
import com.smartstock.erp.repository.SupplierRepository;
import com.smartstock.erp.service.PurchaseOrderService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet pour la gestion des bons de commande fournisseurs.
 *
 * <p>Fonctionnalités exposées :</p>
 * <ul>
 *   <li>Liste paginée des bons de commande</li>
 *   <li>Création d'un nouveau bon de commande</li>
 *   <li>Ajout de lignes de produits</li>
 *   <li>Soumission, réception et annulation</li>
 *   <li>Consultation du détail d'un bon de commande</li>
 * </ul>
 */
@WebServlet(name = "PurchaseOrderServlet", urlPatterns = {"/purchase-orders"})
public class PurchaseOrderServlet extends HttpServlet {

    @Inject
    private PurchaseOrderService orderService;

    @Inject
    private SupplierRepository supplierRepository;

    @Inject
    private ProductRepository productRepository;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "view":
                    viewOrder(request, response);
                    break;
                case "addItem":
                    showAddItemForm(request, response);
                    break;
                case "submit":
                    submitOrder(request, response);
                    break;
                case "receive":
                    receiveOrder(request, response);
                    break;
                case "cancel":
                    cancelOrder(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (ApplicationException e) {
            request.setAttribute("error", e.getUserMessage());
            listOrders(request, response);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                createOrder(request, response);
            } else if ("addItem".equals(action)) {
                addItemToOrder(request, response);
            }
        } catch (ApplicationException e) {
            request.setAttribute("error", e.getUserMessage());
            showNewForm(request, response);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    // -------------------------------------------------------------------------
    // Méthodes privées
    // -------------------------------------------------------------------------

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int size = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
        }

        List<PurchaseOrder> orders = orderService.getAllOrders(page, size);
        long totalItems = orderService.countAllOrders();
        int totalPages  = (int) Math.ceil((double) totalItems / size);

        request.setAttribute("orders",      orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("totalItems",  totalItems);

        request.getRequestDispatcher("/WEB-INF/views/purchase-orders/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("listSuppliers", supplierRepository.findAll());
        request.getRequestDispatcher("/WEB-INF/views/purchase-orders/new.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        PurchaseOrder order = orderService.getOrderById(id);
        request.setAttribute("order",        order);
        request.setAttribute("listProducts", productRepository.findAll());
        request.getRequestDispatcher("/WEB-INF/views/purchase-orders/view.jsp").forward(request, response);
    }

    private void showAddItemForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long orderId = Long.parseLong(request.getParameter("id"));
        request.setAttribute("order",        orderService.getOrderById(orderId));
        request.setAttribute("listProducts", productRepository.findAll());
        request.getRequestDispatcher("/WEB-INF/views/purchase-orders/add-item.jsp").forward(request, response);
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long supplierId = Long.parseLong(request.getParameter("supplierId"));
        String deliveryStr = request.getParameter("expectedDeliveryDate");
        LocalDate expectedDelivery = (deliveryStr != null && !deliveryStr.isEmpty())
                ? LocalDate.parse(deliveryStr) : null;
        String notes = request.getParameter("notes");

        User currentUser = (User) request.getSession(false)
                .getAttribute(LoginServlet.SESSION_USER_KEY);

        PurchaseOrder created = orderService.createOrder(supplierId, expectedDelivery, notes, currentUser);
        response.sendRedirect(request.getContextPath() + "/purchase-orders?action=view&id=" + created.getId());
    }

    private void addItemToOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long orderId   = Long.parseLong(request.getParameter("orderId"));
        Long productId = Long.parseLong(request.getParameter("productId"));
        int quantity   = Integer.parseInt(request.getParameter("quantityOrdered"));
        BigDecimal price = new BigDecimal(request.getParameter("unitPrice"));

        orderService.addItem(orderId, productId, quantity, price);
        response.sendRedirect(request.getContextPath() + "/purchase-orders?action=view&id=" + orderId);
    }

    private void submitOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        orderService.submitOrder(id);
        response.sendRedirect(request.getContextPath() + "/purchase-orders?action=view&id=" + id);
    }

    private void receiveOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        User currentUser = (User) request.getSession(false)
                .getAttribute(LoginServlet.SESSION_USER_KEY);
        orderService.receiveOrder(id, currentUser);
        response.sendRedirect(request.getContextPath() + "/purchase-orders?action=view&id=" + id);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        orderService.cancelOrder(id);
        response.sendRedirect(request.getContextPath() + "/purchase-orders");
    }
}
