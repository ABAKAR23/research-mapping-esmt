package sn.esmt.cartographie.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import sn.esmt.cartographie.dto.ProjetDTO;
import sn.esmt.cartographie.service.ProjetService;

import java.util.List;

@RestController
@RequestMapping("/projects")
@Tag(name = "Projects", description = "API de gestion des projets de recherche")
@SecurityRequirement(name = "bearer-jwt")
public class ProjectController {

    @Autowired
    private ProjetService projetService;

    @GetMapping
    @Operation(summary = "Obtenir tous les projets")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE', 'CANDIDAT')")
    public ResponseEntity<List<ProjetDTO>> getAllProjects(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String role) {
        if (userId != null && role != null) {
            return ResponseEntity.ok(projetService.getProjetsByUser(userId, role));
        }
        return ResponseEntity.ok(projetService.getAllProjets());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtenir un projet par ID")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE', 'CANDIDAT')")
    public ResponseEntity<ProjetDTO> getProjectById(@PathVariable Long id) {
        return ResponseEntity.ok(projetService.getProjetById(id));
    }

    @PostMapping
    @Operation(summary = "Créer un nouveau projet")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<ProjetDTO> createProject(@Valid @RequestBody ProjetDTO projetDTO) {
        ProjetDTO created = projetService.createProjet(projetDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Mettre à jour un projet")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE', 'CANDIDAT')")
    public ResponseEntity<ProjetDTO> updateProject(
            @PathVariable Long id,
            @Valid @RequestBody ProjetDTO projetDTO,
            @RequestParam Long userId,
            @RequestParam String role) {
        ProjetDTO updated = projetService.updateProjet(id, projetDTO, userId, role);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Supprimer un projet")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Void> deleteProject(
            @PathVariable Long id,
            @RequestParam Long userId,
            @RequestParam String role) {
        projetService.deleteProjet(id, userId, role);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/domaine/{domaineId}")
    @Operation(summary = "Obtenir les projets par domaine")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE', 'CANDIDAT')")
    public ResponseEntity<List<ProjetDTO>> getProjectsByDomain(@PathVariable Long domaineId) {
        return ResponseEntity.ok(projetService.getProjetsByDomaine(domaineId));
    }

    @GetMapping("/statut/{statut}")
    @Operation(summary = "Obtenir les projets par statut")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<List<ProjetDTO>> getProjectsByStatus(@PathVariable String statut) {
        return ResponseEntity.ok(projetService.getProjetsByStatut(statut));
    }
}
