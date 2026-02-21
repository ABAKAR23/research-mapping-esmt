package sn.esmt.cartographie.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import sn.esmt.cartographie.dto.StatisticsDTO;
import sn.esmt.cartographie.service.StatistiqueService;

import java.util.Map;

@RestController
@RequestMapping("/api/statistics")
@Tag(name = "Statistics", description = "API des statistiques des projets")
@SecurityRequirement(name = "bearer-jwt")
public class StatisticsController {

    @Autowired
    private StatistiqueService statistiqueService;

    @GetMapping
    @Operation(summary = "Obtenir toutes les statistiques")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<StatisticsDTO> getAllStatistics() {
        return ResponseEntity.ok(statistiqueService.getStatistics());
    }

    @GetMapping("/budget-total")
    @Operation(summary = "Obtenir le budget total")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Double> getTotalBudget() {
        return ResponseEntity.ok(statistiqueService.calculerBudgetTotal());
    }

    @GetMapping("/projets-par-statut")
    @Operation(summary = "Obtenir le nombre de projets par statut")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Map<String, Long>> getProjectsByStatus() {
        return ResponseEntity.ok(statistiqueService.compterProjetsParStatut());
    }

    @GetMapping("/projets-par-domaine")
    @Operation(summary = "Obtenir le nombre de projets par domaine")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Map<String, Long>> getProjectsByDomain() {
        return ResponseEntity.ok(statistiqueService.compterProjetsParDomaine());
    }

    @GetMapping("/budget-par-domaine")
    @Operation(summary = "Obtenir le budget total par domaine")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Map<String, Double>> getBudgetByDomain() {
        return ResponseEntity.ok(statistiqueService.calculerBudgetParDomaine());
    }

    @GetMapping("/projets-par-participant")
    @Operation(summary = "Obtenir le nombre de projets par participant")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Map<String, Long>> getProjectsByParticipant() {
        return ResponseEntity.ok(statistiqueService.compterProjetsParParticipant());
    }

    @GetMapping("/taux-moyen-avancement")
    @Operation(summary = "Obtenir le taux moyen d'avancement des projets")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Double> getAverageProgress() {
        return ResponseEntity.ok(statistiqueService.calculerTauxMoyenAvancement());
    }

    @GetMapping("/total-projets")
    @Operation(summary = "Obtenir le nombre total de projets")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Long> getTotalProjects() {
        return ResponseEntity.ok(statistiqueService.compterTotalProjets());
    }

    @GetMapping("/evolution-temporelle")
    @Operation(summary = "Obtenir l'évolution du nombre de projets par année")
    @PreAuthorize("hasAnyRole('ADMIN', 'GESTIONNAIRE')")
    public ResponseEntity<Map<Integer, Long>> getTemporalEvolution() {
        return ResponseEntity.ok(statistiqueService.compterProjetsParAnnee());
    }
}
