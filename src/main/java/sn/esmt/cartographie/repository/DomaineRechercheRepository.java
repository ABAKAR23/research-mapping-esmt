package sn.esmt.cartographie.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import sn.esmt.cartographie.model.projet.DomaineRecherche;

import java.util.Optional;

@Repository
public interface DomaineRechercheRepository extends JpaRepository<DomaineRecherche, Long> {
    
    Optional<DomaineRecherche> findByNomDomaine(String nomDomaine);
}
