package sn.esmt.service;

import sn.esmt.dao.ParticipationDAO;
import sn.esmt.dao.ResearchDomainDAO;
import sn.esmt.dao.ResearchProjectDAO;
import sn.esmt.dao.UserDAO;
import sn.esmt.model.Participation;
import sn.esmt.model.ResearchDomain;
import sn.esmt.model.ResearchProject;
import sn.esmt.model.User;

import java.util.List;
import java.util.Optional;

public class ProjectService {
    
    private ResearchProjectDAO projectDAO;
    private UserDAO userDAO;
    private ResearchDomainDAO domainDAO;
    private ParticipationDAO participationDAO;
    
    public ProjectService() {
        this.projectDAO = new ResearchProjectDAO();
        this.userDAO = new UserDAO();
        this.domainDAO = new ResearchDomainDAO();
        this.participationDAO = new ParticipationDAO();
    }
    
    public ProjectService(ResearchProjectDAO projectDAO, UserDAO userDAO, 
                         ResearchDomainDAO domainDAO, ParticipationDAO participationDAO) {
        this.projectDAO = projectDAO;
        this.userDAO = userDAO;
        this.domainDAO = domainDAO;
        this.participationDAO = participationDAO;
    }
    
    /**
     * Get all research projects
     * @return list of all projects
     */
    public List<ResearchProject> getAllProjects() {
        return projectDAO.findAll();
    }
    
    /**
     * Get project by ID
     * @param id project ID
     * @return ResearchProject or null if not found
     */
    public ResearchProject getProjectById(Long id) {
        Optional<ResearchProject> projectOpt = projectDAO.findById(id);
        return projectOpt.orElse(null);
    }
    
    /**
     * Get projects where user is responsible or participant
     * @param userId user ID
     * @return list of projects
     */
    public List<ResearchProject> getProjectsByUser(Long userId) {
        return projectDAO.findByUser(userId);
    }
    
    /**
     * Get projects by domain
     * @param domainId domain ID
     * @return list of projects in the domain
     */
    public List<ResearchProject> getProjectsByDomain(Long domainId) {
        return projectDAO.findByDomain(domainId);
    }
    
    /**
     * Get projects by status
     * @param status project status (EN_COURS, TERMINE, SUSPENDU)
     * @return list of projects with the specified status
     */
    public List<ResearchProject> getProjectsByStatus(String status) {
        return projectDAO.findByStatus(status);
    }
    
    /**
     * Create a new research project
     * @param project ResearchProject object
     * @param userId ID of the user creating the project
     * @return saved ResearchProject
     */
    public ResearchProject createProject(ResearchProject project, Long userId) {
        // Verify user exists
        Optional<User> userOpt = userDAO.findById(userId);
        if (!userOpt.isPresent()) {
            throw new IllegalArgumentException("User not found");
        }
        
        // Verify domain exists if specified
        if (project.getDomain() != null && project.getDomain().getId() != null) {
            Optional<ResearchDomain> domainOpt = domainDAO.findById(project.getDomain().getId());
            if (!domainOpt.isPresent()) {
                throw new IllegalArgumentException("Domain not found");
            }
            project.setDomain(domainOpt.get());
        }
        
        // Set responsible user
        if (project.getResponsibleUser() == null) {
            project.setResponsibleUser(userOpt.get());
        }
        
        return projectDAO.save(project);
    }
    
    /**
     * Update a research project
     * @param project ResearchProject with updated information
     * @param userId ID of the user updating the project
     * @return updated ResearchProject
     */
    public ResearchProject updateProject(ResearchProject project, Long userId) {
        // Verify project exists
        Optional<ResearchProject> existingProjectOpt = projectDAO.findById(project.getId());
        if (!existingProjectOpt.isPresent()) {
            throw new IllegalArgumentException("Project not found");
        }
        
        ResearchProject existingProject = existingProjectOpt.get();
        
        // Check if user has permission to update
        // User must be the responsible user or have admin/manager role
        Optional<User> userOpt = userDAO.findById(userId);
        if (!userOpt.isPresent()) {
            throw new IllegalArgumentException("User not found");
        }
        
        User user = userOpt.get();
        boolean isResponsible = existingProject.getResponsibleUser().getId().equals(userId);
        boolean isAdmin = user.getRole() != null && 
                         ("ADMIN".equals(user.getRole().getLibelle()) || 
                          "GESTIONNAIRE".equals(user.getRole().getLibelle()));
        
        if (!isResponsible && !isAdmin) {
            throw new SecurityException("User does not have permission to update this project");
        }
        
        // Verify domain if changed
        if (project.getDomain() != null && project.getDomain().getId() != null) {
            Optional<ResearchDomain> domainOpt = domainDAO.findById(project.getDomain().getId());
            if (!domainOpt.isPresent()) {
                throw new IllegalArgumentException("Domain not found");
            }
        }
        
        return projectDAO.update(project);
    }
    
    /**
     * Delete a research project
     * @param projectId project ID
     * @param userId ID of the user deleting the project
     */
    public void deleteProject(Long projectId, Long userId) {
        // Verify project exists
        Optional<ResearchProject> projectOpt = projectDAO.findById(projectId);
        if (!projectOpt.isPresent()) {
            throw new IllegalArgumentException("Project not found");
        }
        
        ResearchProject project = projectOpt.get();
        
        // Check if user has permission to delete
        Optional<User> userOpt = userDAO.findById(userId);
        if (!userOpt.isPresent()) {
            throw new IllegalArgumentException("User not found");
        }
        
        User user = userOpt.get();
        boolean isResponsible = project.getResponsibleUser().getId().equals(userId);
        boolean isAdmin = user.getRole() != null && 
                         ("ADMIN".equals(user.getRole().getLibelle()) || 
                          "GESTIONNAIRE".equals(user.getRole().getLibelle()));
        
        if (!isResponsible && !isAdmin) {
            throw new SecurityException("User does not have permission to delete this project");
        }
        
        projectDAO.delete(projectId);
    }
    
    /**
     * Add a participant to a project
     * @param projectId project ID
     * @param userId user ID
     * @param role participant role
     * @return saved Participation
     */
    public Participation addParticipant(Long projectId, Long userId, String role) {
        // Verify project exists
        Optional<ResearchProject> projectOpt = projectDAO.findById(projectId);
        if (!projectOpt.isPresent()) {
            throw new IllegalArgumentException("Project not found");
        }
        
        // Verify user exists
        Optional<User> userOpt = userDAO.findById(userId);
        if (!userOpt.isPresent()) {
            throw new IllegalArgumentException("User not found");
        }
        
        Participation participation = new Participation(userOpt.get(), projectOpt.get(), role);
        return participationDAO.save(participation);
    }
    
    /**
     * Remove a participant from a project
     * @param participationId participation ID
     */
    public void removeParticipant(Long participationId) {
        participationDAO.delete(participationId);
    }
    
    /**
     * Get all participants of a project
     * @param projectId project ID
     * @return list of participations
     */
    public List<Participation> getProjectParticipants(Long projectId) {
        return participationDAO.findByProject(projectId);
    }
    
    public void close() {
        projectDAO.close();
        userDAO.close();
        domainDAO.close();
        participationDAO.close();
    }
}
