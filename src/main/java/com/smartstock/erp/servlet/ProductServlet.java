package com.smartstock.erp.servlet;

import com.smartstock.erp.model.Product;
import com.smartstock.erp.model.Supplier;
import com.smartstock.erp.repository.ProductRepository;
import com.smartstock.erp.repository.SupplierRepository;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validator;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

    @Inject
    private ProductRepository productRepository;

    @Inject
    private SupplierRepository supplierRepository;

    @Inject
    private Validator validator;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("insert".equals(action)) {
                insertProduct(request, response);
            } else if ("update".equals(action)) {
                updateProduct(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int size = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        // Get filter parameters
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String supplierIdStr = request.getParameter("supplierId");
        String supplierName = request.getParameter("supplierName");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        Long supplierId = null;
        if (supplierIdStr != null && !supplierIdStr.trim().isEmpty() && !"all".equalsIgnoreCase(supplierIdStr)) {
            try {
                supplierId = Long.parseLong(supplierIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        // If supplierId is set, clear supplierName to avoid conflict
        if (supplierId != null) {
            supplierName = null;
        }
        
        Double minPrice = null;
        Double maxPrice = null;
        try {
            if (minPriceStr != null && !minPriceStr.isEmpty()) minPrice = Double.parseDouble(minPriceStr);
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) maxPrice = Double.parseDouble(maxPriceStr);
        } catch (NumberFormatException e) {
            // Silently ignore invalid price inputs
        }

        long totalProducts = productRepository.countFiltered(search, minPrice, maxPrice, status, supplierId, supplierName);
        int totalPages = (int) Math.ceil((double) totalProducts / size);
        if (totalPages == 0) totalPages = 1;
        
        List<Product> listProduct = productRepository.findFilteredPaginated(page, size, search, minPrice, maxPrice, status, supplierId, supplierName);
        
        request.setAttribute("listProduct", listProduct);
        request.setAttribute("listSupplier", supplierRepository.findAll()); // For the filter dropdown
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalProducts);
        
        request.getRequestDispatcher("/products/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Supplier> listSupplier = supplierRepository.findAll();
        request.setAttribute("listSupplier", listSupplier);
        request.getRequestDispatcher("/products/add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Product existingProduct = productRepository.findById(id);
        List<Supplier> listSupplier = supplierRepository.findAll();
        request.setAttribute("product", existingProduct);
        request.setAttribute("listSupplier", listSupplier);
        request.getRequestDispatcher("/products/edit.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Product newProduct = new Product();
        mapRequestToProduct(request, newProduct);

        Set<ConstraintViolation<Product>> violations = validator.validate(newProduct);
        if (violations.isEmpty()) {
            productRepository.create(newProduct);
            response.sendRedirect("products");
        } else {
            handleValidationErrors(request, response, newProduct, violations, "/products/add.jsp");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Product product = productRepository.findById(id);
        mapRequestToProduct(request, product);

        Set<ConstraintViolation<Product>> violations = validator.validate(product);
        if (violations.isEmpty()) {
            productRepository.update(product);
            response.sendRedirect("products");
        } else {
            handleValidationErrors(request, response, product, violations, "/products/edit.jsp");
        }
    }

    private void handleValidationErrors(HttpServletRequest request, HttpServletResponse response, Product product, Set<ConstraintViolation<Product>> violations, String forwardTo) throws ServletException, IOException {
        Map<String, String> errors = new HashMap<>();
        for (ConstraintViolation<Product> violation : violations) {
            errors.put(violation.getPropertyPath().toString(), violation.getMessage());
        }
        request.setAttribute("errors", errors);
        request.setAttribute("product", product);
        request.setAttribute("listSupplier", supplierRepository.findAll());
        request.getRequestDispatcher(forwardTo).forward(request, response);
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        productRepository.delete(id);
        response.sendRedirect("products");
    }

    private void mapRequestToProduct(HttpServletRequest request, Product product) {
        product.setLabel(request.getParameter("label"));
        product.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        product.setAlertThreshold(Integer.parseInt(request.getParameter("alertThreshold")));
        product.setUnitPrice(new BigDecimal(request.getParameter("unitPrice")));
        
        String supplierId = request.getParameter("supplierId");
        if (supplierId != null && !supplierId.isEmpty()) {
            Supplier supplier = supplierRepository.findById(Long.parseLong(supplierId));
            product.setSupplier(supplier);
        }
    }
}
