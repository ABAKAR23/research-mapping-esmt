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
        if (isAuthenticated(authentication)) {
            return "redirect:/dashboard";
        }
        return "login";
    }

    @GetMapping("/login")
    public String login(Authentication authentication) {
        logger.debug("Accessing login. Authenticated: {}", isAuthenticated(authentication));
        // ✅ NE PLUS rediriger automatiquement - juste afficher la page
        // La redirection se fait uniquement après connexion réussie
        return "login";
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        logger.debug("Accessing dashboard. Authenticated: {}", isAuthenticated(authentication));

        // ✅ Permettre l'accès initial, la vérification se fait côté client avec JWT
        if (!isAuthenticated(authentication)) {
            logger.debug("User not authenticated, redirecting to login");
            return "redirect:/login";
        }

        // Get the role
        String role = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .findFirst()
                .orElse("");

        logger.debug("User role: {}", role);

        if (role.equals("ROLE_CANDIDAT")) {
            return "dashboard-candidat";
        } else if (role.equals("ROLE_ADMIN") || role.equals("ROLE_GESTIONNAIRE")) {
            return "dashboard";
        } else {
            // Fallback
            return "dashboard-candidat";
        }
    }

    @GetMapping("/candidat")
    public String candidat(Authentication authentication) {
        logger.debug("Accessing candidat dashboard. Authenticated: {}", isAuthenticated(authentication));
        // ✅ Route directe pour les candidats
        return "dashboard-candidat";
    }

    private boolean isAuthenticated(Authentication authentication) {
        return authentication != null &&
                authentication.isAuthenticated() &&
                !(authentication instanceof AnonymousAuthenticationToken);
    }
}