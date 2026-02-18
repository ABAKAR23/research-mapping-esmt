package sn.esmt.rest;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import sn.esmt.model.User;
import sn.esmt.service.AuthService;

import java.util.HashMap;
import java.util.Map;

/**
 * REST Resource for Authentication
 * Base path: /api/javaee/auth
 */
@Path("/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthResource {
    
    private AuthService authService;
    
    public AuthResource() {
        this.authService = new AuthService();
    }
    
    /**
     * Login endpoint
     * POST /api/javaee/auth/login
     * Request body: {"usernameOrEmail": "...", "password": "..."}
     */
    @POST
    @Path("/login")
    public Response login(Map<String, String> credentials) {
        try {
            String usernameOrEmail = credentials.get("usernameOrEmail");
            String password = credentials.get("password");
            
            if (usernameOrEmail == null || password == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Username/email and password are required");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
            
            User user = authService.login(usernameOrEmail, password);
            
            if (user == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Invalid credentials");
                return Response.status(Response.Status.UNAUTHORIZED).entity(error).build();
            }
            
            // Return user information (without password hash)
            Map<String, Object> response = new HashMap<>();
            response.put("id", user.getId());
            response.put("username", user.getUsername());
            response.put("email", user.getEmail());
            response.put("firstName", user.getFirstName());
            response.put("lastName", user.getLastName());
            if (user.getRole() != null) {
                response.put("role", user.getRole().getLibelle());
            }
            response.put("message", "Login successful");
            
            return Response.ok(response).build();
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
    
    /**
     * Register endpoint
     * POST /api/javaee/auth/register
     * Request body: User object with password field
     */
    @POST
    @Path("/register")
    public Response register(Map<String, Object> registrationData) {
        try {
            // Extract user data
            String username = (String) registrationData.get("username");
            String email = (String) registrationData.get("email");
            String password = (String) registrationData.get("password");
            String firstName = (String) registrationData.get("firstName");
            String lastName = (String) registrationData.get("lastName");
            
            if (username == null || email == null || password == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Username, email, and password are required");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
            
            // Create user object
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            
            // Register user
            User registeredUser = authService.register(user, password);
            
            // Return user information (without password hash)
            Map<String, Object> response = new HashMap<>();
            response.put("id", registeredUser.getId());
            response.put("username", registeredUser.getUsername());
            response.put("email", registeredUser.getEmail());
            response.put("firstName", registeredUser.getFirstName());
            response.put("lastName", registeredUser.getLastName());
            if (registeredUser.getRole() != null) {
                response.put("role", registeredUser.getRole().getLibelle());
            }
            response.put("message", "Registration successful");
            
            return Response.status(Response.Status.CREATED).entity(response).build();
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
     * Change password endpoint
     * POST /api/javaee/auth/change-password
     * Request body: {"userId": ..., "oldPassword": "...", "newPassword": "..."}
     */
    @POST
    @Path("/change-password")
    public Response changePassword(Map<String, Object> passwordData) {
        try {
            Object userIdObj = passwordData.get("userId");
            String oldPassword = (String) passwordData.get("oldPassword");
            String newPassword = (String) passwordData.get("newPassword");
            
            if (userIdObj == null || oldPassword == null || newPassword == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "userId, oldPassword, and newPassword are required");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
            
            Long userId;
            if (userIdObj instanceof Integer) {
                userId = ((Integer) userIdObj).longValue();
            } else if (userIdObj instanceof Long) {
                userId = (Long) userIdObj;
            } else {
                userId = Long.parseLong(userIdObj.toString());
            }
            
            boolean success = authService.changePassword(userId, oldPassword, newPassword);
            
            if (success) {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Password changed successfully");
                return Response.ok(response).build();
            } else {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Failed to change password. Check old password.");
                return Response.status(Response.Status.BAD_REQUEST).entity(error).build();
            }
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(error).build();
        }
    }
}
