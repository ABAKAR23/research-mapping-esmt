package sn.esmt.service;

import sn.esmt.dao.RoleDAO;
import sn.esmt.dao.UserDAO;
import sn.esmt.model.Role;
import sn.esmt.model.User;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Optional;

public class AuthService {
    
    private UserDAO userDAO;
    private RoleDAO roleDAO;
    
    public AuthService() {
        this.userDAO = new UserDAO();
        this.roleDAO = new RoleDAO();
    }
    
    public AuthService(UserDAO userDAO, RoleDAO roleDAO) {
        this.userDAO = userDAO;
        this.roleDAO = roleDAO;
    }
    
    /**
     * Authenticate user with username/email and password
     * @param usernameOrEmail username or email
     * @param password plain text password
     * @return User if authentication successful, null otherwise
     */
    public User login(String usernameOrEmail, String password) {
        Optional<User> userOpt;
        
        // Try to find by username first
        userOpt = userDAO.findByUsername(usernameOrEmail);
        
        // If not found, try by email
        if (!userOpt.isPresent()) {
            userOpt = userDAO.findByEmail(usernameOrEmail);
        }
        
        // Verify user exists and password matches
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (verifyPassword(password, user.getPasswordHash())) {
                return user;
            }
        }
        
        return null;
    }
    
    /**
     * Register a new user
     * @param user User object with basic information
     * @param plainPassword plain text password
     * @return saved User object
     */
    public User register(User user, String plainPassword) {
        // Check if username or email already exists
        if (userDAO.existsByUsername(user.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }
        
        if (userDAO.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
        
        // Hash the password
        String hashedPassword = hashPassword(plainPassword);
        user.setPasswordHash(hashedPassword);
        
        // Set default role if not set (CANDIDAT)
        if (user.getRole() == null) {
            Optional<Role> candidatRole = roleDAO.findByLibelle("CANDIDAT");
            if (candidatRole.isPresent()) {
                user.setRole(candidatRole.get());
            }
        }
        
        // Set default active status
        if (user.getIsActive() == null) {
            user.setIsActive(true);
        }
        
        return userDAO.save(user);
    }
    
    /**
     * Hash a password using SHA-256 with salt
     * For production, consider using BCrypt instead
     * @param password plain text password
     * @return hashed password with salt
     */
    public String hashPassword(String password) {
        try {
            // Generate a random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);
            
            // Create SHA-256 hash
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes(StandardCharsets.UTF_8));
            
            // Combine salt and hash
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
            
            // Encode to Base64
            return Base64.getEncoder().encodeToString(combined);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Verify a password against a hash
     * @param password plain text password
     * @param storedHash stored hash with salt
     * @return true if password matches
     */
    public boolean verifyPassword(String password, String storedHash) {
        try {
            // Decode the stored hash
            byte[] combined = Base64.getDecoder().decode(storedHash);
            
            // Extract salt (first 16 bytes)
            byte[] salt = new byte[16];
            System.arraycopy(combined, 0, salt, 0, 16);
            
            // Extract hash (remaining bytes)
            byte[] storedPasswordHash = new byte[combined.length - 16];
            System.arraycopy(combined, 16, storedPasswordHash, 0, storedPasswordHash.length);
            
            // Hash the input password with the same salt
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] testHash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            
            // Compare the hashes
            return MessageDigest.isEqual(testHash, storedPasswordHash);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Change user password
     * @param userId user ID
     * @param oldPassword current password
     * @param newPassword new password
     * @return true if password changed successfully
     */
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        Optional<User> userOpt = userDAO.findById(userId);
        
        if (!userOpt.isPresent()) {
            return false;
        }
        
        User user = userOpt.get();
        
        // Verify old password
        if (!verifyPassword(oldPassword, user.getPasswordHash())) {
            return false;
        }
        
        // Hash and set new password
        String newHash = hashPassword(newPassword);
        user.setPasswordHash(newHash);
        
        userDAO.update(user);
        return true;
    }
    
    public void close() {
        userDAO.close();
        roleDAO.close();
    }
}
