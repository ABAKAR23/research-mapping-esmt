package sn.esmt.rest;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import sn.esmt.service.StatisticsService;

import java.util.HashMap;
import java.util.Map;

/**
 * REST Resource for Statistics
 * Base path: /api/javaee/statistics
 */
@Path("/statistics")
@Produces(MediaType.APPLICATION_JSON)
public class StatisticsResource {
    
    private StatisticsService statisticsService;
    
    public StatisticsResource() {
        this.statisticsService = new StatisticsService();
    }
    
    /**
     * Get all statistics
     * GET /api/javaee/statistics
     */
    @GET
    public Response getAllStatistics() {
        try {
            Map<String, Object> stats = statisticsService.getAllStatistics();
            return Response.ok(stats).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get total number of projects
     * GET /api/javaee/statistics/total
     */
    @GET
    @Path("/total")
    public Response getTotalProjects() {
        try {
            Long total = statisticsService.getTotalProjects();
            Map<String, Long> response = new HashMap<>();
            response.put("total", total);
            return Response.ok(response).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get projects by domain
     * GET /api/javaee/statistics/by-domain
     */
    @GET
    @Path("/by-domain")
    public Response getProjectsByDomain() {
        try {
            Map<String, Long> stats = statisticsService.getProjectsByDomain();
            return Response.ok(stats).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get projects by status
     * GET /api/javaee/statistics/by-status
     */
    @GET
    @Path("/by-status")
    public Response getProjectsByStatus() {
        try {
            Map<String, Long> stats = statisticsService.getProjectsByStatus();
            return Response.ok(stats).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get total budget
     * GET /api/javaee/statistics/total-budget
     */
    @GET
    @Path("/total-budget")
    public Response getTotalBudget() {
        try {
            Map<String, Object> response = new HashMap<>();
            response.put("totalBudget", statisticsService.getTotalBudget());
            return Response.ok(response).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get average advancement
     * GET /api/javaee/statistics/average-advancement
     */
    @GET
    @Path("/average-advancement")
    public Response getAverageAdvancement() {
        try {
            Map<String, Object> response = new HashMap<>();
            response.put("averageAdvancement", statisticsService.getAverageAdvancement());
            return Response.ok(response).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get budget by domain
     * GET /api/javaee/statistics/budget-by-domain
     */
    @GET
    @Path("/budget-by-domain")
    public Response getBudgetByDomain() {
        try {
            Map<String, java.math.BigDecimal> budgetMap = statisticsService.getBudgetByDomain();
            // Convertir Map<String, BigDecimal> en Map<String, Object> pour la sérialisation JSON
            Map<String, Object> stats = new HashMap<>();
            for (Map.Entry<String, java.math.BigDecimal> entry : budgetMap.entrySet()) {
                stats.put(entry.getKey(), entry.getValue());
            }
            return Response.ok(stats).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get projects by participant
     * GET /api/javaee/statistics/by-participant
     */
    @GET
    @Path("/by-participant")
    public Response getProjectsByParticipant() {
        try {
            Map<String, Long> stats = statisticsService.getProjectsByParticipant();
            return Response.ok(stats).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
}
