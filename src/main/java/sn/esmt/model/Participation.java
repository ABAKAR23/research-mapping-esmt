package sn.esmt.model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "participation")
public class Participation implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @ManyToOne
    @JoinColumn(name = "project_id", nullable = false)
    private ResearchProject project;
    
    @Column(length = 100)
    private String role;
    
    @Column(name = "joined_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date joinedAt;
    
    // Constructors
    public Participation() {
    }
    
    public Participation(User user, ResearchProject project, String role) {
        this.user = user;
        this.project = project;
        this.role = role;
        this.joinedAt = new Date();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public ResearchProject getProject() {
        return project;
    }
    
    public void setProject(ResearchProject project) {
        this.project = project;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public Date getJoinedAt() {
        return joinedAt;
    }
    
    public void setJoinedAt(Date joinedAt) {
        this.joinedAt = joinedAt;
    }
    
    @PrePersist
    protected void onCreate() {
        joinedAt = new Date();
    }
}
