package com.smartstock.erp.servlet;

import com.smartstock.erp.repository.GlobalSettingRepository;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "SettingsServlet", urlPatterns = {"/settings"})
public class SettingsServlet extends HttpServlet {

    @Inject
    private GlobalSettingRepository settingRepository;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Initialize default settings if they don't exist
        initializeDefaults();
        
        Map<String, String> settings = settingRepository.getAllAsMap();
        request.setAttribute("settings", settings);
        request.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, String[]> parameterMap = request.getParameterMap();
        
        for (String key : parameterMap.keySet()) {
            if (!key.equals("submit")) {
                String value = request.getParameter(key);
                settingRepository.save(key, value, null);
            }
        }
        
        // Refresh ServletContext attributes
        getServletContext().setAttribute("appSettings", settingRepository.getAllAsMap());
        
        response.sendRedirect(request.getContextPath() + "/settings?success=true");
    }

    private void initializeDefaults() {
        checkAndSave("company_name", "SmartStock ERP Corp", "The name of the company");
        checkAndSave("currency", "DH", "Base currency for all products");
        checkAndSave("quote_prefix", "QT-", "Prefix for product quotes (Devis)");
        checkAndSave("quote_tax_rate", "20", "Default tax rate for quotes (%)");
        checkAndSave("stock_alert_threshold_default", "10", "Default threshold for low stock alerts");
        checkAndSave("theme_color", "#0b5e9e", "Primary brand color");
    }

    private void checkAndSave(String key, String defaultValue, String description) {
        if (settingRepository.findById(key) == null) {
            settingRepository.save(key, defaultValue, description);
        }
    }
}
