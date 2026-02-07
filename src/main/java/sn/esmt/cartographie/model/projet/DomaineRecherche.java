package sn.esmt.cartographie.model.projet;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "domaines_recherche")
public class DomaineRecherche implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nomDomaine; // IA, Santé, Énergie, Télécoms [cite: 9, 154]

    private String description;

    public DomaineRecherche() {}

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNomDomaine() {
        return nomDomaine;
    }

    public void setNomDomaine(String nomDomaine) {
        this.nomDomaine = nomDomaine;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}