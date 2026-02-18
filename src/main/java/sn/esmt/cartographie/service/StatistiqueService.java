package sn.esmt.cartographie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import sn.esmt.cartographie.dto.StatisticsDTO;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.repository.ProjetRepository;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class StatistiqueService {

    @Autowired
    private ProjetRepository projetRepository;

    public StatisticsDTO getStatistics() {
        StatisticsDTO stats = new StatisticsDTO();
        List<Projet> projets = projetRepository.findAll();

        // Nombre total de projets
        stats.setTotalProjets((long) projets.size());

        // Budget total
        Double budgetTotal = projets.stream()
                .filter(p -> p.getBudget_estime() != null)
                .mapToDouble(Projet::getBudget_estime)
                .sum();
        stats.setBudgetTotal(budgetTotal);

        // Projets par statut
        Map<String, Long> projetsParStatut = projets.stream()
                .filter(p -> p.getStatut_projet() != null)
                .collect(Collectors.groupingBy(p -> p.getStatut_projet().toString(), Collectors.counting()));
        stats.setProjetsParStatut(projetsParStatut);

        // Projets par domaine
        Map<String, Long> projetsParDomaine = projets.stream()
                .filter(p -> p.getDomaine_recherche() != null)
                .collect(Collectors.groupingBy(p -> p.getDomaine_recherche().getNomDomaine(), Collectors.counting()));
        stats.setProjetsParDomaine(projetsParDomaine);

        // Budget par domaine
        Map<String, Double> budgetParDomaine = projets.stream()
                .filter(p -> p.getDomaine_recherche() != null && p.getBudget_estime() != null)
                .collect(Collectors.groupingBy(
                        p -> p.getDomaine_recherche().getNomDomaine(),
                        Collectors.summingDouble(Projet::getBudget_estime)
                ));
        stats.setBudgetParDomaine(budgetParDomaine);

        // Projets par participant
        Map<String, Long> projetsParParticipant = projets.stream()
                .filter(p -> p.getListe_participants() != null)
                .flatMap(p -> p.getListe_participants().stream())
                .collect(Collectors.groupingBy(Utilisateur::getNom, Collectors.counting()));
        stats.setProjetsParParticipant(projetsParParticipant);

        // Taux moyen d'avancement
        Double tauxMoyenAvancement = projets.stream()
                .filter(p -> p.getNiveau_avancement() != null)
                .mapToInt(Projet::getNiveau_avancement)
                .average()
                .orElse(0.0);
        stats.setTauxMoyenAvancement(tauxMoyenAvancement);

        return stats;
    }

    public Double calculerBudgetTotal() {
        return projetRepository.findAll().stream()
                .filter(p -> p.getBudget_estime() != null)
                .mapToDouble(Projet::getBudget_estime)
                .sum();
    }

    public Map<String, Long> compterProjetsParStatut() {
        return projetRepository.findAll().stream()
                .filter(p -> p.getStatut_projet() != null)
                .collect(Collectors.groupingBy(p -> p.getStatut_projet().toString(), Collectors.counting()));
    }

    /**
     * Compte le nombre de projets par domaine de recherche
     * @return Map avec le nom du domaine comme clé et le nombre de projets comme valeur
     */
    public Map<String, Long> compterProjetsParDomaine() {
        return projetRepository.findAll().stream()
                .filter(p -> p.getDomaine_recherche() != null)
                .collect(Collectors.groupingBy(p -> p.getDomaine_recherche().getNomDomaine(), Collectors.counting()));
    }

    /**
     * Calcule le budget total par domaine de recherche
     * @return Map avec le nom du domaine comme clé et le budget total comme valeur
     */
    public Map<String, Double> calculerBudgetParDomaine() {
        return projetRepository.findAll().stream()
                .filter(p -> p.getDomaine_recherche() != null && p.getBudget_estime() != null)
                .collect(Collectors.groupingBy(
                        p -> p.getDomaine_recherche().getNomDomaine(),
                        Collectors.summingDouble(Projet::getBudget_estime)
                ));
    }

    /**
     * Compte le nombre de projets par participant
     * @return Map avec le nom du participant comme clé et le nombre de projets comme valeur
     */
    public Map<String, Long> compterProjetsParParticipant() {
        return projetRepository.findAll().stream()
                .filter(p -> p.getListe_participants() != null)
                .flatMap(p -> p.getListe_participants().stream())
                .collect(Collectors.groupingBy(Utilisateur::getNom, Collectors.counting()));
    }

    /**
     * Calcule le taux moyen d'avancement de tous les projets
     * @return Taux moyen d'avancement en pourcentage
     */
    public Double calculerTauxMoyenAvancement() {
        return projetRepository.findAll().stream()
                .filter(p -> p.getNiveau_avancement() != null)
                .mapToInt(Projet::getNiveau_avancement)
                .average()
                .orElse(0.0);
    }

    /**
     * Compte le nombre total de projets
     * @return Nombre total de projets
     */
    public Long compterTotalProjets() {
        return projetRepository.count();
    }
}
