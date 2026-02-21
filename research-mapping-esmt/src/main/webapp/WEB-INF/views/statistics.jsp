<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques - ESMT Research Mapping</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: #f0f2f5; 
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
        }
        .header h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }
        .chart-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .chart-card h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 20px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }
        .chart-container {
            position: relative;
            height: 400px;
            width: 100%;
        }
        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .stat-box .label {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .stat-box .value {
            color: #667eea;
            font-size: 32px;
            font-weight: bold;
        }
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .error {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .btn-back {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .btn-back:hover {
            background: #5568d3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Statistiques des Projets de Recherche</h1>
            <p>Visualisation des données de la plateforme ESMT</p>
        </div>

        <div id="loading" class="loading">
            Chargement des statistiques...
        </div>

        <div id="error" class="error" style="display: none;"></div>

        <div id="content" style="display: none;">
            <!-- Résumé des statistiques -->
            <div class="stats-summary">
                <div class="stat-box">
                    <div class="label">Total Projets</div>
                    <div class="value" id="totalProjects">0</div>
                </div>
                <div class="stat-box">
                    <div class="label">Budget Total</div>
                    <div class="value" id="totalBudget">0</div>
                </div>
                <div class="stat-box">
                    <div class="label">Avancement Moyen</div>
                    <div class="value" id="avgAdvancement">0%</div>
                </div>
            </div>

            <!-- Graphiques -->
            <div class="charts-grid">
                <!-- Graphique en barres : Projets par domaine -->
                <div class="chart-card">
                    <h2>📊 Projets par Domaine de Recherche</h2>
                    <div class="chart-container">
                        <canvas id="chartDomaines"></canvas>
                    </div>
                </div>

                <!-- Graphique en camembert : Répartition par statut -->
                <div class="chart-card">
                    <h2>🥧 Répartition des Projets par Statut</h2>
                    <div class="chart-container">
                        <canvas id="chartStatuts"></canvas>
                    </div>
                </div>

                <!-- Graphique en barres : Budget par domaine -->
                <div class="chart-card">
                    <h2>💰 Budget par Domaine</h2>
                    <div class="chart-container">
                        <canvas id="chartBudget"></canvas>
                    </div>
                </div>

                <!-- Graphique en barres horizontales : Projets par participant -->
                <div class="chart-card">
                    <h2>👥 Projets par Participant</h2>
                    <div class="chart-container">
                        <canvas id="chartParticipants"></canvas>
                    </div>
                </div>
            </div>

            <a href="/dashboard" class="btn-back">← Retour au Tableau de Bord</a>
        </div>
    </div>

    <script>
        let charts = {};

        // Charger les statistiques au chargement de la page
        document.addEventListener('DOMContentLoaded', () => {
            loadStatistics();
        });

        async function loadStatistics() {
            try {
                const response = await fetch('/api/javaee/statistics');
                
                if (!response.ok) {
                    throw new Error('Erreur lors du chargement des statistiques: ' + response.status);
                }
                
                const stats = await response.json();
                
                // Masquer le loading et afficher le contenu
                document.getElementById('loading').style.display = 'none';
                document.getElementById('content').style.display = 'block';
                
                // Mettre à jour les résumés
                updateSummary(stats);
                
                // Créer les graphiques
                createCharts(stats);
                
            } catch (error) {
                console.error('Erreur:', error);
                document.getElementById('loading').style.display = 'none';
                document.getElementById('error').style.display = 'block';
                document.getElementById('error').textContent = 'Erreur: ' + error.message;
            }
        }

        function updateSummary(stats) {
            document.getElementById('totalProjects').textContent = stats.totalProjects || 0;
            
            const totalBudget = stats.totalBudget || 0;
            document.getElementById('totalBudget').textContent = 
                new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'XOF' })
                    .format(totalBudget).replace('XOF', 'FCFA');
            
            const avgAdvancement = stats.averageAdvancement || 0;
            document.getElementById('avgAdvancement').textContent = 
                Math.round(avgAdvancement) + '%';
        }

        function createCharts(stats) {
            // 1. Graphique en barres : Projets par domaine
            const ctxDomaines = document.getElementById('chartDomaines').getContext('2d');
            const domainesData = stats.projectsByDomain || {};
            
            if (charts.domaines) {
                charts.domaines.destroy();
            }
            
            charts.domaines = new Chart(ctxDomaines, {
                type: 'bar',
                data: {
                    labels: Object.keys(domainesData),
                    datasets: [{
                        label: 'Nombre de projets',
                        data: Object.values(domainesData),
                        backgroundColor: [
                            'rgba(102, 126, 234, 0.8)',
                            'rgba(118, 75, 162, 0.8)',
                            'rgba(255, 99, 132, 0.8)',
                            'rgba(54, 162, 235, 0.8)',
                            'rgba(255, 206, 86, 0.8)',
                            'rgba(75, 192, 192, 0.8)'
                        ],
                        borderColor: [
                            'rgba(102, 126, 234, 1)',
                            'rgba(118, 75, 162, 1)',
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.parsed.y + ' projet(s)';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });

            // 2. Graphique en camembert : Répartition par statut
            const ctxStatuts = document.getElementById('chartStatuts').getContext('2d');
            const statutsData = stats.projectsByStatus || {};
            
            if (charts.statuts) {
                charts.statuts.destroy();
            }
            
            charts.statuts = new Chart(ctxStatuts, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(statutsData),
                    datasets: [{
                        label: 'Nombre de projets',
                        data: Object.values(statutsData),
                        backgroundColor: [
                            'rgba(102, 126, 234, 0.8)',
                            'rgba(118, 75, 162, 0.8)',
                            'rgba(255, 99, 132, 0.8)',
                            'rgba(54, 162, 235, 0.8)',
                            'rgba(255, 206, 86, 0.8)'
                        ],
                        borderColor: [
                            'rgba(102, 126, 234, 1)',
                            'rgba(118, 75, 162, 1)',
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.parsed || 0;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((value / total) * 100).toFixed(1);
                                    return label + ': ' + value + ' projet(s) (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });

            // 3. Graphique en barres : Budget par domaine
            const ctxBudget = document.getElementById('chartBudget').getContext('2d');
            const budgetData = stats.budgetByDomain || {};
            
            if (charts.budget) {
                charts.budget.destroy();
            }
            
            charts.budget = new Chart(ctxBudget, {
                type: 'bar',
                data: {
                    labels: Object.keys(budgetData),
                    datasets: [{
                        label: 'Budget (FCFA)',
                        data: Object.values(budgetData),
                        backgroundColor: 'rgba(255, 206, 86, 0.8)',
                        borderColor: 'rgba(255, 206, 86, 1)',
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const value = context.parsed.y;
                                    return new Intl.NumberFormat('fr-FR', { 
                                        style: 'currency', 
                                        currency: 'XOF' 
                                    }).format(value).replace('XOF', 'FCFA');
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('fr-FR').format(value) + ' FCFA';
                                }
                            }
                        }
                    }
                }
            });

            // 4. Graphique en barres horizontales : Projets par participant
            const ctxParticipants = document.getElementById('chartParticipants').getContext('2d');
            const participantsData = stats.projectsByParticipant || {};
            
            // Limiter à 10 participants les plus actifs pour la lisibilité
            const sortedParticipants = Object.entries(participantsData)
                .sort((a, b) => b[1] - a[1])
                .slice(0, 10);
            
            if (charts.participants) {
                charts.participants.destroy();
            }
            
            charts.participants = new Chart(ctxParticipants, {
                type: 'bar',
                data: {
                    labels: sortedParticipants.map(p => p[0]),
                    datasets: [{
                        label: 'Nombre de projets',
                        data: sortedParticipants.map(p => p[1]),
                        backgroundColor: 'rgba(75, 192, 192, 0.8)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 2
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.parsed.x + ' projet(s)';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });
        }
    </script>
</body>
</html>
