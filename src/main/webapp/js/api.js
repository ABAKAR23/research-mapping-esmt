/**
 * Centralized API module for Research Mapping ESMT
 * Handles all REST API calls with error management
 */

const API = {
    baseUrl: '/research-mapping-esmt/api/javaee',
    
    /**
     * Generic fetch wrapper with error handling
     */
    async request(endpoint, options = {}) {
        const url = `${this.baseUrl}${endpoint}`;
        const defaultOptions = {
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            credentials: 'include'
        };
        
        try {
            const response = await fetch(url, { ...defaultOptions, ...options });
            
            if (!response.ok) {
                const errorData = await response.json().catch(() => ({}));
                throw new Error(errorData.message || errorData.error || `HTTP ${response.status}: ${response.statusText}`);
            }
            
            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                return await response.json();
            }
            return await response.text();
        } catch (error) {
            console.error('API Error:', error);
            this.handleError(error);
            throw error;
        }
    },
    
    // ==================== PROJECT ENDPOINTS ====================
    
    /**
     * Get all projects
     * GET /projects
     */
    getAllProjects: async function() {
        return await this.request('/projects');
    },
    
    /**
     * Get projects by user ID
     * GET /projects/user/{userId}
     */
    getUserProjects: async function(userId) {
        return await this.request(`/projects/user/${userId}`);
    },
    
    /**
     * Get project by ID
     * GET /projects/{id}
     */
    getProjectById: async function(id) {
        return await this.request(`/projects/${id}`);
    },
    
    /**
     * Create a new project
     * POST /projects
     */
    createProject: async function(projectData) {
        return await this.request('/projects', {
            method: 'POST',
            body: JSON.stringify(projectData)
        });
    },
    
    /**
     * Update an existing project
     * PUT /projects/{id}
     */
    updateProject: async function(id, projectData) {
        return await this.request(`/projects/${id}`, {
            method: 'PUT',
            body: JSON.stringify(projectData)
        });
    },
    
    /**
     * Delete a project
     * DELETE /projects/{id}
     */
    deleteProject: async function(id) {
        return await this.request(`/projects/${id}`, {
            method: 'DELETE'
        });
    },
    
    /**
     * Search projects by title
     * GET /projects/search?title={query}
     */
    searchProjects: async function(query) {
        return await this.request(`/projects/search?title=${encodeURIComponent(query)}`);
    },
    
    // ==================== STATISTICS ENDPOINTS ====================
    
    /**
     * Get all statistics
     * GET /statistics
     */
    getStatistics: async function() {
        return await this.request('/statistics');
    },
    
    /**
     * Get projects by domain
     * GET /statistics/by-domain
     */
    getProjectsByDomain: async function() {
        return await this.request('/statistics/by-domain');
    },
    
    /**
     * Get projects by status
     * GET /statistics/by-status
     */
    getProjectsByStatus: async function() {
        return await this.request('/statistics/by-status');
    },
    
    /**
     * Get temporal evolution (projects by year)
     * GET /statistics/temporal-evolution
     */
    getTemporalEvolution: async function() {
        return await this.request('/statistics/temporal-evolution');
    },
    
    /**
     * Get projects by participant
     * GET /statistics/by-participant
     */
    getProjectsByParticipant: async function() {
        return await this.request('/statistics/by-participant');
    },
    
    /**
     * Get total project count
     * GET /statistics/total
     */
    getTotalProjects: async function() {
        return await this.request('/statistics/total');
    },
    
    /**
     * Get budget by domain
     * GET /statistics/budget-by-domain
     */
    getBudgetByDomain: async function() {
        return await this.request('/statistics/budget-by-domain');
    },
    
    // ==================== USER ENDPOINTS ====================
    
    /**
     * Get all users (Admin only)
     * GET /users
     */
    getAllUsers: async function() {
        return await this.request('/users');
    },
    
    /**
     * Get user by ID
     * GET /users/{id}
     */
    getUserById: async function(id) {
        return await this.request(`/users/${id}`);
    },
    
    /**
     * Get user by email
     * GET /users/email/{email}
     */
    getUserByEmail: async function(email) {
        return await this.request(`/users/email/${encodeURIComponent(email)}`);
    },
    
    /**
     * Update user
     * PUT /users/{id}
     */
    updateUser: async function(id, userData) {
        return await this.request(`/users/${id}`, {
            method: 'PUT',
            body: JSON.stringify(userData)
        });
    },
    
    /**
     * Delete user (Admin only)
     * DELETE /users/{id}
     */
    deleteUser: async function(id) {
        return await this.request(`/users/${id}`, {
            method: 'DELETE'
        });
    },
    
    // ==================== DOMAIN ENDPOINTS ====================
    
    /**
     * Get all research domains
     * GET /domains
     */
    getAllDomains: async function() {
        return await this.request('/domains');
    },
    
    /**
     * Create a new domain (Admin only)
     * POST /domains
     */
    createDomain: async function(domainData) {
        return await this.request('/domains', {
            method: 'POST',
            body: JSON.stringify(domainData)
        });
    },
    
    // ==================== ERROR HANDLING ====================
    
    /**
     * Display error message to user
     */
    handleError: function(error) {
        const message = error.message || 'Une erreur est survenue';
        
        // Try to find an alert container
        const alertContainer = document.getElementById('alert-container');
        if (alertContainer) {
            this.showAlert(message, 'danger', alertContainer);
        } else {
            // Fallback to console if no alert container
            console.error('Error:', message);
        }
    },
    
    /**
     * Show alert message
     */
    showAlert: function(message, type = 'info', container = null) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
        alertDiv.role = 'alert';
        alertDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `;
        
        if (container) {
            container.appendChild(alertDiv);
        } else {
            // Find or create a default container
            let defaultContainer = document.getElementById('alert-container');
            if (!defaultContainer) {
                defaultContainer = document.createElement('div');
                defaultContainer.id = 'alert-container';
                defaultContainer.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999; max-width: 400px;';
                document.body.appendChild(defaultContainer);
            }
            defaultContainer.appendChild(alertDiv);
        }
        
        // Auto-dismiss after 5 seconds
        setTimeout(() => {
            alertDiv.classList.remove('show');
            setTimeout(() => alertDiv.remove(), 150);
        }, 5000);
    },
    
    /**
     * Show success message
     */
    showSuccess: function(message, container = null) {
        this.showAlert(message, 'success', container);
    },
    
    /**
     * Show error message
     */
    showError: function(message, container = null) {
        this.showAlert(message, 'danger', container);
    },
    
    /**
     * Show loading spinner
     */
    showLoading: function(element) {
        if (element) {
            element.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Chargement...</span></div>';
        }
    },
    
    /**
     * Hide loading spinner
     */
    hideLoading: function(element) {
        if (element) {
            element.innerHTML = '';
        }
    }
};

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = API;
}
