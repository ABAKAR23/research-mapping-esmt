package sn.esmt.cartographie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import sn.esmt.cartographie.model.projet.DomaineRecherche;
import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.model.projet.StatutProjet;
import sn.esmt.cartographie.repository.DomaineRechercheRepository;
import sn.esmt.cartographie.repository.ProjetRepository;

import java.io.BufferedReader;
import java.io.FileReader;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

@Service
@Transactional
public class CsvImportService {

    @Autowired
    private ProjetRepository projetRepository;

    @Autowired
    private DomaineRechercheRepository domaineRepository;

    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    public void importProjectsFromCsv(String filePath) {
        String line;
        String cvsSplitBy = ",";
        Map<String, DomaineRecherche> domaineCache = new HashMap<>();

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
            throw new RuntimeException("Erreur lors de l'importation du CSV", e);
        }
    }
    
    public int importFromCsv(String csvContent) {
        int count = 0;
        String[] lines = csvContent.split("\n");
        
        for (int i = 1; i < lines.length; i++) { // Skip header
            String line = lines[i].trim();
            if (line.isEmpty()) continue;
            
            try {
                String[] data = line.split(",");
                Projet projet = new Projet();
                projet.setTitre_projet(data[0]);
                projet.setDescription(data[1]);
                projet.setDate_debut(dateFormat.parse(data[2]));
                projet.setDate_fin(dateFormat.parse(data[3]));
                projet.setStatut_projet(StatutProjet.valueOf(data[4].toUpperCase()));
                projet.setBudget_estime(Double.parseDouble(data[5]));
                projet.setInstitution(data[6]);
                projet.setNiveau_avancement(Integer.parseInt(data[7]));
                
                projetRepository.save(projet);
                count++;
            } catch (Exception e) {
                System.err.println("Erreur ligne " + i + ": " + e.getMessage());
            }
        }
        
        return count;
    }
}
