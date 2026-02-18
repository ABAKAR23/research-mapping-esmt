package sn.esmt.service;

import sn.esmt.dao.RoleDAO;
import sn.esmt.dao.UserDAO;
import sn.esmt.model.Role;
import sn.esmt.model.User;

import java.util.List;
import java.util.Optional;

public class UserService {
    
    private UserDAO userDAO;
    private RoleDAO roleDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
        this.roleDAO = new RoleDAO();
    }
    
    public UserService(UserDAO userDAO, RoleDAO roleDAO) {
        this.userDAO = userDAO;
        this.roleDAO = roleDAO;
    }
    
    /**
     * Get all users
     * @return list of all users
     */
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }
    
    /**
     * Get user by ID
     * @param id user ID
     * @return User or null if not found
     */
    public User getUserById(Long id) {
        Optional<User> userOpt = userDAO.findById(id);
        return userOpt.orElse(null);
    }
    
    /**
     * Get user by email
     * @param email user email
     * @return User or null if not found
     */
    public User getUserByEmail(String email) {
        Optional<User> userOpt = userDAO.findByEmail(email);
        return userOpt.orElse(null);
    }
    
    /**
     * Get user by username
     * @param username username
     * @return User or null if not found
     */
    public User getUserByUsername(String username) {
        Optional<User> userOpt = userDAO.findByUsername(username);
        return userOpt.orElse(null);
    }
    
    /**
     * Create a new user
     * @param user User object
     * @return saved User
     */
    public User createUser(User user) {
        // Validate unique constraints
        if (userDAO.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
        
        if (userDAO.existsByUsername(user.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }
        
        return userDAO.save(user);
    }
    
    /**
     * Update an existing user
     * @param user User object with updated information
     * @return updated User
     */
    public User updateUser(User user) {
        // Verify user exists
        Optional<User> existingUser = userDAO.findById(user.getId());
        if (!existingUser.isPresent()) {
            throw new IllegalArgumentException("User not found");
        }
        
        return userDAO.update(user);
    }
    
    /**
     * Delete a user
     * @param id user ID
     */
    public void deleteUser(Long id) {
        userDAO.delete(id);
    }
    
    /**
     * Get users by role
     * @param roleLibelle role name (e.g., "ADMIN", "GESTIONNAIRE", "CANDIDAT")
     * @return list of users with the specified role
     */
    public List<User> getUsersByRole(String roleLibelle) {
        Optional<Role> roleOpt = roleDAO.findByLibelle(roleLibelle);
        if (!roleOpt.isPresent()) {
            throw new IllegalArgumentException("Role not found: " + roleLibelle);
        }
        
        return userDAO.findByRole(roleOpt.get().getId());
    }
    
    /**
     * Activate or deactivate a user
     * @param userId user ID
     * @param active true to activate, false to deactivate
     */
    public void setUserActive(Long userId, boolean active) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (!userOpt.isPresent()) {
            throw new IllegalArgumentException("User not found");
        }
        
        User user = userOpt.get();
        user.setIsActive(active);
        userDAO.update(user);
    }
    
    /**
     * Assign a role to a user
     * @param userId user ID
     * @param roleLibelle role name
     */
    public void assignRole(Long userId, String roleLibelle) {
        Optional<User> userOpt = userDAO.findById(userId);
        if (!userOpt.isPresent()) {
            throw new IllegalArgumentException("User not found");
        }
        
        Optional<Role> roleOpt = roleDAO.findByLibelle(roleLibelle);
        if (!roleOpt.isPresent()) {
            throw new IllegalArgumentException("Role not found: " + roleLibelle);
        }
        
        User user = userOpt.get();
        user.setRole(roleOpt.get());
        userDAO.update(user);
    }
    
    public void close() {
        userDAO.close();
        roleDAO.close();
    }
}
