package sn.esmt.rest;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import sn.esmt.model.User;
import sn.esmt.service.AuthService;
import sn.esmt.service.UserService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * REST Resource for User Management
 * Base path: /api/javaee/users
 */
@Path("/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {
    
    private UserService userService;
    private AuthService authService;
    
    public UserResource() {
        this.userService = new UserService();
        this.authService = new AuthService();
    }
    
    /**
     * Get all users
     * GET /api/javaee/users
     */
    @GET
    public Response getAllUsers() {
        try {
            List<User> users = userService.getAllUsers();
            return Response.ok(users).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get user by ID
     * GET /api/javaee/users/{id}
     */
    @GET
    @Path("/{id}")
    public Response getUserById(@PathParam("id") Long id) {
        try {
            User user = userService.getUserById(id);
            if (user == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "User not found");
                return Response.status(Response.Status.NOT_FOUND).entity(error).build();
            }
            return Response.ok(user).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Create a new user
     * POST /api/javaee/users
     */
    @POST
    public Response createUser(User user) {
        try {
            User createdUser = userService.createUser(user);
            return Response.status(Response.Status.CREATED).entity(createdUser).build();
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
     * Update a user
     * PUT /api/javaee/users/{id}
     */
    @PUT
    @Path("/{id}")
    public Response updateUser(@PathParam("id") Long id, User user) {
        try {
            user.setId(id);
            User updatedUser = userService.updateUser(user);
            return Response.ok(updatedUser).build();
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
     * Delete a user
     * DELETE /api/javaee/users/{id}
     */
    @DELETE
    @Path("/{id}")
    public Response deleteUser(@PathParam("id") Long id) {
        try {
            userService.deleteUser(id);
            Map<String, String> response = new HashMap<>();
            response.put("message", "User deleted successfully");
            return Response.ok(response).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Get users by role
     * GET /api/javaee/users/role/{roleLibelle}
     */
    @GET
    @Path("/role/{roleLibelle}")
    public Response getUsersByRole(@PathParam("roleLibelle") String roleLibelle) {
        try {
            List<User> users = userService.getUsersByRole(roleLibelle);
            return Response.ok(users).build();
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
}
