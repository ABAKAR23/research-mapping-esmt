package sn.esmt.cartographie.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.repository.ProjetRepository;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class StatistiqueServiceTest {

    @Mock
    private ProjetRepository projetRepository;

    @InjectMocks
    private StatistiqueService statistiqueService;

    private List<Projet> testProjects;

    @BeforeEach
    void setUp() {
        Projet projet1 = new Projet();
        projet1.setBudget_estime(5000000.0);
        projet1.setNiveau_avancement(45);

        Projet projet2 = new Projet();
        projet2.setBudget_estime(8000000.0);
        projet2.setNiveau_avancement(10);

        testProjects = Arrays.asList(projet1, projet2);
    }

    @Test
    void testCalculerBudgetTotal() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        Double budgetTotal = statistiqueService.calculerBudgetTotal();

        assertEquals(13000000.0, budgetTotal);
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testGetStatistics() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        var stats = statistiqueService.getStatistics();

        assertNotNull(stats);
        assertEquals(2L, stats.getTotalProjets());
        assertEquals(13000000.0, stats.getBudgetTotal());
        verify(projetRepository, times(1)).findAll();
    }
}
