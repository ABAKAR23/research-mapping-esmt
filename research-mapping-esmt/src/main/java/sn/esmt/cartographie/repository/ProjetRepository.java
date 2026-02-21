package sn.esmt.cartographie.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.model.projet.StatutProjet;

import java.util.List;

@Repository
public interface ProjetRepository extends JpaRepository<Projet, Long> {

    @Query("SELECT p FROM Projet p WHERE p.responsable_projet.id = :userId")
    List<Projet> findByResponsableProjetId(@Param("userId") Long userId);

    @Query("SELECT p FROM Projet p WHERE p.statut_projet = :statut")
    List<Projet> findByStatutProjet(@Param("statut") StatutProjet statut);

    @Query("SELECT p FROM Projet p WHERE p.domaine_recherche.id = :domaineId")
    List<Projet> findByDomaineRechercheId(@Param("domaineId") Long domaineId);

    @Query("SELECT p FROM Projet p JOIN p.liste_participants part WHERE part.id = :userId")
    List<Projet> findByParticipantId(@Param("userId") Long userId);

    @Query("SELECT p FROM Projet p WHERE p.responsable_projet.id = :userId OR :userId IN (SELECT part.id FROM p.liste_participants part)")
    List<Projet> findByResponsableOrParticipant(@Param("userId") Long userId);
}