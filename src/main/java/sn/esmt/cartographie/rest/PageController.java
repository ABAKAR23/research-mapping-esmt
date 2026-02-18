package sn.esmt.cartographie.rest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    private static final Logger logger = LoggerFactory.getLogger(PageController.class);

    @GetMapping("/")
    public String index(Authentication authentication) {
        logger.debug("Accessing index. Authenticated: {}", isAuthenticated(authentication));

        // ✅ NE PAS rediriger automatiquement - toujours afficher la page de login
        return "login";
    }

    @GetMapping("/login")
    public String login(Authentication authentication) {
        logger.debug("Accessing login. Authenticated: {}", isAuthenticated(authentication));

        // ✅ TOUJOURS afficher la page de login, même si déjà authentifié
        // C'est le JavaScript qui gère la redirection après connexion
        return "login";
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        logger.debug("Accessing dashboard. Authenticated: {}", isAuthenticated(authentication));

        if (!isAuthenticated(authentication)) {
            logger.debug("User not authenticated, redirecting to login");
            return "redirect:/login";
        }

        String role = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .findFirst()
                .orElse("");

        logger.debug("User role: {}", role);

        // Vérifier que l'utilisateur a le bon rôle pour cette page
        if (role.equals("ROLE_CANDIDAT")) {
            logger.debug("Candidat trying to access admin dashboard, redirecting to candidat");
            return "redirect:/candidat";
        }

        return "dashboard";
    }

    @GetMapping("/candidat")
    public String candidat(Authentication authentication) {
        logger.debug("Accessing candidat dashboard. Authenticated: {}", isAuthenticated(authentication));

        if (!isAuthenticated(authentication)) {
            return "redirect:/login";
        }

        return "dashboard-candidat";
    }

    @GetMapping("/logout-success")
    public String logoutSuccess() {
        logger.debug("Logout successful");
        return "redirect:/login?logout";
    }

    private boolean isAuthenticated(Authentication authentication) {
        return authentication != null &&
                authentication.isAuthenticated() &&
                !(authentication instanceof AnonymousAuthenticationToken);
    }
}