package sn.esmt.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;
import sn.esmt.model.ResearchDomain;
import sn.esmt.util.JPAUtil;

import java.util.List;
import java.util.Optional;

public class ResearchDomainDAO {
    
    private EntityManagerFactory emf;
    
    public ResearchDomainDAO() {
        emf = JPAUtil.getEntityManagerFactory();
    }
    
    public ResearchDomainDAO(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public ResearchDomain save(ResearchDomain domain) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (domain.getId() == null) {
                em.persist(domain);
            } else {
                domain = em.merge(domain);
            }
            em.getTransaction().commit();
            return domain;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving research domain", e);
        } finally {
            em.close();
        }
    }
    
    public Optional<ResearchDomain> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            ResearchDomain domain = em.find(ResearchDomain.class, id);
            return Optional.ofNullable(domain);
        } finally {
            em.close();
        }
    }
    
    public Optional<ResearchDomain> findByName(String name) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<ResearchDomain> query = em.createQuery(
                "SELECT d FROM ResearchDomain d WHERE d.name = :name", ResearchDomain.class);
            query.setParameter("name", name);
            List<ResearchDomain> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }
    
    public List<ResearchDomain> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<ResearchDomain> query = em.createQuery(
                "SELECT d FROM ResearchDomain d", ResearchDomain.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            ResearchDomain domain = em.find(ResearchDomain.class, id);
            if (domain != null) {
                em.remove(domain);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting research domain", e);
        } finally {
            em.close();
        }
    }
    
    public void close() {
        // EntityManagerFactory is now managed by JPAUtil - do not close here
    }
}
