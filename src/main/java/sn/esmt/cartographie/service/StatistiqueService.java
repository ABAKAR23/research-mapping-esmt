package sn.esmt.cartographie.service;

import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.repository.ProjetRepository;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class StatistiqueService {

    private ProjetRepository projetRepository = new ProjetRepository();

    // Calculer le budget total de tous les projets
    public Double calculerBudgetTotal() {
        return projetRepository.findAll().stream()
                .mapToDouble(Projet::getBudget_estime)
                .sum();
    }

    // Compter le nombre de projets par statut (pour le graphique en secteurs)
    public Map<String, Long> compterProjetsParStatut() {
        return projetRepository.findAll().stream()
                .collect(Collectors.groupingBy(p -> p.getStatut_projet().toString(), Collectors.counting()));
    }
}