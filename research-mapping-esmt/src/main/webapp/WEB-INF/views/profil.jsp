<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - ESMT Research Mapping</title>
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    
    <style>
        /* Profile-specific styles */
        .profile-container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 12px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
            color: #667eea;
            font-size: 48px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            text-transform: uppercase;
        }
        
        .profile-avatar img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }
        
        .profile-name {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .profile-email {
            font-size: 16px;
            opacity: 0.95;
            margin-bottom: 15px;
        }
        
        .profile-role-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }
        
        .role-ADMIN {
            background: #dc3545;
            color: white;
        }
        
        .role-GESTIONNAIRE {
            background: #ffc107;
            color: #333;
        }
        
        .role-CANDIDAT {
            background: #17a2b8;
            color: white;
        }
        
        .profile-info-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .info-title {
            color: #003d82;
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            font-size: 13px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: 500;
            padding: 10px 0;
        }
        
        .info-value .badge {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        
        .edit-form-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 10px rgba(102, 126, 234, 0.3);
        }
        
        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            display: none;
        }
        
        .alert.show {
            display: block;
        }
        
        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        
        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.8s linear infinite;
            margin-right: 8px;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .main-container {
            display: flex;
            min-height: calc(100vh - 70px);
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            font-weight: 700;
            color: white;
            text-decoration: none;
        }
        
        .navbar-brand span {
            font-size: 28px;
        }
        
        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 16px;
        }
        
        .user-name {
            font-weight: 500;
        }
        
        .btn-logout {
            padding: 8px 20px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
        }
        
        .sidebar {
            width: 260px;
            background: white;
            padding: 30px 20px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        }
        
        .nav-menu ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .nav-menu li {
            margin-bottom: 5px;
        }
        
        .nav-menu a {
            display: block;
            padding: 12px 15px;
            color: #666;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .nav-menu a:hover {
            background: #f0f2f5;
            color: #667eea;
        }
        
        .nav-menu a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .content {
            flex: 1;
            padding: 40px;
            background: #f5f7fa;
            overflow-y: auto;
        }
    </style>
</head>
<body>

<!-- Access Control: Only authenticated users -->
<c:if test="${empty sessionScope.user_email}">
    <div style="text-align: center; padding: 50px;">
        <h2>⛔ Accès Refusé</h2>
        <p>Vous devez être connecté pour accéder à cette page.</p>
        <a href="${pageContext.request.contextPath}/login" style="display: inline-block; margin-top: 20px; padding: 10px 20px; background: #667eea; color: white; text-decoration: none; border-radius: 6px;">
            Se connecter
        </a>
    </div>
    <% return; %>
</c:if>

<!-- Navbar -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">
        <span>📊</span>
        ESMT Research Mapping
    </a>
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
                    <li><a href="${pageContext.request.contextPath}/utilisateurs">👥 Utilisateurs</a></li>
                    <li><a href="${pageContext.request.contextPath}/import">📥 Import CSV</a></li>
                </c:if>
                <li><a href="${pageContext.request.contextPath}/profil" class="active">👤 Mon profil</a></li>
            </ul>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="content">
        <div class="profile-container">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-avatar" id="profileAvatar">
                    ${sessionScope.user_name != null ? sessionScope.user_name.substring(0,2).toUpperCase() : 'US'}
                </div>
                <div class="profile-name" id="profileName">${sessionScope.user_name}</div>
                <div class="profile-email" id="profileEmail">${sessionScope.user_email}</div>
                <span class="profile-role-badge role-${sessionScope.user_role}" id="profileRoleBadge">
                    ${sessionScope.user_role}
                </span>
            </div>

            <!-- Alert Container -->
            <div id="alertContainer"></div>

            <!-- Profile Information Section -->
            <div class="profile-info-section">
                <h3 class="info-title">📋 Informations du profil</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Nom complet</span>
                        <span class="info-value" id="displayName">${sessionScope.user_name}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value" id="displayEmail">${sessionScope.user_email}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Rôle</span>
                        <span class="info-value">
                            <span class="badge role-${sessionScope.user_role}" id="displayRole">${sessionScope.user_role}</span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Institution</span>
                        <span class="info-value" id="displayInstitution">Chargement...</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Date d'inscription</span>
                        <span class="info-value" id="displayCreatedAt">Chargement...</span>
                    </div>
                </div>
            </div>

            <!-- Edit Form Section -->
            <div class="edit-form-section">
                <h3 class="info-title">✏️ Modifier mes informations</h3>
                <form id="editProfileForm">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="editName" class="required">Nom complet</label>
                            <input type="text" 
                                   id="editName" 
                                   name="name" 
                                   class="form-control" 
                                   placeholder="Votre nom complet"
                                   required
                                   minlength="2"
                                   maxlength="100">
                            <small>Minimum 2 caractères</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="editInstitution">Institution</label>
                            <input type="text" 
                                   id="editInstitution" 
                                   name="institution" 
                                   class="form-control" 
                                   placeholder="Votre institution"
                                   maxlength="200">
                            <small>Optionnel</small>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn-primary" id="saveButton">
                            Enregistrer les modifications
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<!-- API JavaScript -->
<script src="${pageContext.request.contextPath}/js/api.js"></script>

<script>
    // User data from session
    const userEmail = '${sessionScope.user_email}';
    const userName = '${sessionScope.user_name}';
    const userRole = '${sessionScope.user_role}';
    
    let currentUser = null;
    
    // Load user data on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadUserData();
        setupFormSubmit();
    });
    
    /**
     * Load user data from API
     */
    async function loadUserData() {
        try {
            showLoading();
            
            // Fetch user by email
            currentUser = await API.getUserByEmail(userEmail);
            
            if (currentUser) {
                populateUserData(currentUser);
                populateEditForm(currentUser);
            } else {
                showError('Impossible de charger les données utilisateur');
            }
        } catch (error) {
            console.error('Error loading user data:', error);
            showError('Erreur lors du chargement des données: ' + error.message);
            
            // Use session data as fallback
            populateFallbackData();
        }
    }
    
    /**
     * Populate user data in the display section
     */
    function populateUserData(user) {
        // Update profile header
        document.getElementById('profileName').textContent = user.name || userName;
        document.getElementById('profileEmail').textContent = user.email || userEmail;
        
        // Update avatar initials
        if (user.name) {
            const initials = user.name.split(' ')
                .map(word => word.charAt(0))
                .join('')
                .substring(0, 2)
                .toUpperCase();
            document.getElementById('profileAvatar').textContent = initials;
        }
        
        // Update info section
        document.getElementById('displayName').textContent = user.name || 'Non renseigné';
        document.getElementById('displayEmail').textContent = user.email || userEmail;
        document.getElementById('displayInstitution').textContent = user.institution || 'Non renseignée';
        
        // Format and display creation date
        if (user.createdAt) {
            const date = new Date(user.createdAt);
            const formattedDate = date.toLocaleDateString('fr-FR', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            document.getElementById('displayCreatedAt').textContent = formattedDate;
        } else {
            document.getElementById('displayCreatedAt').textContent = 'Non disponible';
        }
        
        hideLoading();
    }
    
    /**
     * Populate edit form with current data
     */
    function populateEditForm(user) {
        document.getElementById('editName').value = user.name || '';
        document.getElementById('editInstitution').value = user.institution || '';
    }
    
    /**
     * Use session data as fallback
     */
    function populateFallbackData() {
        document.getElementById('displayInstitution').textContent = 'Non renseignée';
        document.getElementById('displayCreatedAt').textContent = 'Non disponible';
        
        document.getElementById('editName').value = userName || '';
        document.getElementById('editInstitution').value = '';
        
        hideLoading();
    }
    
    /**
     * Setup form submission
     */
    function setupFormSubmit() {
        const form = document.getElementById('editProfileForm');
        
        form.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            if (!currentUser || !currentUser.id) {
                showError('Impossible de mettre à jour le profil: utilisateur non chargé');
                return;
            }
            
            const formData = {
                name: document.getElementById('editName').value.trim(),
                institution: document.getElementById('editInstitution').value.trim()
            };
            
            // Validation
            if (!formData.name || formData.name.length < 2) {
                showError('Le nom doit contenir au moins 2 caractères');
                return;
            }
            
            await updateUserProfile(currentUser.id, formData);
        });
    }
    
    /**
     * Update user profile via API
     */
    async function updateUserProfile(userId, formData) {
        const saveButton = document.getElementById('saveButton');
        
        try {
            // Disable button and show loading
            saveButton.disabled = true;
            saveButton.innerHTML = '<span class="loading-spinner"></span>Enregistrement...';
            
            // Prepare update data - only send fields that should be updated
            const updateData = {
                name: formData.name,
                institution: formData.institution || null
            };
            
            // Call API
            const updatedUser = await API.updateUser(userId, updateData);
            
            // Update current user data
            currentUser = updatedUser;
            
            // Update display
            populateUserData(updatedUser);
            
            // Show success message
            showSuccess('✅ Profil mis à jour avec succès!');
            
            // Scroll to top to show message
            window.scrollTo({ top: 0, behavior: 'smooth' });
            
        } catch (error) {
            console.error('Error updating profile:', error);
            showError('❌ Erreur lors de la mise à jour: ' + error.message);
        } finally {
            // Re-enable button
            saveButton.disabled = false;
            saveButton.innerHTML = 'Enregistrer les modifications';
        }
    }
    
    /**
     * Show success message
     */
    function showSuccess(message) {
        const alertContainer = document.getElementById('alertContainer');
        alertContainer.innerHTML = `
            <div class="alert alert-success show">
                ${message}
            </div>
        `;
        
        // Auto-hide after 5 seconds
        setTimeout(() => {
            const alert = alertContainer.querySelector('.alert');
            if (alert) {
                alert.classList.remove('show');
                setTimeout(() => alertContainer.innerHTML = '', 300);
            }
        }, 5000);
    }
    
    /**
     * Show error message
     */
    function showError(message) {
        const alertContainer = document.getElementById('alertContainer');
        alertContainer.innerHTML = `
            <div class="alert alert-error show">
                ${message}
            </div>
        `;
        
        // Auto-hide after 7 seconds
        setTimeout(() => {
            const alert = alertContainer.querySelector('.alert');
            if (alert) {
                alert.classList.remove('show');
                setTimeout(() => alertContainer.innerHTML = '', 300);
            }
        }, 7000);
    }
    
    /**
     * Show loading state
     */
    function showLoading() {
        document.getElementById('displayInstitution').textContent = 'Chargement...';
        document.getElementById('displayCreatedAt').textContent = 'Chargement...';
    }
    
    /**
     * Hide loading state
     */
    function hideLoading() {
        // Loading states are replaced by actual data
    }
</script>

</body>
</html>
