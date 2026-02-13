package sn.esmt.cartographie.rest;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import sn.esmt.cartographie.dto.StatisticsDTO;
import sn.esmt.cartographie.service.StatistiqueService;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(StatisticsController.class)
class StatisticsControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private StatistiqueService statistiqueService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    @WithMockUser(roles = "ADMIN")
    void testGetAllStatistics() throws Exception {
        StatisticsDTO stats = new StatisticsDTO();
        stats.setTotalProjets(10L);
        stats.setBudgetTotal(50000000.0);

        when(statistiqueService.getStatistics()).thenReturn(stats);

        mockMvc.perform(get("/statistics")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalProjets").value(10))
                .andExpect(jsonPath("$.budgetTotal").value(50000000.0));

        verify(statistiqueService, times(1)).getStatistics();
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void testGetTotalBudget() throws Exception {
        when(statistiqueService.calculerBudgetTotal()).thenReturn(25000000.0);

        mockMvc.perform(get("/statistics/budget-total")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().string("2.5E7"));

        verify(statistiqueService, times(1)).calculerBudgetTotal();
    }
}
