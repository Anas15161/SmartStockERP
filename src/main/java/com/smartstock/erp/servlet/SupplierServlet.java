package com.smartstock.erp.servlet;

import com.smartstock.erp.model.Supplier;
import com.smartstock.erp.repository.SupplierRepository;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validator;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "SupplierServlet", urlPatterns = {"/suppliers"})
public class SupplierServlet extends HttpServlet {

    @Inject
    private SupplierRepository supplierRepository;

    @Inject
    private Validator validator;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteSupplier(request, response);
                    break;
                default:
                    listSuppliers(request, response);
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
                insertSupplier(request, response);
            } else if ("update".equals(action)) {
                updateSupplier(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int size = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        long totalSuppliers = supplierRepository.count();
        int totalPages = (int) Math.ceil((double) totalSuppliers / size);
        
        List<Supplier> listSupplier = supplierRepository.findPaginated(page, size);
        
        request.setAttribute("listSupplier", listSupplier);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalSuppliers);
        
        request.getRequestDispatcher("/suppliers/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/suppliers/add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Supplier existingSupplier = supplierRepository.findById(id);
        request.setAttribute("supplier", existingSupplier);
        request.getRequestDispatcher("/suppliers/edit.jsp").forward(request, response);
    }

    private void insertSupplier(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Supplier newSupplier = new Supplier();
        mapRequestToSupplier(request, newSupplier);

        Set<ConstraintViolation<Supplier>> violations = validator.validate(newSupplier);
        if (violations.isEmpty()) {
            supplierRepository.create(newSupplier);
            response.sendRedirect("suppliers");
        } else {
            handleValidationErrors(request, response, newSupplier, violations, "/suppliers/add.jsp");
        }
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Supplier supplier = supplierRepository.findById(id);
        mapRequestToSupplier(request, supplier);

        Set<ConstraintViolation<Supplier>> violations = validator.validate(supplier);
        if (violations.isEmpty()) {
            supplierRepository.update(supplier);
            response.sendRedirect("suppliers");
        } else {
            handleValidationErrors(request, response, supplier, violations, "/suppliers/edit.jsp");
        }
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        supplierRepository.delete(id);
        response.sendRedirect("suppliers");
    }

    private void handleValidationErrors(HttpServletRequest request, HttpServletResponse response, Supplier supplier, Set<ConstraintViolation<Supplier>> violations, String forwardTo) throws ServletException, IOException {
        Map<String, String> errors = new HashMap<>();
        for (ConstraintViolation<Supplier> violation : violations) {
            errors.put(violation.getPropertyPath().toString(), violation.getMessage());
        }
        request.setAttribute("errors", errors);
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher(forwardTo).forward(request, response);
    }

    private void mapRequestToSupplier(HttpServletRequest request, Supplier supplier) {
        supplier.setName(request.getParameter("name"));
        supplier.setEmail(request.getParameter("email"));
        supplier.setAddress(request.getParameter("address"));
        supplier.setCategory(request.getParameter("category"));
    }
}
