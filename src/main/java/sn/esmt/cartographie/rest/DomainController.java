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
import sn.esmt.cartographie.model.projet.DomaineRecherche;
import sn.esmt.cartographie.service.DomaineService;

import java.util.List;

@RestController
@RequestMapping("/api/domains")
@Tag(name = "Domains", description = "API de gestion des domaines de recherche")
@SecurityRequirement(name = "bearer-jwt")
public class DomainController {

    @Autowired
    private DomaineService domaineService;

    @GetMapping
    @Operation(summary = "Obtenir tous les domaines")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE', 'CANDIDAT')")
    public ResponseEntity<List<DomaineRecherche>> getAllDomains() {
        return ResponseEntity.ok(domaineService.getAllDomaines());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtenir un domaine par ID")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE', 'CANDIDAT')")
    public ResponseEntity<DomaineRecherche> getDomainById(@PathVariable Long id) {
        return ResponseEntity.ok(domaineService.getDomaineById(id));
    }

    @PostMapping
    @Operation(summary = "Créer un nouveau domaine")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DomaineRecherche> createDomain(@Valid @RequestBody DomaineRecherche domaine) {
        DomaineRecherche created = domaineService.createDomaine(domaine);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Mettre à jour un domaine")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DomaineRecherche> updateDomain(
            @PathVariable Long id,
            @Valid @RequestBody DomaineRecherche domaine) {
        DomaineRecherche updated = domaineService.updateDomaine(id, domaine);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Supprimer un domaine")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteDomain(@PathVariable Long id) {
        domaineService.deleteDomaine(id);
        return ResponseEntity.noContent().build();
    }
}
