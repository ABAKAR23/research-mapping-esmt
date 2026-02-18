<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier l'Utilisateur - ESMT Research Mapping</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body data-user-role="${sessionScope.user_role}" data-user-id="${param.id}">

<!-- Access Control: Only ADMIN -->
<c:if test="${sessionScope.user_role != 'ADMIN'}">
    <div class="container mt-5">
        <div class="alert alert-danger text-center" role="alert">
            <h2>⛔ Accès Refusé</h2>
            <p>Vous n'avez pas les droits nécessaires pour accéder à cette page.</p>
            <p>Cette section est réservée aux administrateurs uniquement.</p>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary mt-3">
                ← Retour au tableau de bord
            </a>
        </div>
    </div>
    <% return; %>
</c:if>

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
                <li><a href="${pageContext.request.contextPath}/projets/nouveau">➕ Déclarer un projet</a></li>
                <c:if test="${sessionScope.user_role == 'GESTIONNAIRE' || sessionScope.user_role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/statistiques">📈 Statistiques</a></li>
                </c:if>
                <c:if test="${sessionScope.user_role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/utilisateurs" class="active">👥 Utilisateurs</a></li>
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
                <h2>✏️ Modifier l'utilisateur</h2>
                <p>Modifiez les informations de l'utilisateur</p>
            </div>

            <!-- Alert Container -->
            <div id="alert-container"></div>

            <form id="user-form" method="POST">
                <!-- Section: Informations de l'utilisateur -->
                <div class="form-section">
                    <h3 class="form-section-title">Informations de l'utilisateur</h3>
                    
                    <div class="form-grid">
                        <div class="form-group form-full-width">
                            <label for="nom" class="required">Nom complet</label>
                            <input type="text" id="nom" name="nom" class="form-control" 
                                   placeholder="Ex: Jean Dupont"
                                   maxlength="100" required>
                            <small>Nom et prénom de l'utilisateur</small>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group form-full-width">
                            <label for="email" class="required">Email</label>
                            <input type="email" id="email" name="email" class="form-control" 
                                   placeholder="utilisateur@example.com"
                                   readonly required>
                            <small>L'adresse email ne peut pas être modifiée</small>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="role" class="required">Rôle</label>
                            <select id="role" name="role" class="form-control" required>
                                <option value="">-- Sélectionnez un rôle --</option>
                                <option value="CANDIDAT">CANDIDAT</option>
                                <option value="GESTIONNAIRE">GESTIONNAIRE</option>
                                <option value="ADMIN">ADMIN</option>
                            </select>
                            <small>Définit les permissions de l'utilisateur</small>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="institution" class="required">Institution</label>
                            <input type="text" id="institution" name="institution" class="form-control" 
                                   placeholder="Ex: ESMT Dakar" required>
                            <small>Institution de rattachement</small>
                            <div class="error-message"></div>
                        </div>
                    </div>
                </div>

                <!-- Section: Statut -->
                <div class="form-section">
                    <h3 class="form-section-title">Statut du compte</h3>
                    
                    <div class="form-grid">
                        <div class="form-group form-full-width">
                            <div class="form-check">
                                <input type="checkbox" id="actif" name="actif" class="form-check-input" value="true">
                                <label class="form-check-label" for="actif">
                                    Compte actif
                                </label>
                            </div>
                            <small>Décochez pour désactiver l'accès de l'utilisateur</small>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-light" onclick="window.location.href='${pageContext.request.contextPath}/utilisateurs'">
                        ← Annuler
                    </button>
                    <button type="submit" class="btn btn-primary">
                        ✓ Enregistrer les modifications
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
// Get user ID from body attribute
const userId = document.body.getAttribute('data-user-id');

// Load user data
async function loadUserData() {
    try {
        // Verify user has permission
        const userRole = document.body.getAttribute('data-user-role');
        if (userRole !== 'ADMIN') {
            API.showError('Accès non autorisé. Seuls les Administrateurs peuvent modifier des utilisateurs.');
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/dashboard';
            }, 2000);
            return;
        }
        
        // Load user
        const user = await API.getUserById(userId);
        
        // Pre-fill form fields
        document.getElementById('nom').value = user.nom || '';
        document.getElementById('email').value = user.email || '';
        document.getElementById('role').value = user.role || '';
        document.getElementById('institution').value = user.institution || '';
        document.getElementById('actif').checked = user.actif === true || user.actif === 'true';
        
    } catch (error) {
        console.error('Error loading user:', error);
        API.showError('Erreur lors du chargement de l\'utilisateur: ' + error.message);
        setTimeout(() => {
            window.location.href = '${pageContext.request.contextPath}/utilisateurs';
        }, 2000);
    }
}

// Handle form submission
document.getElementById('user-form').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    // Validate form
    if (!validateUserForm(this)) {
        return;
    }
    
    // Disable submit button
    disableSubmitButton(this);
    
    try {
        // Collect form data
        const formData = {
            nom: document.getElementById('nom').value.trim(),
            email: document.getElementById('email').value.trim(),
            role: document.getElementById('role').value,
            institution: document.getElementById('institution').value.trim(),
            actif: document.getElementById('actif').checked
        };
        
        // Submit via API
        await API.updateUser(userId, formData);
        
        // Show success message
        API.showSuccess('Utilisateur modifié avec succès ! Redirection...');
        
        // Redirect after 2 seconds
        setTimeout(() => {
            window.location.href = '${pageContext.request.contextPath}/utilisateurs';
        }, 2000);
        
    } catch (error) {
        console.error('Error updating user:', error);
        API.showError('Erreur lors de la modification de l\'utilisateur: ' + error.message);
        enableSubmitButton(this);
    }
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', async function() {
    await loadUserData();
});
</script>

</body>
</html>
