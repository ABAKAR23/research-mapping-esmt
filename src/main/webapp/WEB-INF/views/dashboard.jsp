<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - ESMT Research Mapping</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
        }

        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h1 {
            margin: 0;
            font-size: 24px;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-name {
            font-size: 0.95em;
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
            text-decoration: none;
        }

        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .card h2 {
            color: #003d82;
            margin-bottom: 15px;
            font-size: 1.8em;
        }

        .user-info {
            background: linear-gradient(135deg, #f8f9ff 0%, #e8ecff 100%);
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }

        .user-info p {
            margin: 12px 0;
            font-size: 1.05em;
        }

        .user-info strong {
            color: #003d82;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .stat-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            transition: transform 0.3s;
        }

        .stat-box:hover {
            transform: translateY(-5px);
        }

        .stat-box h3 {
            font-size: 2.5em;
            margin: 10px 0;
        }

        .stat-box p {
            font-size: 0.95em;
            opacity: 0.9;
        }

        .api-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }

        .api-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        .welcome-message {
            font-size: 1.1em;
            color: #555;
            line-height: 1.6;
        }

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

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
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🔬 ESMT Research Mapping</h1>
        <div class="navbar-right">
            <span class="user-name">Bienvenue, <strong id="displayName">Utilisateur</strong> 👋</span>
            <button class="btn-logout" onclick="logout()">Se Déconnecter</button>
        </div>
    </div>

    <div class="container">
        <!-- Carte de Bienvenue -->
        <div class="card">
            <h2>Tableau de Bord</h2>

            <div class="user-info">
                <p><strong>📧 Email :</strong> <span id="userEmail">Chargement...</span></p>
                <p><strong>👤 Rôle :</strong> <span id="userRole">Chargement...</span></p>
                <p><strong>🔑 ID Utilisateur :</strong> <span id="userId">Chargement...</span></p>
            </div>

            <p class="welcome-message">
                ✅ Vous êtes maintenant connecté à l'application ESMT Research Mapping.
                Cette plateforme vous permet de gérer et de cartographier les projets de recherche de l'école.
            </p>
        </div>

        <!-- Statistiques -->
        <div class="card">
            <h2>📊 Statistiques</h2>

            <div class="stats">
                <div class="stat-box">
                    <h3>0</h3>
                    <p>Projets</p>
                </div>
                <div class="stat-box">
                    <h3>0</h3>
                    <p>Utilisateurs</p>
                </div>
                <div class="stat-box">
                    <h3>0</h3>
                    <p>Domaines</p>
                </div>
                <div class="stat-box">
                    <h3>0</h3>
                    <p>Chercheurs</p>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="card">
            <h2>⚡ Actions Rapides</h2>

            <div class="actions">
                <a href="/swagger-ui.html" target="_blank" class="btn btn-primary">
                    📚 Documentation API
                </a>
                <a href="/h2-console" target="_blank" class="btn btn-secondary">
                    🗄️ Console H2 (Dev)
                </a>
            </div>
        </div>

        <!-- Informations -->
        <div class="card">
            <h2>ℹ️ Informations</h2>

            <p class="welcome-message">
                <strong>🚀 Application :</strong> ESMT Research Mapping v1.0<br>
                <strong>🔐 Authentification :</strong> JWT Token + OAuth2 Google<br>
                <strong>💾 Base de Données :</strong> MySQL 8.0+<br>
                <strong>🛠️ Framework :</strong> Spring Boot 3.2.0<br>
            </p>

            <p class="welcome-message" style="margin-top: 15px;">
                Pour accéder à la documentation complète de l'API, cliquez sur
                <a href="/swagger-ui.html" class="api-link">Documentation API</a>
            </p>
        </div>
    </div>

    <script>
        // Afficher les infos utilisateur au chargement
        window.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('token');
            const user = localStorage.getItem('user');

            // Si pas de token, rediriger vers le login
            if (!token) {
                window.location.href = '/login';
                return;
            }

            // Afficher les infos utilisateur
            if (user) {
                try {
                    const userData = JSON.parse(user);
                    document.getElementById('userEmail').textContent = userData.email || 'N/A';
                    document.getElementById('userRole').textContent = userData.role || 'N/A';
                    document.getElementById('userId').textContent = userData.userId || 'N/A';
                    document.getElementById('displayName').textContent = userData.email.split('@')[0] || 'Utilisateur';
                } catch (e) {
                    console.error('Erreur parsing user:', e);
                }
            }
        });

        // Fonction de déconnexion
        function logout() {
            if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
                localStorage.removeItem('token');
                localStorage.removeItem('user');
                window.location.href = '/login';
            }
        }
    </script>
</body>
</html>