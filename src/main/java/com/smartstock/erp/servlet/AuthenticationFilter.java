package com.smartstock.erp.servlet;

import com.smartstock.erp.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Set;

/**
 * Filtre d'authentification et de contrôle d'accès basé sur les rôles (RBAC).
 *
 * <p>Ce filtre protège toutes les routes privées de l'application en vérifiant :
 * <ol>
 *   <li>La présence d'une session valide avec un utilisateur authentifié</li>
 *   <li>Le rôle de l'utilisateur pour les routes restreintes aux administrateurs</li>
 * </ol>
 *
 * <p>Routes publiques (accessibles sans authentification) :</p>
 * <ul>
 *   <li>{@code /login} - Page de connexion</li>
 *   <li>{@code /} et {@code /index.jsp} - Page d'accueil publique</li>
 *   <li>{@code /css/*}, {@code /js/*}, {@code /assets/*} - Ressources statiques</li>
 * </ul>
 *
 * <p>Routes réservées aux administrateurs ({@code ADMIN}) :</p>
 * <ul>
 *   <li>{@code /admin/*} - Panneau d'administration</li>
 *   <li>{@code /users} - Gestion des utilisateurs</li>
 * </ul>
 */
@WebFilter(urlPatterns = {"/*"})
public class AuthenticationFilter implements Filter {

    /** Ensemble des préfixes de routes accessibles sans authentification */
    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/login", "/login.jsp", "/", "/index.jsp",
            "/presentation.jsp", "/documentation.jsp"
    );

    /** Préfixes de ressources statiques (CSS, JS, images) */
    private static final Set<String> STATIC_PREFIXES = Set.of(
            "/css/", "/js/", "/assets/", "/favicon"
    );

    /** Routes réservées aux administrateurs uniquement */
    private static final Set<String> ADMIN_ONLY_PREFIXES = Set.of(
            "/admin", "/users"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String contextPath = httpRequest.getContextPath();
        String requestURI = httpRequest.getRequestURI();
        // Chemin relatif au contexte de l'application
        String path = requestURI.substring(contextPath.length());
        if (path.isEmpty()) path = "/";

        // 1. Laisser passer les ressources statiques
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Laisser passer les routes publiques
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Vérifier l'authentification
        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null)
                ? (User) session.getAttribute(LoginServlet.SESSION_USER_KEY)
                : null;

        if (currentUser == null) {
            // Utilisateur non connecté : sauvegarder l'URL demandée et rediriger vers login
            if (session != null) {
                session.setAttribute("requestedUrl", requestURI);
            }
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // 4. Vérifier les droits d'accès aux routes admin
        if (isAdminOnlyPath(path)) {
            String roleName = currentUser.getRole() != null ? currentUser.getRole().getName() : "";
            if (!"ADMIN".equalsIgnoreCase(roleName)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Accès refusé : vous n'avez pas les droits nécessaires pour accéder à cette page.");
                return;
            }
        }

        // 5. Exposer l'utilisateur courant dans la requête pour les JSP
        httpRequest.setAttribute("currentUser", currentUser);

        chain.doFilter(request, response);
    }

    private boolean isStaticResource(String path) {
        return STATIC_PREFIXES.stream().anyMatch(path::startsWith)
                || path.endsWith(".ico")
                || path.endsWith(".png")
                || path.endsWith(".jpg")
                || path.endsWith(".gif");
    }

    private boolean isPublicPath(String path) {
        return PUBLIC_PATHS.contains(path)
                || path.startsWith("/api/");
    }

    private boolean isAdminOnlyPath(String path) {
        return ADMIN_ONLY_PREFIXES.stream().anyMatch(path::startsWith);
    }
}
