/**
 * Projects Module for ESMT Research Mapping Platform
 * Handles project listing, filtering, search, and CRUD operations
 */

let allProjects = [];
let filteredProjects = [];
let currentFilters = {
    domain: '',
    status: '',
    responsable: '',
    searchQuery: ''
};

/**
 * Load all projects
 */
async function loadProjects(userId = null) {
    const loadingContainer = document.getElementById('projects-loading');
    const tableBody = document.getElementById('projects-table-body');
    
    if (loadingContainer) loadingContainer.style.display = 'block';
    if (tableBody) tableBody.innerHTML = '';
    
    try {
        // Load projects visible to the current user (server-side role filtering)
        allProjects = await API.getMesProjects();
        
        filteredProjects = [...allProjects];
        displayProjects();
        updateProjectCount();
        
        if (loadingContainer) loadingContainer.style.display = 'none';
    } catch (error) {
        console.error('Error loading projects:', error);
        if (loadingContainer) loadingContainer.style.display = 'none';
        showError('Erreur lors du chargement des projets');
    }
}

/**
 * Display projects in table
 */
function displayProjects() {
    const tableBody = document.getElementById('projects-table-body');
    if (!tableBody) return;
    
    if (filteredProjects.length === 0) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="8" class="table-empty">
                    <div class="table-empty-icon">📁</div>
                    <div class="table-empty-text">Aucun projet trouvé</div>
                    <div class="table-empty-subtext">Essayez de modifier vos filtres ou créez un nouveau projet</div>
                </td>
            </tr>
        `;
        return;
    }
    
    tableBody.innerHTML = filteredProjects.map(project => `
        <tr>
            <td class="truncate" title="${escapeHtml(project.titre)}">${escapeHtml(project.titre)}</td>
            <td>${escapeHtml(project.domaine?.nom || 'N/A')}</td>
            <td><span class="badge badge-${getStatusClass(project.statut)}">${formatStatus(project.statut)}</span></td>
            <td>${formatDate(project.dateDebut)}</td>
            <td>${formatDate(project.dateFin)}</td>
            <td class="number">${formatBudget(project.budgetEstime)}</td>
            <td>
                <div class="progress-bar-cell">
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: ${project.niveauAvancement || 0}%"></div>
                    </div>
                    <span class="progress-text">${project.niveauAvancement || 0}%</span>
                </div>
            </td>
            <td class="table-actions-cell">
                <button class="action-btn action-btn-view" onclick="viewProject(${project.id})" title="Voir les détails">
                    👁️ Voir
                </button>
                ${canEdit() ? `
                    <button class="action-btn action-btn-edit" onclick="editProject(${project.id})" title="Modifier">
                        ✏️ Éditer
                    </button>
                ` : ''}
                ${canDelete() ? `
                    <button class="action-btn action-btn-delete" onclick="deleteProject(${project.id})" title="Supprimer">
                        🗑️ Supprimer
                    </button>
                ` : ''}
            </td>
        </tr>
    `).join('');
}

/**
 * Filter projects based on criteria
 */
function filterProjects(criteria = null) {
    if (criteria) {
        currentFilters = { ...currentFilters, ...criteria };
    }
    
    filteredProjects = allProjects.filter(project => {
        // Filter by domain
        if (currentFilters.domain && project.domaine?.nom !== currentFilters.domain) {
            return false;
        }
        
        // Filter by status
        if (currentFilters.status && project.statut !== currentFilters.status) {
            return false;
        }
        
        // Filter by responsable
        if (currentFilters.responsable && project.responsable?.email !== currentFilters.responsable) {
            return false;
        }
        
        // Filter by search query
        if (currentFilters.searchQuery) {
            const query = currentFilters.searchQuery.toLowerCase();
            const titleMatch = project.titre?.toLowerCase().includes(query);
            const descMatch = project.description?.toLowerCase().includes(query);
            const instMatch = project.institution?.toLowerCase().includes(query);
            
            if (!titleMatch && !descMatch && !instMatch) {
                return false;
            }
        }
        
        return true;
    });
    
    displayProjects();
    updateProjectCount();
}

/**
 * Search projects by title
 */
function searchProjects(query) {
    currentFilters.searchQuery = query;
    filterProjects();
}

/**
 * Reset all filters
 */
function resetFilters() {
    currentFilters = {
        domain: '',
        status: '',
        responsable: '',
        searchQuery: ''
    };
    
    // Reset form elements
    const domainFilter = document.getElementById('filter-domain');
    const statusFilter = document.getElementById('filter-status');
    const responsableFilter = document.getElementById('filter-responsable');
    const searchInput = document.getElementById('search-projects');
    
    if (domainFilter) domainFilter.value = '';
    if (statusFilter) statusFilter.value = '';
    if (responsableFilter) responsableFilter.value = '';
    if (searchInput) searchInput.value = '';
    
    filterProjects();
}

/**
 * View project details
 */
function viewProject(projectId) {
    window.location.href = `/research-mapping-esmt/projects/${projectId}`;
}

/**
 * Edit project
 */
function editProject(projectId) {
    window.location.href = `/research-mapping-esmt/projects/${projectId}/edit`;
}

/**
 * Delete project with confirmation
 */
async function deleteProject(projectId) {
    if (!confirm('Êtes-vous sûr de vouloir supprimer ce projet ? Cette action est irréversible.')) {
        return;
    }
    
    try {
        await API.deleteProject(projectId);
        API.showSuccess('Projet supprimé avec succès');
        
        // Remove from local arrays
        allProjects = allProjects.filter(p => p.id !== projectId);
        filteredProjects = filteredProjects.filter(p => p.id !== projectId);
        
        displayProjects();
        updateProjectCount();
    } catch (error) {
        console.error('Error deleting project:', error);
        API.showError('Erreur lors de la suppression du projet');
    }
}

/**
 * Update project count display
 */
function updateProjectCount() {
    const countElement = document.getElementById('project-count');
    if (countElement) {
        const total = allProjects.length;
        const filtered = filteredProjects.length;
        
        if (filtered === total) {
            countElement.textContent = `${total} projet(s)`;
        } else {
            countElement.textContent = `${filtered} projet(s) sur ${total}`;
        }
    }
}

/**
 * Helper: Format status for display
 */
function formatStatus(status) {
    const statusMap = {
        'EN_COURS': 'En cours',
        'TERMINE': 'Terminé',
        'SUSPENDU': 'Suspendu'
    };
    return statusMap[status] || status;
}

/**
 * Helper: Get status CSS class
 */
function getStatusClass(status) {
    const classMap = {
        'EN_COURS': 'en-cours',
        'TERMINE': 'termine',
        'SUSPENDU': 'suspendu'
    };
    return classMap[status] || 'secondary';
}

/**
 * Helper: Format date
 */
function formatDate(dateString) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR');
}

/**
 * Helper: Format budget
 */
function formatBudget(budget) {
    if (!budget) return 'N/A';
    return new Intl.NumberFormat('fr-FR', {
        style: 'currency',
        currency: 'XOF'
    }).format(budget);
}

/**
 * Helper: Escape HTML to prevent XSS
 */
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

/**
 * Helper: Check if user can edit projects
 */
function canEdit() {
    // Check user role from session or data attribute
    const userRole = document.body.dataset.userRole;
    return userRole === 'GESTIONNAIRE' || userRole === 'ADMIN';
}

/**
 * Helper: Check if user can delete projects
 */
function canDelete() {
    const userRole = document.body.dataset.userRole;
    return userRole === 'ADMIN';
}

/**
 * Helper: Show error message
 */
function showError(message) {
    if (typeof API !== 'undefined' && API.showError) {
        API.showError(message);
    } else {
        alert(message);
    }
}

// Event listeners setup
document.addEventListener('DOMContentLoaded', function() {
    // Search input
    const searchInput = document.getElementById('search-projects');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            searchProjects(e.target.value);
        });
    }
    
    // Domain filter
    const domainFilter = document.getElementById('filter-domain');
    if (domainFilter) {
        domainFilter.addEventListener('change', (e) => {
            filterProjects({ domain: e.target.value });
        });
    }
    
    // Status filter
    const statusFilter = document.getElementById('filter-status');
    if (statusFilter) {
        statusFilter.addEventListener('change', (e) => {
            filterProjects({ status: e.target.value });
        });
    }
    
    // Responsable filter
    const responsableFilter = document.getElementById('filter-responsable');
    if (responsableFilter) {
        responsableFilter.addEventListener('change', (e) => {
            filterProjects({ responsable: e.target.value });
        });
    }
    
    // Reset filters button
    const resetBtn = document.getElementById('reset-filters');
    if (resetBtn) {
        resetBtn.addEventListener('click', resetFilters);
    }
    
    // Load projects on page load
    const userId = document.body.dataset.userId;
    const loadOnInit = document.body.dataset.loadProjects;
    
    if (loadOnInit === 'true') {
        loadProjects(userId || null);
    }
});