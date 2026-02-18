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
        // Route accessible via permitAll() - la vérification JWT se fait côté client
        // Cette vérification serveur basique redirige si Spring Security détecte un utilisateur non authentifié
        if (!isAuthenticated(authentication)) {
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
        // Route accessible via permitAll() - la vérification JWT se fait côté client dans dashboard-candidat.jsp
        // Cela évite les boucles de redirection tout en permettant la validation JavaScript
        return "dashboard-candidat";
    }

    private boolean isAuthenticated(Authentication authentication) {
        return authentication != null &&
                authentication.isAuthenticated() &&
                !(authentication instanceof AnonymousAuthenticationToken);
    }
}