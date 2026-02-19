<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - ESMT Research Mapping</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 0 40px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
            display: flex; justify-content: space-between; align-items: center;
            height: 70px; position: sticky; top: 0; z-index: 1000;
        }
        .navbar-brand { display: flex; align-items: center; gap: 10px; font-size: 24px; font-weight: 700; }
        .navbar-right { display: flex; align-items: center; gap: 25px; }
        .btn-logout { background: rgba(255, 255, 255, 0.2); color: white; padding: 8px 16px; border: 1px solid white; border-radius: 5px; cursor: pointer; font-weight: 600; }
        .main-container { display: flex; min-height: calc(100vh - 70px); }
        .sidebar { width: 250px; background: white; border-right: 1px solid #e0e0e0; padding: 20px 0; }
        .sidebar-menu { list-style: none; }
        .sidebar-menu a { display: flex; align-items: center; gap: 12px; padding: 15px 25px; color: #555; text-decoration: none; cursor: pointer; }
        .sidebar-menu a.active { background: #f0f2f5; color: #667eea; border-left: 4px solid #667eea; }
        .content { flex: 1; padding: 30px; overflow-y: auto; }
        .page { display: none; }
        .page.active { display: block; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; text-align: center; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .chart-container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); height: 400px; margin-bottom: 20px;}
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); z-index: 2000; justify-content: center; align-items: center; }
        .modal-overlay.show { display: flex; }
        .modal { background: white; border-radius: 10px; padding: 30px; width: 500px; max-width: 90%; }

        /* Petits styles manquants dans ton extrait */
        .user-info { display:flex; align-items:center; gap:12px; }
        .user-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            background: rgba(255,255,255,0.25);
            display:flex; align-items:center; justify-content:center;
            font-weight:700;
        }
        .page-header { margin-bottom: 18px; }
        .page-header h1 { margin-bottom: 6px; }
        .label { opacity: 0.9; font-size: 13px; }
        .value { font-size: 28px; font-weight: 800; margin-top: 6px; }
    </style>

    <script>
        let charts = {};

        // INITIALISATION AU CHARGEMENT (CORRIGÉ)
        // - On ne dépend plus de localStorage pour décider si l'utilisateur est connecté.
        // - Spring Security protège déjà /dashboard : si non connecté => redirect /login
        document.addEventListener('DOMContentLoaded', () => {
            // Optionnel: si tu as encore des restes JWT dans localStorage, on ne les utilise plus ici.
            // localStorage.removeItem('token'); // (optionnel)

            // Valeurs par défaut (évite erreurs JS)
            setUserHeader({
                nom: "Utilisateur",
                email: "",
                role: ""
            });

            // Charger les données initiales
            loadDashboardStats();
        });

        function setUserHeader(user) {
            const displayNameNav = document.getElementById('displayNameNav');
            const userAvatarNav = document.getElementById('userAvatarNav');
            const userEmail = document.getElementById('userEmail');
            const userRole = document.getElementById('userRole');

            if (displayNameNav) displayNameNav.textContent = user.nom || "Utilisateur";
            if (userAvatarNav) userAvatarNav.textContent = (user.nom && user.nom.length > 0) ? user.nom.charAt(0).toUpperCase() : "U";
            if (userEmail) userEmail.textContent = user.email || "";
            if (userRole) userRole.textContent = user.role || "";
        }

        function showPage(pageId, event) {
            if (event) event.preventDefault();
            document.querySelectorAll('.page').forEach(page => page.classList.remove('active'));
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            document.getElementById(pageId).classList.add('active');
            if (event) {
                const link = event.target.closest('.nav-link');
                if (link) link.classList.add('active');
            }
        }

        // LOGOUT (CORRIGÉ pour Spring Security formLogin)
        // Ton SecurityConfig utilise /logout
        function logout() {
            if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
                window.location.href = '/logout';
            }
        }

        function loadDashboardStats() {
            // Ici tu peux faire des fetch vers tes endpoints.
            // Comme tu es en session (JSESSIONID), pas besoin de token.
            console.log("Dashboard chargé (auth gérée par session Spring Security).");
        }

        function closeModal(id) {
            document.getElementById(id).classList.remove('show');
        }

        function showDomainModal() {
            document.getElementById('domainModal').classList.add('show');
        }

        function showUserModal() {
            document.getElementById('userModal').classList.add('show');
        }
    </script>
</head>

<body>
    <div class="navbar">
        <div class="navbar-brand"><span>🔬</span> ESMT Research Mapping</div>
        <div class="navbar-right">
            <div class="user-info">
                <div class="user-avatar" id="userAvatarNav">U</div>
                <div>
                    <div style="font-size: 14px;">Bienvenue,</div>
                    <div style="font-weight: 600;" id="displayNameNav">Utilisateur</div>
                </div>
            </div>
            <button class="btn-logout" onclick="logout()">Se Déconnecter</button>
        </div>
    </div>

    <div class="main-container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li><a class="nav-link active" onclick="showPage('dashboard', event)"><span>📊</span> Tableau de Bord</a></li>
                <li><a class="nav-link" onclick="showPage('projects', event)"><span>📁</span> Projets</a></li>
                <li><a class="nav-link" onclick="showPage('users', event)"><span>👥</span> Utilisateurs</a></li>
                <li><a class="nav-link" onclick="showPage('domains', event)"><span>🏷️</span> Domaines</a></li>
                <li><a class="nav-link" onclick="showPage('statistics', event)"><span>📈</span> Statistiques</a></li>
            </ul>
        </div>

        <div class="content">
            <div id="dashboard" class="page active">
                <div class="page-header">
                    <h1>🎯 Tableau de Bord Principal</h1>
                    <p>Vue d'ensemble de votre plateforme</p>
                </div>

                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="label">Total Projets</div>
                        <div class="value" id="totalProjects">12</div>
                    </div>
                    <div class="stat-card">
                        <div class="label">Domaines</div>
                        <div class="value" id="totalDomains">5</div>
                    </div>
                    <div class="stat-card">
                        <div class="label">Utilisateurs</div>
                        <div class="value">24</div>
                    </div>
                </div>

                <div class="header-info" style="background: white; padding: 20px; border-radius: 10px; border-left: 5px solid #667eea;">
                    <p><strong>📧 Email :</strong> <span id="userEmail"></span></p>
                    <p><strong>👤 Rôle :</strong> <span id="userRole"></span></p>
                </div>
            </div>

            <div id="domains" class="page">
                <div class="page-header"><h1>🏷️ Domaines</h1></div>
                <button class="btn-logout" style="background:#667eea" onclick="showDomainModal()">+ Nouveau Domaine</button>
            </div>

            <!-- Pages placeholders (évite erreurs quand on clique) -->
            <div id="projects" class="page">
                <div class="page-header"><h1>📁 Projets</h1></div>
                <p>Page Projets (à implémenter).</p>
            </div>

            <div id="users" class="page">
                <div class="page-header"><h1>👥 Utilisateurs</h1></div>
                <p>Page Utilisateurs (à implémenter).</p>
            </div>

            <div id="statistics" class="page">
                <div class="page-header"><h1>📈 Statistiques</h1></div>
                <p>Page Statistiques (à implémenter).</p>
            </div>
        </div>
    </div>

    <div id="domainModal" class="modal-overlay">
        <div class="modal">
            <h2>Nouveau Domaine</h2>
            <form>
                <div style="margin-bottom:15px">
                    <label style="display:block">Nom du Domaine</label>
                    <input type="text" style="width:100%; padding:10px">
                </div>
                <button type="button" class="btn-logout" style="background:#28a745; border:none" onclick="alert('Enregistré')">Enregistrer</button>
                <button type="button" class="btn-logout" style="background:#6c757d; border:none" onclick="closeModal('domainModal')">Annuler</button>
            </form>
        </div>
    </div>
</body>
</html>