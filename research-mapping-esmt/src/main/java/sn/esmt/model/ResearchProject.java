package sn.esmt.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "research_projects")
public class ResearchProject implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "project_id")
    private Long id;
    
    @Column(name = "titre_projet", nullable = false, length = 255)
    private String title;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @ManyToOne
    @JoinColumn(name = "domaine_recherche_id", nullable = false)
    private ResearchDomain domain;
    
    @ManyToOne
    @JoinColumn(name = "responsable_projet_id", nullable = false)
    private User responsibleUser;
    
    @Column(length = 255)
    private String institution;
    
    @Column(name = "date_debut")
    @Temporal(TemporalType.DATE)
    private Date startDate;
    
    @Column(name = "date_fin")
    @Temporal(TemporalType.DATE)
    private Date endDate;
    
    @Column(name = "statut_projet", length = 50)
    private String status = "EN_COURS"; // EN_COURS, TERMINE, SUSPENDU
    
    @Column(name = "budget_estime", precision = 15, scale = 2)
    private BigDecimal budgetEstimated;
    
    @Column(name = "niveau_avancement")
    private Integer advancementLevel = 0;
    
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
    private List<Participation> participations;
    
    // Constructors
    public ResearchProject() {
    }
    
    public ResearchProject(String title, String description, ResearchDomain domain, User responsibleUser) {
        this.title = title;
        this.description = description;
        this.domain = domain;
        this.responsibleUser = responsibleUser;
        this.createdAt = new Date();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public ResearchDomain getDomain() {
        return domain;
    }
    
    public void setDomain(ResearchDomain domain) {
        this.domain = domain;
    }
    
    public User getResponsibleUser() {
        return responsibleUser;
    }
    
    public void setResponsibleUser(User responsibleUser) {
        this.responsibleUser = responsibleUser;
    }
    
    public String getInstitution() {
        return institution;
    }
    
    public void setInstitution(String institution) {
        this.institution = institution;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public BigDecimal getBudgetEstimated() {
        return budgetEstimated;
    }
    
    public void setBudgetEstimated(BigDecimal budgetEstimated) {
        this.budgetEstimated = budgetEstimated;
    }
    
    public Integer getAdvancementLevel() {
        return advancementLevel;
    }
    
    public void setAdvancementLevel(Integer advancementLevel) {
        this.advancementLevel = advancementLevel;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public List<Participation> getParticipations() {
        return participations;
    }
    
    public void setParticipations(List<Participation> participations) {
        this.participations = participations;
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
    }
}
