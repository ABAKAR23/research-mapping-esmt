package sn.esmt.cartographie.security;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filtre de sécurité : Vérifie si l'utilisateur est authentifié avec Google
 * avant d'accéder aux ressources protégées.
 */
@WebFilter(urlPatterns = {"/import.jsp", "/import-csv", "/projets/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation du filtre
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // On récupère la session existante sans en créer une nouvelle (false)
        HttpSession session = req.getSession(false);

        // Vérification de la présence de l'attribut défini dans CallbackServlet
        boolean loggedIn = (session != null && session.getAttribute("is_authenticated") != null);

        // Permettre l'accès si l'utilisateur est connecté
        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            // Sinon, redirection vers la page d'accueil avec un message d'erreur
            res.sendRedirect(req.getContextPath() + "/index.jsp?error=auth_required");
        }
    }

    @Override
    public void destroy() {
        // Nettoyage des ressources du filtre
    }
}