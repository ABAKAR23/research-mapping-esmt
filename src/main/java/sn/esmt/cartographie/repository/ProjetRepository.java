package sn.esmt.cartographie.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import sn.esmt.cartographie.model.projet.Projet;
import java.util.List;

public class ProjetRepository {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("CartographiePU");

    public void save(Projet projet) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(projet);
        em.getTransaction().commit();
        em.close();
    }

    public List<Projet> findAll() {
        EntityManager em = emf.createEntityManager();
        List<Projet> projets = em.createQuery("SELECT p FROM Projet p", Projet.class).getResultList();
        em.close();
        return projets;
    }

    public List<Projet> findByResponsable(Long userId) {
        EntityManager em = emf.createEntityManager();
        List<Projet> projets = em.createQuery("SELECT p FROM Projet p WHERE p.responsable_projet.id = :userId", Projet.class)
                .setParameter("userId", userId)
                .getResultList();
        em.close();
        return projets;
    }
}