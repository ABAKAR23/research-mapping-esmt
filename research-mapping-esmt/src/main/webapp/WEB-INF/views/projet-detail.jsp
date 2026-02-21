<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Projet - ESMT Research Mapping</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
    
    <style>
        .project-detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .project-header {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .project-title {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .status-badge {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-badge.EN_COURS {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .status-badge.TERMINE {
            background-color: #e8f5e9;
            color: #388e3c;
        }
        
        .status-badge.SUSPENDU {
            background-color: #fff3e0;
            color: #f57c00;
        }
        
        .info-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: 100%;
        }
        
        .info-card-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-card-title::before {
            content: '';
            width: 4px;
            height: 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 2px;
        }
        
        .info-item {
            margin-bottom: 16px;
        }
        
        .info-label {
            font-size: 13px;
            font-weight: 600;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        
        .info-value {
            font-size: 15px;
            color: #2c3e50;
            line-height: 1.6;
        }
        
        .info-value.empty {
            color: #95a5a6;
            font-style: italic;
        }
        
        .progress-container {
            margin-top: 8px;
        }
        
        .progress {
            height: 24px;
            border-radius: 12px;
            background-color: #ecf0f1;
        }
        
        .progress-bar {
            border-radius: 12px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .participants-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .participant-item {
            padding: 10px 12px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .participant-item::before {
            content: '👤';
            font-size: 16px;
        }
        
        .action-buttons {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-top: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-outline-primary {
            background: white;
            border: 2px solid #667eea;
            color: #667eea;
        }
        
        .btn-outline-primary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        
        .btn-light {
            background: #ecf0f1;
            color: #2c3e50;
        }
        
        .btn-light:hover {
            background: #d5dbdb;
        }
        
        .loading-spinner {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 400px;
        }
        
        .spinner-border {
            width: 3rem;
            height: 3rem;
            border-width: 0.3em;
        }
        
        .back-button {
            margin-bottom: 20px;
        }
        
        .duration-info {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            background: #f8f9fa;
            border-radius: 6px;
            margin-top: 8px;
        }
        
        .duration-info::before {
            content: '⏱️';
        }
    </style>
</head>
<body data-user-role="${sessionScope.user_role}" data-project-id="${param.id}">

<!-- Navbar -->
<nav class="navbar">
    <div class="navbar-brand">
        <span>📊</span>
        ESMT Research Mapping
    </div>
    <div class="navbar-right">
        <div class="user-info">
            <div class="user-avatar">${sessionScope.user_name != null ? sessionScope.user_name.substring(0,1).toUpperCase() : 'U'}</div>
            <span class="user-name">${sessionScope.user_name}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
    </div>
</nav>

<!-- Main Container -->
<div class="main-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <nav class="nav-menu">
            <ul>
                <li><a href="${pageContext.request.contextPath}/dashboard">📊 Tableau de bord</a></li>
                <li><a href="${pageContext.request.contextPath}/projets" class="active">📁 Mes projets</a></li>
                <li><a href="${pageContext.request.contextPath}/projets/nouveau">➕ Déclarer un projet</a></li>
                <c:if test="${sessionScope.user_role == 'GESTIONNAIRE' || sessionScope.user_role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/statistiques">📈 Statistiques</a></li>
                </c:if>
                <c:if test="${sessionScope.user_role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/utilisateurs">👥 Utilisateurs</a></li>
                    <li><a href="${pageContext.request.contextPath}/import">📥 Import CSV</a></li>
                </c:if>
                <li><a href="${pageContext.request.contextPath}/profil">👤 Mon profil</a></li>
            </ul>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="content">
        <div class="project-detail-container">
            <!-- Loading State -->
            <div id="loading-container" class="loading-spinner">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Chargement...</span>
                </div>
            </div>

            <!-- Project Details Content (Hidden initially) -->
            <div id="project-content" style="display: none;">
                <!-- Back Button -->
                <div class="back-button">
                    <a href="${pageContext.request.contextPath}/projets" class="btn btn-light">
                        ← Retour à la liste des projets
                    </a>
                </div>

                <!-- Project Header -->
                <div class="project-header">
                    <h1 class="project-title">
                        <span id="project-title-text"></span>
                        <span id="project-status-badge" class="status-badge"></span>
                    </h1>
                </div>

                <!-- Information Cards Grid -->
                <div class="row g-4">
                    <!-- General Information Card -->
                    <div class="col-12 col-lg-6">
                        <div class="info-card">
                            <h2 class="info-card-title">Informations Générales</h2>
                            
                            <div class="info-item">
                                <div class="info-label">Titre</div>
                                <div class="info-value" id="info-titre"></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Description</div>
                                <div class="info-value" id="info-description"></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Domaine de Recherche</div>
                                <div class="info-value" id="info-domaine"></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Institution</div>
                                <div class="info-value" id="info-institution"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Planning Card -->
                    <div class="col-12 col-lg-6">
                        <div class="info-card">
                            <h2 class="info-card-title">Planification</h2>
                            
                            <div class="info-item">
                                <div class="info-label">Date de Début</div>
                                <div class="info-value" id="info-date-debut"></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Date de Fin Prévue</div>
                                <div class="info-value" id="info-date-fin"></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Durée</div>
                                <div class="duration-info" id="info-duree"></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Statut</div>
                                <div class="info-value" id="info-statut"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Budget & Progress Card -->
                    <div class="col-12 col-lg-6">
                        <div class="info-card">
                            <h2 class="info-card-title">Budget & Progression</h2>
                            
                            <div class="info-item">
                                <div class="info-label">Budget Estimé</div>
                                <div class="info-value" id="info-budget"></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Niveau d'Avancement</div>
                                <div class="info-value" id="info-avancement-text"></div>
                                <div class="progress-container">
                                    <div class="progress">
                                        <div id="info-avancement-bar" class="progress-bar" role="progressbar" 
                                             aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Team Card -->
                    <div class="col-12 col-lg-6">
                        <div class="info-card">
                            <h2 class="info-card-title">Équipe du Projet</h2>
                            
                            <div class="info-item">
                                <div class="info-label">Responsable</div>
                                <div class="info-value" id="info-responsable"></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Participants</div>
                                <ul class="participants-list" id="info-participants"></ul>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons" id="action-buttons">
                    <!-- Buttons will be added dynamically based on user role -->
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/js/api.js"></script>

<script>
// Get project ID from data attribute
const projectId = document.body.getAttribute('data-project-id');
const userRole = document.body.getAttribute('data-user-role');

// Format date to French locale
function formatDate(dateString) {
    if (!dateString) return 'Non définie';
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', { 
        day: '2-digit', 
        month: 'long', 
        year: 'numeric' 
    });
}

// Format budget
function formatBudget(amount) {
    if (!amount) return 'Non défini';
    return new Intl.NumberFormat('fr-FR', {
        style: 'currency',
        currency: 'XOF',
        minimumFractionDigits: 0
    }).format(amount);
}

// Calculate duration between two dates
function calculateDuration(startDate, endDate) {
    if (!startDate || !endDate) return 'Non calculable';
    
    const start = new Date(startDate);
    const end = new Date(endDate);
    const diffTime = Math.abs(end - start);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    const years = Math.floor(diffDays / 365);
    const months = Math.floor((diffDays % 365) / 30);
    const days = diffDays % 30;
    
    let result = [];
    if (years > 0) result.push(years + (years > 1 ? ' ans' : ' an'));
    if (months > 0) result.push(months + ' mois');
    if (days > 0 && years === 0) result.push(days + ' jours');
    
    return result.length > 0 ? result.join(', ') : '0 jours';
}

// Get status label in French
function getStatusLabel(status) {
    const statusMap = {
        'EN_COURS': 'En cours',
        'TERMINE': 'Terminé',
        'SUSPENDU': 'Suspendu'
    };
    return statusMap[status] || status;
}

// Display project details
function displayProject(project) {
    // Header
    document.getElementById('project-title-text').textContent = project.titre;
    const statusBadge = document.getElementById('project-status-badge');
    statusBadge.textContent = getStatusLabel(project.statut);
    statusBadge.className = 'status-badge ' + project.statut;
    
    // General Information
    document.getElementById('info-titre').textContent = project.titre;
    document.getElementById('info-description').textContent = project.description || 'Aucune description';
    document.getElementById('info-domaine').textContent = project.domaine?.nom || 'Non défini';
    document.getElementById('info-institution').textContent = project.institution || 'Non définie';
    
    // Planning
    document.getElementById('info-date-debut').textContent = formatDate(project.dateDebut);
    document.getElementById('info-date-fin').textContent = formatDate(project.dateFin);
    document.getElementById('info-duree').textContent = calculateDuration(project.dateDebut, project.dateFin);
    document.getElementById('info-statut').textContent = getStatusLabel(project.statut);
    
    // Budget & Progress
    document.getElementById('info-budget').textContent = formatBudget(project.budgetEstime);
    document.getElementById('info-avancement-text').textContent = (project.niveauAvancement || 0) + '%';
    const progressBar = document.getElementById('info-avancement-bar');
    const avancement = project.niveauAvancement || 0;
    progressBar.style.width = avancement + '%';
    progressBar.textContent = avancement + '%';
    progressBar.setAttribute('aria-valuenow', avancement);
    
    // Team
    document.getElementById('info-responsable').textContent = project.responsable?.nom || 'Non défini';
    
    const participantsList = document.getElementById('info-participants');
    participantsList.innerHTML = '';
    
    if (project.participants && project.participants.length > 0) {
        project.participants.forEach(participant => {
            const li = document.createElement('li');
            li.className = 'participant-item';
            li.textContent = participant.nom || participant.email;
            participantsList.appendChild(li);
        });
    } else {
        const li = document.createElement('li');
        li.className = 'info-value empty';
        li.style.listStyle = 'none';
        li.textContent = 'Aucun participant';
        participantsList.appendChild(li);
    }
    
    // Display action buttons based on role
    displayActionButtons(project);
}

// Display action buttons based on user role
function displayActionButtons(project) {
    const actionsContainer = document.getElementById('action-buttons');
    actionsContainer.innerHTML = '';
    
    const userEmail = '${sessionScope.user_email}';
    const isProjectOwner = project.responsable?.email === userEmail;
    
    if (userRole === 'ADMIN') {
        // Admin: Edit, Delete, Assign participants
        actionsContainer.innerHTML = `
            <button class="btn btn-primary" onclick="editProject()">
                ✏️ Modifier
            </button>
            <button class="btn btn-outline-primary" onclick="assignParticipants()">
                👥 Assigner des participants
            </button>
            <button class="btn btn-danger" onclick="deleteProject()">
                🗑️ Supprimer
            </button>
        `;
    } else if (userRole === 'GESTIONNAIRE') {
        // Gestionnaire: Edit, Assign participants
        actionsContainer.innerHTML = `
            <button class="btn btn-primary" onclick="editProject()">
                ✏️ Modifier
            </button>
            <button class="btn btn-outline-primary" onclick="assignParticipants()">
                👥 Assigner des participants
            </button>
        `;
    } else if (userRole === 'CANDIDAT' && isProjectOwner) {
        // Candidat: View only (their own project)
        actionsContainer.innerHTML = `
            <div class="info-value" style="color: #7f8c8d; font-style: italic; padding: 10px;">
                💡 Vous pouvez consulter les détails de votre projet
            </div>
        `;
    }
}

// Edit project
function editProject() {
    window.location.href = '${pageContext.request.contextPath}/projets/modifier?id=' + projectId;
}

// Delete project
async function deleteProject() {
    if (!confirm('Êtes-vous sûr de vouloir supprimer ce projet ? Cette action est irréversible.')) {
        return;
    }
    
    try {
        await API.deleteProject(projectId);
        API.showSuccess('Projet supprimé avec succès ! Redirection...');
        setTimeout(() => {
            window.location.href = '${pageContext.request.contextPath}/projets';
        }, 1500);
    } catch (error) {
        console.error('Error deleting project:', error);
        API.showError('Erreur lors de la suppression du projet: ' + error.message);
    }
}

// Assign participants
function assignParticipants() {
    window.location.href = '${pageContext.request.contextPath}/projets/participants?id=' + projectId;
}

// Load project details
async function loadProjectDetails() {
    if (!projectId) {
        API.showError('ID de projet manquant');
        return;
    }
    
    try {
        const project = await API.getProjectById(projectId);
        
        // Hide loading spinner
        document.getElementById('loading-container').style.display = 'none';
        
        // Display project details
        displayProject(project);
        
        // Show content
        document.getElementById('project-content').style.display = 'block';
        
    } catch (error) {
        console.error('Error loading project:', error);
        document.getElementById('loading-container').innerHTML = `
            <div class="alert alert-danger" role="alert">
                <strong>Erreur:</strong> Impossible de charger les détails du projet. ${error.message}
            </div>
            <a href="${pageContext.request.contextPath}/projets" class="btn btn-light">
                ← Retour à la liste des projets
            </a>
        `;
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    loadProjectDetails();
});
</script>

</body>
</html>
