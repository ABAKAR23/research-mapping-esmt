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
        font-size: 22px;
        font-weight: 700;
      }

      .navbar-right {
        display: flex;
        align-items: center;
        gap: 25px;
      }

      .user-info {
        display: flex;
        align-items: center;
        gap: 12px;
      }

      .user-avatar {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.25);
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
      }

      .main-container {
        display: flex;
        min-height: calc(100vh - 70px);
      }

      .sidebar {
        width: 250px;
        background: white;
        border-right: 1px solid #e0e0e0;
        padding: 20px 0;
        flex-shrink: 0;
      }

      .sidebar-menu {
        list-style: none;
      }

      .sidebar-menu a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 25px;
        color: #555;
        text-decoration: none;
        cursor: pointer;
        transition: background 0.2s;
      }

      .sidebar-menu a:hover {
        background: #f7f7f7;
      }

      .sidebar-menu a.active {
        background: #f0f2f5;
        color: #667eea;
        border-left: 4px solid #667eea;
        font-weight: 600;
      }

      .sidebar-section {
        padding: 10px 20px 4px;
        font-size: 11px;
        text-transform: uppercase;
        color: #aaa;
        letter-spacing: 1px;
      }

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

      .page-header {
        margin-bottom: 20px;
      }

      .page-header h1 {
        font-size: 22px;
        margin-bottom: 5px;
      }

      .page-header p {
        color: #777;
        font-size: 14px;
      }

      .stat-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 20px;
        border-radius: 10px;
        text-align: center;
      }

      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
      }

      .label {
        opacity: 0.9;
        font-size: 13px;
      }

      .value {
        font-size: 28px;
        font-weight: 800;
        margin-top: 6px;
      }

      .panel {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        margin-bottom: 20px;
      }

      .panel h3 {
        margin-bottom: 14px;
        font-size: 16px;
        color: #333;
      }

      .chart-container {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        height: 380px;
        margin-bottom: 20px;
        display: flex;
        flex-direction: column;
      }

      .chart-container h3 {
        margin-bottom: 10px;
        font-size: 15px;
        color: #333;
      }

      .chart-container canvas {
        flex: 1;
        min-height: 0;
      }

      .charts-grid-2 {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
      }

      .chart-full {
        grid-column: 1 / -1;
      }

      @media (max-width: 1000px) {
        .charts-grid-2 {
          grid-template-columns: 1fr;
        }

        .chart-full {
          grid-column: 1;
        }
      }

      table {
        width: 100%;
        border-collapse: collapse;
      }

      th,
      td {
        padding: 10px 12px;
        border-bottom: 1px solid #eee;
        text-align: left;
        vertical-align: middle;
        font-size: 14px;
      }

      th {
        background: #f7f7f7;
        font-weight: 600;
        color: #444;
      }

      tr:hover td {
        background: #fafafa;
      }

      .btn-small {
        padding: 5px 10px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-weight: 600;
        color: #fff;
        font-size: 12px;
      }

      .btn-blue {
        background: #667eea;
      }

      .btn-green {
        background: #28a745;
      }

      .btn-red {
        background: #e53e3e;
      }

      .btn-gray {
        background: #6c757d;
      }

      .btn-primary-lg {
        padding: 10px 20px;
        background: #667eea;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
      }

      .badge {
        display: inline-block;
        padding: 3px 8px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 600;
      }

      .badge-green {
        background: #c6f6d5;
        color: #276749;
      }

      .badge-blue {
        background: #bee3f8;
        color: #2b6cb0;
      }

      .badge-orange {
        background: #feebc8;
        color: #c05621;
      }

      .badge-gray {
        background: #e2e8f0;
        color: #4a5568;
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
        border-radius: 12px;
        padding: 28px;
        width: 600px;
        max-width: 95%;
        max-height: 90vh;
        overflow-y: auto;
      }

      .modal h2 {
        margin-bottom: 16px;
        font-size: 18px;
      }

      .modal label {
        display: block;
        font-weight: 600;
        margin: 12px 0 5px;
        font-size: 13px;
        color: #555;
      }

      .modal input,
      .modal select,
      .modal textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
      }

      .modal textarea {
        resize: vertical;
        min-height: 70px;
      }

      .modal-actions {
        display: flex;
        gap: 10px;
        margin-top: 18px;
        justify-content: flex-end;
      }

      .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 12px;
      }

      .alert {
        padding: 12px 16px;
        border-radius: 8px;
        margin-bottom: 16px;
        font-size: 14px;
      }

      .alert-success {
        background: #f0fff4;
        color: #276749;
        border: 1px solid #c6f6d5;
      }

      .alert-error {
        background: #fff5f5;
        color: #c53030;
        border: 1px solid #feb2b2;
      }

      #alert-msg {
        display: none;
      }

      .progress-bar-bg {
        background: #e2e8f0;
        border-radius: 4px;
        height: 8px;
      }

      .progress-bar-fill {
        background: linear-gradient(90deg, #667eea, #764ba2);
        height: 8px;
        border-radius: 4px;
        transition: width 0.3s;
      }
    </style>

    <script>
      window.showPage = function (pageId, event) {
        if (event) event.preventDefault();
        document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
        const page = document.getElementById(pageId);
        if (page) page.classList.add('active');
        const navLink = document.querySelector(`[data-page="${pageId}"]`);
        if (navLink) navLink.classList.add('active');
      };
    </script>
  </head>

  <body>
    <!-- NAVBAR -->
    <div class="navbar">
      <div class="navbar-brand"><span>🔬</span> ESMT Research Mapping</div>
      <div class="navbar-right">
        <div class="user-info">
          <div class="user-avatar" id="userAvatarNav">U</div>
          <div>
            <div style="font-size:13px;">Bienvenue,</div>
            <div style="font-weight:600;" id="displayNameNav">Utilisateur</div>
          </div>
        </div>
        <button class="btn-logout" id="logoutBtn">Se Déconnecter</button>
      </div>
    </div>

    <div class="main-container">
      <!-- SIDEBAR -->
      <div class="sidebar">
        <ul class="sidebar-menu">
          <li class="sidebar-section">Tableau de Bord</li>
          <li><a class="nav-link active" data-page="dashboard" onclick="showPage('dashboard', event)"><span>📊</span>
              Vue Générale</a></li>

          <li class="sidebar-section">Gestion</li>
          <li><a class="nav-link" data-page="projects" onclick="showPage('projects', event)"><span>📁</span> Projets</a>
          </li>
          <li><a class="nav-link" data-page="statistiques" onclick="showPage('statistiques', event)"><span>📈</span>
              Statistiques</a></li>
          <li><a class="nav-link" data-page="utilisateurs" onclick="showPage('utilisateurs', event)"><span>👥</span>
              Utilisateurs</a></li>

          <li class="sidebar-section">Configuration</li>
          <li><a class="nav-link" data-page="domaines" onclick="showPage('domaines', event)"><span>🏷️</span>
              Domaines</a></li>
          <li><a href="/import"><span>⬆️</span> Import CSV</a></li>
        </ul>
      </div>

      <!-- CONTENU PRINCIPAL -->
      <div class="content">
        <!-- Alert global -->
        <div id="alert-msg" class="alert"></div>

        <!-- ===== PAGE: DASHBOARD OVERVIEW ===== -->
        <div id="dashboard" class="page active">
          <div class="page-header">
            <h1>🎯 Tableau de Bord — Administrateur / Gestionnaire</h1>
            <p>Vue globale automatique des projets de recherche</p>
          </div>

          <!-- KPIs -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="label">1) Nombre total de projets</div>
              <div class="value" id="totalProjects">—</div>
            </div>
            <div class="stat-card">
              <div class="label">2) Domaines actifs</div>
              <div class="value" id="totalDomains">—</div>
            </div>
            <div class="stat-card">
              <div class="label">6) Taux moyen d'avancement</div>
              <div class="value" id="avgProgress">—</div>
            </div>
            <div class="stat-card">
              <div class="label">Budget total estimé</div>
              <div class="value" id="totalBudget">—</div>
            </div>
          </div>

          <div class="panel">
            <p><strong>📧 Email :</strong> <span id="userEmail"></span>&nbsp;&nbsp;
              <strong>👤 Rôle :</strong> <span id="userRole"></span>
            </p>
          </div>

          <!-- Graphiques -->
          <div class="charts-grid-2">
            <!-- Graphique 1: Projets par domaine (bar) -->
            <div class="chart-container">
              <h3>📊 G1 — Projets par domaine</h3>
              <canvas id="chartByDomain"></canvas>
            </div>

            <!-- Graphique 2: Statut des projets (doughnut / camembert) -->
            <div class="chart-container">
              <h3>🔵 G2 — Répartition par statut</h3>
              <canvas id="chartByStatus"></canvas>
            </div>

            <!-- Graphique 3: Évolution temporelle (line) — REQUIS par le cahier des charges -->
            <div class="chart-container chart-full">
              <h3>📈 G3 — Évolution temporelle des projets par année</h3>
              <canvas id="chartTimeline"></canvas>
            </div>

            <!-- Graphique 4: Charge des participants (bar horizontal) -->
            <div class="chart-container">
              <h3>👥 G4 — Charge des participants (Top 10)</h3>
              <canvas id="chartByParticipant"></canvas>
            </div>

            <!-- Graphique 5: Budget par domaine (bar) -->
            <div class="chart-container">
              <h3>💰 G5 — Budget total par domaine</h3>
              <canvas id="chartBudgetByDomain"></canvas>
            </div>
          </div>
        </div>

        <!-- ===== PAGE: PROJETS ===== -->
        <div id="projects" class="page">
          <div class="page-header">
            <h1>📁 Gestion des Projets</h1>
            <p>Admin/Gestionnaire : voir tous les projets, modifier, affecter des participants.</p>
          </div>

          <div class="panel" style="display:flex; gap:10px; align-items:center;">
            <button class="btn-primary-lg" onclick="openCreateProjectModal()">+ Nouveau Projet</button>
            <button class="btn-primary-lg" style="background:#28a745;" id="reloadProjectsBtn">↺ Actualiser</button>
          </div>

          <div class="panel">
            <div style="overflow:auto;">
              <table>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Titre</th>
                    <th>Domaine</th>
                    <th>Statut</th>
                    <th>Avancement</th>
                    <th>Budget</th>
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

        <!-- ===== PAGE: STATISTIQUES ===== -->
        <div id="statistiques" class="page">
          <div class="page-header">
            <h1>📈 Statistiques Détaillées</h1>
            <p>Indicateurs clés pour la prise de décision</p>
          </div>
          <div class="stats-grid" id="statsDetailGrid">
            <div class="stat-card">
              <div class="label">Total Projets</div>
              <div class="value" id="stat-total">—</div>
            </div>
            <div class="stat-card">
              <div class="label">Domaines actifs</div>
              <div class="value" id="stat-domaines">—</div>
            </div>
            <div class="stat-card">
              <div class="label">Taux d'avancement moyen</div>
              <div class="value" id="stat-avancement">—</div>
            </div>
            <div class="stat-card">
              <div class="label">Budget total estimé</div>
              <div class="value" id="stat-budget">—</div>
            </div>
          </div>
          <div class="panel">
            <h3>Répartition par statut</h3>
            <table>
              <thead>
                <tr>
                  <th>Statut</th>
                  <th>Nombre de projets</th>
                </tr>
              </thead>
              <tbody id="statutTableBody"></tbody>
            </table>
          </div>
          <div class="panel">
            <h3>Projets par domaine</h3>
            <table>
              <thead>
                <tr>
                  <th>Domaine</th>
                  <th>Nombre de projets</th>
                  <th>Budget total</th>
                </tr>
              </thead>
              <tbody id="domaineStatTableBody"></tbody>
            </table>
          </div>
          <div class="panel">
            <h3>Charge par participant</h3>
            <table>
              <thead>
                <tr>
                  <th>Participant</th>
                  <th>Nombre de projets</th>
                </tr>
              </thead>
              <tbody id="participantStatTableBody"></tbody>
            </table>
          </div>
        </div>

        <!-- ===== PAGE: UTILISATEURS ===== -->
        <div id="utilisateurs" class="page">
          <div class="page-header">
            <h1>👥 Gestion des Utilisateurs</h1>
            <p>Administrateur : créer, modifier et supprimer des comptes utilisateurs.</p>
          </div>
          <div class="panel" style="display:flex; gap:10px;">
            <button class="btn-primary-lg" onclick="openCreateUserModal()">+ Nouvel Utilisateur</button>
            <button class="btn-primary-lg" style="background:#28a745;" onclick="loadUsers()">↺ Actualiser</button>
          </div>
          <div class="panel">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Nom</th>
                  <th>Email</th>
                  <th>Institution</th>
                  <th>Rôle</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody id="usersTableBody"></tbody>
            </table>
          </div>
        </div>

        <!-- ===== PAGE: DOMAINES ===== -->
        <div id="domaines" class="page">
          <div class="page-header">
            <h1>🏷️ Domaines de Recherche</h1>
            <p>Administrateur : paramétrer les domaines scientifiques disponibles.</p>
          </div>
          <div class="panel" style="display:flex; gap:10px;">
            <button class="btn-primary-lg" onclick="openCreateDomaineModal()">+ Nouveau Domaine</button>
            <button class="btn-primary-lg" style="background:#28a745;" onclick="loadDomaines()">↺ Actualiser</button>
          </div>
          <div class="panel">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Nom du Domaine</th>
                  <th>Description</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody id="domainesTableBody"></tbody>
            </table>
          </div>
        </div>

      </div><!-- /content -->
    </div><!-- /main-container -->

    <!-- ===== MODAL: Modifier Projet ===== -->
    <div id="projectModal" class="modal-overlay">
      <div class="modal">
        <h2 id="projectModalTitle">Projet</h2>
        <div class="form-row">
          <div>
            <label>Titre *</label>
            <input id="editTitre" type="text" placeholder="Titre du projet">
          </div>
          <div>
            <label>Institution</label>
            <input id="editInstitution" type="text" placeholder="Institution">
          </div>
        </div>
        <label>Description</label>
        <textarea id="editDescription" placeholder="Description du projet"></textarea>
        <div class="form-row">
          <div>
            <label>Domaine</label>
            <select id="editDomaine"></select>
          </div>
          <div>
            <label>Statut</label>
            <select id="editStatut">
              <option value="EN_COURS">En cours</option>
              <option value="TERMINE">Terminé</option>
              <option value="SUSPENDU">Suspendu</option>
            </select>
          </div>
        </div>
        <div class="form-row">
          <div>
            <label>Date début</label>
            <input id="editDateDebut" type="date">
          </div>
          <div>
            <label>Date fin</label>
            <input id="editDateFin" type="date">
          </div>
        </div>
        <div class="form-row">
          <div>
            <label>Budget estimé (FCFA)</label>
            <input id="editBudget" type="number" min="0">
          </div>
          <div>
            <label>Avancement (%)</label>
            <input id="editProgress" type="number" min="0" max="100">
          </div>
        </div>
        <label>Participants (IDs séparés par virgule)</label>
        <input id="editParticipantIds" type="text" placeholder="Ex: 2,4,7">
        <div style="color:#777; font-size:13px; margin-top:5px;" id="currentParticipants">Participants actuels : —</div>
        <div class="modal-actions">
          <button class="btn-small btn-gray" onclick="closeModal('projectModal')">Annuler</button>
          <button class="btn-small btn-green" onclick="saveProjectChanges()">💾 Enregistrer</button>
        </div>
      </div>
    </div>

    <!-- ===== MODAL: Créer Utilisateur ===== -->
    <div id="userModal" class="modal-overlay">
      <div class="modal">
        <h2 id="userModalTitle">Utilisateur</h2>
        <label>Nom *</label>
        <input id="userNom" type="text" placeholder="Nom complet">
        <label>Email *</label>
        <input id="userEmail2" type="email" placeholder="email@esmt.sn">
        <label>Institution</label>
        <input id="userInstitution" type="text" placeholder="ESMT">
        <label>Rôle</label>
        <select id="userRole2">
          <option value="ADMIN">Administrateur</option>
          <option value="GESTIONNAIRE">Gestionnaire</option>
          <option value="CANDIDAT">Candidat</option>
        </select>
        <label>Mot de passe (création uniquement)</label>
        <input id="userPassword" type="password" placeholder="••••••••">
        <div class="modal-actions">
          <button class="btn-small btn-gray" onclick="closeModal('userModal')">Annuler</button>
          <button class="btn-small btn-green" onclick="saveUser()">💾 Enregistrer</button>
        </div>
      </div>
    </div>

    <!-- ===== MODAL: Domaine ===== -->
    <div id="domaineModal" class="modal-overlay">
      <div class="modal">
        <h2 id="domaineModalTitle">Domaine de Recherche</h2>
        <label>Nom du domaine *</label>
        <input id="domaineNom" type="text" placeholder="Ex: Intelligence Artificielle">
        <label>Description</label>
        <textarea id="domaineDesc" placeholder="Description du domaine"></textarea>
        <div class="modal-actions">
          <button class="btn-small btn-gray" onclick="closeModal('domaineModal')">Annuler</button>
          <button class="btn-small btn-green" onclick="saveDomaine()">💾 Enregistrer</button>
        </div>
      </div>
    </div>

    <script>
      let charts = {};
      let currentProject = null;
      let currentUserId = null;
      let currentDomaineId = null;
      let allDomaines = [];
      let allUsers = [];

      // ─── Expose functions for inline event handlers ────────────────
      window.openEditProject = openEditProject;
      window.openCreateProjectModal = openCreateProjectModal;
      window.saveProjectChanges = saveProjectChanges;
      window.openCreateUserModal = openCreateUserModal;
      window.openEditUserModal = openEditUserModal;
      window.deleteUser = deleteUser;
      window.openCreateDomaineModal = openCreateDomaineModal;
      window.openEditDomaineModal = openEditDomaineModal;
      window.deleteDomaine = deleteDomaine;
      window.saveUser = saveUser;
      window.saveDomaine = saveDomaine;
      window.closeModal = closeModal;
      window.loadUsers = loadUsers;
      window.loadDomaines = loadDomaines;

      document.addEventListener('DOMContentLoaded', async () => {
        document.getElementById('logoutBtn').addEventListener('click', () => {
          if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) window.location.href = '/logout';
        });
        const reloadProjectsBtn = document.getElementById('reloadProjectsBtn');
        if (reloadProjectsBtn) reloadProjectsBtn.addEventListener('click', loadProjects);

        try {
          await loadMe();
          await Promise.all([loadAllStats(), loadProjects(), loadDomaines(), loadUsers()]);
        } catch (e) {
          console.error(e);
          showAlert('Erreur lors du chargement du tableau de bord : ' + e.message, 'error');
        }
      });

      // ─── HTTP helper ──────────────────────────────────────────────
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
          throw new Error(`HTTP ${response.status} — ${text}`);
        }
        const ct = response.headers.get('content-type') || '';
        if (ct.includes('application/json')) return response.json();
        return response.text();
      }

      // ─── Profil courant ───────────────────────────────────────────
      async function loadMe() {
        const me = await apiRequest('/api/users/me');
        document.getElementById('userEmail').textContent = me.email || '';
        document.getElementById('userRole').textContent = me.roleLibelle || me.role || '';
        const name = (me.nom && me.nom.trim().length > 0) ? me.nom : (me.email ? me.email.split('@')[0] : 'Utilisateur');
        document.getElementById('displayNameNav').textContent = name;
        document.getElementById('userAvatarNav').textContent = name.charAt(0).toUpperCase();
      }

      // ─── Statistiques & Graphiques ────────────────────────────────
      async function loadAllStats() {
        const stats = await apiRequest('/api/statistics');

        const totalProjets = stats.totalProjets ?? 0;
        const byDomain = stats.projetsParDomaine || {};
        const byStatus = stats.projetsParStatut || {};
        const byParticipant = stats.projetsParParticipant || {};
        const budgetByDomain = stats.budgetParDomaine || {};
        const timeline = stats.evolutionTemporelle || {};

        // KPIs
        document.getElementById('totalProjects').textContent = totalProjets;
        document.getElementById('totalDomains').textContent = Object.keys(byDomain).length;
        document.getElementById('avgProgress').textContent = Number(stats.tauxMoyenAvancement ?? 0).toFixed(1) + '%';
        document.getElementById('totalBudget').textContent = formatMoney(stats.budgetTotal ?? 0);

        // Statistiques page duplicates
        document.getElementById('stat-total').textContent = totalProjets;
        document.getElementById('stat-domaines').textContent = Object.keys(byDomain).length;
        document.getElementById('stat-avancement').textContent = Number(stats.tauxMoyenAvancement ?? 0).toFixed(1) + '%';
        document.getElementById('stat-budget').textContent = formatMoney(stats.budgetTotal ?? 0);

        // Table statuts
        const statutBody = document.getElementById('statutTableBody');
        if (statutBody) {
          statutBody.innerHTML = Object.entries(byStatus).map(([s, n]) =>
            `<tr><td>${escapeHtml(s)}</td><td><strong>${n}</strong></td></tr>`
          ).join('');
        }

        // Table domaines/budget
        const domaineStatBody = document.getElementById('domaineStatTableBody');
        if (domaineStatBody) {
          domaineStatBody.innerHTML = Object.entries(byDomain).map(([d, n]) =>
            `<tr><td>${escapeHtml(d)}</td><td>${n}</td><td>${formatMoney(budgetByDomain[d] || 0)}</td></tr>`
          ).join('');
        }

        // Table participants
        const participantBody = document.getElementById('participantStatTableBody');
        if (participantBody) {
          participantBody.innerHTML = Object.entries(byParticipant)
            .sort((a, b) => b[1] - a[1])
            .map(([p, n]) => `<tr><td>${escapeHtml(p)}</td><td>${n}</td></tr>`)
            .join('');
        }

        // ── Graphique 1: Projets par domaine (bar) ──
        renderBarChart('chartByDomain', 'Projets', byDomain, false, 'bar');

        // ── Graphique 2: Statut des projets (doughnut/camembert) ──
        renderDoughnutChart('chartByStatus', byStatus);

        // ── Graphique 3: Évolution temporelle (line) ──
        renderLineChart('chartTimeline', 'Projets démarrés', timeline);

        // ── Graphique 4: Charge des participants (bar horizontal) ──
        renderBarHChart('chartByParticipant', 'Projets', takeTopN(byParticipant, 10));

        // ── Graphique 5: Budget par domaine (bar) ──
        renderBarChart('chartBudgetByDomain', 'Budget (FCFA)', budgetByDomain, true, 'bar');
      }

      // ─── Projets ──────────────────────────────────────────────────
      async function loadProjects() {
        const projects = await apiRequest('/api/projects');
        const tbody = document.getElementById('projectsTableBody');
        if (!tbody) return;
        tbody.innerHTML = (projects || []).map(p => `
        <tr>
          <td>${p.projectId ?? ''}</td>
          <td><strong>${escapeHtml(p.titreProjet ?? '')}</strong></td>
          <td>${escapeHtml(p.domaineNom ?? '—')}</td>
          <td><span class="badge ${getStatutBadgeClass(p.statutProjet)}">${escapeHtml(p.statutProjet ?? '')}</span></td>
          <td>
            <div class="progress-bar-bg">
              <div class="progress-bar-fill" style="width:${p.niveauAvancement ?? 0}%"></div>
            </div>
            <small>${p.niveauAvancement ?? 0}%</small>
          </td>
          <td>${formatMoney(p.budgetEstime ?? 0)}</td>
          <td>${escapeHtml(p.responsableNom ?? '—')}</td>
          <td>${escapeHtml((p.participantNames || []).join(', ') || '—')}</td>
          <td style="white-space:nowrap">
            <button class="btn-small btn-blue" onclick="openEditProject(${p.projectId})">✏️ Modifier</button>
          </td>
        </tr>
      `).join('');
      }

      async function openCreateProjectModal() {
        currentProject = null;
        document.getElementById('projectModalTitle').textContent = '➕ Nouveau Projet';
        document.getElementById('editTitre').value = '';
        document.getElementById('editDescription').value = '';
        document.getElementById('editInstitution').value = '';
        document.getElementById('editStatut').value = 'EN_COURS';
        document.getElementById('editBudget').value = '';
        document.getElementById('editProgress').value = '0';
        document.getElementById('editDateDebut').value = '';
        document.getElementById('editDateFin').value = '';
        document.getElementById('editParticipantIds').value = '';
        document.getElementById('currentParticipants').textContent = 'Participants actuels : —';
        populateDomaineSelect();
        openModal('projectModal');
      }

      async function openEditProject(projectId) {
        currentProject = await apiRequest('/api/projects/' + projectId);
        document.getElementById('projectModalTitle').textContent = '✏️ Modifier Projet #' + projectId;
        document.getElementById('editTitre').value = currentProject.titreProjet ?? '';
        document.getElementById('editDescription').value = currentProject.description ?? '';
        document.getElementById('editInstitution').value = currentProject.institution ?? '';
        document.getElementById('editStatut').value = currentProject.statutProjet ?? 'EN_COURS';
        document.getElementById('editBudget').value = currentProject.budgetEstime ?? 0;
        document.getElementById('editProgress').value = currentProject.niveauAvancement ?? 0;
        document.getElementById('editDateDebut').value = formatDateForInput(currentProject.dateDebut);
        document.getElementById('editDateFin').value = formatDateForInput(currentProject.dateFin);
        const ids = (currentProject.participantIds || []).join(',');
        const names = (currentProject.participantNames || []).join(', ');
        document.getElementById('editParticipantIds').value = ids;
        document.getElementById('currentParticipants').textContent = names ? 'Participants actuels : ' + names : 'Participants actuels : —';
        populateDomaineSelect(currentProject.domaineId);
        openModal('projectModal');
      }

      async function saveProjectChanges() {
        const payload = {
          titreProjet: document.getElementById('editTitre').value,
          description: document.getElementById('editDescription').value,
          institution: document.getElementById('editInstitution').value,
          statutProjet: document.getElementById('editStatut').value,
          budgetEstime: Number(document.getElementById('editBudget').value || 0),
          niveauAvancement: Number(document.getElementById('editProgress').value || 0),
          domaineId: Number(document.getElementById('editDomaine').value) || null,
          dateDebut: document.getElementById('editDateDebut').value || null,
          dateFin: document.getElementById('editDateFin').value || null,
          participantIds: parseIds(document.getElementById('editParticipantIds').value)
        };
        try {
          if (currentProject && currentProject.projectId) {
            payload.projectId = currentProject.projectId;
            await apiRequest('/api/projects/' + currentProject.projectId, { method: 'PUT', body: JSON.stringify(payload) });
            showAlert('✅ Projet mis à jour avec succès.', 'success');
          } else {
            await apiRequest('/api/projects', { method: 'POST', body: JSON.stringify(payload) });
            showAlert('✅ Projet créé avec succès.', 'success');
          }
          closeModal('projectModal');
          await Promise.all([loadProjects(), loadAllStats()]);
        } catch (e) {
          showAlert('❌ Erreur : ' + e.message, 'error');
        }
      }

      // ─── Utilisateurs ─────────────────────────────────────────────
      async function loadUsers() {
        try {
          allUsers = await apiRequest('/api/users');
          const tbody = document.getElementById('usersTableBody');
          if (!tbody) return;
          tbody.innerHTML = (allUsers || []).map(u => `
          <tr>
            <td>${u.id ?? ''}</td>
            <td>${escapeHtml(u.nom ?? '')}</td>
            <td>${escapeHtml(u.email ?? '')}</td>
            <td>${escapeHtml(u.institution ?? '—')}</td>
            <td><span class="badge ${getRoleBadgeClass(u.roleLibelle)}">${escapeHtml(u.roleLibelle ?? '')}</span></td>
            <td>
              <button class="btn-small btn-blue" onclick="openEditUserModal(${u.id})">✏️</button>
              <button class="btn-small btn-red" style="margin-left:4px" onclick="deleteUser(${u.id})">🗑️</button>
            </td>
          </tr>
        `).join('');
        } catch (e) {
          console.warn('Cannot load users (permission?):', e.message);
        }
      }

      function openCreateUserModal() {
        currentUserId = null;
        document.getElementById('userModalTitle').textContent = '➕ Nouvel Utilisateur';
        document.getElementById('userNom').value = '';
        document.getElementById('userEmail2').value = '';
        document.getElementById('userInstitution').value = 'ESMT';
        document.getElementById('userRole2').value = 'CANDIDAT';
        document.getElementById('userPassword').value = '';
        openModal('userModal');
      }

      function openEditUserModal(userId) {
        currentUserId = userId;
        const user = allUsers.find(u => u.id === userId);
        if (!user) return;
        document.getElementById('userModalTitle').textContent = '✏️ Modifier Utilisateur #' + userId;
        document.getElementById('userNom').value = user.nom ?? '';
        document.getElementById('userEmail2').value = user.email ?? '';
        document.getElementById('userInstitution').value = user.institution ?? '';
        document.getElementById('userRole2').value = user.roleLibelle ?? 'CANDIDAT';
        document.getElementById('userPassword').value = '';
        openModal('userModal');
      }

      async function saveUser() {
        const payload = {
          nom: document.getElementById('userNom').value,
          email: document.getElementById('userEmail2').value,
          institution: document.getElementById('userInstitution').value,
          roleLibelle: document.getElementById('userRole2').value
        };
        const password = document.getElementById('userPassword').value;
        try {
          if (currentUserId) {
            await apiRequest('/api/users/' + currentUserId, { method: 'PUT', body: JSON.stringify(payload) });
            showAlert('✅ Utilisateur mis à jour.', 'success');
          } else {
            await apiRequest('/api/users?password=' + encodeURIComponent(password), { method: 'POST', body: JSON.stringify(payload) });
            showAlert('✅ Utilisateur créé.', 'success');
          }
          closeModal('userModal');
          await loadUsers();
        } catch (e) {
          showAlert('❌ Erreur : ' + e.message, 'error');
        }
      }

      async function deleteUser(userId) {
        if (!confirm('Supprimer cet utilisateur ?')) return;
        try {
          await apiRequest('/api/users/' + userId, { method: 'DELETE' });
          showAlert('✅ Utilisateur supprimé.', 'success');
          await loadUsers();
        } catch (e) {
          showAlert('❌ Erreur : ' + e.message, 'error');
        }
      }

      // ─── Domaines ─────────────────────────────────────────────────
      async function loadDomaines() {
        try {
          allDomaines = await apiRequest('/api/domains');
          populateDomaineSelect();
          const tbody = document.getElementById('domainesTableBody');
          if (!tbody) return;
          tbody.innerHTML = (allDomaines || []).map(d => `
          <tr>
            <td>${d.id ?? ''}</td>
            <td><strong>${escapeHtml(d.nomDomaine ?? '')}</strong></td>
            <td>${escapeHtml(d.description ?? '—')}</td>
            <td>
              <button class="btn-small btn-blue" onclick="openEditDomaineModal(${d.id})">✏️</button>
              <button class="btn-small btn-red" style="margin-left:4px" onclick="deleteDomaine(${d.id})">🗑️</button>
            </td>
          </tr>
        `).join('');
        } catch (e) {
          console.warn('Cannot load domaines:', e.message);
        }
      }

      function populateDomaineSelect(selectedId) {
        const sel = document.getElementById('editDomaine');
        if (!sel) return;
        sel.innerHTML = '<option value="">— Sélectionner un domaine —</option>' +
          allDomaines.map(d => `<option value="${d.id}" ${d.id == selectedId ? 'selected' : ''}>${escapeHtml(d.nomDomaine)}</option>`).join('');
      }

      function openCreateDomaineModal() {
        currentDomaineId = null;
        document.getElementById('domaineModalTitle').textContent = '➕ Nouveau Domaine';
        document.getElementById('domaineNom').value = '';
        document.getElementById('domaineDesc').value = '';
        openModal('domaineModal');
      }

      function openEditDomaineModal(domaineId) {
        currentDomaineId = domaineId;
        const d = allDomaines.find(x => x.id === domaineId);
        if (!d) return;
        document.getElementById('domaineModalTitle').textContent = '✏️ Modifier Domaine #' + domaineId;
        document.getElementById('domaineNom').value = d.nomDomaine ?? '';
        document.getElementById('domaineDesc').value = d.description ?? '';
        openModal('domaineModal');
      }

      async function saveDomaine() {
        const payload = {
          nomDomaine: document.getElementById('domaineNom').value,
          description: document.getElementById('domaineDesc').value
        };
        try {
          if (currentDomaineId) {
            await apiRequest('/api/domains/' + currentDomaineId, { method: 'PUT', body: JSON.stringify(payload) });
            showAlert('✅ Domaine mis à jour.', 'success');
          } else {
            await apiRequest('/api/domains', { method: 'POST', body: JSON.stringify(payload) });
            showAlert('✅ Domaine créé.', 'success');
          }
          closeModal('domaineModal');
          await loadDomaines();
        } catch (e) {
          showAlert('❌ Erreur : ' + e.message, 'error');
        }
      }

      async function deleteDomaine(id) {
        if (!confirm('Supprimer ce domaine ?')) return;
        try {
          await apiRequest('/api/domains/' + id, { method: 'DELETE' });
          showAlert('✅ Domaine supprimé.', 'success');
          await loadDomaines();
        } catch (e) {
          showAlert('❌ Erreur : ' + e.message, 'error');
        }
      }

      // ─── Helpers Modals ───────────────────────────────────────────
      function openModal(id) { document.getElementById(id).classList.add('show'); }
      function closeModal(id) { document.getElementById(id).classList.remove('show'); }

      // ─── Alertes ──────────────────────────────────────────────────
      function showAlert(msg, type) {
        const el = document.getElementById('alert-msg');
        el.className = 'alert ' + (type === 'success' ? 'alert-success' : 'alert-error');
        el.textContent = msg;
        el.style.display = 'block';
        setTimeout(() => { el.style.display = 'none'; }, 5000);
      }

      // ─── Graphiques Chart.js ──────────────────────────────────────
      const PALETTE = ['#667eea', '#764ba2', '#28a745', '#ffc107', '#17a2b8', '#dc3545', '#fd7e14', '#6f42c1', '#20c997', '#e83e8c'];

      function renderBarChart(canvasId, label, obj, money, type) {
        const el = document.getElementById(canvasId);
        if (!el) return;
        const labels = Object.keys(obj || {});
        const data = Object.values(obj || {});
        if (charts[canvasId]) charts[canvasId].destroy();
        charts[canvasId] = new Chart(el, {
          type: type || 'bar',
          data: { labels, datasets: [{ label, data, backgroundColor: PALETTE }] },
          options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { y: { ticks: { callback: v => money ? formatMoney(v) : v } } }
          }
        });
      }

      function renderDoughnutChart(canvasId, obj) {
        const el = document.getElementById(canvasId);
        if (!el) return;
        const labels = Object.keys(obj || {});
        const data = Object.values(obj || {});
        if (charts[canvasId]) charts[canvasId].destroy();
        charts[canvasId] = new Chart(el, {
          type: 'doughnut',
          data: { labels, datasets: [{ data, backgroundColor: ['#28a745', '#007bff', '#dc3545', '#ffc107', '#17a2b8'] }] },
          options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
        });
      }

      // ── Graphique 3 — Évolution temporelle (line chart) ──
      function renderLineChart(canvasId, label, obj) {
        const el = document.getElementById(canvasId);
        if (!el) return;
        const labels = Object.keys(obj || {}).sort();
        const data = labels.map(k => obj[k]);
        if (charts[canvasId]) charts[canvasId].destroy();
        charts[canvasId] = new Chart(el, {
          type: 'line',
          data: {
            labels,
            datasets: [{
              label,
              data,
              borderColor: '#667eea',
              backgroundColor: 'rgba(102,126,234,0.12)',
              borderWidth: 3,
              pointRadius: 5,
              pointBackgroundColor: '#667eea',
              fill: true,
              tension: 0.4
            }]
          },
          options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
              y: { beginAtZero: true, ticks: { precision: 0 } },
              x: { title: { display: true, text: 'Année' } }
            }
          }
        });
      }

      function renderBarHChart(canvasId, label, obj) {
        const el = document.getElementById(canvasId);
        if (!el) return;
        const labels = Object.keys(obj || {});
        const data = Object.values(obj || {});
        if (charts[canvasId]) charts[canvasId].destroy();
        charts[canvasId] = new Chart(el, {
          type: 'bar',
          data: { labels, datasets: [{ label, data, backgroundColor: '#764ba2' }] },
          options: {
            indexAxis: 'y',
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } }
          }
        });
      }

      // ─── Utilitaires ──────────────────────────────────────────────
      function takeTopN(obj, n) {
        return Object.fromEntries(
          Object.entries(obj || {}).sort((a, b) => (b[1] || 0) - (a[1] || 0)).slice(0, n)
        );
      }

      function formatMoney(x) {
        return Number(x || 0).toLocaleString('fr-FR') + ' F';
      }

      function formatDateForInput(dateArr) {
        if (!dateArr) return '';
        if (Array.isArray(dateArr)) {
          const [y, m, d] = dateArr;
          return `${y}-${String(m).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
        }
        return String(dateArr).substring(0, 10);
      }

      function parseIds(raw) {
        return String(raw || '').split(',').map(s => s.trim()).filter(Boolean).map(Number).filter(n => Number.isFinite(n));
      }

      function escapeHtml(str) {
        return String(str ?? '').replace(/[&<>"']/g, s => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[s]));
      }

      function getStatutBadgeClass(statut) {
        if (!statut) return 'badge-gray';
        if (statut === 'EN_COURS') return 'badge-blue';
        if (statut === 'TERMINE') return 'badge-green';
        if (statut === 'SUSPENDU') return 'badge-orange';
        return 'badge-gray';
      }

      function getRoleBadgeClass(role) {
        if (role === 'ADMIN') return 'badge-orange';
        if (role === 'GESTIONNAIRE') return 'badge-blue';
        return 'badge-green';
      }
    </script>
  </body>

  </html>