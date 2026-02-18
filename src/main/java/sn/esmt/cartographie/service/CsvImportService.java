package sn.esmt.cartographie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.model.projet.DomaineRecherche;
import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.model.projet.StatutProjet;
import sn.esmt.cartographie.repository.DomaineRechercheRepository;
import sn.esmt.cartographie.repository.ProjetRepository;
import sn.esmt.cartographie.repository.UtilisateurRepository;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CsvImportService {

    @Autowired
    private ProjetRepository projetRepository;

    @Autowired
    private DomaineRechercheRepository domaineRepository;

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // Format standard ISO

    public String importProjectsFromCsv(MultipartFile file) {
        if (file.isEmpty()) {
            return "Le fichier est vide.";
        }

        int successCount = 0;
        int failureCount = 0;
        StringBuilder report = new StringBuilder();

        try (BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
            String line;
            // Lire l'en-tête et vérifier qu'il est correct (optionnel mais recommandé)
            // Attendu:
            // Titre,Description,DateDebut,DateFin,Statut,Budget,Institution,Avancement,Domaine,ResponsableEmail,ParticipantsEmails
            String header = br.readLine();

            int lineNumber = 1;
            while ((line = br.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty())
                    continue;

                try {
                    // Utiliser une regex pour splitter par virgule mais ignorer les virgules entre
                    // guillemets si nécessaire
                    // Pour simplifier ici: split simple, attention aux virgules dans les
                    // descriptions
                    String[] data = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1);

                    // Nettoyage des guillemets éventuels
                    for (int i = 0; i < data.length; i++) {
                        data[i] = data[i].trim().replaceAll("^\"|\"$", "");
                    }

                    if (data.length < 10) { // Au moins jusqu'au responsable
                        throw new IllegalArgumentException("Nombre de colonnes insuffisant (" + data.length + ")");
                    }

                    Projet projet = new Projet();
                    projet.setTitre_projet(data[0]);
                    projet.setDescription(data[1]);

                    try {
                        projet.setDate_debut(dateFormat.parse(data[2]));
                        projet.setDate_fin(dateFormat.parse(data[3]));
                    } catch (Exception e) {
                        throw new IllegalArgumentException("Format de date invalide (attendu: yyyy-MM-dd)");
                    }

                    try {
                        projet.setStatut_projet(StatutProjet.valueOf(data[4].toUpperCase()));
                    } catch (IllegalArgumentException e) {
                        projet.setStatut_projet(StatutProjet.EN_COURS); // Valeur par défaut
                    }

                    projet.setBudget_estime(Double.parseDouble(data[5].isEmpty() ? "0" : data[5]));
                    projet.setInstitution(data[6]);
                    projet.setNiveau_avancement(Integer.parseInt(data[7].isEmpty() ? "0" : data[7]));

                    // Domaine
                    String nomDomaine = data[8];
                    DomaineRecherche domaine = domaineRepository.findByNomDomaine(nomDomaine)
                            .orElseGet(() -> {
                                DomaineRecherche d = new DomaineRecherche();
                                d.setNomDomaine(nomDomaine);
                                d.setDescription("Domaine importé automatiquement");
                                return domaineRepository.save(d);
                            });
                    projet.setDomaine_recherche(domaine);

                    // Responsable
                    String emailResponsable = data[9];
                    Utilisateur responsable = utilisateurRepository.findByEmail(emailResponsable)
                            .orElseThrow(
                                    () -> new IllegalArgumentException("Responsable non trouvé: " + emailResponsable));
                    projet.setResponsable_projet(responsable);

                    // Participants
                    if (data.length > 10 && !data[10].isEmpty()) {
                        String[] emailsParticipants = data[10].split(";");
                        List<Utilisateur> participants = new ArrayList<>();
                        for (String email : emailsParticipants) {
                            utilisateurRepository.findByEmail(email.trim()).ifPresent(participants::add);
                        }
                        projet.setListe_participants(participants);
                    }

                    projetRepository.save(projet);
                    successCount++;

                } catch (Exception e) {
                    failureCount++;
                    report.append("Ligne ").append(lineNumber).append(": ").append(e.getMessage()).append("<br>");
                }
            }

            report.insert(0,
                    "Importation terminée. Succès: " + successCount + ", Échecs: " + failureCount + "<br><br>");

        } catch (Exception e) {
            return "Erreur globale lors de l'importation: " + e.getMessage();
        }

        return report.toString();
    }
}
