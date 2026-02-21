package sn.esmt.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sn.esmt.model.User;
import sn.esmt.dao.UserDAO;

import java.io.IOException;

/**
 * Filtre de sécurité pour contrôler l'accès aux ressources selon les rôles
 * Empêche les CANDIDAT d'accéder à la liste complète des projets
 */
@WebFilter(urlPatterns = {"/api/javaee/projects"})
public class SecurityFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation si nécessaire
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Vérifier si c'est une requête GET pour obtenir tous les projets
        String method = httpRequest.getMethod();
        String pathInfo = httpRequest.getPathInfo();
        
        // Si c'est GET /api/javaee/projects (sans ID), vérifier le rôle
        if ("GET".equals(method) && (pathInfo == null || pathInfo.equals("/"))) {
            HttpSession session = httpRequest.getSession(false);
            
            if (session == null) {
                // Pas de session, rediriger vers login ou retourner 401
                sendUnauthorizedResponse(httpResponse, "Session requise");
                return;
            }
            
            // Récupérer l'ID utilisateur depuis la session
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                sendUnauthorizedResponse(httpResponse, "Utilisateur non authentifié");
                return;
            }
            
            // Vérifier le rôle de l'utilisateur
            UserDAO userDAO = new UserDAO();
            try {
                var userOpt = userDAO.findById(userId);
                if (userOpt.isEmpty()) {
                    sendUnauthorizedResponse(httpResponse, "Utilisateur non trouvé");
                    return;
                }
                
                User user = userOpt.get();
                if (user.getRole() == null) {
                    sendForbiddenResponse(httpResponse, "Rôle non défini");
                    return;
                }
                
                String role = user.getRole().getLibelle();
                
                // CANDIDAT ne peut pas accéder à la liste complète des projets
                if ("CANDIDAT".equals(role)) {
                    sendForbiddenResponse(httpResponse, 
                        "Accès refusé : Les candidats ne peuvent accéder qu'à leurs propres projets. " +
                        "Utilisez /api/javaee/projects/user/{userId}");
                    return;
                }
            } finally {
                userDAO.close();
            }
        }
        
        // Continuer la chaîne de filtres
        chain.doFilter(request, response);
    }
    
    private void sendUnauthorizedResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"error\":\"" + message + "\"}");
    }
    
    private void sendForbiddenResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"error\":\"" + message + "\"}");
    }
    
    @Override
    public void destroy() {
        // Nettoyage si nécessaire
    }
}
