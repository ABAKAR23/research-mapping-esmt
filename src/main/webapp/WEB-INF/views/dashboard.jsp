<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ESMT Research Mapping</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }

        .navbar {
            background: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .navbar h1 {
            color: #003d82;
            font-size: 24px;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .username {
            font-weight: 600;
            color: #333;
        }

        .btn-logout {
            padding: 8px 16px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-logout:hover {
            background: #c82333;
        }

        .container {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .welcome-section {
            margin-bottom: 2rem;
        }

        .welcome-section h2 {
            color: #003d82;
            margin-bottom: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-left: 5px solid #667eea;
        }

        .stat-card h3 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #003d82;
        }

        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 20px;
            margin-bottom: 2rem;
        }

        .chart-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: relative;
            height: 400px;
        }

        .chart-container h3 {
            color: #003d82;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .chart-wrapper {
            position: relative;
            height: 350px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div>
            <h1>🔬 ESMT Research Mapping</h1>
        </div>
        <div class="nav-right">
            <div class="user-info">
                <span class="username" id="username">Chargement...</span>
            </div>
            <button class="btn-logout" onclick="handleLogout()">Déconnexion</button>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="welcome-section">
            <h2 id="welcome">Bienvenue! 👋</h2>
            <p>Tableau de bord des projets de recherche</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>📊 Total Projets</h3>
                <div class="stat-value" id="totalProjects">0</div>
            </div>
            <div class="stat-card">
                <h3>✅ Projets Approuvés</h3>
                <div class="stat-value" id="approvedProjects">0</div>
            </div>
            <div class="stat-card">
                <h3>⏳ En Attente</h3>
                <div class="stat-value" id="pendingProjects">0</div>
            </div>
            <div class="stat-card">
                <h3>👥 Chercheurs</h3>
                <div class="stat-value" id="totalResearchers">0</div>
            </div>
        </div>

        <!-- Charts -->
        <div class="charts-grid">
            <div class="chart-container">
                <h3>📈 Projets par Statut</h3>
                <div class="chart-wrapper">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
            <div class="chart-container">
                <h3>🎯 Projets par Domaine</h3>
                <div class="chart-wrapper">
                    <canvas id="domainChart"></canvas>
                </div>
            </div>
            <div class="chart-container">
                <h3>📅 Projets par Mois</h3>
                <div class="chart-wrapper">
                    <canvas id="monthChart"></canvas>
                </div>
            </div>
            <div class="chart-container">
                <h3>👨‍💼 Top Chercheurs</h3>
                <div class="chart-wrapper">
                    <canvas id="researchersChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Vérifier l'authentification
        window.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('token');
            if (!token) {
                window.location.href = '/research-platform/login.jsp';
                return;
            }

            // Charger les données utilisateur
            const user = JSON.parse(localStorage.getItem('user') || '{}');
            document.getElementById('username').textContent = user.name || 'Utilisateur';
            document.getElementById('welcome').textContent = `Bienvenue, ${user.name}! 👋`;

            // Charger les statistiques
            loadStatistics();
        });

        function handleLogout() {
            localStorage.removeItem('token');
            localStorage.removeItem('user');
            window.location.href = '/research-platform/login.jsp';
        }

        function loadStatistics() {
            const token = localStorage.getItem('token');

            fetch('/research-platform/api/statistics/all', {
                headers: {
                    'Authorization': 'Bearer ' + token
                }
            })
            .then(response => response.json())
            .then(data => {
                // Update stat cards
                document.getElementById('totalProjects').textContent = data.totalProjects || 0;
                document.getElementById('approvedProjects').textContent = data.approvedProjects || 0;
                document.getElementById('pendingProjects').textContent = data.pendingProjects || 0;
                document.getElementById('totalResearchers').textContent = data.totalResearchers || 0;

                // Create charts
                createStatusChart(data.projectsByStatus || {});
                createDomainChart(data.projectsByDomain || {});
                createMonthChart(data.projectsByMonth || {});
                createResearchersChart(data.topResearchers || []);
            })
            .catch(error => {
                console.error('Erreur:', error);
            });
        }

        function createStatusChart(data) {
            const ctx = document.getElementById('statusChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(data),
                    datasets: [{
                        data: Object.values(data),
                        backgroundColor: ['#28a745', '#ffc107', '#dc3545']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }

        function createDomainChart(data) {
            const ctx = document.getElementById('domainChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: Object.keys(data),
                    datasets: [{
                        label: 'Nombre de projets',
                        data: Object.values(data),
                        backgroundColor: '#667eea'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    indexAxis: 'y'
                }
            });
        }

        function createMonthChart(data) {
            const ctx = document.getElementById('monthChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: Object.keys(data),
                    datasets: [{
                        label: 'Projets par mois',
                        data: Object.values(data),
                        borderColor: '#764ba2',
                        backgroundColor: 'rgba(118, 75, 162, 0.1)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }

        function createResearchersChart(data) {
            const ctx = document.getElementById('researchersChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.map(r => r.name),
                    datasets: [{
                        label: 'Nombre de projets',
                        data: data.map(r => r.projectCount),
                        backgroundColor: '#ffc107'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    indexAxis: 'y'
                }
            });
        }
    </script>
</body>
</html>