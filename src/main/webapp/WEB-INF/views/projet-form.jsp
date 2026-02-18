<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Déclarer un Projet - ESMT Research Mapping</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body data-user-role="${sessionScope.user_role}">

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
                <li><a href="${pageContext.request.contextPath}/projets">📁 Mes projets</a></li>
                <li><a href="${pageContext.request.contextPath}/projets/nouveau" class="active">➕ Déclarer un projet</a></li>
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
        <div class="form-container">
            <div class="form-header">
                <h2>📝 Déclarer un nouveau projet de recherche</h2>
                <p>Remplissez tous les champs obligatoires pour déclarer votre projet</p>
            </div>

            <!-- Alert Container -->
            <div id="alert-container"></div>

            <form id="project-form" method="POST" action="${pageContext.request.contextPath}/api/javaee/projects">
                <!-- Section: Informations Générales -->
                <div class="form-section">
                    <h3 class="form-section-title">Informations Générales</h3>
                    
                    <div class="form-grid">
                        <div class="form-group form-full-width">
                            <label for="titre" class="required">Titre du projet</label>
                            <input type="text" id="titre" name="titre" class="form-control" 
                                   placeholder="Ex: Développement d'une application mobile pour la santé"
                                   maxlength="200" required>
                            <small>Entre 5 et 200 caractères</small>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group form-full-width">
                            <label for="description" class="required">Description détaillée</label>
                            <textarea id="description" name="description" class="form-control large" 
                                      placeholder="Décrivez en détail les objectifs, la méthodologie et les résultats attendus du projet..."
                                      maxlength="1000" required></textarea>
                            <small>Entre 20 et 1000 caractères</small>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="domaineId" class="required">Domaine de recherche</label>
                            <select id="domaineId" name="domaineId" class="form-control" required>
                                <option value="">-- Sélectionnez un domaine --</option>
                                <!-- Domains will be loaded via JavaScript -->
                            </select>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="institution" class="required">Institution</label>
                            <input type="text" id="institution" name="institution" class="form-control" 
                                   placeholder="Ex: ESMT Dakar" required>
                            <small>Nom de l'institution porteuse du projet</small>
                            <div class="error-message"></div>
                        </div>
                    </div>
                </div>

                <!-- Section: Planification -->
                <div class="form-section">
                    <h3 class="form-section-title">Planification</h3>
                    
                    <div class="form-grid three-columns">
                        <div class="form-group">
                            <label for="dateDebut" class="required">Date de début</label>
                            <input type="date" id="dateDebut" name="dateDebut" class="form-control" required>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="dateFin" class="required">Date de fin prévue</label>
                            <input type="date" id="dateFin" name="dateFin" class="form-control" required>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="statut" class="required">Statut actuel</label>
                            <select id="statut" name="statut" class="form-control" required>
                                <option value="">-- Sélectionnez --</option>
                                <option value="EN_COURS">En cours</option>
                                <option value="TERMINE">Terminé</option>
                                <option value="SUSPENDU">Suspendu</option>
                            </select>
                            <div class="error-message"></div>
                        </div>
                    </div>
                </div>

                <!-- Section: Budget et Avancement -->
                <div class="form-section">
                    <h3 class="form-section-title">Budget et Avancement</h3>
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="budgetEstime" class="required">Budget estimé (FCFA)</label>
                            <input type="number" id="budgetEstime" name="budgetEstime" class="form-control" 
                                   placeholder="Ex: 5000000" min="0" step="1000" required>
                            <small>Budget total prévu pour le projet</small>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="niveauAvancement" class="required">Niveau d'avancement (%)</label>
                            <input type="range" id="niveauAvancement" name="niveauAvancement" 
                                   min="0" max="100" value="0" step="5" required>
                            <div class="range-value" id="avancementValue">0%</div>
                            <div class="error-message"></div>
                        </div>
                    </div>
                </div>

                <!-- Section: Équipe -->
                <div class="form-section">
                    <h3 class="form-section-title">Équipe du projet</h3>
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="responsableEmail" class="required">Email du responsable</label>
                            <input type="email" id="responsableEmail" name="responsableEmail" class="form-control" 
                                   placeholder="responsable@example.com"
                                   value="${sessionScope.user_email}" required>
                            <small>Adresse email du chef de projet</small>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="participantsEmails">Participants (emails)</label>
                            <input type="text" id="participantsEmails" name="participantsEmails" class="form-control" 
                                   placeholder="email1@example.com; email2@example.com">
                            <small>Séparez les emails par des points-virgules (;)</small>
                            <div class="error-message"></div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-light" onclick="history.back()">
                        ← Annuler
                    </button>
                    <button type="submit" class="btn btn-primary">
                        ✓ Déclarer le projet
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/js/api.js"></script>
<script src="${pageContext.request.contextPath}/js/form-validation.js"></script>

<script>
// Load domains
async function loadDomains() {
    try {
        const domains = await API.getAllDomains();
        const select = document.getElementById('domaineId');
        
        domains.forEach(domain => {
            const option = document.createElement('option');
            option.value = domain.id;
            option.textContent = domain.nom;
            select.appendChild(option);
        });
    } catch (error) {
        console.error('Error loading domains:', error);
    }
}

// Update advancement value display
document.getElementById('niveauAvancement').addEventListener('input', function() {
    document.getElementById('avancementValue').textContent = this.value + '%';
});

// Handle form submission
document.getElementById('project-form').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    // Validate form
    if (!validateProjectForm(this)) {
        return;
    }
    
    // Disable submit button
    disableSubmitButton(this);
    
    try {
        // Collect form data
        const formData = {
            titre: document.getElementById('titre').value,
            description: document.getElementById('description').value,
            domaineId: parseInt(document.getElementById('domaineId').value),
            dateDebut: document.getElementById('dateDebut').value,
            dateFin: document.getElementById('dateFin').value,
            statut: document.getElementById('statut').value,
            budgetEstime: parseFloat(document.getElementById('budgetEstime').value),
            institution: document.getElementById('institution').value,
            niveauAvancement: parseInt(document.getElementById('niveauAvancement').value),
            responsableEmail: document.getElementById('responsableEmail').value,
            participantsEmails: document.getElementById('participantsEmails').value
        };
        
        // Submit via API
        await API.createProject(formData);
        
        // Show success message
        API.showSuccess('Projet créé avec succès ! Redirection...');
        
        // Redirect after 2 seconds
        setTimeout(() => {
            window.location.href = '${pageContext.request.contextPath}/projets';
        }, 2000);
        
    } catch (error) {
        console.error('Error creating project:', error);
        API.showError('Erreur lors de la création du projet: ' + error.message);
        enableSubmitButton(this);
    }
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    loadDomains();
});
</script>

</body>
</html>
