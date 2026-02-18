package sn.esmt.cartographie.rest;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String index(Authentication authentication) {
        if (isAuthenticated(authentication)) {
            return "redirect:/dashboard";
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String login(Authentication authentication) {
        if (isAuthenticated(authentication)) {
            return "redirect:/dashboard";
        }
        return "login";
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        // Permettre l'accès initial, la vérification se fait côté client
        if (!isAuthenticated(authentication)) {
            // Vérification basique côté serveur
            return "redirect:/login";
        }

        // Get the role
        String role = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .findFirst()
                .orElse("");

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
        // Permettre l'accès initial pour les candidats
        return "dashboard-candidat";
    }

    private boolean isAuthenticated(Authentication authentication) {
        return authentication != null &&
                authentication.isAuthenticated() &&
                !(authentication instanceof AnonymousAuthenticationToken);
    }
}