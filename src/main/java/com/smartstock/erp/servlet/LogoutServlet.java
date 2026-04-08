package com.smartstock.erp.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet gérant la déconnexion sécurisée des utilisateurs.
 * Invalide la session HTTP et supprime le cookie de session côté client.
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        performLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        performLogout(request, response);
    }

    private void performLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Invalider la session pour supprimer toutes les données utilisateur
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Supprimer le cookie de session côté client
        Cookie sessionCookie = new Cookie("JSESSIONID", "");
        sessionCookie.setMaxAge(0);
        sessionCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        sessionCookie.setHttpOnly(true);
        response.addCookie(sessionCookie);

        response.sendRedirect(request.getContextPath() + "/login");
    }
}
