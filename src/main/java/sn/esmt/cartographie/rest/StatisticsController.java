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
@RequestMapping("/statistics")
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
}
