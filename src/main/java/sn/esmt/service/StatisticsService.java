package sn.esmt.service;

import sn.esmt.dao.ResearchDomainDAO;
import sn.esmt.dao.ResearchProjectDAO;
import sn.esmt.model.ResearchProject;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StatisticsService {
    
    private ResearchProjectDAO projectDAO;
    private ResearchDomainDAO domainDAO;
    
    public StatisticsService() {
        this.projectDAO = new ResearchProjectDAO();
        this.domainDAO = new ResearchDomainDAO();
    }
    
    public StatisticsService(ResearchProjectDAO projectDAO, ResearchDomainDAO domainDAO) {
        this.projectDAO = projectDAO;
        this.domainDAO = domainDAO;
    }
    
    /**
     * Get total number of projects
     * @return total project count
     */
    public Long getTotalProjects() {
        return projectDAO.countAll();
    }
    
    /**
     * Get number of projects by domain
     * @return Map of domain name to project count
     */
    public Map<String, Long> getProjectsByDomain() {
        Map<String, Long> result = new HashMap<>();
        List<ResearchProject> allProjects = projectDAO.findAll();
        
        for (ResearchProject project : allProjects) {
            if (project.getDomain() != null) {
                String domainName = project.getDomain().getName();
                result.put(domainName, result.getOrDefault(domainName, 0L) + 1);
            }
        }
        
        return result;
    }
    
    /**
     * Get number of projects by status
     * @return Map of status to project count
     */
    public Map<String, Long> getProjectsByStatus() {
        Map<String, Long> result = new HashMap<>();
        List<ResearchProject> allProjects = projectDAO.findAll();
        
        for (ResearchProject project : allProjects) {
            String status = project.getStatus();
            if (status != null) {
                result.put(status, result.getOrDefault(status, 0L) + 1);
            }
        }
        
        return result;
    }
    
    /**
     * Get total estimated budget across all projects
     * @return total budget
     */
    public BigDecimal getTotalBudget() {
        List<ResearchProject> allProjects = projectDAO.findAll();
        BigDecimal total = BigDecimal.ZERO;
        
        for (ResearchProject project : allProjects) {
            if (project.getBudgetEstimated() != null) {
                total = total.add(project.getBudgetEstimated());
            }
        }
        
        return total;
    }
    
    /**
     * Get average advancement level across all projects
     * @return average advancement level (0-100)
     */
    public Double getAverageAdvancement() {
        List<ResearchProject> allProjects = projectDAO.findAll();
        
        if (allProjects.isEmpty()) {
            return 0.0;
        }
        
        int totalAdvancement = 0;
        int count = 0;
        
        for (ResearchProject project : allProjects) {
            if (project.getAdvancementLevel() != null) {
                totalAdvancement += project.getAdvancementLevel();
                count++;
            }
        }
        
        return count > 0 ? (double) totalAdvancement / count : 0.0;
    }
    
    /**
     * Get count of projects by status
     * @param status project status
     * @return count of projects with the given status
     */
    public Long getProjectCountByStatus(String status) {
        List<ResearchProject> projects = projectDAO.findByStatus(status);
        return (long) projects.size();
    }
    
    /**
     * Get count of projects by domain
     * @param domainId domain ID
     * @return count of projects in the domain
     */
    public Long getProjectCountByDomain(Long domainId) {
        List<ResearchProject> projects = projectDAO.findByDomain(domainId);
        return (long) projects.size();
    }
    
    /**
     * Get comprehensive statistics
     * @return Map with all statistics
     */
    public Map<String, Object> getAllStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        stats.put("totalProjects", getTotalProjects());
        stats.put("projectsByDomain", getProjectsByDomain());
        stats.put("projectsByStatus", getProjectsByStatus());
        stats.put("totalBudget", getTotalBudget());
        stats.put("averageAdvancement", getAverageAdvancement());
        
        return stats;
    }
    
    public void close() {
        projectDAO.close();
        domainDAO.close();
    }
}
