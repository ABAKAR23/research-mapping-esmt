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
                        <p><strong>📧 Email :</strong> <span id="userEmail">admin@esmt.sn</span></p>
                        <p><strong>👤 Rôle :</strong> <span id="userRole">ADMIN</span></p>
                        <p><strong>🔑 ID Utilisateur :</strong> <span id="userId">1</span></p>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="label">Total Projets</div>
                            <div class="value" id="totalProjects">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">Utilisateurs</div>
                            <div class="value" id="totalUsers">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">Domaines</div>
                            <div class="value" id="totalDomains">0</div>
                        </div>
                        <div class="stat-card">
                            <div class="label">En Cours</div>
                            <div class="value" id="projectsInProgress">0</div>
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

                    <button class="btn btn-primary" onclick="toggleForm()">➕ Nouveau Projet</button>

                    <div id="projectForm" class="card" style="display: none; margin-top: 20px;">
                        <h2>Créer un Nouveau Projet</h2>
                        <form onsubmit="saveProject(event)">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Titre du Projet</label>
                                    <input type="text" id="projectTitle" required>
                                </div>
                                <div class="form-group">
                                    <label>Domaine</label>
                                    <select id="projectDomain" required>
                                        <option value="">Sélectionner...</option>
                                        <option value="IA">Intelligence Artificielle</option>
                                        <option value="Santé">Santé</option>
                                        <option value="Énergie">Énergie</option>
                                        <option value="Télécoms">Télécommunications</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Description</label>
                                <textarea id="projectDescription" required></textarea>
                            </div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Date Début</label>
                                    <input type="date" id="projectStartDate" required>
                                </div>
                                <div class="form-group">
                                    <label>Date Fin</label>
                                    <input type="date" id="projectEndDate" required>
                                </div>
                                <div class="form-group">
                                    <label>Budget Estimé</label>
                                    <input type="number" id="projectBudget" required>
                                </div>
                                <div class="form-group">
                                    <label>Statut</label>
                                    <select id="projectStatus" required>
                                        <option value="EN_COURS">En Cours</option>
                                        <option value="TERMINE">Terminé</option>
                                        <option value="SUSPENDU">Suspendu</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">Enregistrer</button>
                            <button type="button" class="btn btn-secondary" onclick="toggleForm()">Annuler</button>
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
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="projectsList">
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: #999;">Aucun projet créé</td>
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

                    <button class="btn btn-primary" onclick="showAddUserForm()">➕ Nouvel Utilisateur</button>

                    <div class="card" style="margin-top: 20px;">
                        <h2>Liste des Utilisateurs</h2>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Email</th>
                                        <th>Rôle</th>
                                        <th>Institution</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="usersList">
                                    <tr>
                                        <td>admin@esmt.sn</td>
                                        <td><span class="status-badge status-en-cours">ADMIN</span></td>
                                        <td>ESMT</td>
                                        <td><button class="btn btn-small btn-secondary">Éditer</button></td>
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

                    <button class="btn btn-primary" onclick="showAddDomainForm()">➕ Nouveau Domaine</button>

                    <div class="card" style="margin-top: 20px;">
                        <h2>Domaines Disponibles</h2>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Nom</th>
                                        <th>Description</th>
                                        <th>Projets</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="domainsList">
                                    <tr>
                                        <td>Intelligence Artificielle</td>
                                        <td>Recherche en IA et Machine Learning</td>
                                        <td>0</td>
                                        <td><button class="btn btn-small btn-secondary">Éditer</button></td>
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

                    <!--
                <div class="charts-grid" style="grid-template-columns: 1fr;">
                    <div class="chart-container" style="height: 500px;">
                        <h3>📅 Évolution Temporelle des Projets</h3>
                        <canvas id="timelineChart"></canvas>
                    </div>
                </div>
                -->

                    <div class="charts-grid">
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
                            <p><strong>Email :</strong> <span id="settingsEmail">admin@esmt.sn</span></p>
                            <p><strong>Rôle :</strong> <span id="settingsRole">ADMIN</span></p>
                            <p><strong>Inscrit depuis :</strong> <span id="settingsDate">2026-02-16</span></p>
                        </div>
                        <button class="btn btn-primary" onclick="changePassword()">Changer le mot de passe</button>
                    </div>

                    <div class="card">
                        <h2>Paramètres du Système</h2>
                        <div class="form-group">
                            <label>
                                <input type="checkbox" checked> Notifications par email
                            </label>
                        </div>
                        <div class="form-group">
                            <label>
                                <input type="checkbox" checked> Rapports automatiques
                            </label>
                        </div>
                        <button class="btn btn-primary">Enregistrer les paramètres</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            let charts = {};

            // Initialize on page load
            window.addEventListener('DOMContentLoaded', function () {
                const token = localStorage.getItem('token');
                const user = localStorage.getItem('user');

                if (!document.cookie.includes('JSESSIONID') && !token) {
                    // Simple check, improper but better than redirecting if session cookie exists
                    // In reality, we just let the server redirect us if needed.
                    // window.location.href = '/login'; 
                }

                if (user) {
                    try {
                        // Check if user is string or object before parsing
                        const userData = (typeof user === 'string') ? JSON.parse(user) : user;
                        // ... rest of logic
                        document.getElementById('userEmail').textContent = userData.email || 'N/A';
                        document.getElementById('userRole').textContent = userData.role || 'N/A';
                        document.getElementById('userId').textContent = userData.userId || 'N/A';

                        const displayName = userData.email.split('@')[0] || 'Utilisateur';
                        document.getElementById('displayNameNav').textContent = displayName;
                        document.getElementById('userAvatarNav').textContent = displayName.charAt(0).toUpperCase();

                        document.getElementById('settingsEmail').textContent = userData.email;
                        document.getElementById('settingsRole').textContent = userData.role;
                    } catch (e) {
                        console.error('Erreur parsing user:', e);
                    }
                }

                loadStatistics();
                // initCharts called in loadStatistics
            });

            // Navigation
            function showPage(pageId, event) {
                event.preventDefault();

                // Hide all pages
                document.querySelectorAll('.page').forEach(page => {
                    page.classList.remove('active');
                });

                // Remove active class from all nav links
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.classList.remove('active');
                });

                // Show selected page
                document.getElementById(pageId).classList.add('active');
                event.target.closest('.nav-link').classList.add('active');

                // Re-initialize charts if needed
                if (pageId === 'statistics') {
                    setTimeout(() => {
                        if (charts.timeline) charts.timeline.resize();
                    }, 100);
                }
            }

            // Load Statistics
            function loadStatistics() {
                fetch('/api/statistics')
                    .then(response => response.json())
                    .then(stats => {
                        document.getElementById('totalProjects').textContent = stats.totalProjets;
                        document.getElementById('totalUsers').textContent = '-'; // Not in DTO
                        document.getElementById('totalDomains').textContent = Object.keys(stats.projetsParDomaine).length;

                        const enCours = stats.projetsParStatut['EN_COURS'] || 0;
                        document.getElementById('projectsInProgress').textContent = enCours;

                        initCharts(stats);
                    })
                    .catch(e => console.error("Erreur stats", e));
            }

            // Initialize Charts
            function initCharts(stats) {
                if (!stats) return;

                // Domain Chart
                const ctxDomaine = document.getElementById('domaineChart');
                if (ctxDomaine) {
                    if (charts.domaine) charts.domaine.destroy();
                    charts.domaine = new Chart(ctxDomaine, {
                        type: 'bar',
                        data: {
                            labels: Object.keys(stats.projetsParDomaine),
                            datasets: [{
                                label: 'Nombre de Projets',
                                data: Object.values(stats.projetsParDomaine),
                                backgroundColor: '#667eea'
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: false }
                    });
                }

                // Status Chart
                const ctxStatus = document.getElementById('statusChart');
                if (ctxStatus) {
                    if (charts.status) charts.status.destroy();
                    charts.status = new Chart(ctxStatus, {
                        type: 'doughnut',
                        data: {
                            labels: Object.keys(stats.projetsParStatut),
                            datasets: [{
                                data: Object.values(stats.projetsParStatut),
                                backgroundColor: ['#28a745', '#007bff', '#dc3545', '#ffc107']
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: false }
                    });
                }

                // Participants Chart
                const ctxParticipants = document.getElementById('participantsChart');
                if (ctxParticipants) {
                    if (charts.participants) charts.participants.destroy();
                    charts.participants = new Chart(ctxParticipants, {
                        type: 'bar',
                        indexAxis: 'y',
                        data: {
                            labels: Object.keys(stats.projetsParParticipant),
                            datasets: [{
                                label: 'Projets',
                                data: Object.values(stats.projetsParParticipant),
                                backgroundColor: '#667eea'
                            }]
                        },
                        options: { indexAxis: 'y', responsive: true, maintainAspectRatio: false }
                    });
                }

                // Budget Chart
                const ctxBudget = document.getElementById('budgetChart');
                if (ctxBudget) {
                    if (charts.budget) charts.budget.destroy();
                    charts.budget = new Chart(ctxBudget, {
                        type: 'pie',
                        data: {
                            labels: Object.keys(stats.budgetParDomaine),
                            datasets: [{
                                data: Object.values(stats.budgetParDomaine),
                                backgroundColor: ['#667eea', '#764ba2', '#f093fb', '#4facfe']
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: false }
                    });
                }
            }

            // Project Functions
            function toggleForm() {
                const form = document.getElementById('projectForm');
                form.style.display = form.style.display === 'none' ? 'block' : 'none';
            }

            function saveProject(event) {
                event.preventDefault();
                alert('Projet enregistré avec succès!');
                toggleForm();
            }

            function showAddUserForm() {
                alert('Formulaire d\'ajout utilisateur');
            }

            function showAddDomainForm() {
                alert('Formulaire d\'ajout domaine');
            }

            function changePassword() {
                alert('Interface de changement de mot de passe');
            }

            // Logout
            function logout() {
                if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
                    window.location.href = '/logout';
                }
            }
        </script>
    </body>

    </html>