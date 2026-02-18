package sn.esmt.cartographie.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import sn.esmt.cartographie.model.auth.Role;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.repository.RoleRepository;
import sn.esmt.cartographie.repository.UtilisateurRepository;

import java.util.Collections;
import java.util.Map;
import java.util.Optional;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        String email = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");

        Utilisateur utilisateur = utilisateurRepository.findByEmail(email)
                .orElseGet(() -> registerNewUser(email, name));

        return new DefaultOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority("ROLE_" + utilisateur.getRole().getLibelle())),
                oAuth2User.getAttributes(),
                "email"); // Use email as the name attribute
    }

    private Utilisateur registerNewUser(String email, String name) {
        if (email == null) {
            throw new IllegalArgumentException("Email cannot be null");
        }
        
        Utilisateur user = new Utilisateur();
        user.setEmail(email);
        user.setNom(name);
        user.setInstitution("ESMT"); // Default institution
        user.setMotDePasse(""); // No password for OAuth users

        // Assign role based on email or other criteria
        Role role;
        if (isAdminEmail(email)) {
            role = roleRepository.findByLibelle("ADMIN")
                    .orElseThrow(() -> new RuntimeException("Role ADMIN not found"));
        } else if (isManagerEmail(email)) {
            role = roleRepository.findByLibelle("GESTIONNAIRE")
                    .orElseThrow(() -> new RuntimeException("Role GESTIONNAIRE not found"));
        } else {
            // Default to CANDIDAT for external users
            role = roleRepository.findByLibelle("CANDIDAT")
                    .orElseThrow(() -> new RuntimeException("Role CANDIDAT not found"));
        }
        
        user.setRole(role);
        return utilisateurRepository.save(user);
    }

    // Helper methods to determine role based on email
    // TODO: Consider moving admin/manager emails to application.properties for better security and configuration management
    private boolean isAdminEmail(String email) {
        // Admin emails: admin@esmt.sn or configured admin emails
        return email.equals("admin@esmt.sn") || 
               email.equals("saleyokor@gmail.com"); // Example: add specific admin email
    }

    private boolean isManagerEmail(String email) {
        // Manager emails: manager@esmt.sn or emails from specific domain
        return email.equals("manager@esmt.sn") || 
               email.endsWith("@esmt-manager.sn");
    }
}
