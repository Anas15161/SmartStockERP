package com.smartstock.erp.servlet;

import com.smartstock.erp.exception.ApplicationException;
import com.smartstock.erp.model.User;
import com.smartstock.erp.service.UserService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet gérant l'authentification des utilisateurs via la base de données Oracle.
 *
 * <p>L'authentification est déléguée au {@link UserService} qui vérifie
 * les identifiants en base de données avec hachage BCrypt.</p>
 *
 * <p>Sécurité : invalidation de la session existante avant création d'une nouvelle
 * (prévention de la fixation de session), messages d'erreur génériques.</p>
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /** Clé de session pour stocker l'objet User authentifié */
    public static final String SESSION_USER_KEY = "currentUser";

    /** Durée maximale d'inactivité de session (30 minutes) */
    private static final int SESSION_TIMEOUT_SECONDS = 30 * 60;

    @Inject
    private UserService userService;

    /**
     * Affiche la page de connexion.
     * Si l'utilisateur est déjà connecté, redirige vers le tableau de bord.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(SESSION_USER_KEY) != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * Traite la soumission du formulaire de connexion.
     * Délègue la vérification au UserService (BCrypt + Oracle).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Authentification via le service (vérification Oracle + BCrypt)
            User authenticatedUser = userService.authenticate(email, password);

            // Prévention de la fixation de session : invalider l'ancienne session
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Création d'une nouvelle session sécurisée
            HttpSession newSession = request.getSession(true);
            newSession.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);
            newSession.setAttribute(SESSION_USER_KEY, authenticatedUser);

            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (ApplicationException e) {
            request.setAttribute("error", e.getUserMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
