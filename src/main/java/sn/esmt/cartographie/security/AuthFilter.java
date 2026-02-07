package sn.esmt.cartographie.security;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// On définit ici toutes les pages qui nécessitent d'être connecté
@WebFilter(urlPatterns = {"/projets", "/dashboard", "/import", "/profil"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation si nécessaire
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); // On récupère la session sans en créer une nouvelle

        // On vérifie si l'utilisateur est passé par la CallbackServlet avec succès
        boolean loggedIn = (session != null && session.getAttribute("is_authenticated") != null);

        if (loggedIn) {
            // L'utilisateur est connecté, on laisse passer la requête vers la Servlet demandée
            chain.doFilter(request, response);
        } else {
            // L'utilisateur n'est pas connecté, on le redirige vers la page d'accueil (index.jsp)
            // avec un petit message d'erreur
            res.sendRedirect(req.getContextPath() + "/index.jsp?error=auth_required");
        }
    }

    @Override
    public void destroy() {
        // Nettoyage si nécessaire
    }
}