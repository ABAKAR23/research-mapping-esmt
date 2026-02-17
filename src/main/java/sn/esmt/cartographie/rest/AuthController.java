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

@RestController
@RequestMapping("/api/auth")
@Tag(name = "Authentication", description = "API d'authentification")
public class AuthController {

    @Autowired
    private AuthenticationService authenticationService;

    @PostMapping("/login")
    @Operation(summary = "Connexion avec email et mot de passe")
    public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        TokenResponse response = authenticationService.login(loginRequest);
        return ResponseEntity.ok(response);
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