package sn.esmt.cartographie.security;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import sn.esmt.cartographie.model.auth.Role;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.repository.RoleRepository;
import sn.esmt.cartographie.repository.UtilisateurRepository;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CustomOAuth2UserServiceTest {

    @Mock
    private UtilisateurRepository utilisateurRepository;

    @Mock
    private RoleRepository roleRepository;

    @InjectMocks
    private CustomOAuth2UserService customOAuth2UserService;

    private Role adminRole;
    private Role gestionnaireRole;
    private Role candidatRole;

    @BeforeEach
    void setUp() {
        adminRole = new Role();
        adminRole.setId(1L);
        adminRole.setLibelle("ADMIN");

        gestionnaireRole = new Role();
        gestionnaireRole.setId(2L);
        gestionnaireRole.setLibelle("GESTIONNAIRE");

        candidatRole = new Role();
        candidatRole.setId(3L);
        candidatRole.setLibelle("CANDIDAT");
    }

    @Test
    void testRegisterNewUser_AdminEmail() {
        // Given
        String adminEmail = "admin@esmt.sn";
        String name = "Admin User";

        when(roleRepository.findByLibelle("ADMIN")).thenReturn(Optional.of(adminRole));
        when(utilisateurRepository.save(any(Utilisateur.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Utilisateur result = invokeRegisterNewUser(adminEmail, name);

        // Then
        assertNotNull(result);
        assertEquals(adminEmail, result.getEmail());
        assertEquals(name, result.getNom());
        assertEquals("ADMIN", result.getRole().getLibelle());
        verify(roleRepository).findByLibelle("ADMIN");
        verify(utilisateurRepository).save(any(Utilisateur.class));
    }

    @Test
    void testRegisterNewUser_SpecificAdminEmail() {
        // Given
        String adminEmail = "saleyokor@gmail.com";
        String name = "Saley Okor";

        when(roleRepository.findByLibelle("ADMIN")).thenReturn(Optional.of(adminRole));
        when(utilisateurRepository.save(any(Utilisateur.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Utilisateur result = invokeRegisterNewUser(adminEmail, name);

        // Then
        assertNotNull(result);
        assertEquals(adminEmail, result.getEmail());
        assertEquals("ADMIN", result.getRole().getLibelle());
    }

    @Test
    void testRegisterNewUser_ManagerEmail() {
        // Given
        String managerEmail = "manager@esmt.sn";
        String name = "Manager User";

        when(roleRepository.findByLibelle("GESTIONNAIRE")).thenReturn(Optional.of(gestionnaireRole));
        when(utilisateurRepository.save(any(Utilisateur.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Utilisateur result = invokeRegisterNewUser(managerEmail, name);

        // Then
        assertNotNull(result);
        assertEquals(managerEmail, result.getEmail());
        assertEquals("GESTIONNAIRE", result.getRole().getLibelle());
        verify(roleRepository).findByLibelle("GESTIONNAIRE");
    }

    @Test
    void testRegisterNewUser_ManagerDomainEmail() {
        // Given
        String managerEmail = "user@esmt-manager.sn";
        String name = "Manager Domain User";

        when(roleRepository.findByLibelle("GESTIONNAIRE")).thenReturn(Optional.of(gestionnaireRole));
        when(utilisateurRepository.save(any(Utilisateur.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Utilisateur result = invokeRegisterNewUser(managerEmail, name);

        // Then
        assertNotNull(result);
        assertEquals(managerEmail, result.getEmail());
        assertEquals("GESTIONNAIRE", result.getRole().getLibelle());
    }

    @Test
    void testRegisterNewUser_CandidatEmail() {
        // Given
        String candidatEmail = "candidat@gmail.com";
        String name = "Candidat User";

        when(roleRepository.findByLibelle("CANDIDAT")).thenReturn(Optional.of(candidatRole));
        when(utilisateurRepository.save(any(Utilisateur.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Utilisateur result = invokeRegisterNewUser(candidatEmail, name);

        // Then
        assertNotNull(result);
        assertEquals(candidatEmail, result.getEmail());
        assertEquals("CANDIDAT", result.getRole().getLibelle());
        verify(roleRepository).findByLibelle("CANDIDAT");
    }

    @Test
    void testRegisterNewUser_DefaultsToCandidatForUnknownEmail() {
        // Given
        String unknownEmail = "unknown@example.com";
        String name = "Unknown User";

        when(roleRepository.findByLibelle("CANDIDAT")).thenReturn(Optional.of(candidatRole));
        when(utilisateurRepository.save(any(Utilisateur.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Utilisateur result = invokeRegisterNewUser(unknownEmail, name);

        // Then
        assertNotNull(result);
        assertEquals(unknownEmail, result.getEmail());
        assertEquals("CANDIDAT", result.getRole().getLibelle());
    }

    // Helper method to invoke the private registerNewUser method using reflection
    private Utilisateur invokeRegisterNewUser(String email, String name) {
        try {
            java.lang.reflect.Method method = CustomOAuth2UserService.class.getDeclaredMethod("registerNewUser", String.class, String.class);
            method.setAccessible(true);
            return (Utilisateur) method.invoke(customOAuth2UserService, email, name);
        } catch (Exception e) {
            throw new RuntimeException("Failed to invoke registerNewUser", e);
        }
    }
}
