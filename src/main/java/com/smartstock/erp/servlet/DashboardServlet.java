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

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Inject
    private ProductRepository productRepository;

    @Inject
    private SupplierRepository supplierRepository;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long totalProducts = productRepository.count();
        long totalSuppliers = supplierRepository.count();
        List<Product> lowStockProducts = productRepository.findLowStockProducts();
        
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalSuppliers", totalSuppliers);
        request.setAttribute("lowStockCount", (long) lowStockProducts.size());
        request.setAttribute("lowStockProducts", lowStockProducts);

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}
