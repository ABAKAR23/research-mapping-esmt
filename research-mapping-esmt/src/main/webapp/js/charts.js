/**
 * Charts Module for ESMT Research Mapping Platform
 * Implements 4 charts with real API integration
 */

// Chart instances storage
let chartInstances = {
    byDomain: null,
    byStatus: null,
    temporal: null,
    byParticipant: null
};

/**
 * Initialize all charts
 */
async function initCharts() {
    showChartLoading();
    
    try {
        await Promise.all([
            initProjectsByDomainChart(),
            initProjectStatusChart(),
            initTemporalEvolutionChart(),
            initParticipantWorkloadChart()
        ]);
        
        hideChartLoading();
    } catch (error) {
        console.error('Error initializing charts:', error);
        showChartError('Erreur lors du chargement des graphiques');
    }
}

/**
 * Chart 1: Projects by Domain (Bar Chart)
 */
async function initProjectsByDomainChart() {
    const canvas = document.getElementById('projectsByDomainChart');
    if (!canvas) return;
    
    try {
        const data = await API.getProjectsByDomain();
        
        const labels = Object.keys(data);
        const values = Object.values(data);
        
        // Destroy existing chart if any
        if (chartInstances.byDomain) {
            chartInstances.byDomain.destroy();
        }
        
        const ctx = canvas.getContext('2d');
        chartInstances.byDomain = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Nombre de projets',
                    data: values,
                    backgroundColor: 'rgba(102, 126, 234, 0.6)',
                    borderColor: 'rgba(102, 126, 234, 1)',
                    borderWidth: 2,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Projets par Domaine de Recherche',
                        font: {
                            size: 16,
                            weight: 'bold'
                        }
                    },
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
                    },
                    x: {
                        ticks: {
                            maxRotation: 45,
                            minRotation: 45
                        }
                    }
                }
            }
        });
    } catch (error) {
        console.error('Error loading projects by domain:', error);
        showChartError('Erreur lors du chargement des projets par domaine');
    }
}

/**
 * Chart 2: Project Status (Pie Chart)
 */
async function initProjectStatusChart() {
    const canvas = document.getElementById('projectStatusChart');
    if (!canvas) return;
    
    try {
        const data = await API.getProjectsByStatus();
        
        const labels = Object.keys(data).map(key => {
            const statusMap = {
                'EN_COURS': 'En cours',
                'TERMINE': 'Terminé',
                'SUSPENDU': 'Suspendu'
            };
            return statusMap[key] || key;
        });
        const values = Object.values(data);
        
        // Destroy existing chart if any
        if (chartInstances.byStatus) {
            chartInstances.byStatus.destroy();
        }
        
        const ctx = canvas.getContext('2d');
        chartInstances.byStatus = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Statut des projets',
                    data: values,
                    backgroundColor: [
                        'rgba(23, 162, 184, 0.7)',  // En cours - blue
                        'rgba(40, 167, 69, 0.7)',   // Terminé - green
                        'rgba(255, 193, 7, 0.7)'    // Suspendu - yellow
                    ],
                    borderColor: [
                        'rgba(23, 162, 184, 1)',
                        'rgba(40, 167, 69, 1)',
                        'rgba(255, 193, 7, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Répartition par Statut',
                        font: {
                            size: 16,
                            weight: 'bold'
                        }
                    },
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
                                return `${label}: ${value} (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
    } catch (error) {
        console.error('Error loading project status:', error);
        showChartError('Erreur lors du chargement des statuts');
    }
}

/**
 * Chart 3: Temporal Evolution (Line Chart)
 */
async function initTemporalEvolutionChart() {
    const canvas = document.getElementById('timelineEvolutionChart');
    if (!canvas) return;
    
    try {
        const data = await API.getTemporalEvolution();
        
        const labels = Object.keys(data).sort();
        const values = labels.map(year => data[year]);
        
        // Destroy existing chart if any
        if (chartInstances.temporal) {
            chartInstances.temporal.destroy();
        }
        
        const ctx = canvas.getContext('2d');
        chartInstances.temporal = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Nombre de projets',
                    data: values,
                    fill: true,
                    backgroundColor: 'rgba(118, 75, 162, 0.2)',
                    borderColor: 'rgba(118, 75, 162, 1)',
                    borderWidth: 3,
                    tension: 0.4,
                    pointBackgroundColor: 'rgba(118, 75, 162, 1)',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 7
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Évolution Temporelle des Projets',
                        font: {
                            size: 16,
                            weight: 'bold'
                        }
                    },
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y + ' projet(s) créé(s)';
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
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Année'
                        }
                    }
                }
            }
        });
    } catch (error) {
        console.error('Error loading temporal evolution:', error);
        showChartError('Erreur lors du chargement de l\'évolution temporelle');
    }
}

/**
 * Chart 4: Participant Workload (Horizontal Bar Chart)
 */
async function initParticipantWorkloadChart() {
    const canvas = document.getElementById('participantWorkloadChart');
    if (!canvas) return;
    
    try {
        const data = await API.getProjectsByParticipant();
        
        // Sort and get top 10
        const sortedEntries = Object.entries(data)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 10);
        
        const labels = sortedEntries.map(entry => entry[0]);
        const values = sortedEntries.map(entry => entry[1]);
        
        // Generate gradient colors
        const colors = labels.map((_, i) => {
            const ratio = i / labels.length;
            return `rgba(${102 + ratio * 20}, ${126 - ratio * 50}, ${234 - ratio * 100}, 0.7)`;
        });
        
        // Destroy existing chart if any
        if (chartInstances.byParticipant) {
            chartInstances.byParticipant.destroy();
        }
        
        const ctx = canvas.getContext('2d');
        chartInstances.byParticipant = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Nombre de projets',
                    data: values,
                    backgroundColor: colors,
                    borderColor: colors.map(c => c.replace('0.7', '1')),
                    borderWidth: 2,
                    borderRadius: 5
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Top 10 Participants les plus actifs',
                        font: {
                            size: 16,
                            weight: 'bold'
                        }
                    },
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
    } catch (error) {
        console.error('Error loading participant workload:', error);
        showChartError('Erreur lors du chargement de la charge des participants');
    }
}

/**
 * Refresh all charts
 */
async function refreshCharts() {
    const refreshBtn = document.getElementById('refreshChartsBtn');
    if (refreshBtn) {
        refreshBtn.disabled = true;
        refreshBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Actualisation...';
    }
    
    await initCharts();
    
    if (refreshBtn) {
        refreshBtn.disabled = false;
        refreshBtn.innerHTML = '🔄 Actualiser';
    }
}

/**
 * Show loading state
 */
function showChartLoading() {
    const charts = ['projectsByDomainChart', 'projectStatusChart', 'timelineEvolutionChart', 'participantWorkloadChart'];
    charts.forEach(chartId => {
        const container = document.getElementById(chartId)?.parentElement;
        if (container) {
            container.classList.add('chart-loading');
        }
    });
}

/**
 * Hide loading state
 */
function hideChartLoading() {
    const charts = ['projectsByDomainChart', 'projectStatusChart', 'timelineEvolutionChart', 'participantWorkloadChart'];
    charts.forEach(chartId => {
        const container = document.getElementById(chartId)?.parentElement;
        if (container) {
            container.classList.remove('chart-loading');
        }
    });
}

/**
 * Show error message
 */
function showChartError(message) {
    console.error(message);
    if (typeof API !== 'undefined' && API.showError) {
        API.showError(message);
    }
}

// Initialize charts when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initCharts);
} else {
    initCharts();
}