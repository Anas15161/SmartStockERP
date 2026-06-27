package com.smartstock.erp.servlet;

import com.smartstock.erp.repository.GlobalSettingRepository;
import jakarta.inject.Inject;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter(urlPatterns = {"/*"})
public class SettingsFilter implements Filter {

    @Inject
    private GlobalSettingRepository settingRepository;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        ServletContext context = request.getServletContext();
        if (context.getAttribute("appSettings") == null) {
            try {
                context.setAttribute("appSettings", settingRepository.getAllAsMap());
            } catch (Exception e) {
                // Silently fail if DB not ready yet
            }
        }
        
        chain.doFilter(request, response);
    }
}
