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

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/auth")
@Tag(name = "Authentication", description = "API d'authentification")
public class AuthController {

    @Autowired
    private AuthenticationService authenticationService;

    @PostMapping("/login")
    @Operation(summary = "Connexion utilisateur")
    public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        TokenResponse token = authenticationService.login(loginRequest);
        return ResponseEntity.ok(token);
    }

    @GetMapping("/oauth2/success")
    @Operation(summary = "Callback OAuth2 success")
    public ResponseEntity<Map<String, String>> oauth2Success() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Authentification OAuth2 réussie");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/validate")
    @Operation(summary = "Valider le token")
    public ResponseEntity<Map<String, Object>> validateToken(@RequestHeader("Authorization") String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        var user = authenticationService.validateToken(token);
        
        Map<String, Object> response = new HashMap<>();
        response.put("valid", true);
        response.put("userId", user.getId());
        response.put("email", user.getEmail());
        response.put("role", user.getRole() != null ? user.getRole().getLibelle() : "USER");
        
        return ResponseEntity.ok(response);
    }
}
