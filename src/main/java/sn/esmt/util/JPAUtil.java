package sn.esmt.util;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Singleton utility class to manage EntityManagerFactory
 * This ensures only one EMF instance is created and reused across the application
 */
public class JPAUtil {
    
    private static final String PERSISTENCE_UNIT_NAME = "research-pu";
    private static EntityManagerFactory entityManagerFactory;
    
    // Private constructor to prevent instantiation
    private JPAUtil() {
    }
    
    /**
     * Get the singleton EntityManagerFactory instance
     * @return EntityManagerFactory instance
     */
    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (entityManagerFactory == null || !entityManagerFactory.isOpen()) {
            entityManagerFactory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        }
        return entityManagerFactory;
    }
    
    /**
     * Close the EntityManagerFactory
     * This should be called when the application shuts down
     */
    public static synchronized void closeEntityManagerFactory() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
            entityManagerFactory = null;
        }
    }
}
