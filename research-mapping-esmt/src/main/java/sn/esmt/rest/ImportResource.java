package sn.esmt.rest;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;
import sn.esmt.service.CsvImportService;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

/**
 * REST Resource pour l'import de projets depuis un fichier CSV
 * Base path: /api/javaee/import
 */
@Path("/import")
@Produces(MediaType.APPLICATION_JSON)
public class ImportResource {
    
    /**
     * Importe des projets depuis un fichier CSV
     * POST /api/javaee/import/csv
     * 
     * Format CSV attendu:
     * Titre,Description,DateDebut,DateFin,Statut,Budget,Institution,Avancement,Domaine,ResponsableEmail,ParticipantsEmails
     */
    @POST
    @Path("/csv")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response importCsv(
            @FormDataParam("file") InputStream fileInputStream,
            @FormDataParam("file") FormDataContentDisposition fileDetail) {
        
        try {
            if (fileInputStream == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Aucun fichier fourni");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
            
            // Vérifier l'extension du fichier
            String fileName = fileDetail.getFileName();
            if (fileName == null || !fileName.toLowerCase().endsWith(".csv")) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Le fichier doit être au format CSV (.csv)");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
            
            // Importer les projets
            CsvImportService importService = new CsvImportService();
            String report = importService.importProjectsFromCsv(fileInputStream);
            importService.close();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Importation terminée");
            response.put("report", report);
            
            return Response.ok(response).build();
            
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de l'importation: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Endpoint pour obtenir des informations sur le format CSV attendu
     * GET /api/javaee/import/format
     */
    @GET
    @Path("/format")
    public Response getCsvFormat() {
        Map<String, Object> format = new HashMap<>();
        format.put("description", "Format CSV pour l'importation de projets");
        format.put("columns", new String[]{
            "Titre",
            "Description",
            "DateDebut (yyyy-MM-dd)",
            "DateFin (yyyy-MM-dd)",
            "Statut (EN_COURS, TERMINE, SUSPENDU)",
            "Budget (nombre)",
            "Institution",
            "Avancement (0-100)",
            "Domaine",
            "ResponsableEmail",
            "ParticipantsEmails (séparés par ;)"
        });
        format.put("example", "Projet IA,Description du projet,2024-01-01,2024-12-31,EN_COURS,500000,ESMT,50,Intelligence Artificielle,admin@esmt.sn,user1@esmt.sn;user2@esmt.sn");
        format.put("encoding", "UTF-8");
        format.put("separator", ",");
        
        return Response.ok(format).build();
    }
}
