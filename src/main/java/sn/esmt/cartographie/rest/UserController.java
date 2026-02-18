package sn.esmt.cartographie.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.*;
import sn.esmt.cartographie.dto.UtilisateurDTO;
import sn.esmt.cartographie.service.UtilisateurService;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@Tag(name = "Users", description = "API de gestion des utilisateurs")
@SecurityRequirement(name = "bearer-jwt")
public class UserController {

    @Autowired
    private UtilisateurService utilisateurService;

    @GetMapping("/me")
    @Operation(summary = "Obtenir le profil de l'utilisateur connecté")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE', 'CANDIDAT')")
    public ResponseEntity<UtilisateurDTO> getMyProfile(@AuthenticationPrincipal OAuth2User principal) {
        String email = principal.getAttribute("email");
        return ResponseEntity.ok(utilisateurService.getUtilisateurByEmail(email));
    }

    @PutMapping("/me")
    @Operation(summary = "Mettre à jour le profil de l'utilisateur connecté")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE', 'CANDIDAT')")
    public ResponseEntity<UtilisateurDTO> updateMyProfile(
            @AuthenticationPrincipal OAuth2User principal,
            @Valid @RequestBody UtilisateurDTO utilisateurDTO) {
        String email = principal.getAttribute("email");
        UtilisateurDTO updated = utilisateurService.updateMyProfile(email, utilisateurDTO);
        return ResponseEntity.ok(updated);
    }

    @GetMapping
    @Operation(summary = "Obtenir tous les utilisateurs")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<List<UtilisateurDTO>> getAllUsers() {
        return ResponseEntity.ok(utilisateurService.getAllUtilisateurs());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtenir un utilisateur par ID")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<UtilisateurDTO> getUserById(@PathVariable Long id) {
        return ResponseEntity.ok(utilisateurService.getUtilisateurById(id));
    }

    @PostMapping
    @Operation(summary = "Créer un nouvel utilisateur")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UtilisateurDTO> createUser(
            @Valid @RequestBody UtilisateurDTO utilisateurDTO,
            @RequestParam String password) {
        UtilisateurDTO created = utilisateurService.createUtilisateur(utilisateurDTO, password);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Mettre à jour un utilisateur")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UtilisateurDTO> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UtilisateurDTO utilisateurDTO) {
        UtilisateurDTO updated = utilisateurService.updateUtilisateur(id, utilisateurDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Supprimer un utilisateur")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        utilisateurService.deleteUtilisateur(id);
        return ResponseEntity.noContent().build();
    }
}
