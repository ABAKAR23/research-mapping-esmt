package sn.esmt.rest;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import sn.esmt.model.ResearchProject;
import sn.esmt.service.ProjectService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST Resource for Research Project Management
 * Base path: /api/javaee/projects
 */
@Path("/projects")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ProjectResource {
    
    private ProjectService projectService;
    
    public ProjectResource() {
        this.projectService = new ProjectService();
    }
    
    /**
     * Get all projects
     * GET /api/javaee/projects
     */
    @GET
    public Response getAllProjects() {
        try {
            List<ResearchProject> projects = projectService.getAllProjects();
            return Response.ok(projects).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get project by ID
     * GET /api/javaee/projects/{id}
     */
    @GET
    @Path("/{id}")
    public Response getProjectById(@PathParam("id") Long id) {
        try {
            ResearchProject project = projectService.getProjectById(id);
            if (project == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Project not found");
                return Response.status(Response.Status.NOT_FOUND).entity(error).build();
            }
            return Response.ok(project).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get projects by user
     * GET /api/javaee/projects/user/{userId}
     */
    @GET
    @Path("/user/{userId}")
    public Response getProjectsByUser(@PathParam("userId") Long userId) {
        try {
            List<ResearchProject> projects = projectService.getProjectsByUser(userId);
            return Response.ok(projects).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get projects by domain
     * GET /api/javaee/projects/domain/{domainId}
     */
    @GET
    @Path("/domain/{domainId}")
    public Response getProjectsByDomain(@PathParam("domainId") Long domainId) {
        try {
            List<ResearchProject> projects = projectService.getProjectsByDomain(domainId);
            return Response.ok(projects).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get projects by status
     * GET /api/javaee/projects/status/{status}
     */
    @GET
    @Path("/status/{status}")
    public Response getProjectsByStatus(@PathParam("status") String status) {
        try {
            List<ResearchProject> projects = projectService.getProjectsByStatus(status);
            return Response.ok(projects).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Create a new project
     * POST /api/javaee/projects?userId={userId}
     */
    @POST
    public Response createProject(ResearchProject project, @QueryParam("userId") Long userId) {
        try {
            if (userId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "userId query parameter is required");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
            ResearchProject createdProject = projectService.createProject(project, userId);
            return Response.status(Response.Status.CREATED).entity(createdProject).build();
        } catch (IllegalArgumentException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Update a project
     * PUT /api/javaee/projects/{id}?userId={userId}
     */
    @PUT
    @Path("/{id}")
    public Response updateProject(@PathParam("id") Long id, ResearchProject project, 
                                  @QueryParam("userId") Long userId) {
        try {
            if (userId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "userId query parameter is required");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
            project.setId(id);
            ResearchProject updatedProject = projectService.updateProject(project, userId);
            return Response.ok(updatedProject).build();
        } catch (IllegalArgumentException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
        } catch (SecurityException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.FORBIDDEN).entity(error).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Delete a project
     * DELETE /api/javaee/projects/{id}?userId={userId}
     */
    @DELETE
    @Path("/{id}")
    public Response deleteProject(@PathParam("id") Long id, @QueryParam("userId") Long userId) {
        try {
            if (userId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "userId query parameter is required");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
            projectService.deleteProject(id, userId);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Project deleted successfully");
            return Response.ok(response).build();
        } catch (IllegalArgumentException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
        } catch (SecurityException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.FORBIDDEN).entity(error).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
}
