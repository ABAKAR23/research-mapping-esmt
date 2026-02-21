package sn.esmt.cartographie.rest;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import sn.esmt.cartographie.config.TestSecurityConfig;
import sn.esmt.cartographie.dto.ProjetDTO;
import sn.esmt.cartographie.service.ProjetService;

import java.util.List;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ProjectController.class)
@Import(TestSecurityConfig.class)
class ProjectControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProjetService projetService;

    @Test
    @WithMockUser(roles = "ADMIN")
    void testGetAllProjects_admin_returns200() throws Exception {
        when(projetService.getAllProjets()).thenReturn(List.of());

        mockMvc.perform(get("/api/projects")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        verify(projetService).getAllProjets();
    }

    @Test
    @WithMockUser(roles = "GESTIONNAIRE")
    void testGetAllProjects_gestionnaire_returns200() throws Exception {
        when(projetService.getAllProjets()).thenReturn(List.of());

        mockMvc.perform(get("/api/projects")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        verify(projetService).getAllProjets();
    }

    @Test
    @WithMockUser(roles = "CANDIDAT")
    void testGetAllProjects_candidat_returns403() throws Exception {
        mockMvc.perform(get("/api/projects")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isForbidden());
    }

    @Test
    @WithMockUser(roles = "CANDIDAT")
    void testGetMesProjects_candidat_returns200() throws Exception {
        when(projetService.getMyProjects(anyString())).thenReturn(List.of(new ProjetDTO()));

        mockMvc.perform(get("/api/projects/mes-projets")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        verify(projetService).getMyProjects("user");
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void testGetMesProjects_admin_returns200() throws Exception {
        when(projetService.getMyProjects(anyString())).thenReturn(List.of());

        mockMvc.perform(get("/api/projects/mes-projets")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        verify(projetService).getMyProjects("user");
    }
}
