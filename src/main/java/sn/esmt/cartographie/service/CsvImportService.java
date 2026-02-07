package sn.esmt.cartographie.service;

import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.model.projet.StatutProjet;
import sn.esmt.cartographie.repository.ProjetRepository;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;

public class CsvImportService {

    private ProjetRepository projetRepository = new ProjetRepository();
    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    public void importProjectsFromCsv(String filePath) {
        String line;
        String cvsSplitBy = ","; // ou ";" selon votre fichier

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            // Sauter la première ligne (entête)
            br.readLine();

            while ((line = br.readLine()) != null) {
                String[] data = line.split(cvsSplitBy);

                Projet projet = new Projet();
                projet.setTitre_projet(data[0]);
                projet.setDescription(data[1]);
                projet.setDate_debut(dateFormat.parse(data[2]));
                projet.setDate_fin(dateFormat.parse(data[3]));
                projet.setStatut_projet(StatutProjet.valueOf(data[4].toUpperCase()));
                projet.setBudget_estime(Double.parseDouble(data[5]));
                projet.setInstitution(data[6]);
                projet.setNiveau_avancement(Integer.parseInt(data[7]));

                // Sauvegarde en base via le repository
                projetRepository.save(projet);
            }
            System.out.println("Importation réussie !");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Erreur lors de l'importation : " + e.getMessage());
        }
    }
}