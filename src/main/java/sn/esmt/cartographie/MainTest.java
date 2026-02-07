package sn.esmt.cartographie;

import sn.esmt.cartographie.repository.RoleRepository;
import sn.esmt.cartographie.service.CsvImportService;
import sn.esmt.cartographie.service.StatistiqueService;
import sn.esmt.cartographie.repository.ProjetRepository;

public class MainTest {
    public static void main(String[] args) {
        System.out.println("=== DEBUT DU TEST TECHNIQUE PCPR-ESMT ===");

        // 1. Initialisation des rôles
        System.out.println("1. Initialisation des rôles en base...");
        RoleRepository roleRepo = new RoleRepository();
        roleRepo.initRoles();

        // 2. Test de l'import CSV
        System.out.println("2. Importation des données depuis projets.csv...");
        CsvImportService csvService = new CsvImportService();
        // Assurez-vous que le fichier est à la racine du projet
        csvService.importProjectsFromCsv("projets.csv");

        // 3. Vérification des statistiques
        System.out.println("3. Vérification des calculs métiers...");
        StatistiqueService statService = new StatistiqueService();
        Double budgetTotal = statService.calculerBudgetTotal();

        System.out.println("-----------------------------------------");
        System.out.println("RESULTAT : Budget total des projets : " + budgetTotal + " FCFA");
        System.out.println("Nombre de projets importés : " + new ProjetRepository().findAll().size());
        System.out.println("-----------------------------------------");

        System.out.println("=== TEST TERMINE AVEC SUCCES ===");
        System.exit(0);
    }
}