package sn.esmt.cartographie.rest;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.security.test.context.support.WithAnonymousUser;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import sn.esmt.cartographie.config.TestSecurityConfig;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(PageController.class)
@Import(TestSecurityConfig.class)
class PageControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @WithAnonymousUser
    void testLoginPageWithAnonymousUser() throws Exception {
        // Anonymous user should be able to access login page
        mockMvc.perform(get("/login"))
                .andExpect(status().isOk())
                .andExpect(view().name("login"));
    }

    @Test
    @WithMockUser(username = "test@example.com")
    void testLoginPageWithAuthenticatedUser() throws Exception {
        // Authenticated user should be able to access login page (no automatic
        // redirect)
        mockMvc.perform(get("/login"))
                .andExpect(status().isOk())
                .andExpect(view().name("login"));
    }

    @Test
    @WithAnonymousUser
    void testIndexPageWithAnonymousUser() throws Exception {
        // Anonymous user should see login page directly (no redirect)
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(view().name("login"));
    }

    @Test
    @WithMockUser(username = "test@example.com")
    void testIndexPageWithAuthenticatedUser() throws Exception {
        // Page d'accueil affiche toujours la page login
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(view().name("login"));
    }

    @Test
    @WithAnonymousUser
    void testDashboardPageWithAnonymousUser() throws Exception {
        // Anonymous user should be redirected to login
        mockMvc.perform(get("/dashboard"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/login"));
    }

    @Test
    @WithMockUser(username = "test@example.com", roles = "ADMIN")
    void testDashboardPageWithAuthenticatedUser() throws Exception {
        // Authenticated user should be able to access dashboard
        mockMvc.perform(get("/dashboard"))
                .andExpect(status().isOk())
                .andExpect(view().name("dashboard"));
    }

    @Test
    @WithAnonymousUser
    void testCandidatPageWithAnonymousUser() throws Exception {
        // Anonymous user should be redirected to login
        mockMvc.perform(get("/candidat"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/login"));
    }

    @Test
    @WithMockUser(username = "candidat@example.com", roles = "CANDIDAT")
    void testCandidatPageWithAuthenticatedCandidat() throws Exception {
        // Authenticated candidat should be able to access candidat page
        mockMvc.perform(get("/candidat"))
                .andExpect(status().isOk())
                .andExpect(view().name("dashboard-candidat"));
    }
}
