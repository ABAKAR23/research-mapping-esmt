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
      color: white; padding: 0 40px; box-shadow: 0 2px 10px rgba(0,0,0,0.15);
      display: flex; justify-content: space-between; align-items: center;
      height: 70px; position: sticky; top: 0; z-index: 1000;
    }
    .navbar-brand { display: flex; align-items: center; gap: 10px; font-size: 24px; font-weight: 700; }
    .navbar-right { display: flex; align-items: center; gap: 25px; }

    .user-info { display:flex; align-items:center; gap:12px; }
    .user-avatar {
      width: 38px; height: 38px; border-radius: 50%;
      background: rgba(255,255,255,0.25);
      display:flex; align-items:center; justify-content:center;
      font-weight:700;
    }

    .btn-logout {
      background: rgba(255,255,255,0.2);
      color: white;
      padding: 8px 16px;
      border: 1px solid white;
      border-radius: 5px;
      cursor: pointer;
      font-weight: 600;
    }

    .main-container { display: flex; min-height: calc(100vh - 70px); }
    .sidebar { width: 250px; background: white; border-right: 1px solid #e0e0e0; padding: 20px 0; }
    .sidebar-menu { list-style: none; }
    .sidebar-menu a {
      display: flex; align-items: center; gap: 12px;
      padding: 15px 25px; color: #555; text-decoration: none; cursor: pointer;
    }
    .sidebar-menu a.active { background: #f0f2f5; color: #667eea; border-left: 4px solid #667eea; }

    .content { flex: 1; padding: 30px; overflow-y: auto; }
    .page { display: none; }
    .page.active { display: block; }
    .page-header { margin-bottom: 18px; }
    .page-header h1 { margin-bottom: 6px; }
    .page-header p { color: #777; }

    .stat-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white; padding: 20px; border-radius: 10px; text-align: center;
    }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 20px; margin-bottom: 30px;
    }
    .label { opacity: 0.9; font-size: 13px; }
    .value { font-size: 28px; font-weight: 800; margin-top: 6px; }

    .panel {
      background: white;
      padding: 16px;
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      margin-bottom: 20px;
    }

    .chart-container {
      background: white; padding: 20px; border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      height: 420px; margin-bottom: 20px;
    }

    .grid-2 { display:grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    @media (max-width: 1000px) { .grid-2 { grid-template-columns: 1fr; } }

    table { width:100%; border-collapse: collapse; }
    th, td { padding: 10px; border-bottom: 1px solid #eee; text-align: left; vertical-align: top; }
    th { background: #f7f7f7; }

    .btn-small {
      padding: 6px 10px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 600;
      color: #fff;
    }
    .btn-blue { background: #667eea; }
    .btn-green { background: #28a745; }
    .btn-gray { background: #6c757d; }

    /* Modal */
    .modal-overlay {
      display: none;
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0, 0, 0, 0.5);
      z-index: 2000;
      justify-content: center;
      align-items: center;
    }
    .modal-overlay.show { display: flex; }
    .modal {
      background: white;
      border-radius: 10px;
      padding: 22px;
      width: 560px;
      max-width: 92%;
    }
    .modal h2 { margin-bottom: 14px; }
    .modal label { display:block; font-weight:600; margin: 10px 0 6px; }
    .modal input, .modal select {
      width:100%;
      padding:10px;
      border:1px solid #ddd;
      border-radius:6px;
    }
    .modal-actions { display:flex; gap:10px; margin-top: 16px; justify-content:flex-end; }
  </style>

  <script>
    // ✅ pour les onclick inline (évite "showPage is not defined")
    window.showPage = function(pageId, event) {
      if (event) event.preventDefault();

      document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
      document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));

      const page = document.getElementById(pageId);
      if (page) page.classList.add('active');

      const navLink = document.querySelector(`[data-page="\${pageId}"]`);
      if (navLink) navLink.classList.add('active');
    };
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
      <button class="btn-logout" id="logoutBtn">Se Déconnecter</button>
    </div>
  </div>

  <div class="main-container">
    <div class="sidebar">
      <ul class="sidebar-menu">
        <li><a class="nav-link active" data-page="dashboard" onclick="showPage('dashboard', event)"><span>📊</span> Tableau de Bord</a></li>
        <li><a class="nav-link" data-page="projects" onclick="showPage('projects', event)"><span>📁</span> Projets</a></li>
      </ul>
    </div>

    <div class="content">
      <!-- DASHBOARD -->
      <div id="dashboard" class="page active">
        <div class="page-header">
          <h1>🎯 Tableau de Bord (Admin / Gestionnaire)</h1>
          <p>Affichage automatique des statistiques globales</p>
        </div>

        <div class="stats-grid">
          <div class="stat-card">
            <div class="label">1) Nombre total de projets</div>
            <div class="value" id="totalProjects">-</div>
          </div>
          <div class="stat-card">
            <div class="label">2) Domaines (avec projets)</div>
            <div class="value" id="totalDomains">-</div>
          </div>
          <div class="stat-card">
            <div class="label">6) Taux moyen d’avancement</div>
            <div class="value" id="avgProgress">-</div>
          </div>
          <div class="stat-card">
            <div class="label">Budget total (info)</div>
            <div class="value" id="totalBudget">-</div>
          </div>
        </div>

        <div class="panel">
          <p><strong>📧 Email :</strong> <span id="userEmail"></span></p>
          <p><strong>👤 Rôle :</strong> <span id="userRole"></span></p>
        </div>

        <div class="grid-2">
          <div class="chart-container">
            <h3>2) Nombre de projets par domaine</h3>
            <canvas id="chartByDomain"></canvas>
          </div>

          <div class="chart-container">
            <h3>3) Répartition par statut</h3>
            <canvas id="chartByStatus"></canvas>
          </div>

          <div class="chart-container">
            <h3>5) Budget total par domaine</h3>
            <canvas id="chartBudgetByDomain"></canvas>
          </div>

          <div class="chart-container">
            <h3>4) Nombre de projets par participant (Top 10)</h3>
            <canvas id="chartByParticipant"></canvas>
          </div>
        </div>
      </div>

      <!-- PROJECTS -->
      <div id="projects" class="page">
        <div class="page-header">
          <h1>📁 Projets</h1>
          <p>Admin/Gestionnaire : voit tous les projets, peut modifier et affecter des participants.</p>
        </div>

        <div class="panel">
          <button class="btn-logout" style="background:#667eea" id="reloadProjectsBtn">Recharger</button>
        </div>

        <div class="panel">
          <div style="overflow:auto">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Titre</th>
                  <th>Domaine</th>
                  <th>Statut</th>
                  <th>Budget</th>
                  <th>Avancement</th>
                  <th>Responsable</th>
                  <th>Participants</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody id="projectsTableBody"></tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- MODAL: Edit project + assign participants -->
  <div id="projectModal" class="modal-overlay">
    <div class="modal">
      <h2 id="projectModalTitle">Modifier Projet</h2>

      <label for="editStatut">Statut</label>
      <select id="editStatut">
        <option value="EN_COURS">EN_COURS</option>
        <option value="SUSPENDU">SUSPENDU</option>
        <option value="TERMINE">TERMINE</option>
      </select>

      <label for="editBudget">Budget (FCFA)</label>
      <input id="editBudget" type="number" min="0">

      <label for="editProgress">Avancement (%)</label>
      <input id="editProgress" type="number" min="0" max="100">

      <label for="editParticipantIds">Participants (IDs séparés par virgule)</label>
      <input id="editParticipantIds" type="text" placeholder="Ex: 2,4,7">
      <div style="color:#777;margin-top:6px" id="currentParticipants">Participants actuels: —</div>

      <div class="modal-actions">
        <button class="btn-small btn-gray" onclick="closeModal('projectModal')">Annuler</button>
        <button class="btn-small btn-green" onclick="saveProjectChanges()">Enregistrer</button>
      </div>
    </div>
  </div>

  <script>
    let charts = {};
    let currentProject = null;

    document.addEventListener('DOMContentLoaded', async () => {
      // expose for inline buttons
      window.openEditProject = openEditProject;
      window.openParticipants = openParticipants;
      window.saveProjectChanges = saveProjectChanges;
      window.closeModal = closeModal;

      document.getElementById('logoutBtn').addEventListener('click', () => {
        if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) window.location.href = '/logout';
      });

      const reloadProjectsBtn = document.getElementById('reloadProjectsBtn');
      if (reloadProjectsBtn) reloadProjectsBtn.addEventListener('click', loadProjects);

      try {
        await loadMe();
        await loadAllStats();
        await loadProjects();
      } catch (e) {
        console.error(e);
        alert("Erreur lors du chargement du tableau de bord. Vérifie /api/statistics et /api/users/me.");
      }
    });

    async function apiRequest(url, options = {}) {
      const response = await fetch(url, {
        credentials: 'include',
        headers: {
          'Accept': 'application/json',
          ...(options.body ? { 'Content-Type': 'application/json' } : {}),
          ...(options.headers || {})
        },
        ...options
      });

      if (!response.ok) {
        const text = await response.text().catch(() => '');
        throw new Error(`HTTP \${response.status} \${response.statusText}: \${text}`);
      }

      const ct = response.headers.get('content-type') || '';
      if (ct.includes('application/json')) return response.json();
      return response.text();
    }

    async function loadMe() {
      const me = await apiRequest('/api/users/me');

      document.getElementById('userEmail').textContent = me.email || '';
      document.getElementById('userRole').textContent = me.roleLibelle || me.role || '';

      const name =
        (me.nom && me.nom.trim().length > 0)
          ? me.nom
          : (me.email ? me.email.split('@')[0] : 'Utilisateur');

      document.getElementById('displayNameNav').textContent = name;
      document.getElementById('userAvatarNav').textContent = name.charAt(0).toUpperCase();
    }

    async function loadAllStats() {
      const stats = await apiRequest('/api/statistics');

      document.getElementById('totalProjects').textContent = (stats.totalProjets ?? '-');
      document.getElementById('avgProgress').textContent =
        (Number(stats.tauxMoyenAvancement ?? 0).toFixed(1)) + '%';
      document.getElementById('totalBudget').textContent = formatMoney(stats.budgetTotal ?? 0);

      const byDomain = stats.projetsParDomaine || {};
      document.getElementById('totalDomains').textContent = Object.keys(byDomain).length;

      renderPieChart('chartByDomain', 'Projets', byDomain);
      renderPieChart('chartByStatus', 'Projets', stats.projetsParStatut || {});
      renderBarChart('chartBudgetByDomain', 'Budget', stats.budgetParDomaine || {}, true);
      renderBarChart('chartByParticipant', 'Projets', takeTopN(stats.projetsParParticipant || {}, 10), false);
    }

    async function loadProjects() {
      const projects = await apiRequest('/api/projects'); // admin/gestionnaire => tous
      const tbody = document.getElementById('projectsTableBody');
      if (!tbody) return;

      tbody.innerHTML = (projects || []).map(p => `
        <tr>
          <td>\${p.projectId ?? ''}</td>
          <td>\${escapeHtml(p.titreProjet ?? '')}</td>
          <td>\${escapeHtml(p.domaineNom ?? '')}</td>
          <td>\${escapeHtml(p.statutProjet ?? '')}</td>
          <td>\${formatMoney(p.budgetEstime ?? 0)}</td>
          <td>\${(p.niveauAvancement ?? 0)}%</td>
          <td>\${escapeHtml(p.responsableNom ?? '')}</td>
          <td>\${escapeHtml((p.participantNames || []).join(', '))}</td>
          <td style="white-space:nowrap">
            <button class="btn-small btn-blue" onclick="openEditProject(\${p.projectId})">Modifier</button>
            <button class="btn-small btn-green" style="margin-left:6px" onclick="openParticipants(\${p.projectId})">Participants</button>
          </td>
        </tr>
      `).join('');
    }

    function openModal(id) {
      document.getElementById(id).classList.add('show');
    }
    function closeModal(id) {
      document.getElementById(id).classList.remove('show');
    }

    function parseIds(raw) {
      return String(raw || '')
        .split(',')
        .map(s => s.trim())
        .filter(Boolean)
        .map(Number)
        .filter(n => Number.isFinite(n));
    }

    async function openEditProject(projectId) {
      currentProject = await apiRequest('/api/projects/' + projectId);

      document.getElementById('projectModalTitle').textContent = 'Modifier Projet #' + projectId;
      document.getElementById('editStatut').value = currentProject.statutProjet || 'EN_COURS';
      document.getElementById('editBudget').value = currentProject.budgetEstime ?? 0;
      document.getElementById('editProgress').value = currentProject.niveauAvancement ?? 0;

      const names = (currentProject.participantNames || []).join(', ');
      document.getElementById('currentParticipants').textContent =
        names ? ('Participants actuels: ' + names) : 'Participants actuels: —';

      const ids = (currentProject.participantIds || []).join(',');
      document.getElementById('editParticipantIds').value = ids;

      openModal('projectModal');
    }

    async function openParticipants(projectId) {
      await openEditProject(projectId);
      document.getElementById('editParticipantIds').focus();
    }

    async function saveProjectChanges() {
      if (!currentProject || !currentProject.projectId) return;

      // On garde les champs existants du projet + on modifie ce qu'on expose dans le modal
      const payload = {
        projectId: currentProject.projectId,
        titreProjet: currentProject.titreProjet,
        description: currentProject.description,
        dateDebut: currentProject.dateDebut,
        dateFin: currentProject.dateFin,
        institution: currentProject.institution,
        domaineId: currentProject.domaineId,

        statutProjet: document.getElementById('editStatut').value,
        budgetEstime: Number(document.getElementById('editBudget').value || 0),
        niveauAvancement: Number(document.getElementById('editProgress').value || 0),

        participantIds: parseIds(document.getElementById('editParticipantIds').value)
      };

      await apiRequest('/api/projects/' + currentProject.projectId, {
        method: 'PUT',
        body: JSON.stringify(payload)
      });

      closeModal('projectModal');
      await loadAllStats();
      await loadProjects();
      alert('✅ Projet mis à jour');
    }

    function renderPieChart(canvasId, label, obj) {
      const el = document.getElementById(canvasId);
      if (!el) return;

      const labels = Object.keys(obj || {});
      const data = Object.values(obj || {});
      if (charts[canvasId]) charts[canvasId].destroy();

      charts[canvasId] = new Chart(el, {
        type: 'doughnut',
        data: { labels, datasets: [{ label, data }] },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
      });
    }

    function renderBarChart(canvasId, label, obj, money) {
      const el = document.getElementById(canvasId);
      if (!el) return;

      const labels = Object.keys(obj || {});
      const data = Object.values(obj || {});
      if (charts[canvasId]) charts[canvasId].destroy();

      charts[canvasId] = new Chart(el, {
        type: 'bar',
        data: { labels, datasets: [{ label, data, backgroundColor: '#667eea' }] },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            y: {
              ticks: {
                callback: function(value) {
                  return money ? formatMoney(value) : value;
                }
              }
            }
          }
        }
      });
    }

    function takeTopN(obj, n) {
      return Object.fromEntries(
        Object.entries(obj || {})
          .sort((a,b) => (b[1] || 0) - (a[1] || 0))
          .slice(0, n)
      );
    }

    function formatMoney(x) {
      const v = Number(x || 0);
      return v.toLocaleString('fr-FR') + ' F';
    }

    function escapeHtml(str) {
      return String(str ?? '').replace(/[&<>"']/g, s => ({
        '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
      }[s]));
    }
  </script>
</body>
</html>