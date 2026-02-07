package sn.esmt.cartographie.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import sn.esmt.cartographie.model.auth.Role;

public class RoleRepository {
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("CartographiePU");

    public void initRoles() {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();

        // On vérifie si les rôles existent déjà pour éviter les doublons
        Long count = em.createQuery("SELECT COUNT(r) FROM Role r", Long.class).getSingleResult();

        if (count == 0) {
            em.persist(new Role("ADMIN"));
            em.persist(new Role("GESTIONNAIRE"));
            em.persist(new Role("CANDIDAT"));
        }

        em.getTransaction().commit();
        em.close();
    }
}