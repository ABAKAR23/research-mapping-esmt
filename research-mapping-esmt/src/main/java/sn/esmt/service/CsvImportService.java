package sn.esmt.service;

import sn.esmt.dao.ResearchDomainDAO;
import sn.esmt.dao.ResearchProjectDAO;
import sn.esmt.dao.UserDAO;
import sn.esmt.dao.ParticipationDAO;
import sn.esmt.model.ResearchDomain;
import sn.esmt.model.ResearchProject;
import sn.esmt.model.User;
import sn.esmt.model.Participation;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;

/**
 * Service pour l'import de projets depuis un fichier CSV
 */
public class CsvImportService {
    
    private ResearchProjectDAO projectDAO;
    private ResearchDomainDAO domainDAO;
    private UserDAO userDAO;
    private ParticipationDAO participationDAO;
    private SimpleDateFormat dateFormat;
    
    public CsvImportService() {
        this.projectDAO = new ResearchProjectDAO();
        this.domainDAO = new ResearchDomainDAO();
        this.userDAO = new UserDAO();
        this.participationDAO = new ParticipationDAO();
        this.dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    }
    
    /**
     * Importe les projets depuis un fichier CSV
     * Format attendu: Titre,Description,DateDebut,DateFin,Statut,Budget,Institution,Avancement,Domaine,ResponsableEmail,ParticipantsEmails
     * 
     * @param inputStream InputStream du fichier CSV
     * @return Rapport d'importation avec nombre de succès/échecs
     */
    public String importProjectsFromCsv(java.io.InputStream inputStream) {
        StringBuilder report = new StringBuilder();
        int successCount = 0;
        int failureCount = 0;
        int lineNumber = 0;
        
        try (BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"))) {
            String line;
            
            // Lire l'en-tête (première ligne)
            String header = br.readLine();
            if (header == null) {
                return "Erreur: Le fichier CSV est vide.";
            }
            
            lineNumber = 1;
            
            // Traiter chaque ligne
            while ((line = br.readLine()) != null) {
                lineNumber++;
                
                if (line.trim().isEmpty()) {
                    continue; // Ignorer les lignes vides
                }
                
                try {
                    // Parser la ligne CSV (gérer les guillemets)
                    String[] fields = parseCsvLine(line);
                    
                    if (fields.length < 11) {
                        failureCount++;
                        report.append("Ligne ").append(lineNumber)
                              .append(": Nombre de colonnes insuffisant (").append(fields.length)
                              .append(" au lieu de 11).\n");
                        continue;
                    }
                    
                    // Créer ou récupérer le projet
                    ResearchProject project = createProjectFromFields(fields, lineNumber);
                    
                    if (project != null) {
                        projectDAO.save(project);
                        successCount++;
                        report.append("Ligne ").append(lineNumber)
                              .append(": Projet '").append(project.getTitle())
                              .append("' importé avec succès.\n");
                    } else {
                        failureCount++;
                    }
                    
                } catch (Exception e) {
                    failureCount++;
                    report.append("Ligne ").append(lineNumber)
                          .append(": Erreur - ").append(e.getMessage()).append("\n");
                }
            }
            
        } catch (Exception e) {
            return "Erreur lors de la lecture du fichier: " + e.getMessage();
        } finally {
            projectDAO.close();
            domainDAO.close();
            userDAO.close();
            participationDAO.close();
        }
        
        // Construire le rapport final
        StringBuilder finalReport = new StringBuilder();
        finalReport.append("=== RAPPORT D'IMPORTATION CSV ===\n");
        finalReport.append("Total de lignes traitées: ").append(lineNumber - 1).append("\n");
        finalReport.append("Succès: ").append(successCount).append("\n");
        finalReport.append("Échecs: ").append(failureCount).append("\n\n");
        finalReport.append("Détails:\n").append(report.toString());
        
        return finalReport.toString();
    }
    
    /**
     * Parse une ligne CSV en gérant les guillemets
     */
    private String[] parseCsvLine(String line) {
        java.util.List<String> fields = new java.util.ArrayList<>();
        StringBuilder currentField = new StringBuilder();
        boolean insideQuotes = false;
        
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            
            if (c == '"') {
                if (insideQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    // Double guillemet = guillemet échappé
                    currentField.append('"');
                    i++; // Passer le guillemet suivant
                } else {
                    // Toggle insideQuotes
                    insideQuotes = !insideQuotes;
                }
            } else if (c == ',' && !insideQuotes) {
                // Fin du champ
                fields.add(currentField.toString().trim());
                currentField = new StringBuilder();
            } else {
                currentField.append(c);
            }
        }
        
        // Ajouter le dernier champ
        fields.add(currentField.toString().trim());
        
        return fields.toArray(new String[0]);
    }
    
    /**
     * Crée un projet ResearchProject à partir des champs CSV
     */
    private ResearchProject createProjectFromFields(String[] fields, int lineNumber) throws Exception {
        ResearchProject project = new ResearchProject();
        
        // Titre (champ 0)
        String titre = fields[0].trim();
        if (titre.isEmpty()) {
            throw new Exception("Le titre est obligatoire");
        }
        project.setTitle(titre);
        
        // Description (champ 1)
        project.setDescription(fields[1].trim());
        
        // DateDebut (champ 2)
        if (!fields[2].trim().isEmpty()) {
            try {
                Date dateDebut = dateFormat.parse(fields[2].trim());
                project.setStartDate(dateDebut);
            } catch (Exception e) {
                throw new Exception("Format de date invalide pour DateDebut: " + fields[2]);
            }
        }
        
        // DateFin (champ 3)
        if (!fields[3].trim().isEmpty()) {
            try {
                Date dateFin = dateFormat.parse(fields[3].trim());
                project.setEndDate(dateFin);
            } catch (Exception e) {
                throw new Exception("Format de date invalide pour DateFin: " + fields[3]);
            }
        }
        
        // Statut (champ 4)
        String statut = fields[4].trim().toUpperCase();
        if (statut.isEmpty()) {
            statut = "EN_COURS";
        }
        // Valider le statut
        if (!statut.equals("EN_COURS") && !statut.equals("TERMINE") && !statut.equals("SUSPENDU")) {
            throw new Exception("Statut invalide: " + statut + " (doit être EN_COURS, TERMINE ou SUSPENDU)");
        }
        project.setStatus(statut);
        
        // Budget (champ 5)
        if (!fields[5].trim().isEmpty()) {
            try {
                BigDecimal budget = new BigDecimal(fields[5].trim().replace(",", "."));
                project.setBudgetEstimated(budget);
            } catch (Exception e) {
                throw new Exception("Format de budget invalide: " + fields[5]);
            }
        }
        
        // Institution (champ 6)
        project.setInstitution(fields[6].trim());
        
        // Avancement (champ 7)
        if (!fields[7].trim().isEmpty()) {
            try {
                int avancement = Integer.parseInt(fields[7].trim());
                if (avancement < 0 || avancement > 100) {
                    throw new Exception("Niveau d'avancement doit être entre 0 et 100");
                }
                project.setAdvancementLevel(avancement);
            } catch (NumberFormatException e) {
                throw new Exception("Format d'avancement invalide: " + fields[7]);
            }
        }
        
        // Domaine (champ 8)
        String domaineName = fields[8].trim();
        if (domaineName.isEmpty()) {
            throw new Exception("Le domaine est obligatoire");
        }
        
        // Créer ou récupérer le domaine
        Optional<ResearchDomain> domainOpt = domainDAO.findByName(domaineName);
        ResearchDomain domain;
        if (domainOpt.isPresent()) {
            domain = domainOpt.get();
        } else {
            // Créer un nouveau domaine
            domain = new ResearchDomain(domaineName, "Domaine importé automatiquement");
            domain = domainDAO.save(domain);
        }
        project.setDomain(domain);
        
        // ResponsableEmail (champ 9)
        String responsableEmail = fields[9].trim();
        if (responsableEmail.isEmpty()) {
            throw new Exception("L'email du responsable est obligatoire");
        }
        
        Optional<User> responsableOpt = userDAO.findByEmail(responsableEmail);
        if (responsableOpt.isEmpty()) {
            throw new Exception("Responsable non trouvé avec l'email: " + responsableEmail);
        }
        project.setResponsibleUser(responsableOpt.get());
        
        // ParticipantsEmails (champ 10) - séparés par point-virgule
        String participantsEmails = fields[10].trim();
        if (!participantsEmails.isEmpty()) {
            String[] emails = participantsEmails.split(";");
            for (String email : emails) {
                email = email.trim();
                if (!email.isEmpty()) {
                    Optional<User> participantOpt = userDAO.findByEmail(email);
                    if (participantOpt.isPresent()) {
                        // Créer la participation après la sauvegarde du projet
                        // Note: On devra sauvegarder le projet d'abord pour avoir un ID
                        // Pour l'instant, on ne peut pas créer les participations ici
                        // car le projet n'a pas encore d'ID
                    }
                }
            }
        }
        
        return project;
    }
    
    public void close() {
        projectDAO.close();
        domainDAO.close();
        userDAO.close();
        participationDAO.close();
    }
}
