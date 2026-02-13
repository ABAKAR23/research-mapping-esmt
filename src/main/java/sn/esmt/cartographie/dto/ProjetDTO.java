package sn.esmt.cartographie.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

public class ProjetDTO {
    private Long projectId;

    @NotBlank(message = "Le titre est requis")
    private String titreProjet;

    private String description;

    @NotNull(message = "La date de début est requise")
    private Date dateDebut;

    private Date dateFin;

    @NotBlank(message = "Le statut est requis")
    private String statutProjet;

    private Double budgetEstime;
    private String institution;
    private Integer niveauAvancement;
    private Long domaineId;
    private String domaineNom;
    private Long responsableId;
    private String responsableNom;
    private List<Long> participantIds;
    private List<String> participantNames;

    public ProjetDTO() {}

    // Getters and Setters
    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public String getTitreProjet() {
        return titreProjet;
    }

    public void setTitreProjet(String titreProjet) {
        this.titreProjet = titreProjet;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public String getStatutProjet() {
        return statutProjet;
    }

    public void setStatutProjet(String statutProjet) {
        this.statutProjet = statutProjet;
    }

    public Double getBudgetEstime() {
        return budgetEstime;
    }

    public void setBudgetEstime(Double budgetEstime) {
        this.budgetEstime = budgetEstime;
    }

    public String getInstitution() {
        return institution;
    }

    public void setInstitution(String institution) {
        this.institution = institution;
    }

    public Integer getNiveauAvancement() {
        return niveauAvancement;
    }

    public void setNiveauAvancement(Integer niveauAvancement) {
        this.niveauAvancement = niveauAvancement;
    }

    public Long getDomaineId() {
        return domaineId;
    }

    public void setDomaineId(Long domaineId) {
        this.domaineId = domaineId;
    }

    public String getDomaineNom() {
        return domaineNom;
    }

    public void setDomaineNom(String domaineNom) {
        this.domaineNom = domaineNom;
    }

    public Long getResponsableId() {
        return responsableId;
    }

    public void setResponsableId(Long responsableId) {
        this.responsableId = responsableId;
    }

    public String getResponsableNom() {
        return responsableNom;
    }

    public void setResponsableNom(String responsableNom) {
        this.responsableNom = responsableNom;
    }

    public List<Long> getParticipantIds() {
        return participantIds;
    }

    public void setParticipantIds(List<Long> participantIds) {
        this.participantIds = participantIds;
    }

    public List<String> getParticipantNames() {
        return participantNames;
    }

    public void setParticipantNames(List<String> participantNames) {
        this.participantNames = participantNames;
    }
}
