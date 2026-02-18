package sn.esmt.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;
import sn.esmt.model.Role;
import sn.esmt.util.JPAUtil;

import java.util.List;
import java.util.Optional;

public class RoleDAO {
    
    private EntityManagerFactory emf;
    
    public RoleDAO() {
        emf = JPAUtil.getEntityManagerFactory();
    }
    
    public RoleDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public Role save(Role role) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (role.getId() == null) {
                em.persist(role);
            } else {
                role = em.merge(role);
            }
            em.getTransaction().commit();
            return role;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving role", e);
        } finally {
            em.close();
        }
    }
    
    public Optional<Role> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            Role role = em.find(Role.class, id);
            return Optional.ofNullable(role);
        } finally {
            em.close();
        }
    }
    
    public Optional<Role> findByLibelle(String libelle) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Role> query = em.createQuery(
                "SELECT r FROM Role r WHERE r.libelle = :libelle", Role.class);
            query.setParameter("libelle", libelle);
            List<Role> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }
    
    public List<Role> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Role> query = em.createQuery("SELECT r FROM Role r", Role.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public void close() {
        // EntityManagerFactory is now managed by JPAUtil - do not close here
    }
}
