<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Espace Candidat - ESMT Research Mapping</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f0f2f5;
            }

            /* Navbar */
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
            }

            .navbar-brand span {
                font-size: 28px;
            }

            .navbar-right {
                display: flex;
                align-items: center;
                gap: 25px;
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
                background: rgba(255, 255, 255, 0.3);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
            }

            .btn-logout {
                background: rgba(255, 255, 255, 0.2);
                color: white;
                padding: 8px 16px;
                border: 1px solid white;
                border-radius: 5px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s;
            }

            .btn-logout:hover {
                background: rgba(255, 255, 255, 0.3);
            }

            /* Main layout */
            .main-container {
                display: flex;
                min-height: calc(100vh - 70px);
            }

            /* Sidebar */
            .sidebar {
                width: 250px;
                background: white;
                border-right: 1px solid #e0e0e0;
                padding: 20px 0;
            }

            .sidebar-menu {
                list-style: none;
            }

            .sidebar-menu li {
                border-bottom: 1px solid #f0f0f0;
            }

            .sidebar-menu a {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 15px 25px;
                color: #555;
                text-decoration: none;
                transition: all 0.3s;
                cursor: pointer;
            }

            .sidebar-menu a:hover,
            .sidebar-menu a.active {
                background: #f0f2f5;
                color: #667eea;
                border-left: 4px solid #667eea;
                padding-left: 21px;
            }

            .sidebar-menu span {
                font-size: 16px;
            }

            /* Content */
            .content {
                flex: 1;
                padding: 30px;
                overflow-y: auto;
            }

            .page {
                display: none;
            }

            .page.active {
                display: block;
            }

            /* Header */
            .page-header {
                margin-bottom: 30px;
            }

            .page-header h1 {
                color: #003d82;
                font-size: 28px;
                margin-bottom: 10px;
            }

            .page-header p {
                color: #999;
            }

            /* Cards */
            .card {
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            .card h2 {
                color: #003d82;
                margin-bottom: 20px;
                font-size: 20px;
            }

            /* Stats Grid */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 10px;
                text-align: center;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
                transition: transform 0.3s;
            }

            .stat-card:hover {
                transform: translateY(-5px);
            }

            .stat-card .value {
                font-size: 32px;
                font-weight: 700;
                margin: 10px 0;
            }

            .stat-card .label {
                font-size: 14px;
                opacity: 0.9;
            }

            /* Charts */
            .charts-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
                gap: 20px;
            }

            .chart-container {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                position: relative;
                height: 400px;
            }

            .chart-container h3 {
                color: #003d82;
                margin-bottom: 20px;
            }

            /* Project Card */
            .project-card {
                background: white;
                border: 1px solid #e0e0e0;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 15px;
                transition: all 0.3s;
            }

            .project-card:hover {
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                border-color: #667eea;
            }

            .project-header {
                display: flex;
                justify-content: space-between;
                align-items: start;
                margin-bottom: 15px;
            }

            .project-title {
                color: #003d82;
                font-size: 18px;
                font-weight: 600;
            }

            .project-domain {
                background: #667eea;
                color: white;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .project-description {
                color: #666;
                margin-bottom: 15px;
                line-height: 1.6;
            }

            .project-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-bottom: 15px;
                font-size: 14px;
            }

            .project-info-item {
                border-left: 3px solid #667eea;
                padding-left: 10px;
            }

            .project-info-label {
                color: #999;
                font-size: 12px;
            }

            .project-info-value {
                color: #003d82;
                font-weight: 600;
            }

            .progress-bar {
                background: #e0e0e0;
                height: 8px;
                border-radius: 4px;
                overflow: hidden;
                margin-top: 10px;
            }

            .progress-fill {
                background: linear-gradient(90deg, #667eea, #764ba2);
                height: 100%;
                transition: width 0.3s;
            }

            .project-actions {
                display: flex;
                gap: 10px;
                margin-top: 15px;
            }

            /* Table */
            .table-container {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            table th {
                background: #f5f5f5;
                color: #003d82;
                padding: 12px;
                text-align: left;
                font-weight: 600;
            }

            table td {
                padding: 12px;
                border-bottom: 1px solid #f0f0f0;
            }

            table tr:hover {
                background: #f9f9f9;
            }

            .status-badge {
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .status-en-cours {
                background: #d4edda;
                color: #155724;
            }

            .status-termine {
                background: #cfe2ff;
                color: #0c5de4;
            }

            .status-suspendu {
                background: #f8d7da;
                color: #842029;
            }

            /* Buttons */
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-block;
            }

            .btn-primary {
                background: #667eea;
                color: white;
            }

            .btn-primary:hover {
                background: #764ba2;
            }

            .btn-secondary {
                background: #ecf0f1;
                color: #333;
            }

            .btn-secondary:hover {
                background: #bdc3c7;
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn-success:hover {
                background: #218838;
            }

            .btn-danger {
                background: #dc3545;
                color: white;
            }

            .btn-danger:hover {
                background: #c82333;
            }

            .btn-small {
                padding: 6px 12px;
                font-size: 12px;
            }

            /* Form */
            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #555;
                font-weight: 600;
            }

            .form-group input,
            .form-group textarea,
            .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
            }

            .form-group textarea {
                min-height: 100px;
                resize: vertical;
            }

            .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
            }

            /* Alert */
            .alert {
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-info {
                background: #d1ecf1;
                color: #0c5460;
                border: 1px solid #bee5eb;
            }

            /* Header Info */
            .header-info {
                background: linear-gradient(135deg, #f8f9ff 0%, #e8ecff 100%);
                padding: 20px;
                border-radius: 5px;
                border-left: 4px solid #667eea;
                margin-bottom: 20px;
            }

            .header-info p {
                margin: 8px 0;
                color: #555;
            }

            .header-info strong {
                color: #003d82;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #999;
            }

            .empty-state h3 {
                color: #555;
                margin-bottom: 10px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                    border-right: none;
                    border-bottom: 1px solid #e0e0e0;
                    display: flex;
                    overflow-x: auto;
                }

                .sidebar-menu {
                    display: flex;
                    width: 100%;
                }

                .sidebar-menu li {
                    border-bottom: none;
                    border-right: 1px solid #f0f0f0;
                }

                .sidebar-menu a {
                    padding: 15px 20px;
                    white-space: nowrap;
                }

                .charts-grid {
                    grid-template-columns: 1fr;
                }

                .stats-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .project-info {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>
        <!-- Navbar -->
        <div class="navbar">
            <div class="navbar-brand">
                <span>🔬</span>
                ESMT Research Mapping
            </div>
            <div class="navbar-right">
                <div class="user-info">
                    <div class="user-avatar" id="userAvatarNav">C</div>
                    <div>
                        <div style="font-size: 14px;">Bienvenue,</div>
                        <div style="font-weight: 600;" id="displayNameNav">Candidat</div>
                    </div>
                </div>
                <!-- ✅ FIX 1: Changé le onclick pour appeler la fonction logout() -->
                <button class="btn-logout" onclick="logout()">Se Déconnecter</button>
            </div>
        </div>

        <!-- Main Container -->
        <div class="main-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <ul class="sidebar-menu">
                    <li><a class="nav-link active" data-page="dashboard" onclick="showPage('dashboard', event)">
                            <span>📊</span> Accueil
                        </a></li>
                    <li><a class="nav-link" data-page="mes-projets" onclick="showPage('mes-projets', event)">
                            <span>📁</span> Mes Projets
                        </a></li>
                    <li><a class="nav-link" data-page="nouveau-projet" onclick="showPage('nouveau-projet', event)">
                            <span>➕</span> Nouveau Projet
                        </a></li>
                    <li><a class="nav-link" data-page="profil" onclick="showPage('profil', event)">
                            <span>👤</span> Mon Profil
                        </a></li>
                </ul>
            </div>

            <!-- Content -->
            <div class="content">
                <!-- Dashboard Page -->
                <div id="dashboard" class="page active">
                    <div class="page-header">
                        <h1>🎓 Espace Candidat</h1>
                        <p>Bienvenue sur la plateforme de cartographie des projets de recherche ESMT</p>
                    </div>

                    <div class="header-info">
                        <p><strong>📧 Email :</strong> <span id="userEmail">candidat@esmt.sn</span></p>
                        <p><strong>👤 Nom :</strong> <span id="userNom">Candidat</span></p>
                        <p><strong>🏢 Institution :</strong> <span id="userInstitution">ESMT</span></p>
                    </div>

                    <div class="alert alert-info">
                        <strong>ℹ️ Information :</strong> Vous pouvez déclarer vos projets de recherche et suivre leur
                        avancement.
                        Seuls vos projets personnels vous sont visibles.
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="label">Mes Projets</div>
                            <div class="value" id="mesProjetCount">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">En Cours</div>
                            <div class="value" id="projetEnCoursCount">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">Terminés</div>
                            <div class="value" id="projetTermineCount">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">Budget Total</div>
                            <div class="value" id="budgetTotal">0 F</div>
                        </div>
                    </div>

                    <div class="card">
                        <h2>📊 Résumé de Vos Projets</h2>
                        <div class="charts-grid">
                            <div class="chart-container">
                                <h3>Status de vos projets</h3>
                                <canvas id="statusChart"></canvas>
                            </div>
                            <div class="chart-container">
                                <h3>Taux d'avancement</h3>
                                <canvas id="progressChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <h2>📝 Mes Projets Récents</h2>
                        <div id="recentProjects"></div>
                    </div>
                </div>

                <!-- Mes Projets Page -->
                <div id="mes-projets" class="page">
                    <div class="page-header">
                        <h1>📁 Mes Projets</h1>
                        <p>Consultez et gérez vos projets de recherche</p>
                    </div>

                    <!-- ✅ FIX 2: Changé onclick pour utiliser showPage au lieu de href="#" -->
                    <button class="btn btn-primary" onclick="showPage('nouveau-projet', event)">
                        ➕ Ajouter un Nouveau Projet
                    </button>

                    <div id="projectsList" style="margin-top: 20px;">
                        <div class="empty-state">
                            <h3>Aucun projet déclaré</h3>
                            <p>Créez votre premier projet pour le partager avec la communauté de recherche</p>
                        </div>
                    </div>
                </div>

                <!-- Nouveau Projet Page -->
                <div id="nouveau-projet" class="page">
                    <div class="page-header">
                        <h1>➕ Déclarer un Nouveau Projet</h1>
                        <p>Complétez les informations de votre projet de recherche</p>
                    </div>

                    <div class="card">
                        <h2>Formulaire de Déclaration</h2>
                        <form onsubmit="saveProject(event)">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Titre du Projet *</label>
                                    <input type="text" id="projectTitle" required
                                        placeholder="Ex: Intelligence Artificielle pour la diagnostic médical">
                                </div>
                                <div class="form-group">
                                    <label>Domaine de Recherche *</label>
                                    <select id="projectDomain" required>
                                        <option value="">-- Sélectionner --</option>
                                        <option value="IA">Intelligence Artificielle</option>
                                        <option value="Santé">Santé</option>
                                        <option value="Énergie">Énergie</option>
                                        <option value="Télécoms">Télécommunications</option>
                                        <option value="Autre">Autre</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Description du Projet *</label>
                                <textarea id="projectDescription" required
                                    placeholder="Décrivez votre projet en détail..."></textarea>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Date de Début *</label>
                                    <input type="date" id="projectStartDate" required>
                                </div>
                                <div class="form-group">
                                    <label>Date de Fin Prévue *</label>
                                    <input type="date" id="projectEndDate" required>
                                </div>
                                <div class="form-group">
                                    <label>Budget Estimé (FCFA) *</label>
                                    <input type="number" id="projectBudget" required placeholder="0" min="0">
                                </div>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Institution *</label>
                                    <input type="text" id="projectInstitution" required placeholder="Ex: ESMT">
                                </div>
                                <div class="form-group">
                                    <label>Statut *</label>
                                    <select id="projectStatus" required>
                                        <option value="EN_COURS">En Cours</option>
                                        <option value="PLANIFIE">Planifié</option>
                                        <option value="SUSPENDU">Suspendu</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Taux d'Avancement (%) *</label>
                                    <input type="number" id="projectProgress" required placeholder="0" min="0" max="100"
                                        value="0">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Participants</label>
                                <input type="text" id="projectParticipants"
                                    placeholder="Ex: Chercheur 1, Chercheur 2, ...">
                            </div>

                            <div style="display: flex; gap: 10px;">
                                <button type="submit" class="btn btn-success">💾 Enregistrer le Projet</button>
                                <button type="reset" class="btn btn-secondary">🔄 Réinitialiser</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Profil Page -->
                <div id="profil" class="page">
                    <div class="page-header">
                        <h1>👤 Mon Profil</h1>
                        <p>Gestion de vos informations personnelles</p>
                    </div>

                    <div class="card">
                        <h2>Informations Personnelles</h2>
                        <div class="header-info">
                            <p><strong>📧 Email :</strong> <span id="profileEmail">candidat@esmt.sn</span></p>
                            <p><strong>👤 Nom Complet :</strong> <span id="profileNom">Candidat</span></p>
                            <p><strong>🏢 Institution :</strong> <span id="profileInstitution">ESMT</span></p>
                            <p><strong>📅 Inscrit depuis :</strong> <span id="profileDate">2026-02-16</span></p>
                        </div>
                    </div>

                    <div class="card">
                        <h2>Modifier Mon Profil</h2>
                        <form onsubmit="updateProfile(event)">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Nom Complet</label>
                                    <input type="text" id="editNom" placeholder="Votre nom complet">
                                </div>
                                <div class="form-group">
                                    <label>Institution</label>
                                    <input type="text" id="editInstitution" placeholder="Votre institution">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Spécialité / Domaine</label>
                                <input type="text" id="editSpecialite" placeholder="Votre domaine de spécialité">
                            </div>

                            <button type="submit" class="btn btn-primary">💾 Enregistrer les modifications</button>
                        </form>
                    </div>

                    <div class="card">
                        <h2>Sécurité</h2>
                        <button class="btn btn-primary" onclick="changePassword()">🔐 Changer mon mot de passe</button>
                    </div>

                    <div class="card">
                        <h2>Aide & Support</h2>
                        <p>Pour toute question ou assistance, contactez:</p>
                        <p><strong>Email :</strong> support@esmt.sn</p>
                        <p><strong>Téléphone :</strong> 77 656 84 51 – 77 836 12 12</p>
                    </div>
                </div>
            </div>
        </div>

        ...
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            let charts = {};
            let mesProjets = [];

            // ✅ DÉFINIR LA FONCTION LOGOUT AU DÉBUT
            // ✅ DÉFINIR LA FONCTION LOGOUT AU DÉBUT
            function logout() {
                console.log('📤 Tentative de déconnexion...');
                if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
                    // Pour OAuth2/Session, on appelle l'endpoint de logout du serveur
                    window.location.href = '/logout';
                }
            }

            // ✅ PUIS DÉFINIR LES AUTRES FONCTIONS
            function showPage(pageId, event) {
                if (event) event.preventDefault();

                document.querySelectorAll('.page').forEach(page => {
                    page.classList.remove('active');
                });

                document.querySelectorAll('.nav-link').forEach(link => {
                    link.classList.remove('active');
                });

                document.getElementById(pageId).classList.add('active');

                const navLink = document.querySelector(`[data-page="${pageId}"]`);
                if (navLink) navLink.classList.add('active');
            }

            function saveProject(event) {
                event.preventDefault();

                const newProject = {
                    titreProjet: document.getElementById('projectTitle').value,
                    domaineId: null, // À gérer si on a les IDs des domaines, sinon envoyer le nom si le DTO le supporte
                    domaineNom: document.getElementById('projectDomain').value, // On enverra le nom pour le mapping
                    description: document.getElementById('projectDescription').value,
                    dateDebut: document.getElementById('projectStartDate').value,
                    dateFin: document.getElementById('projectEndDate').value,
                    budgetEstime: parseFloat(document.getElementById('projectBudget').value),
                    statutProjet: document.getElementById('projectStatus').value,
                    niveauAvancement: parseInt(document.getElementById('projectProgress').value),
                    institution: document.getElementById('projectInstitution').value
                };

                // Mapping manuel du domaine ID si possible ou modification du backend pour accepter le nom
                // Pour l'instant, faisons simple: supposons que le backend peut trouver le domaine par ID ou Nom
                // Le DTO a domaineId. Le select a des valeurs textuelles (IA, Santé...). 
                // Il faudrait des IDs dans les values du select options.
                // CORRECTION: Le backend attend domaineId. Le select doit avoir des IDs.
                // On va hardcoder les IDs pour l'instant correspondant au DataInitializer:
                // IA=1, Santé=2, Énergie=3, Télécoms=4

                const domaines = {
                    "IA": 1,
                    "Santé": 2,
                    "Énergie": 3,
                    "Télécoms": 4,
                    "Autre": 1 // Fallback
                };
                newProject.domaineId = domaines[newProject.domaineNom] || 1;

                fetch('/api/projects', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(newProject)
                })
                    .then(response => {
                        if (response.ok) {
                            return response.json();
                        }
                        throw new Error('Erreur lors de la création');
                    })
                    .then(data => {
                        event.target.reset();
                        alert('✅ Projet créé avec succès!');
                        showPage('mes-projets');
                        loadProjectsData(); // Recharger la liste
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Erreur lors de la création du projet');
                    });
            }

            function editProject(id) {
                alert('Interface de modification du projet ' + id);
            }

            function deleteProject(id) {
                if (confirm('Êtes-vous sûr de vouloir supprimer ce projet ?')) {
                    mesProjets = mesProjets.filter(p => p.id !== id);
                    updateStats();
                    displayProjects();
                    alert('✅ Projet supprimé avec succès!');
                }
            }

            function updateProfile(event) {
                event.preventDefault();
                alert('✅ Profil mis à jour avec succès!');
            }

            function changePassword() {
                alert('Interface de changement de mot de passe');
            }

            // Initialize on page load
            window.addEventListener('DOMContentLoaded', function () {
                // Plus de vérification de token local. La session cookie gère l'auth.
                loadProjectsData();
                // initCharts is called after data load
            });

            // Load Projects Data
            function loadProjectsData() {
                fetch('/api/projects')
                    .then(response => response.json())
                    .then(data => {
                        // Mapper les DTOs backend vers le format attendu par le frontend si nécessaire
                        mesProjets = data.map(p => ({
                            id: p.projectId,
                            titre: p.titreProjet,
                            domaine: p.domaineNom || 'Non spécifié',
                            description: p.description,
                            dateDebut: p.dateDebut, // Peut nécessiter formatage
                            dateFin: p.dateFin,
                            budget: p.budgetEstime,
                            statut: p.statutProjet,
                            avancement: p.niveauAvancement,
                            institution: p.institution
                        }));

                        updateStats();
                        displayProjects();
                        initCharts(); // Re-init charts with new data
                    })
                    .catch(e => console.error("Erreur chargement projets", e));
            }

            // Update Stats
            function updateStats() {
                const enCours = mesProjets.filter(p => p.statut === 'EN_COURS').length;
                const termine = mesProjets.filter(p => p.statut === 'TERMINE').length;
                const budget = mesProjets.reduce((sum, p) => sum + p.budget, 0);

                document.getElementById('mesProjetCount').textContent = mesProjets.length;
                document.getElementById('projetEnCoursCount').textContent = enCours;
                document.getElementById('projetTermineCount').textContent = termine;
                document.getElementById('budgetTotal').textContent = (budget / 1000000).toFixed(0) + 'M F';
            }

            // Display Projects
            function displayProjects() {
                const container = document.getElementById('projectsList');

                if (mesProjets.length === 0) {
                    container.innerHTML = `
                        <div class="empty-state">
                            <h3>Aucun projet déclaré</h3>
                            <p>Créez votre premier projet pour le partager avec la communauté de recherche</p>
                        </div>
                    `;
                    return;
                }

                let html = '';
                mesProjets.forEach(projet => {
                    html += `
                        <div class="project-card">
                            <div class="project-header">
                                <div>
                                    <div class="project-title">${projet.titre}</div>
                                    <div style="margin-top: 5px;">
                                        <span class="project-domain">${projet.domaine}</span>
                                    </div>
                                </div>
                                <div>
                                    <span class="status-badge status-${projet.statut.toLowerCase()}">
                                        ${projet.statut}
                                    </span>
                                </div>
                            </div>

                            <div class="project-description">
                                ${projet.description}
                            </div>

                            <div class="project-info">
                                <div class="project-info-item">
                                    <div class="project-info-label">Début</div>
                                    <div class="project-info-value">${projet.dateDebut}</div>
                                </div>
                                <div class="project-info-item">
                                    <div class="project-info-label">Fin Prévue</div>
                                    <div class="project-info-value">${projet.dateFin}</div>
                                </div>
                                <div class="project-info-item">
                                    <div class="project-info-label">Budget</div>
                                    <div class="project-info-value">${(projet.budget / 1000000).toFixed(0)}M F</div>
                                </div>
                                <div class="project-info-item">
                                    <div class="project-info-label">Avancement</div>
                                    <div class="project-info-value">${projet.avancement}%</div>
                                </div>
                            </div>

                            <div class="progress-bar">
                                <div class="progress-fill" style="width: ${projet.avancement}%"></div>
                            </div>

                            <div class="project-actions">
                                <button class="btn btn-primary btn-small" onclick="editProject(${projet.id})">
                                    ✏️ Modifier
                                </button>
                                <button class="btn btn-danger btn-small" onclick="deleteProject(${projet.id})">
                                    🗑️ Supprimer
                                </button>
                            </div>
                        </div>
                    `;
                });

                container.innerHTML = html;
            }

            // Initialize Charts
            function initCharts() {
                const ctxStatus = document.getElementById('statusChart');
                if (ctxStatus) {
                    const enCours = mesProjets.filter(p => p.statut === 'EN_COURS').length;
                    const termine = mesProjets.filter(p => p.statut === 'TERMINE').length;

                    charts.status = new Chart(ctxStatus, {
                        type: 'doughnut',
                        data: {
                            labels: ['En Cours', 'Terminé'],
                            datasets: [{
                                data: [enCours, termine],
                                backgroundColor: [
                                    '#28a745',
                                    '#007bff'
                                ]
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'bottom'
                                }
                            }
                        }
                    });
                }

                const ctxProgress = document.getElementById('progressChart');
                if (ctxProgress) {
                    charts.progress = new Chart(ctxProgress, {
                        type: 'bar',
                        data: {
                            labels: mesProjets.map(p => p.titre.substring(0, 15) + '...'),
                            datasets: [{
                                label: 'Avancement (%)',
                                data: mesProjets.map(p => p.avancement),
                                backgroundColor: '#667eea'
                            }]
                        },
                        options: {
                            indexAxis: 'y',
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                }
                            },
                            scales: {
                                x: {
                                    max: 100
                                }
                            }
                        }
                    });
                }
            }
        </script>
    </body>

    </html>