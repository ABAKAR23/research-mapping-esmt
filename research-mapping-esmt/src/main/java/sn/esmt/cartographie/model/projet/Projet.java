package sn.esmt.cartographie.model.projet;

import jakarta.persistence.*;
import sn.esmt.cartographie.model.auth.Utilisateur;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "projets")
public class Projet implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long project_id;

    private String titre_projet;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Temporal(TemporalType.DATE)
    private Date date_debut;

    @Temporal(TemporalType.DATE)
    private Date date_fin;
    @Enumerated(EnumType.STRING)
    private StatutProjet statut_projet;

    private Double budget_estime;
    private String institution;
    private Integer niveau_avancement; // Valeur en % [cite: 118]

    @ManyToOne
    @JoinColumn(name = "domaine_id")
    private DomaineRecherche domaine_recherche;

    @ManyToOne
    @JoinColumn(name = "responsable_id")
    private Utilisateur responsable_projet;

    @ManyToMany
    @JoinTable(
            name = "projet_participants",
            joinColumns = @JoinColumn(name = "projet_id"),
            inverseJoinColumns = @JoinColumn(name = "utilisateur_id")
    )
    private List<Utilisateur> liste_participants;

    public Projet() {}

    // Getters et Setters
    public Long getProject_id() { return project_id; }
    public void setProject_id(Long project_id) { this.project_id = project_id; }

    public String getTitre_projet() { return titre_projet; }
    public void setTitre_projet(String titre_projet) { this.titre_projet = titre_projet; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getDate_debut() { return date_debut; }
    public void setDate_debut(Date date_debut) { this.date_debut = date_debut; }

    public Date getDate_fin() { return date_fin; }
    public void setDate_fin(Date date_fin) { this.date_fin = date_fin; }

    public StatutProjet getStatut_projet() { return statut_projet; }
    public void setStatut_projet(StatutProjet statut_projet) { this.statut_projet = statut_projet; }

    public Double getBudget_estime() { return budget_estime; }
    public void setBudget_estime(Double budget_estime) { this.budget_estime = budget_estime; }

    public String getInstitution() { return institution; }
    public void setInstitution(String institution) { this.institution = institution; }

    public Integer getNiveau_avancement() { return niveau_avancement; }
    public void setNiveau_avancement(Integer niveau_avancement) { this.niveau_avancement = niveau_avancement; }

    public DomaineRecherche getDomaine_recherche() { return domaine_recherche; }
    public void setDomaine_recherche(DomaineRecherche domaine_recherche) { this.domaine_recherche = domaine_recherche; }

    public Utilisateur getResponsable_projet() { return responsable_projet; }
    public void setResponsable_projet(Utilisateur responsable_projet) { this.responsable_projet = responsable_projet; }

    public List<Utilisateur> getListe_participants() { return liste_participants; }
    public void setListe_participants(List<Utilisateur> liste_participants) { this.liste_participants = liste_participants; }
}