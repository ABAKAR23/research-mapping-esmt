package sn.esmt.cartographie.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sn.esmt.cartographie.dto.LoginRequest;
import sn.esmt.cartographie.dto.TokenResponse;
import sn.esmt.cartographie.service.AuthenticationService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import java.util.Collections;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "Authentication", description = "API d'authentification")
public class AuthController {

    @Autowired
    private AuthenticationService authenticationService;

    @PostMapping("/login")
    @Operation(summary = "Connexion avec email et mot de passe")
    public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest loginRequest,
                                               HttpServletRequest request) {

        TokenResponse response = authenticationService.login(loginRequest);

        // Nettoyer toute session existante
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        // Créer une nouvelle session
        HttpSession session = request.getSession(true);

        // Configurer l'authentification Spring Security
        String role = "ROLE_" + response.getRole().toUpperCase();

        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                response.getEmail(),
                null,
                Collections.singleton(new SimpleGrantedAuthority(role)));

        SecurityContext sc = SecurityContextHolder.createEmptyContext();
        sc.setAuthentication(auth);
        SecurityContextHolder.setContext(sc);

        // Sauvegarder dans la session
        session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, sc);
        session.setAttribute("user", response);
        session.setMaxInactiveInterval(3600); // 1 heure

        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    @Operation(summary = "Déconnexion")
    public ResponseEntity<?> logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        SecurityContextHolder.clearContext();
        return ResponseEntity.ok().body("Déconnecté avec succès");
    }

    @GetMapping("/validate")
    @Operation(summary = "Valider un token JWT")
    public ResponseEntity<String> validateToken(@RequestHeader("Authorization") String token) {
        if (token != null && token.startsWith("Bearer ")) {
            String jwt = token.substring(7);
            authenticationService.validateToken(jwt);
            return ResponseEntity.ok("Token valide");
        }
        return ResponseEntity.status(401).body("Token invalide");
    }
}