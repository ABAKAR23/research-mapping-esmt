package sn.esmt.cartographie.security;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import sn.esmt.cartographie.model.auth.Utilisateur;
import java.util.Optional;

public class AuthService {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("CartographiePU");

    /**
     * Simule une vérification de login
     * Dans un flux OAuth 2.0 réel, cette partie est gérée par le serveur d'autorisation
     */
    public Optional<Utilisateur> login(String email, String password) {
        EntityManager em = emf.createEntityManager();
        try {
            Utilisateur user = em.createQuery(
                            "SELECT u FROM Utilisateur u WHERE u.email = :email AND u.motDePasse = :password",
                            Utilisateur.class)
                    .setParameter("email", email)
                    .setParameter("password", password)
                    .getSingleResult();
            return Optional.of(user);
        } catch (Exception e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    /**
     * Vérifie si l'utilisateur a le rôle requis pour accéder à une fonctionnalité
     */
    public boolean hasRole(Utilisateur user, String roleName) {
        return user != null && user.getRole() != null &&
                user.getRole().getLibelle().equalsIgnoreCase(roleName);
    }
}