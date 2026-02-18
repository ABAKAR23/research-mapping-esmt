package sn.esmt.cartographie.dto;

import java.util.Map;

public class StatisticsDTO {
    private Long totalProjets;
    private Map<String, Long> projetsParDomaine;
    private Map<String, Long> projetsParStatut;
    private Map<String, Long> projetsParParticipant;
    private Map<String, Double> budgetParDomaine;
    private Double tauxMoyenAvancement;
    private Double budgetTotal;
    private Map<Integer, Long> evolutionTemporelle;

    public StatisticsDTO() {
    }

    public Long getTotalProjets() {
        return totalProjets;
    }

    public void setTotalProjets(Long totalProjets) {
        this.totalProjets = totalProjets;
    }

    public Map<String, Long> getProjetsParDomaine() {
        return projetsParDomaine;
    }

    public void setProjetsParDomaine(Map<String, Long> projetsParDomaine) {
        this.projetsParDomaine = projetsParDomaine;
    }

    public Map<String, Long> getProjetsParStatut() {
        return projetsParStatut;
    }

    public void setProjetsParStatut(Map<String, Long> projetsParStatut) {
        this.projetsParStatut = projetsParStatut;
    }

    public Map<String, Long> getProjetsParParticipant() {
        return projetsParParticipant;
    }

    public void setProjetsParParticipant(Map<String, Long> projetsParParticipant) {
        this.projetsParParticipant = projetsParParticipant;
    }

    public Map<String, Double> getBudgetParDomaine() {
        return budgetParDomaine;
    }

    public void setBudgetParDomaine(Map<String, Double> budgetParDomaine) {
        this.budgetParDomaine = budgetParDomaine;
    }

    public Double getTauxMoyenAvancement() {
        return tauxMoyenAvancement;
    }

    public void setTauxMoyenAvancement(Double tauxMoyenAvancement) {
        this.tauxMoyenAvancement = tauxMoyenAvancement;
    }

    public Double getBudgetTotal() {
        return budgetTotal;
    }

    public void setBudgetTotal(Double budgetTotal) {
        this.budgetTotal = budgetTotal;
    }

    public Map<Integer, Long> getEvolutionTemporelle() {
        return evolutionTemporelle;
    }

    public void setEvolutionTemporelle(Map<Integer, Long> evolutionTemporelle) {
        this.evolutionTemporelle = evolutionTemporelle;
    }
}
