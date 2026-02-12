function initCharts() {
    const ctxProjectsByDomain = document.getElementById('projectsByDomainChart').getContext('2d');
    const projectsByDomainChart = new Chart(ctxProjectsByDomain, {
        type: 'bar',
        data: {
            labels: [],  // Add your domain labels
            datasets: [{
                label: 'Projects by Domain',
                data: [],  // Add your data here
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    const ctxProjectStatus = document.getElementById('projectStatusChart').getContext('2d');
    const projectStatusChart = new Chart(ctxProjectStatus, {
        type: 'pie',
        data: {
            labels: [],  // Add your status labels
            datasets: [{
                label: 'Project Status',
                data: [],  // Add your status data here
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true
        }
    });

    const ctxTimelineEvolution = document.getElementById('timelineEvolutionChart').getContext('2d');
    const timelineEvolutionChart = new Chart(ctxTimelineEvolution, {
        type: 'line',
        data: {
            labels: [],  // Add your timeline labels
            datasets: [{
                label: 'Timeline Evolution',
                data: [],  // Add your timeline data here
                fill: false,
                borderColor: 'rgba(75, 192, 192, 1)',
                tension: 0.1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    const ctxParticipantWorkload = document.getElementById('participantWorkloadChart').getContext('2d');
    const participantWorkloadChart = new Chart(ctxParticipantWorkload, {
        type: 'doughnut',
        data: {
            labels: [],  // Add your workload labels
            datasets: [{
                label: 'Participant Workload',
                data: [],  // Add your workload data here
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true
        }
    });
}