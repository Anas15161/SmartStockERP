package com.smartstock.erp.servlet;

import com.smartstock.erp.model.Product;
import com.smartstock.erp.repository.ProductRepository;
import com.smartstock.erp.repository.SupplierRepository;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Inject
    private ProductRepository productRepository;

    @Inject
    private SupplierRepository supplierRepository;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> allProducts = productRepository.findAll();
        long totalProducts = allProducts.size();
        long totalSuppliers = supplierRepository.findAll().size();
        
        // Products with stock <= alert threshold
        List<Product> lowStockProducts = allProducts.stream()
                .filter(p -> p.getStockQuantity() <= p.getAlertThreshold())
                .collect(Collectors.toList());
        
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalSuppliers", totalSuppliers);
        request.setAttribute("lowStockCount", lowStockProducts.size());
        request.setAttribute("lowStockProducts", lowStockProducts);

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}
