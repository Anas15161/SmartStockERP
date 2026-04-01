package com.smartstock.erp.servlet;

import com.smartstock.erp.model.Product;
import com.smartstock.erp.model.Supplier;
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

@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

    @Inject
    private ProductRepository productRepository;

    @Inject
    private SupplierRepository supplierRepository;

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
        List<Product> listProduct = productRepository.findAll();
        request.setAttribute("listProduct", listProduct);
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

    private void insertProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Product newProduct = new Product();
        mapRequestToProduct(request, newProduct);
        productRepository.create(newProduct);
        response.sendRedirect("products");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Product product = productRepository.findById(id);
        mapRequestToProduct(request, product);
        productRepository.update(product);
        response.sendRedirect("products");
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
