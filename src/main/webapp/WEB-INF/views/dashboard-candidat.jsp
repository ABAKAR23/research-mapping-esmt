<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Candidat - ESMT Research Mapping</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* Votre CSS existant reste identique */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; }

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
        .navbar-brand { display: flex; align-items: center; gap: 10px; font-size: 24px; font-weight: 700; }
        .navbar-brand span { font-size: 28px; }

        .navbar-right { display: flex; align-items: center; gap: 25px; }
        .user-info { display: flex; align-items: center; gap: 10px; }
        .user-avatar {
            width: 40px; height: 40px; border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            display: flex; align-items: center; justify-content: center;
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
        .btn-logout:hover { background: rgba(255, 255, 255, 0.3); }

        /* Layout */
        .main-container { display: flex; min-height: calc(100vh - 70px); }

        /* Sidebar */
        .sidebar { width: 250px; background: white; border-right: 1px solid #e0e0e0; padding: 20px 0; }
        .sidebar-menu { list-style: none; }
        .sidebar-menu li { border-bottom: 1px solid #f0f0f0; }

        .sidebar-menu a {
            display: flex; align-items: center; gap: 12px;
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
        .sidebar-menu span { font-size: 16px; }

        /* Content */
        .content { flex: 1; padding: 30px; overflow-y: auto; }
        .page { display: none; }
        .page.active { display: block; }

        /* Header */
        .page-header { margin-bottom: 30px; }
        .page-header h1 { color: #003d82; font-size: 28px; margin-bottom: 10px; }
        .page-header p { color: #999; }

        /* Cards */
        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .card h2 { color: #003d82; margin-bottom: 20px; font-size: 20px; }

        /* Stats */
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
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card .value { font-size: 32px; font-weight: 700; margin: 10px 0; }
        .stat-card .label { font-size: 14px; opacity: 0.9; }

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
        .chart-container h3 { color: #003d82; margin-bottom: 20px; }

        /* Status Badges */
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-en_cours { background: #28a745; color: white; }
        .status-termine { background: #007bff; color: white; }
        .status-suspendu { background: #dc3545; color: white; }
        .status-planifie { background: #ffc107; color: #333; }

        /* Project Card */
        .project-card {
            background: white;
            border: 1px solid #e0e0e0;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            transition: all 0.3s;
        }
        .project-card:hover { box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); border-color: #667eea; }

        .project-header { display: flex; justify-content: space-between; align-items: start; margin-bottom: 15px; }
        .project-title { color: #003d82; font-size: 18px; font-weight: 600; }
        .project-domain {
            background: #667eea;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            margin-top: 5px;
        }
        .project-description { color: #666; margin-bottom: 15px; line-height: 1.6; }

        .project-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
            font-size: 14px;
        }
        .project-info-item { border-left: 3px solid #667eea; padding-left: 10px; }
        .project-info-label { color: #999; font-size: 12px; }
        .project-info-value { color: #003d82; font-weight: 600; }

        .progress-bar { background: #e0e0e0; height: 8px; border-radius: 4px; overflow: hidden; margin-top: 10px; }
        .progress-fill { background: linear-gradient(90deg, #667eea, #764ba2); height: 100%; transition: width 0.3s; }

        .project-actions { display: flex; gap: 10px; margin-top: 15px; }

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
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #764ba2; }
        .btn-secondary { background: #ecf0f1; color: #333; }
        .btn-secondary:hover { background: #bdc3c7; }
        .btn-success { background: #28a745; color: white; }
        .btn-success:hover { background: #218838; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-danger:hover { background: #c82333; }
        .btn-small { padding: 6px 12px; font-size: 12px; }

        /* Form */
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #555; font-weight: 600; }
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
        }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }

        /* Alert */
        .alert { padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .alert-info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* Header Info */
        .header-info {
            background: linear-gradient(135deg, #f8f9ff 0%, #e8ecff 100%);
            padding: 20px;
            border-radius: 5px;
            border-left: 4px solid #667eea;
            margin-bottom: 20px;
        }
        .header-info p { margin: 8px 0; color: #555; }
        .header-info strong { color: #003d82; }

        /* Empty State */
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        .empty-state h3 { color: #555; margin-bottom: 10px; }

        /* Loading Spinner */
        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

        /* Template caché pour les projets */
        .template-hidden { display: none; }

        /* Responsive */
        @media (max-width: 768px) {
            .main-container { flex-direction: column; }
            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #e0e0e0;
                display: flex;
                overflow-x: auto;
            }
            .sidebar-menu { display: flex; width: 100%; }
            .sidebar-menu li { border-bottom: none; border-right: 1px solid #f0f0f0; }
            .sidebar-menu a { padding: 15px 20px; white-space: nowrap; }
            .charts-grid { grid-template-columns: 1fr; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .project-info { grid-template-columns: 1fr; }
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
            <button class="btn-logout" id="logoutBtn">Se Déconnecter</button>
        </div>
    </div>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a class="nav-link active" data-page="dashboard" href="#">📊 Accueil</a></li>
                <li><a class="nav-link" data-page="mes-projets" href="#">📁 Mes Projets</a></li>
                <li><a class="nav-link" data-page="nouveau-projet" href="#">➕ Nouveau Projet</a></li>
                <li><a class="nav-link" data-page="profil" href="#">👤 Mon Profil</a></li>
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
                    <strong>ℹ️ Information :</strong>
                    Vous pouvez déclarer vos projets de recherche et suivre leur avancement.
                    Seuls vos projets personnels vous sont visibles.
                </div>

                <div id="dashboardLoading" class="spinner" style="display: none;"></div>

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

                <button class="btn btn-primary" onclick="app.showPage('nouveau-projet')">
                    ➕ Ajouter un Nouveau Projet
                </button>

                <div id="projectsListLoading" class="spinner" style="display: none;"></div>
                <div id="projectsList" style="margin-top: 20px;"></div>
            </div>

            <!-- Nouveau Projet Page -->
            <div id="nouveau-projet" class="page">
                <div class="page-header">
                    <h1 id="formTitle">➕ Déclarer un Nouveau Projet</h1>
                    <p>Complétez les informations de votre projet de recherche</p>
                </div>

                <div id="formAlert" class="alert" style="display: none;"></div>

                <div class="card">
                    <h2 id="formSubtitle">Formulaire de Déclaration</h2>
                    <form id="projectForm">
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
                            <textarea id="projectDescription" required placeholder="Décrivez votre projet en détail..."></textarea>
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
                                    <option value="TERMINE">Terminé</option>
                                    <option value="SUSPENDU">Suspendu</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Taux d'Avancement (%) *</label>
                                <input type="number" id="projectProgress" required placeholder="0" min="0" max="100" value="0">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Participants</label>
                            <input type="text" id="projectParticipants" placeholder="Ex: Chercheur 1, Chercheur 2, ...">
                        </div>

                        <input type="hidden" id="editingProjectId" value="">

                        <div style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-success" id="submitBtn">💾 Enregistrer le Projet</button>
                            <button type="button" class="btn btn-secondary" id="cancelEditBtn" style="display: none;">❌ Annuler</button>
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
                    <form id="profileForm">
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
                    <button class="btn btn-primary" id="changePasswordBtn">🔐 Changer mon mot de passe</button>
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

    <!-- Template pour les projets (caché) -->
    <div id="projectTemplate" class="template-hidden">
        <div class="project-card">
            <div class="project-header">
                <div>
                    <div class="project-title"></div>
                    <div style="margin-top: 5px;">
                        <span class="project-domain"></span>
                    </div>
                </div>
                <div>
                    <span class="status-badge"></span>
                </div>
            </div>
            <div class="project-description"></div>
            <div class="project-info">
                <div class="project-info-item">
                    <div class="project-info-label">Début</div>
                    <div class="project-info-value start-date"></div>
                </div>
                <div class="project-info-item">
                    <div class="project-info-label">Fin Prévue</div>
                    <div class="project-info-value end-date"></div>
                </div>
                <div class="project-info-item">
                    <div class="project-info-label">Budget</div>
                    <div class="project-info-value budget"></div>
                </div>
                <div class="project-info-item">
                    <div class="project-info-label">Avancement</div>
                    <div class="project-info-value progress-value"></div>
                </div>
            </div>
            <div class="progress-bar">
                <div class="progress-fill"></div>
            </div>
            <div class="project-actions"></div>
        </div>
    </div>

    <script>
        // Constantes
        const DOMAINES_MAP = {
            "IA": 1,
            "Santé": 2,
            "Énergie": 3,
            "Télécoms": 4,
            "Autre": 5
        };

        const STATUTS_COLORS = {
            'EN_COURS': '#28a745',
            'TERMINE': '#007bff',
            'SUSPENDU': '#dc3545',
            'PLANIFIE': '#ffc107'
        };

        const STATUTS_LABELS = {
            'EN_COURS': 'En Cours',
            'TERMINE': 'Terminé',
            'SUSPENDU': 'Suspendu',
            'PLANIFIE': 'Planifié'
        };

        // Application object
        const app = {
            charts: {},
            mesProjets: [],
            editingId: null,

            // Initialisation
            init: function() {
                console.log('Initialisation de l\'application...');
                this.attachEvents();
                this.loadUserFromSession();
                this.loadProjectsData();
            },

            // Attachement des événements
            attachEvents: function() {
                console.log('Attachement des événements...');

                // Navigation - méthode 1: par dataset
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        const pageId = link.getAttribute('data-page');
                        console.log('Navigation vers:', pageId);
                        this.showPage(pageId);
                    });
                });

                // Navigation - méthode 2: par onclick (alternative)
                window.showPage = (pageId) => {
                    this.showPage(pageId);
                };

                // Déconnexion - correction: on utilise l'ID correct
                const logoutBtn = document.getElementById('logoutBtn');
                if (logoutBtn) {
                    console.log('Bouton déconnexion trouvé');
                    logoutBtn.addEventListener('click', (e) => {
                        e.preventDefault();
                        console.log('Clic sur déconnexion');
                        this.logout();
                    });
                } else {
                    console.error('Bouton déconnexion non trouvé!');
                }

                // Formulaire projet
                const projectForm = document.getElementById('projectForm');
                if (projectForm) {
                    projectForm.addEventListener('submit', (e) => {
                        e.preventDefault();
                        this.saveProject();
                    });
                }

                // Annuler édition
                const cancelEditBtn = document.getElementById('cancelEditBtn');
                if (cancelEditBtn) {
                    cancelEditBtn.addEventListener('click', () => {
                        this.cancelEdit();
                    });
                }

                // Reset formulaire
                if (projectForm) {
                    projectForm.addEventListener('reset', () => {
                        setTimeout(() => this.resetForm(), 0);
                    });
                }

                // Formulaire profil
                const profileForm = document.getElementById('profileForm');
                if (profileForm) {
                    profileForm.addEventListener('submit', (e) => {
                        e.preventDefault();
                        this.updateProfile();
                    });
                }

                // Changement mot de passe
                const changePasswordBtn = document.getElementById('changePasswordBtn');
                if (changePasswordBtn) {
                    changePasswordBtn.addEventListener('click', () => {
                        this.changePassword();
                    });
                }

                // Validation des dates
                const startDate = document.getElementById('projectStartDate');
                const endDate = document.getElementById('projectEndDate');

                if (startDate) {
                    startDate.addEventListener('change', () => this.validateDates());
                }
                if (endDate) {
                    endDate.addEventListener('change', () => this.validateDates());
                }
            },

            // Navigation
            showPage: function(pageId) {
                console.log('Affichage de la page:', pageId);

                // Cacher toutes les pages
                document.querySelectorAll('.page').forEach(page => {
                    page.classList.remove('active');
                });

                // Désactiver tous les liens
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.classList.remove('active');
                });

                // Afficher la page demandée
                const page = document.getElementById(pageId);
                if (page) {
                    page.classList.add('active');
                    console.log('Page trouvée et activée');
                } else {
                    console.error('Page non trouvée:', pageId);
                }

                // Activer le lien correspondant
                const navLink = document.querySelector(`[data-page="${pageId}"]`);
                if (navLink) {
                    navLink.classList.add('active');
                }

                // Reset du formulaire si on quitte la page nouveau-projet
                if (pageId !== 'nouveau-projet') {
                    this.cancelEdit();
                }
            },

            // Déconnexion - version corrigée et améliorée
            logout: function() {
                console.log('Tentative de déconnexion...');

                if (!confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
                    console.log('Déconnexion annulée par l\'utilisateur');
                    return;
                }

                const token = localStorage.getItem('token');
                console.log('Token présent:', !!token);

                // Afficher le chargement
                this.showLoading(true);

                // Appel API de déconnexion
                fetch('/api/auth/logout', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        ...(token && { 'Authorization': 'Bearer ' + token })
                    }
                })
                .then(response => {
                    console.log('Réponse déconnexion:', response.status);
                    // Nettoyer le stockage local dans tous les cas
                    this.clearUserSession();

                    // Rediriger vers la page de connexion
                    console.log('Redirection vers /login?logout');
                    window.location.href = '/login?logout';
                })
                .catch(error => {
                    console.error('Erreur lors de la déconnexion:', error);
                    // Même en cas d'erreur, on nettoie et on redirige
                    this.clearUserSession();
                    window.location.href = '/login?logout';
                });
            },

            // Nettoyer la session utilisateur
            clearUserSession: function() {
                console.log('Nettoyage de la session...');
                localStorage.removeItem('token');
                localStorage.removeItem('user');
                sessionStorage.clear();
            },

            // Chargement utilisateur
            loadUserFromSession: function() {
                console.log('Chargement utilisateur...');
                const userStr = localStorage.getItem('user');
                if (!userStr) {
                    console.log('Aucun utilisateur trouvé');
                    return;
                }

                try {
                    const user = JSON.parse(userStr);
                    console.log('Utilisateur chargé:', user.email);

                    // Mettre à jour l'affichage
                    this.updateUserDisplay(user);

                } catch (e) {
                    console.error('Erreur parsing user:', e);
                }
            },

            // Mettre à jour l'affichage utilisateur
            updateUserDisplay: function(user) {
                // Éléments du navbar
                const userEmail = document.getElementById('userEmail');
                const userNom = document.getElementById('userNom');
                const userInstitution = document.getElementById('userInstitution');
                const displayNameNav = document.getElementById('displayNameNav');
                const userAvatarNav = document.getElementById('userAvatarNav');

                if (userEmail) userEmail.textContent = user.email || 'Non disponible';
                if (userNom) userNom.textContent = user.nom || 'Candidat';
                if (userInstitution) userInstitution.textContent = user.institution || 'ESMT';

                const displayName = user.email ? user.email.split('@')[0] : 'Candidat';
                if (displayNameNav) displayNameNav.textContent = displayName;
                if (userAvatarNav) userAvatarNav.textContent = displayName.charAt(0).toUpperCase();

                // Éléments du profil
                const profileEmail = document.getElementById('profileEmail');
                const profileNom = document.getElementById('profileNom');
                const profileInstitution = document.getElementById('profileInstitution');

                if (profileEmail) profileEmail.textContent = user.email || 'Non disponible';
                if (profileNom) profileNom.textContent = user.nom || 'Candidat';
                if (profileInstitution) profileInstitution.textContent = user.institution || 'ESMT';

                // Formulaire d'édition
                const editNom = document.getElementById('editNom');
                const editInstitution = document.getElementById('editInstitution');

                if (editNom) editNom.value = user.nom || '';
                if (editInstitution) editInstitution.value = user.institution || '';
            },

            // Afficher/masquer chargement
            showLoading: function(show, elementId = 'dashboardLoading') {
                const loader = document.getElementById(elementId);
                if (loader) {
                    loader.style.display = show ? 'block' : 'none';
                }
            },

            // Validation des dates
            validateDates: function() {
                const startInput = document.getElementById('projectStartDate');
                const endInput = document.getElementById('projectEndDate');

                if (!startInput || !endInput || !startInput.value || !endInput.value) return true;

                const start = new Date(startInput.value);
                const end = new Date(endInput.value);
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                if (start < today) {
                    this.showFormAlert('La date de début ne peut pas être dans le passé', 'error');
                    return false;
                }

                if (end <= start) {
                    this.showFormAlert('La date de fin doit être postérieure à la date de début', 'error');
                    return false;
                }

                this.hideFormAlert();
                return true;
            },

            // Afficher alerte formulaire
            showFormAlert: function(message, type = 'info') {
                const alert = document.getElementById('formAlert');
                if (alert) {
                    alert.textContent = message;
                    alert.className = `alert alert-${type}`;
                    alert.style.display = 'block';
                }
            },

            hideFormAlert: function() {
                const alert = document.getElementById('formAlert');
                if (alert) {
                    alert.style.display = 'none';
                }
            },

            // Sauvegarder projet
            saveProject: function() {
                if (!this.validateDates()) return;

                const token = localStorage.getItem('token');
                if (!token) {
                    alert('Session expirée, veuillez vous reconnecter');
                    window.location.href = '/login';
                    return;
                }

                const projectData = {
                    titreProjet: document.getElementById('projectTitle').value,
                    domaineId: DOMAINES_MAP[document.getElementById('projectDomain').value] || 1,
                    description: document.getElementById('projectDescription').value,
                    dateDebut: document.getElementById('projectStartDate').value,
                    dateFin: document.getElementById('projectEndDate').value,
                    budgetEstime: parseFloat(document.getElementById('projectBudget').value) || 0,
                    statutProjet: document.getElementById('projectStatus').value,
                    niveauAvancement: parseInt(document.getElementById('projectProgress').value) || 0,
                    institution: document.getElementById('projectInstitution').value
                };

                const editingId = document.getElementById('editingProjectId').value;
                const url = editingId ? `/api/projects/${editingId}` : '/api/projects';
                const method = editingId ? 'PUT' : 'POST';

                const submitBtn = document.getElementById('submitBtn');
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.textContent = '💾 Enregistrement...';
                }

                fetch(url, {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + token
                    },
                    body: JSON.stringify(projectData)
                })
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 401 || response.status === 403) {
                            throw new Error('Non autorisé');
                        }
                        return response.json().then(err => { throw new Error(err.message || 'Erreur serveur'); });
                    }
                    return response.json();
                })
                .then(() => {
                    const message = editingId ? 'modifié' : 'créé';
                    alert(`✅ Projet ${message} avec succès!`);

                    this.cancelEdit();
                    this.showPage('mes-projets');
                    this.loadProjectsData();
                })
                .catch(error => {
                    console.error('Error:', error);
                    this.showFormAlert(error.message || 'Erreur lors de la sauvegarde', 'error');
                })
                .finally(() => {
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.textContent = editingId ? '✏️ Modifier le Projet' : '💾 Enregistrer le Projet';
                    }
                });
            },

            // Charger les projets
            loadProjectsData: function() {
                const token = localStorage.getItem('token');
                if (!token) {
                    window.location.href = '/login';
                    return;
                }

                this.showLoading(true, 'projectsListLoading');
                this.showLoading(true, 'dashboardLoading');

                fetch('/api/projects/mes-projets', {
                    headers: { 'Authorization': 'Bearer ' + token }
                })
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 401 || response.status === 403) {
                            throw new Error('Non autorisé');
                        }
                        throw new Error('Erreur chargement');
                    }
                    return response.json();
                })
                .then(data => {
                    this.mesProjets = (data || []).map(p => ({
                        id: p.projectId,
                        titre: p.titreProjet,
                        domaine: p.domaineNom || 'Non spécifié',
                        description: p.description,
                        dateDebut: p.dateDebut ? p.dateDebut.substring(0, 10) : '',
                        dateFin: p.dateFin ? p.dateFin.substring(0, 10) : '',
                        budget: p.budgetEstime || 0,
                        statut: p.statutProjet,
                        avancement: p.niveauAvancement || 0,
                        institution: p.institution
                    }));

                    this.updateStats();
                    this.displayProjects();
                    this.displayRecentProjects();
                    this.initCharts();
                })
                .catch(e => {
                    console.error("Erreur chargement projets", e);
                    if (e.message === 'Non autorisé') {
                        this.clearUserSession();
                        window.location.href = '/login';
                    } else {
                        alert('Erreur lors du chargement des projets');
                    }
                })
                .finally(() => {
                    this.showLoading(false, 'projectsListLoading');
                    this.showLoading(false, 'dashboardLoading');
                });
            },

            // Mettre à jour les stats
            updateStats: function() {
                const enCours = this.mesProjets.filter(p => p.statut === 'EN_COURS').length;
                const termine = this.mesProjets.filter(p => p.statut === 'TERMINE').length;
                const budget = this.mesProjets.reduce((sum, p) => sum + (p.budget || 0), 0);

                const mesProjetCount = document.getElementById('mesProjetCount');
                const projetEnCoursCount = document.getElementById('projetEnCoursCount');
                const projetTermineCount = document.getElementById('projetTermineCount');
                const budgetTotal = document.getElementById('budgetTotal');

                if (mesProjetCount) mesProjetCount.textContent = this.mesProjets.length;
                if (projetEnCoursCount) projetEnCoursCount.textContent = enCours;
                if (projetTermineCount) projetTermineCount.textContent = termine;

                if (budgetTotal) {
                    const budgetFormatted = budget >= 1000000
                        ? (budget / 1000000).toFixed(1) + 'M F'
                        : budget.toLocaleString() + ' F';
                    budgetTotal.textContent = budgetFormatted;
                }
            },

            // Afficher les projets
            displayProjects: function() {
                const container = document.getElementById('projectsList');
                if (!container) return;

                if (!this.mesProjets || this.mesProjets.length === 0) {
                    container.innerHTML = `
                        <div class="empty-state">
                            <h3>Aucun projet déclaré</h3>
                            <p>Créez votre premier projet pour le partager avec la communauté de recherche</p>
                        </div>
                    `;
                    return;
                }

                container.innerHTML = '';
                this.mesProjets.forEach(projet => {
                    const card = this.createProjectCard(projet, false);
                    if (card) container.appendChild(card);
                });
            },

            // Afficher projets récents
            displayRecentProjects: function() {
                const container = document.getElementById('recentProjects');
                if (!container) return;

                const recents = this.mesProjets.slice(0, 3);

                if (recents.length === 0) {
                    container.innerHTML = `
                        <div class="empty-state">
                            <p>Aucun projet récent</p>
                        </div>
                    `;
                    return;
                }

                container.innerHTML = '';
                recents.forEach(projet => {
                    const card = this.createProjectCard(projet, true);
                    if (card) container.appendChild(card);
                });
            },

            // Créer une carte projet
            createProjectCard: function(projet, isRecent = false) {
                const template = document.getElementById('projectTemplate');
                if (!template) {
                    console.error('Template non trouvé');
                    return null;
                }

                const card = template.cloneNode(true);
                card.id = '';
                card.classList.remove('template-hidden');

                // Remplir les données
                const titleEl = card.querySelector('.project-title');
                const domainEl = card.querySelector('.project-domain');
                const statusBadge = card.querySelector('.status-badge');
                const descEl = card.querySelector('.project-description');
                const startDateEl = card.querySelector('.start-date');
                const endDateEl = card.querySelector('.end-date');
                const budgetEl = card.querySelector('.budget');
                const progressValueEl = card.querySelector('.progress-value');
                const progressFill = card.querySelector('.progress-fill');

                if (titleEl) titleEl.textContent = projet.titre || '';
                if (domainEl) domainEl.textContent = projet.domaine || '';

                if (statusBadge) {
                    statusBadge.textContent = STATUTS_LABELS[projet.statut] || projet.statut;
                    statusBadge.className = 'status-badge';
                    statusBadge.classList.add(`status-${(projet.statut || '').toLowerCase()}`);
                }

                if (descEl) descEl.textContent = projet.description || '';
                if (startDateEl) startDateEl.textContent = this.formatDate(projet.dateDebut);
                if (endDateEl) endDateEl.textContent = this.formatDate(projet.dateFin);
                if (budgetEl) budgetEl.textContent = this.formatBudget(projet.budget);
                if (progressValueEl) progressValueEl.textContent = projet.avancement + '%';

                if (progressFill) {
                    progressFill.style.width = projet.avancement + '%';
                }

                // Ajouter les boutons d'action
                if (!isRecent) {
                    const actions = card.querySelector('.project-actions');
                    if (actions) {
                        actions.innerHTML = '';

                        const editBtn = document.createElement('button');
                        editBtn.className = 'btn btn-primary btn-small';
                        editBtn.innerHTML = '✏️ Modifier';
                        editBtn.onclick = (e) => {
                            e.preventDefault();
                            this.editProject(projet.id);
                        };

                        const deleteBtn = document.createElement('button');
                        deleteBtn.className = 'btn btn-danger btn-small';
                        deleteBtn.innerHTML = '🗑️ Supprimer';
                        deleteBtn.onclick = (e) => {
                            e.preventDefault();
                            this.deleteProject(projet.id);
                        };

                        actions.appendChild(editBtn);
                        actions.appendChild(deleteBtn);
                    }
                } else {
                    const actions = card.querySelector('.project-actions');
                    if (actions) actions.innerHTML = '';
                }

                return card;
            },

            // Éditer projet
            editProject: function(id) {
                const projet = this.mesProjets.find(p => p.id === id);
                if (!projet) return;

                this.editingId = id;
                const editingInput = document.getElementById('editingProjectId');
                if (editingInput) editingInput.value = id;

                // Remplir le formulaire
                const titleInput = document.getElementById('projectTitle');
                const descInput = document.getElementById('projectDescription');
                const startInput = document.getElementById('projectStartDate');
                const endInput = document.getElementById('projectEndDate');
                const budgetInput = document.getElementById('projectBudget');
                const statusInput = document.getElementById('projectStatus');
                const institutionInput = document.getElementById('projectInstitution');
                const progressInput = document.getElementById('projectProgress');

                if (titleInput) titleInput.value = projet.titre || '';
                if (descInput) descInput.value = projet.description || '';
                if (startInput) startInput.value = projet.dateDebut || '';
                if (endInput) endInput.value = projet.dateFin || '';
                if (budgetInput) budgetInput.value = projet.budget || '';
                if (statusInput) statusInput.value = projet.statut || 'EN_COURS';
                if (institutionInput) institutionInput.value = projet.institution || '';
                if (progressInput) progressInput.value = projet.avancement || 0;

                // Modifier l'interface
                const formTitle = document.getElementById('formTitle');
                const formSubtitle = document.getElementById('formSubtitle');
                const submitBtn = document.getElementById('submitBtn');
                const cancelEditBtn = document.getElementById('cancelEditBtn');

                if (formTitle) formTitle.textContent = '✏️ Modifier le Projet';
                if (formSubtitle) formSubtitle.textContent = 'Formulaire de Modification';
                if (submitBtn) submitBtn.textContent = '✏️ Modifier le Projet';
                if (cancelEditBtn) cancelEditBtn.style.display = 'inline-block';

                this.showPage('nouveau-projet');
            },

            // Annuler édition
            cancelEdit: function() {
                this.editingId = null;
                const editingInput = document.getElementById('editingProjectId');
                if (editingInput) editingInput.value = '';

                // Reset formulaire
                const form = document.getElementById('projectForm');
                if (form) form.reset();

                // Restaurer interface
                const formTitle = document.getElementById('formTitle');
                const formSubtitle = document.getElementById('formSubtitle');
                const submitBtn = document.getElementById('submitBtn');
                const cancelEditBtn = document.getElementById('cancelEditBtn');

                if (formTitle) formTitle.textContent = '➕ Déclarer un Nouveau Projet';
                if (formSubtitle) formSubtitle.textContent = 'Formulaire de Déclaration';
                if (submitBtn) submitBtn.textContent = '💾 Enregistrer le Projet';
                if (cancelEditBtn) cancelEditBtn.style.display = 'none';

                this.hideFormAlert();
            },

            // Reset formulaire
            resetForm: function() {
                if (!this.editingId) {
                    this.hideFormAlert();
                }
            },

            // Supprimer projet
            deleteProject: function(id) {
                if (!confirm('Êtes-vous sûr de vouloir supprimer ce projet ?')) return;

                const token = localStorage.getItem('token');
                if (!token) {
                    alert('Session expirée, veuillez vous reconnecter');
                    window.location.href = '/login';
                    return;
                }

                fetch('/api/projects/' + id, {
                    method: 'DELETE',
                    headers: { 'Authorization': 'Bearer ' + token }
                })
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 401 || response.status === 403) {
                            throw new Error('Non autorisé');
                        }
                        throw new Error('Erreur lors de la suppression');
                    }

                    this.mesProjets = this.mesProjets.filter(p => p.id !== id);
                    this.updateStats();
                    this.displayProjects();
                    this.displayRecentProjects();
                    this.initCharts();

                    alert('✅ Projet supprimé avec succès!');
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    alert(error.message || 'Erreur lors de la suppression du projet');
                });
            },

            // Mettre à jour profil
            updateProfile: function() {
                const token = localStorage.getItem('token');
                if (!token) {
                    alert('Session expirée, veuillez vous reconnecter');
                    window.location.href = '/login';
                    return;
                }

                const editNom = document.getElementById('editNom');
                const editInstitution = document.getElementById('editInstitution');

                const profileData = {
                    nom: editNom ? editNom.value : '',
                    institution: editInstitution ? editInstitution.value : ''
                };

                fetch('/api/users/me', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + token
                    },
                    body: JSON.stringify(profileData)
                })
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 401 || response.status === 403) {
                            throw new Error('Non autorisé');
                        }
                        throw new Error('Erreur lors de la mise à jour');
                    }
                    return response.json();
                })
                .then(data => {
                    alert('✅ Profil mis à jour avec succès!');

                    // Mettre à jour l'affichage
                    const user = {
                        email: data.email,
                        nom: data.nom,
                        institution: data.institution
                    };

                    this.updateUserDisplay(user);

                    // Mettre à jour localStorage
                    localStorage.setItem('user', JSON.stringify(user));
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    alert(error.message || 'Erreur lors de la mise à jour du profil');
                });
            },

            // Changer mot de passe
            changePassword: function() {
                const newPassword = prompt('Entrez votre nouveau mot de passe (minimum 6 caractères):');
                if (!newPassword) return;

                if (newPassword.length < 6) {
                    alert('Le mot de passe doit contenir au moins 6 caractères.');
                    return;
                }

                const confirmPassword = prompt('Confirmez votre nouveau mot de passe:');
                if (newPassword !== confirmPassword) {
                    alert('Les mots de passe ne correspondent pas.');
                    return;
                }

                const token = localStorage.getItem('token');
                if (!token) {
                    alert('Session expirée, veuillez vous reconnecter');
                    window.location.href = '/login';
                    return;
                }

                fetch('/api/users/change-password', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + token
                    },
                    body: JSON.stringify({ password: newPassword })
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erreur lors du changement de mot de passe');
                    }
                    alert('✅ Mot de passe modifié avec succès!');
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    alert(error.message || 'Erreur lors du changement de mot de passe');
                });
            },

            // Initialiser les graphiques
            initCharts: function() {
                // Détruire les anciens graphiques
                Object.values(this.charts).forEach(chart => {
                    if (chart) chart.destroy();
                });
                this.charts = {};

                // Graphique des statuts
                const ctxStatus = document.getElementById('statusChart');
                if (ctxStatus) {
                    const stats = {
                        EN_COURS: this.mesProjets.filter(p => p.statut === 'EN_COURS').length,
                        TERMINE: this.mesProjets.filter(p => p.statut === 'TERMINE').length,
                        SUSPENDU: this.mesProjets.filter(p => p.statut === 'SUSPENDU').length,
                        PLANIFIE: this.mesProjets.filter(p => p.statut === 'PLANIFIE').length
                    };

                    const labels = [];
                    const data = [];
                    const colors = [];

                    Object.entries(stats).forEach(([statut, count]) => {
                        if (count > 0) {
                            labels.push(STATUTS_LABELS[statut] || statut);
                            data.push(count);
                            colors.push(STATUTS_COLORS[statut]);
                        }
                    });

                    if (data.length > 0) {
                        this.charts.status = new Chart(ctxStatus, {
                            type: 'doughnut',
                            data: {
                                labels,
                                datasets: [{
                                    data,
                                    backgroundColor: colors,
                                    borderWidth: 0
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        position: 'bottom',
                                        labels: { padding: 20 }
                                    }
                                },
                                cutout: '60%'
                            }
                        });
                    }
                }

                // Graphique d'avancement
                const ctxProgress = document.getElementById('progressChart');
                if (ctxProgress && this.mesProjets.length > 0) {
                    const projetsAvecTitre = this.mesProjets.map(p => ({
                        titre: p.titre || 'Sans titre',
                        avancement: p.avancement
                    }));

                    this.charts.progress = new Chart(ctxProgress, {
                        type: 'bar',
                        data: {
                            labels: projetsAvecTitre.map(p => p.titre.length > 20 ? p.titre.substring(0, 20) + '...' : p.titre),
                            datasets: [{
                                label: "Avancement (%)",
                                data: projetsAvecTitre.map(p => p.avancement),
                                backgroundColor: '#667eea',
                                borderRadius: 5
                            }]
                        },
                        options: {
                            indexAxis: 'y',
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { display: false }
                            },
                            scales: {
                                x: {
                                    max: 100,
                                    grid: { display: false }
                                },
                                y: {
                                    grid: { display: false }
                                }
                            }
                        }
                    });
                }
            },

            // Formatage date
            formatDate: function(dateStr) {
                if (!dateStr) return 'Non définie';
                try {
                    const date = new Date(dateStr);
                    return date.toLocaleDateString('fr-FR', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric'
                    });
                } catch (e) {
                    return dateStr;
                }
            },

            // Formatage budget
            formatBudget: function(budget) {
                if (!budget) return '0 F';
                if (budget >= 1000000) {
                    return (budget / 1000000).toFixed(1) + 'M F';
                }
                return budget.toLocaleString() + ' F';
            }
        };

        // Initialisation au chargement du DOM
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM chargé, initialisation...');
            app.init();
        });

        // Fallback pour les anciens navigateurs
        window.onload = function() {
            console.log('Page complètement chargée');
        };
    </script>
</body>

</html>