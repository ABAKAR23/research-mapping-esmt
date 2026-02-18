<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tableau de Bord - ESMT Research Mapping</title>
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
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
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

            .status-en-cours,
            .status-EN_COURS {
                background: #d4edda;
                color: #155724;
            }

            .status-termine,
            .status-TERMINE {
                background: #cfe2ff;
                color: #0c5de4;
            }

            .status-suspendu,
            .status-SUSPENDU {
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

            .btn-danger {
                background: #dc3545;
                color: white;
            }

            .btn-danger:hover {
                background: #c82333;
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn-success:hover {
                background: #218838;
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
                display: none;
            }

            .alert.show {
                display: block;
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-danger {
                background: #f8d7da;
                color: #842029;
                border: 1px solid #f5c6cb;
            }

            .alert-warning {
                background: #fff3cd;
                color: #856404;
                border: 1px solid #ffeeba;
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

            /* Modal */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 2000;
                justify-content: center;
                align-items: center;
            }

            .modal-overlay.show {
                display: flex;
            }

            .modal {
                background: white;
                border-radius: 10px;
                padding: 30px;
                width: 500px;
                max-width: 90%;
                max-height: 80vh;
                overflow-y: auto;
            }

            .modal h2 {
                color: #003d82;
                margin-bottom: 20px;
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
                }

                .charts-grid {
                    grid-template-columns: 1fr;
                }

                .stats-grid {
                    grid-template-columns: repeat(2, 1fr);
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
                    <div class="user-avatar" id="userAvatarNav">A</div>
                    <div>
                        <div style="font-size: 14px;">Bienvenue,</div>
                        <div style="font-weight: 600;" id="displayNameNav">Admin</div>
                    </div>
                </div>
                <button class="btn-logout" onclick="logout()">Se Déconnecter</button>
            </div>
        </div>

        <!-- Alert global -->
        <div id="globalAlert" class="alert" style="margin: 10px 30px;"></div>

        <!-- Main Container -->
        <div class="main-container">
            <!-- Sidebar -->
            <div class="sidebar">
                <ul class="sidebar-menu">
                    <li><a class="nav-link active" data-page="dashboard" onclick="showPage('dashboard', event)">
                            <span>📊</span> Tableau de Bord
                        </a></li>
                    <li><a class="nav-link" data-page="projects" onclick="showPage('projects', event)">
                            <span>📁</span> Projets
                        </a></li>
                    <li><a class="nav-link" data-page="users" onclick="showPage('users', event)">
                            <span>👥</span> Utilisateurs
                        </a></li>
                    <li><a class="nav-link" data-page="domains" onclick="showPage('domains', event)">
                            <span>🏷️</span> Domaines
                        </a></li>
                    <li><a class="nav-link" data-page="statistics" onclick="showPage('statistics', event)">
                            <span>📈</span> Statistiques
                        </a></li>
                    <li><a class="nav-link" href="/import">
                            <span>📥</span> Import CSV
                        </a></li>
                    <li><a class="nav-link" data-page="settings" onclick="showPage('settings', event)">
                            <span>⚙️</span> Paramètres
                        </a></li>
                </ul>
            </div>

            <!-- Content -->
            <div class="content">
                <!-- Dashboard Page -->
                <div id="dashboard" class="page active">
                    <div class="page-header">
                        <h1>🎯 Tableau de Bord Principal</h1>
                        <p>Vue d'ensemble de votre plateforme de cartographie des projets</p>
                    </div>

                    <div class="header-info">
                        <p><strong>📧 Email :</strong> <span id="userEmail">-</span></p>
                        <p><strong>👤 Rôle :</strong> <span id="userRole">-</span></p>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="label">Total Projets</div>
                            <div class="value" id="totalProjects">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">Budget Total</div>
                            <div class="value" id="totalBudget">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">Domaines</div>
                            <div class="value" id="totalDomains">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">En Cours</div>
                            <div class="value" id="projectsInProgress">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">Terminés</div>
                            <div class="value" id="projectsCompleted">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">Avancement Moyen</div>
                            <div class="value" id="avgProgress">0%</div>
                        </div>
                    </div>

                    <div class="charts-grid">
                        <div class="chart-container">
                            <h3>📊 Projets par Domaine</h3>
                            <canvas id="domaineChart"></canvas>
                        </div>
                        <div class="chart-container">
                            <h3>🔄 Statut des Projets</h3>
                            <canvas id="statusChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Projects Page -->
                <div id="projects" class="page">
                    <div class="page-header">
                        <h1>📁 Gestion des Projets</h1>
                        <p>Créer, modifier et supprimer les projets de recherche</p>
                    </div>

                    <button class="btn btn-primary" onclick="toggleProjectForm()">➕ Nouveau Projet</button>

                    <div id="projectForm" class="card" style="display: none; margin-top: 20px;">
                        <h2 id="projectFormTitle">Créer un Nouveau Projet</h2>
                        <form onsubmit="saveProject(event)">
                            <input type="hidden" id="editProjectId" value="">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Titre du Projet *</label>
                                    <input type="text" id="projectTitle" required>
                                </div>
                                <div class="form-group">
                                    <label>Domaine *</label>
                                    <select id="projectDomain" required>
                                        <option value="">Sélectionner...</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Description *</label>
                                <textarea id="projectDescription" required></textarea>
                            </div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Date Début *</label>
                                    <input type="date" id="projectStartDate" required>
                                </div>
                                <div class="form-group">
                                    <label>Date Fin</label>
                                    <input type="date" id="projectEndDate">
                                </div>
                                <div class="form-group">
                                    <label>Budget Estimé (FCFA)</label>
                                    <input type="number" id="projectBudget" min="0">
                                </div>
                                <div class="form-group">
                                    <label>Statut *</label>
                                    <select id="projectStatus" required>
                                        <option value="EN_COURS">En Cours</option>
                                        <option value="TERMINE">Terminé</option>
                                        <option value="SUSPENDU">Suspendu</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Institution</label>
                                    <input type="text" id="projectInstitution" value="ESMT">
                                </div>
                                <div class="form-group">
                                    <label>Avancement (%)</label>
                                    <input type="number" id="projectProgress" min="0" max="100" value="0">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Participants (sélection multiple)</label>
                                <select id="projectParticipants" multiple style="height: 100px;">
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success">💾 Enregistrer</button>
                            <button type="button" class="btn btn-secondary"
                                onclick="toggleProjectForm()">Annuler</button>
                        </form>
                    </div>

                    <div class="card" style="margin-top: 20px;">
                        <h2>Liste des Projets</h2>
                        <div class="table-container">
                            <table id="projectsTable">
                                <thead>
                                    <tr>
                                        <th>Titre</th>
                                        <th>Domaine</th>
                                        <th>Statut</th>
                                        <th>Budget</th>
                                        <th>Avancement</th>
                                        <th>Responsable</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="projectsList">
                                    <tr>
                                        <td colspan="7" style="text-align: center; color: #999;">Chargement...</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Users Page -->
                <div id="users" class="page">
                    <div class="page-header">
                        <h1>👥 Gestion des Utilisateurs</h1>
                        <p>Administrer les utilisateurs et leurs rôles</p>
                    </div>

                    <button class="btn btn-primary" onclick="showUserModal()">➕ Nouvel Utilisateur</button>

                    <div class="card" style="margin-top: 20px;">
                        <h2>Liste des Utilisateurs</h2>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Nom</th>
                                        <th>Email</th>
                                        <th>Rôle</th>
                                        <th>Institution</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="usersList">
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: #999;">Chargement...</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Domains Page -->
                <div id="domains" class="page">
                    <div class="page-header">
                        <h1>🏷️ Domaines de Recherche</h1>
                        <p>Gérer les domaines de recherche</p>
                    </div>

                    <button class="btn btn-primary" onclick="showDomainModal()">➕ Nouveau Domaine</button>

                    <div class="card" style="margin-top: 20px;">
                        <h2>Domaines Disponibles</h2>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Nom</th>
                                        <th>Description</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="domainsList">
                                    <tr>
                                        <td colspan="3" style="text-align: center; color: #999;">Chargement...</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Statistics Page -->
                <div id="statistics" class="page">
                    <div class="page-header">
                        <h1>📈 Statistiques Avancées</h1>
                        <p>Analyse détaillée de vos projets</p>
                    </div>

                    <div class="charts-grid" style="grid-template-columns: 1fr;">
                        <div class="chart-container" style="height: 500px;">
                            <h3>📅 Évolution Temporelle des Projets</h3>
                            <canvas id="timelineChart"></canvas>
                        </div>
                    </div>

                    <div class="charts-grid" style="margin-top: 20px;">
                        <div class="chart-container">
                            <h3>👥 Charge des Participants</h3>
                            <canvas id="participantsChart"></canvas>
                        </div>
                        <div class="chart-container">
                            <h3>💰 Budget par Domaine</h3>
                            <canvas id="budgetChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Settings Page -->
                <div id="settings" class="page">
                    <div class="page-header">
                        <h1>⚙️ Paramètres</h1>
                        <p>Configuration du système</p>
                    </div>

                    <div class="card">
                        <h2>Mon Profil</h2>
                        <div class="header-info">
                            <p><strong>Email :</strong> <span id="settingsEmail">-</span></p>
                            <p><strong>Rôle :</strong> <span id="settingsRole">-</span></p>
                        </div>
                    </div>

                    <div class="card">
                        <h2>Informations Système</h2>
                        <div class="header-info">
                            <p><strong>Version :</strong> 1.0.0</p>
                            <p><strong>API Docs :</strong> <a href="/swagger-ui.html" target="_blank">Swagger UI</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Utilisateur -->
        <div id="userModal" class="modal-overlay">
            <div class="modal">
                <h2 id="userModalTitle">Nouvel Utilisateur</h2>
                <form onsubmit="saveUser(event)">
                    <input type="hidden" id="editUserId" value="">
                    <div class="form-group">
                        <label>Nom *</label>
                        <input type="text" id="userNom" required>
                    </div>
                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email" id="userEmail2" required>
                    </div>
                    <div class="form-group" id="userPasswordGroup">
                        <label>Mot de passe *</label>
                        <input type="password" id="userPassword" required>
                    </div>
                    <div class="form-group">
                        <label>Institution</label>
                        <input type="text" id="userInstitution" value="ESMT">
                    </div>
                    <div class="form-group">
                        <label>Rôle *</label>
                        <select id="userRoleSelect" required>
                            <option value="3">CANDIDAT</option>
                            <option value="2">GESTIONNAIRE</option>
                            <option value="1">ADMIN</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success">💾 Enregistrer</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal('userModal')">Annuler</button>
                </form>
            </div>
        </div>

        <!-- Modal Domaine -->
        <div id="domainModal" class="modal-overlay">
            <div class="modal">
                <h2 id="domainModalTitle">Nouveau Domaine</h2>
                <form onsubmit="saveDomain(event)">
                    <input type="hidden" id="editDomainId" value="">
                    <div class="form-group">
                        <label>Nom du Domaine *</label>
                        <input type="text" id="domainNom" required>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea id="domainDescription"></textarea>
                    </div>
                    <button type="submit" class="btn btn-success">💾 Enregistrer</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal('domainModal')">Annuler</button>
                </form>
            </div>
        </div>

        <script>
            let charts = {};
            let allDomains = [];
            let allUsers = [];
            let allProjects = [];

            // ==================== INIT ====================
            window.addEventListener('DOMContentLoaded', function () {
                const user = localStorage.getItem('user');
                if (user) {
                    try {
                        const userData = (typeof user === 'string') ? JSON.parse(user) : user;
                        document.getElementById('userEmail').textContent = userData.email || 'N/A';
                        document.getElementById('userRole').textContent = userData.role || 'N/A';
                        document.getElementById('settingsEmail').textContent = userData.email;
                        document.getElementById('settingsRole').textContent = userData.role;

                        const displayName = (userData.email || '').split('@')[0] || 'Admin';
                        document.getElementById('displayNameNav').textContent = displayName;
                        document.getElementById('userAvatarNav').textContent = displayName.charAt(0).toUpperCase();
                    } catch (e) {
                        console.error('Erreur parsing user:', e);
                    }
                }

                loadAllData();
            });

            function loadAllData() {
                loadStatistics();
                loadProjects();
                loadUsers();
                loadDomains();
            }

            // ==================== NAVIGATION ====================
            function showPage(pageId, event) {
                if (event) event.preventDefault();
                document.querySelectorAll('.page').forEach(page => page.classList.remove('active'));
                document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
                document.getElementById(pageId).classList.add('active');
                if (event) {
                    const link = event.target.closest('.nav-link');
                    if (link) link.classList.add('active');
                }

                // Redimensionner les graphiques si nécessaire
                if (pageId === 'statistics') {
                    setTimeout(() => {
                        Object.values(charts).forEach(c => { if (c && c.resize) c.resize(); });
                    }, 100);
                }
            }

            // ==================== ALERT ====================
            function showAlert(message, type) {
                const alert = document.getElementById('globalAlert');
                alert.className = 'alert alert-' + type + ' show';
                alert.textContent = message;
                setTimeout(() => { alert.classList.remove('show'); }, 5000);
            }

            function closeModal(id) {
                document.getElementById(id).classList.remove('show');
            }

            // ==================== FORMAT ====================
            function formatBudget(amount) {
                if (!amount) return '0 FCFA';
                return new Intl.NumberFormat('fr-FR').format(amount) + ' FCFA';
            }

            function formatDate(dateStr) {
                if (!dateStr) return '-';
                return new Date(dateStr).toLocaleDateString('fr-FR');
            }

            // ==================== STATISTICS ====================
            function loadStatistics() {
                fetch('/api/statistics')
                    .then(response => response.json())
                    .then(stats => {
                        document.getElementById('totalProjects').textContent = stats.totalProjets || 0;
                        document.getElementById('totalBudget').textContent = formatBudget(stats.budgetTotal);
                        document.getElementById('totalDomains').textContent =
                            stats.projetsParDomaine ? Object.keys(stats.projetsParDomaine).length : 0;

                        const enCours = (stats.projetsParStatut && stats.projetsParStatut['EN_COURS']) || 0;
                        const termines = (stats.projetsParStatut && stats.projetsParStatut['TERMINE']) || 0;
                        document.getElementById('projectsInProgress').textContent = enCours;
                        document.getElementById('projectsCompleted').textContent = termines;
                        document.getElementById('avgProgress').textContent =
                            (stats.tauxMoyenAvancement || 0).toFixed(1) + '%';

                        initCharts(stats);
                    })
                    .catch(e => {
                        console.error("Erreur stats", e);
                        showAlert('Erreur lors du chargement des statistiques', 'danger');
                    });
            }

            // ==================== CHARTS ====================
            function initCharts(stats) {
                if (!stats) return;

                // Graphique 1 : Projets par Domaine (barres)
                const ctxDomaine = document.getElementById('domaineChart');
                if (ctxDomaine && stats.projetsParDomaine) {
                    if (charts.domaine) charts.domaine.destroy();
                    charts.domaine = new Chart(ctxDomaine, {
                        type: 'bar',
                        data: {
                            labels: Object.keys(stats.projetsParDomaine),
                            datasets: [{
                                label: 'Nombre de Projets',
                                data: Object.values(stats.projetsParDomaine),
                                backgroundColor: ['#667eea', '#764ba2', '#f093fb', '#4facfe', '#43e97b']
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: false }
                    });
                }

                // Graphique 2 : Statut des Projets (camembert)
                const ctxStatus = document.getElementById('statusChart');
                if (ctxStatus && stats.projetsParStatut) {
                    if (charts.status) charts.status.destroy();
                    charts.status = new Chart(ctxStatus, {
                        type: 'pie',
                        data: {
                            labels: Object.keys(stats.projetsParStatut).map(s => {
                                if (s === 'EN_COURS') return 'En Cours';
                                if (s === 'TERMINE') return 'Terminé';
                                if (s === 'SUSPENDU') return 'Suspendu';
                                return s;
                            }),
                            datasets: [{
                                data: Object.values(stats.projetsParStatut),
                                backgroundColor: ['#28a745', '#007bff', '#dc3545', '#ffc107']
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: false }
                    });
                }

                // Graphique 3 : Évolution Temporelle (courbe)
                const ctxTimeline = document.getElementById('timelineChart');
                if (ctxTimeline && stats.evolutionTemporelle) {
                    if (charts.timeline) charts.timeline.destroy();
                    const years = Object.keys(stats.evolutionTemporelle).sort();
                    charts.timeline = new Chart(ctxTimeline, {
                        type: 'line',
                        data: {
                            labels: years,
                            datasets: [{
                                label: 'Nombre de projets démarrés',
                                data: years.map(y => stats.evolutionTemporelle[y]),
                                borderColor: '#667eea',
                                backgroundColor: 'rgba(102, 126, 234, 0.1)',
                                fill: true,
                                tension: 0.3,
                                pointBackgroundColor: '#667eea',
                                pointRadius: 6,
                                pointHoverRadius: 8
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: { stepSize: 1 }
                                }
                            }
                        }
                    });
                }

                // Graphique 4 : Charge des Participants (barres horizontales)
                const ctxParticipants = document.getElementById('participantsChart');
                if (ctxParticipants && stats.projetsParParticipant) {
                    if (charts.participants) charts.participants.destroy();
                    charts.participants = new Chart(ctxParticipants, {
                        type: 'bar',
                        data: {
                            labels: Object.keys(stats.projetsParParticipant),
                            datasets: [{
                                label: 'Nombre de Projets',
                                data: Object.values(stats.projetsParParticipant),
                                backgroundColor: '#667eea'
                            }]
                        },
                        options: { indexAxis: 'y', responsive: true, maintainAspectRatio: false }
                    });
                }

                // Graphique Budget par Domaine
                const ctxBudget = document.getElementById('budgetChart');
                if (ctxBudget && stats.budgetParDomaine) {
                    if (charts.budget) charts.budget.destroy();
                    charts.budget = new Chart(ctxBudget, {
                        type: 'doughnut',
                        data: {
                            labels: Object.keys(stats.budgetParDomaine),
                            datasets: [{
                                data: Object.values(stats.budgetParDomaine),
                                backgroundColor: ['#667eea', '#764ba2', '#f093fb', '#4facfe', '#43e97b']
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: false }
                    });
                }
            }

            // ==================== PROJECTS ====================
            function loadProjects() {
                fetch('/api/projects')
                    .then(response => response.json())
                    .then(projects => {
                        allProjects = projects;
                        renderProjects(projects);
                    })
                    .catch(e => console.error("Erreur projets", e));
            }

            function renderProjects(projects) {
                const tbody = document.getElementById('projectsList');
                if (!projects || projects.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: #999;">Aucun projet</td></tr>';
                    return;
                }
                tbody.innerHTML = projects.map(p => `
                <tr>
                    <td><strong>${p.titreProjet || ''}</strong></td>
                    <td>${p.domaineNom || '-'}</td>
                    <td><span class="status-badge status-${p.statutProjet || ''}">${formatStatus(p.statutProjet)}</span></td>
                    <td>${formatBudget(p.budgetEstime)}</td>
                    <td>${p.niveauAvancement || 0}%</td>
                    <td>${p.responsableNom || '-'}</td>
                    <td>
                        <button class="btn btn-small btn-primary" onclick="editProject(${p.projectId})">✏️</button>
                        <button class="btn btn-small btn-danger" onclick="deleteProject(${p.projectId})">🗑️</button>
                    </td>
                </tr>
            `).join('');
            }

            function formatStatus(s) {
                if (s === 'EN_COURS') return 'En Cours';
                if (s === 'TERMINE') return 'Terminé';
                if (s === 'SUSPENDU') return 'Suspendu';
                return s || '-';
            }

            function toggleProjectForm() {
                const form = document.getElementById('projectForm');
                if (form.style.display === 'none') {
                    form.style.display = 'block';
                    document.getElementById('editProjectId').value = '';
                    document.getElementById('projectFormTitle').textContent = 'Créer un Nouveau Projet';
                    document.getElementById('projectTitle').value = '';
                    document.getElementById('projectDescription').value = '';
                    document.getElementById('projectStartDate').value = '';
                    document.getElementById('projectEndDate').value = '';
                    document.getElementById('projectBudget').value = '';
                    document.getElementById('projectStatus').value = 'EN_COURS';
                    document.getElementById('projectInstitution').value = 'ESMT';
                    document.getElementById('projectProgress').value = '0';
                    document.getElementById('projectDomain').value = '';
                    loadDomainsForSelect();
                    loadUsersForSelect();
                } else {
                    form.style.display = 'none';
                }
            }

            function loadDomainsForSelect() {
                fetch('/api/domains')
                    .then(r => r.json())
                    .then(domains => {
                        const select = document.getElementById('projectDomain');
                        select.innerHTML = '<option value="">Sélectionner...</option>';
                        domains.forEach(d => {
                            select.innerHTML += `<option value="${d.id}">${d.nomDomaine}</option>`;
                        });
                    })
                    .catch(e => console.error('Erreur domaines', e));
            }

            function loadUsersForSelect() {
                fetch('/api/users')
                    .then(r => r.json())
                    .then(users => {
                        const select = document.getElementById('projectParticipants');
                        select.innerHTML = '';
                        users.forEach(u => {
                            select.innerHTML += `<option value="${u.id}">${u.nom} (${u.email})</option>`;
                        });
                    })
                    .catch(e => console.error('Erreur users', e));
            }

            function saveProject(event) {
                event.preventDefault();
                const editId = document.getElementById('editProjectId').value;
                const participantsSelect = document.getElementById('projectParticipants');
                const selectedParticipants = Array.from(participantsSelect.selectedOptions).map(o => parseInt(o.value));

                const projectData = {
                    titreProjet: document.getElementById('projectTitle').value,
                    description: document.getElementById('projectDescription').value,
                    dateDebut: document.getElementById('projectStartDate').value,
                    dateFin: document.getElementById('projectEndDate').value || null,
                    statutProjet: document.getElementById('projectStatus').value,
                    budgetEstime: parseFloat(document.getElementById('projectBudget').value) || 0,
                    institution: document.getElementById('projectInstitution').value,
                    niveauAvancement: parseInt(document.getElementById('projectProgress').value) || 0,
                    domaineId: parseInt(document.getElementById('projectDomain').value) || null,
                    participantIds: selectedParticipants
                };

                const url = editId ? `/api/projects/${editId}` : '/api/projects';
                const method = editId ? 'PUT' : 'POST';

                fetch(url, {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(projectData)
                })
                    .then(response => {
                        if (!response.ok) throw new Error('Erreur serveur');
                        return response.json();
                    })
                    .then(data => {
                        showAlert(editId ? 'Projet modifié avec succès!' : 'Projet créé avec succès!', 'success');
                        toggleProjectForm();
                        loadProjects();
                        loadStatistics();
                    })
                    .catch(e => {
                        console.error('Erreur:', e);
                        showAlert('Erreur lors de l\'enregistrement du projet', 'danger');
                    });
            }

            function editProject(id) {
                const project = allProjects.find(p => p.projectId === id);
                if (!project) return;

                document.getElementById('projectForm').style.display = 'block';
                document.getElementById('editProjectId').value = id;
                document.getElementById('projectFormTitle').textContent = 'Modifier le Projet';
                document.getElementById('projectTitle').value = project.titreProjet || '';
                document.getElementById('projectDescription').value = project.description || '';
                document.getElementById('projectStartDate').value = project.dateDebut ? project.dateDebut.substring(0, 10) : '';
                document.getElementById('projectEndDate').value = project.dateFin ? project.dateFin.substring(0, 10) : '';
                document.getElementById('projectBudget').value = project.budgetEstime || '';
                document.getElementById('projectStatus').value = project.statutProjet || 'EN_COURS';
                document.getElementById('projectInstitution').value = project.institution || '';
                document.getElementById('projectProgress').value = project.niveauAvancement || 0;

                loadDomainsForSelect();
                loadUsersForSelect();

                setTimeout(() => {
                    if (project.domaineId) document.getElementById('projectDomain').value = project.domaineId;
                    if (project.participantIds) {
                        const select = document.getElementById('projectParticipants');
                        Array.from(select.options).forEach(opt => {
                            opt.selected = project.participantIds.includes(parseInt(opt.value));
                        });
                    }
                }, 500);
            }

            function deleteProject(id) {
                if (!confirm('Êtes-vous sûr de vouloir supprimer ce projet ?')) return;

                fetch(`/api/projects/${id}`, { method: 'DELETE' })
                    .then(response => {
                        if (!response.ok) throw new Error('Erreur');
                        showAlert('Projet supprimé avec succès!', 'success');
                        loadProjects();
                        loadStatistics();
                    })
                    .catch(e => {
                        console.error('Erreur:', e);
                        showAlert('Erreur lors de la suppression', 'danger');
                    });
            }

            // ==================== USERS ====================
            function loadUsers() {
                fetch('/api/users')
                    .then(response => response.json())
                    .then(users => {
                        allUsers = users;
                        renderUsers(users);
                    })
                    .catch(e => console.error("Erreur users", e));
            }

            function renderUsers(users) {
                const tbody = document.getElementById('usersList');
                if (!users || users.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="5" style="text-align: center; color: #999;">Aucun utilisateur</td></tr>';
                    return;
                }
                tbody.innerHTML = users.map(u => `
                <tr>
                    <td>${u.nom || '-'}</td>
                    <td>${u.email || '-'}</td>
                    <td><span class="status-badge status-en-cours">${u.roleLibelle || '-'}</span></td>
                    <td>${u.institution || '-'}</td>
                    <td>
                        <button class="btn btn-small btn-primary" onclick="editUser(${u.id})">✏️</button>
                        <button class="btn btn-small btn-danger" onclick="deleteUser(${u.id})">🗑️</button>
                    </td>
                </tr>
            `).join('');
            }

            function showUserModal(user) {
                document.getElementById('userModal').classList.add('show');
                document.getElementById('editUserId').value = '';
                document.getElementById('userModalTitle').textContent = 'Nouvel Utilisateur';
                document.getElementById('userNom').value = '';
                document.getElementById('userEmail2').value = '';
                document.getElementById('userPassword').value = '';
                document.getElementById('userInstitution').value = 'ESMT';
                document.getElementById('userRoleSelect').value = '3';
                document.getElementById('userPasswordGroup').style.display = 'block';
            }

            function editUser(id) {
                const user = allUsers.find(u => u.id === id);
                if (!user) return;
                document.getElementById('userModal').classList.add('show');
                document.getElementById('editUserId').value = id;
                document.getElementById('userModalTitle').textContent = 'Modifier l\'Utilisateur';
                document.getElementById('userNom').value = user.nom || '';
                document.getElementById('userEmail2').value = user.email || '';
                document.getElementById('userInstitution').value = user.institution || '';
                document.getElementById('userRoleSelect').value = user.roleId || '3';
                document.getElementById('userPasswordGroup').style.display = 'none';
                document.getElementById('userPassword').required = false;
            }

            function saveUser(event) {
                event.preventDefault();
                const editId = document.getElementById('editUserId').value;

                const userData = {
                    nom: document.getElementById('userNom').value,
                    email: document.getElementById('userEmail2').value,
                    institution: document.getElementById('userInstitution').value,
                    roleId: parseInt(document.getElementById('userRoleSelect').value)
                };

                let url, method;
                if (editId) {
                    url = `/api/users/${editId}`;
                    method = 'PUT';
                } else {
                    const password = document.getElementById('userPassword').value;
                    url = `/api/users?password=${encodeURIComponent(password)}`;
                    method = 'POST';
                }

                fetch(url, {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(userData)
                })
                    .then(response => {
                        if (!response.ok) throw new Error('Erreur');
                        return response.json();
                    })
                    .then(data => {
                        showAlert(editId ? 'Utilisateur modifié!' : 'Utilisateur créé!', 'success');
                        closeModal('userModal');
                        loadUsers();
                    })
                    .catch(e => {
                        console.error('Erreur:', e);
                        showAlert('Erreur lors de l\'enregistrement', 'danger');
                    });
            }

            function deleteUser(id) {
                if (!confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) return;

                fetch(`/api/users/${id}`, { method: 'DELETE' })
                    .then(response => {
                        if (!response.ok) throw new Error('Erreur');
                        showAlert('Utilisateur supprimé!', 'success');
                        loadUsers();
                    })
                    .catch(e => {
                        console.error('Erreur:', e);
                        showAlert('Erreur lors de la suppression', 'danger');
                    });
            }

            // ==================== DOMAINS ====================
            function loadDomains() {
                fetch('/api/domains')
                    .then(response => response.json())
                    .then(domains => {
                        allDomains = domains;
                        renderDomains(domains);
                    })
                    .catch(e => console.error("Erreur domaines", e));
            }

            function renderDomains(domains) {
                const tbody = document.getElementById('domainsList');
                if (!domains || domains.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="3" style="text-align: center; color: #999;">Aucun domaine</td></tr>';
                    return;
                }
                tbody.innerHTML = domains.map(d => `
                <tr>
                    <td><strong>${d.nomDomaine || '-'}</strong></td>
                    <td>${d.description || '-'}</td>
                    <td>
                        <button class="btn btn-small btn-primary" onclick="editDomain(${d.id})">✏️</button>
                        <button class="btn btn-small btn-danger" onclick="deleteDomain(${d.id})">🗑️</button>
                    </td>
                </tr>
            `).join('');
            }

            function showDomainModal() {
                document.getElementById('domainModal').classList.add('show');
                document.getElementById('editDomainId').value = '';
                document.getElementById('domainModalTitle').textContent = 'Nouveau Domaine';
                document.getElementById('domainNom').value = '';
                document.getElementById('domainDescription').value = '';
            }

            function editDomain(id) {
                const domain = allDomains.find(d => d.id === id);
                if (!domain) return;
                document.getElementById('domainModal').classList.add('show');
                document.getElementById('editDomainId').value = id;
                document.getElementById('domainModalTitle').textContent = 'Modifier le Domaine';
                document.getElementById('domainNom').value = domain.nomDomaine || '';
                document.getElementById('domainDescription').value = domain.description || '';
            }

            function saveDomain(event) {
                event.preventDefault();
                const editId = document.getElementById('editDomainId').value;

                const domainData = {
                    nomDomaine: document.getElementById('domainNom').value,
                    description: document.getElementById('domainDescription').value
                };

                const url = editId ? `/api/domains/${editId}` : '/api/domains';
                const method = editId ? 'PUT' : 'POST';

                fetch(url, {
                    method: method,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(domainData)
                })
                    .then(response => {
                        if (!response.ok) throw new Error('Erreur');
                        return response.json();
                    })
                    .then(data => {
                        showAlert(editId ? 'Domaine modifié!' : 'Domaine créé!', 'success');
                        closeModal('domainModal');
                        loadDomains();
                        loadStatistics();
                    })
                    .catch(e => {
                        console.error('Erreur:', e);
                        showAlert('Erreur lors de l\'enregistrement', 'danger');
                    });
            }

            function deleteDomain(id) {
                if (!confirm('Êtes-vous sûr de vouloir supprimer ce domaine ?')) return;

                fetch(`/api/domains/${id}`, { method: 'DELETE' })
                    .then(response => {
                        if (!response.ok) throw new Error('Erreur');
                        showAlert('Domaine supprimé!', 'success');
                        loadDomains();
                        loadStatistics();
                    })
                    .catch(e => {
                        console.error('Erreur:', e);
                        showAlert('Erreur lors de la suppression', 'danger');
                    });
            }

            // ==================== LOGOUT ====================
            function logout() {
                if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
                    localStorage.removeItem('token');
                    localStorage.removeItem('user');
                    window.location.href = '/logout';
                }
            }
        </script>
    </body>

    </html>