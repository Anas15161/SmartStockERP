package com.smartstock.erp.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/", "/index.jsp", "/admin/*", "/products", "/products/*", "/suppliers", "/suppliers/*"})
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
        String loginJspURI = httpRequest.getContextPath() + "/login.jsp";
        String indexURI = httpRequest.getContextPath() + "/";
        String indexJspURI = httpRequest.getContextPath() + "/index.jsp";

        boolean isLoginRequest = httpRequest.getRequestURI().equals(loginURI) || httpRequest.getRequestURI().equals(loginJspURI);
        boolean isPublicPage = httpRequest.getRequestURI().equals(indexURI) || httpRequest.getRequestURI().equals(indexJspURI);
        boolean isApiRequest = httpRequest.getRequestURI().startsWith(httpRequest.getContextPath() + "/api");
        boolean isStaticResource = httpRequest.getRequestURI().startsWith(httpRequest.getContextPath() + "/css") ||
                                    httpRequest.getRequestURI().startsWith(httpRequest.getContextPath() + "/js") ||
                                    httpRequest.getRequestURI().startsWith(httpRequest.getContextPath() + "/assets");

        if (isLoggedIn || isLoginRequest || isPublicPage || isApiRequest || isStaticResource) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(loginURI);
        }
    }
}
