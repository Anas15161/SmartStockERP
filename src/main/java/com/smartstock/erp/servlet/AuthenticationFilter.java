package com.smartstock.erp.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/", "/index.jsp", "/admin/*", "/products", "/products/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        String loginURI = httpRequest.getContextPath() + "/login";

        boolean isLoginRequest = httpRequest.getRequestURI().equals(loginURI);
        boolean isStaticResource = httpRequest.getRequestURI().startsWith(httpRequest.getContextPath() + "/css") ||
                                    httpRequest.getRequestURI().startsWith(httpRequest.getContextPath() + "/js");

        if (isLoggedIn || isLoginRequest || isStaticResource) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(loginURI);
        }
    }
}
