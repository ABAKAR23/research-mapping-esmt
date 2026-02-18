package sn.esmt.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;
import sn.esmt.model.Participation;
import sn.esmt.util.JPAUtil;

import java.util.List;
import java.util.Optional;

public class ParticipationDAO {
    
    private EntityManagerFactory emf;
    
    public ParticipationDAO() {
        emf = JPAUtil.getEntityManagerFactory();
    }
    
    public ParticipationDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public Participation save(Participation participation) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (participation.getId() == null) {
                em.persist(participation);
            } else {
                participation = em.merge(participation);
            }
            em.getTransaction().commit();
            return participation;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving participation", e);
        } finally {
            em.close();
        }
    }
    
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Participation participation = em.find(Participation.class, id);
            if (participation != null) {
                em.remove(participation);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting participation", e);
        } finally {
            em.close();
        }
    }
    
    public Optional<Participation> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            Participation participation = em.find(Participation.class, id);
            return Optional.ofNullable(participation);
        } finally {
            em.close();
        }
    }
    
    public List<Participation> findByProject(Long projectId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Participation> query = em.createQuery(
                "SELECT p FROM Participation p WHERE p.project.id = :projectId", 
                Participation.class);
            query.setParameter("projectId", projectId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Participation> findByUser(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Participation> query = em.createQuery(
                "SELECT p FROM Participation p WHERE p.user.id = :userId", 
                Participation.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Participation> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Participation> query = em.createQuery(
                "SELECT p FROM Participation p", Participation.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public void close() {
        // EntityManagerFactory is now managed by JPAUtil - do not close here
    }
}
