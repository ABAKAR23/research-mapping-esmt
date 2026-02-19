package sn.esmt.cartographie.rest;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping({"/", "/login"})
    public String login(Authentication authentication) {
        // CORRECTION : Si déjà authentifié, rediriger vers le dashboard approprié
        if (isAuthenticated(authentication)) {
            String role = getFirstRole(authentication);
            return role.equals("ROLE_CANDIDAT") ? "redirect:/candidat" : "redirect:/dashboard";
        }
        return "login";
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication) {
        if (!isAuthenticated(authentication)) return "redirect:/login";

        // Sécurité : Un candidat ne doit pas accéder au dashboard admin
        if (getFirstRole(authentication).equals("ROLE_CANDIDAT")) return "redirect:/candidat";

        return "dashboard";
    }

    @GetMapping("/candidat")
    public String candidat(Authentication authentication) {
        if (!isAuthenticated(authentication)) return "redirect:/login";
        return "dashboard-candidat";
    }

    private boolean isAuthenticated(Authentication authentication) {
        return authentication != null && authentication.isAuthenticated() &&
                !(authentication instanceof AnonymousAuthenticationToken);
    }

    private String getFirstRole(Authentication auth) {
        return auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .findFirst().orElse("");
    }
}