package sn.esmt.cartographie.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.model.projet.DomaineRecherche;
import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.model.projet.StatutProjet;
import sn.esmt.cartographie.repository.ProjetRepository;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class StatistiqueServiceTest {

    @Mock
    private ProjetRepository projetRepository;

    @InjectMocks
    private StatistiqueService statistiqueService;

    private List<Projet> testProjects;
    private DomaineRecherche domaineIA;
    private DomaineRecherche domaineSante;
    private Utilisateur utilisateur1;
    private Utilisateur utilisateur2;

    @BeforeEach
    void setUp() {
        // Setup domaines
        domaineIA = new DomaineRecherche();
        domaineIA.setId(1L);
        domaineIA.setNomDomaine("Intelligence Artificielle");

        domaineSante = new DomaineRecherche();
        domaineSante.setId(2L);
        domaineSante.setNomDomaine("Santé");

        // Setup utilisateurs
        utilisateur1 = new Utilisateur();
        utilisateur1.setId(1L);
        utilisateur1.setNom("John Doe");

        utilisateur2 = new Utilisateur();
        utilisateur2.setId(2L);
        utilisateur2.setNom("Jane Smith");

        // Setup projets
        Projet projet1 = new Projet();
        projet1.setBudget_estime(5000000.0);
        projet1.setNiveau_avancement(45);
        projet1.setStatut_projet(StatutProjet.EN_COURS);
        projet1.setDomaine_recherche(domaineIA);
        projet1.setListe_participants(Arrays.asList(utilisateur1, utilisateur2));

        Projet projet2 = new Projet();
        projet2.setBudget_estime(8000000.0);
        projet2.setNiveau_avancement(10);
        projet2.setStatut_projet(StatutProjet.TERMINE);
        projet2.setDomaine_recherche(domaineSante);
        projet2.setListe_participants(Arrays.asList(utilisateur1));

        Projet projet3 = new Projet();
        projet3.setBudget_estime(3000000.0);
        projet3.setNiveau_avancement(75);
        projet3.setStatut_projet(StatutProjet.EN_COURS);
        projet3.setDomaine_recherche(domaineIA);
        projet3.setListe_participants(Arrays.asList(utilisateur2));

        testProjects = Arrays.asList(projet1, projet2, projet3);
    }

    @Test
    void testCalculerBudgetTotal() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        Double budgetTotal = statistiqueService.calculerBudgetTotal();

        assertEquals(16000000.0, budgetTotal);
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testGetStatistics() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        var stats = statistiqueService.getStatistics();

        assertNotNull(stats);
        assertEquals(3L, stats.getTotalProjets());
        assertEquals(16000000.0, stats.getBudgetTotal());
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testCompterProjetsParStatut() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        Map<String, Long> projetsParStatut = statistiqueService.compterProjetsParStatut();

        assertNotNull(projetsParStatut);
        assertEquals(2L, projetsParStatut.get("EN_COURS"));
        assertEquals(1L, projetsParStatut.get("TERMINE"));
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testCompterProjetsParDomaine() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        Map<String, Long> projetsParDomaine = statistiqueService.compterProjetsParDomaine();

        assertNotNull(projetsParDomaine);
        assertEquals(2L, projetsParDomaine.get("Intelligence Artificielle"));
        assertEquals(1L, projetsParDomaine.get("Santé"));
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testCalculerBudgetParDomaine() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        Map<String, Double> budgetParDomaine = statistiqueService.calculerBudgetParDomaine();

        assertNotNull(budgetParDomaine);
        assertEquals(8000000.0, budgetParDomaine.get("Intelligence Artificielle"));
        assertEquals(8000000.0, budgetParDomaine.get("Santé"));
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testCompterProjetsParParticipant() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        Map<String, Long> projetsParParticipant = statistiqueService.compterProjetsParParticipant();

        assertNotNull(projetsParParticipant);
        assertEquals(2L, projetsParParticipant.get("John Doe"));
        assertEquals(2L, projetsParParticipant.get("Jane Smith"));
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testCalculerTauxMoyenAvancement() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        Double tauxMoyen = statistiqueService.calculerTauxMoyenAvancement();

        assertNotNull(tauxMoyen);
        // (45 + 10 + 75) / 3 = 43.33
        assertEquals(43.33, tauxMoyen, 0.01);
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testCompterTotalProjets() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        Long totalProjets = statistiqueService.compterTotalProjets();

        assertEquals(3L, totalProjets);
        verify(projetRepository, times(1)).findAll();
    }

    @Test
    void testGetAllStatistics() {
        when(projetRepository.findAll()).thenReturn(testProjects);

        var stats = statistiqueService.getAllStatistics();

        assertNotNull(stats);
        assertEquals(3L, stats.getTotalProjets());
        assertEquals(16000000.0, stats.getBudgetTotal());
        verify(projetRepository, times(1)).findAll();
    }
}
