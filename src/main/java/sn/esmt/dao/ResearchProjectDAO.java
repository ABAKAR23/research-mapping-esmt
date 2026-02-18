package sn.esmt.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import sn.esmt.model.ResearchProject;

import java.util.List;
import java.util.Optional;

public class ResearchProjectDAO {
    
    private static final String PERSISTENCE_UNIT_NAME = "research-pu";
    private EntityManagerFactory emf;
    
    public ResearchProjectDAO() {
        emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
    }
    
    public ResearchProjectDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public ResearchProject save(ResearchProject project) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (project.getId() == null) {
                em.persist(project);
            } else {
                project = em.merge(project);
            }
            em.getTransaction().commit();
            return project;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving research project", e);
        } finally {
            em.close();
        }
    }
    
    public ResearchProject update(ResearchProject project) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            project = em.merge(project);
            em.getTransaction().commit();
            return project;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating research project", e);
        } finally {
            em.close();
        }
    }
    
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            ResearchProject project = em.find(ResearchProject.class, id);
            if (project != null) {
                em.remove(project);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting research project", e);
        } finally {
            em.close();
        }
    }
    
    public Optional<ResearchProject> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            ResearchProject project = em.find(ResearchProject.class, id);
            return Optional.ofNullable(project);
        } finally {
            em.close();
        }
    }
    
    public List<ResearchProject> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<ResearchProject> query = em.createQuery(
                "SELECT p FROM ResearchProject p", ResearchProject.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<ResearchProject> findByUser(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<ResearchProject> query = em.createQuery(
                "SELECT p FROM ResearchProject p WHERE p.responsibleUser.id = :userId " +
                "OR EXISTS (SELECT pt FROM Participation pt WHERE pt.project.id = p.id AND pt.user.id = :userId)", 
                ResearchProject.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<ResearchProject> findByResponsibleUser(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<ResearchProject> query = em.createQuery(
                "SELECT p FROM ResearchProject p WHERE p.responsibleUser.id = :userId", 
                ResearchProject.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<ResearchProject> findByDomain(Long domainId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<ResearchProject> query = em.createQuery(
                "SELECT p FROM ResearchProject p WHERE p.domain.id = :domainId", 
                ResearchProject.class);
            query.setParameter("domainId", domainId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<ResearchProject> findByStatus(String status) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<ResearchProject> query = em.createQuery(
                "SELECT p FROM ResearchProject p WHERE p.status = :status", 
                ResearchProject.class);
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public Long countAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(p) FROM ResearchProject p", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
