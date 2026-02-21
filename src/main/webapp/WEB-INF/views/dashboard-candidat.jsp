<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Espace Candidat - ESMT Research Mapping</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <style>
    /* ======== TON CSS (inchangé) ======== */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; }

    .navbar {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white; padding: 0 40px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
      display: flex; justify-content: space-between; align-items: center;
      height: 70px; position: sticky;
      top: 0; z-index: 1000;
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
      color: white; padding: 8px 16px;
      border: 1px solid white; border-radius: 5px;
      cursor: pointer; font-weight: 600;
      transition: all 0.3s;
    }
    .btn-logout:hover { background: rgba(255, 255, 255, 0.3); }

    .main-container { display: flex; min-height: calc(100vh - 70px); }

    .sidebar { width: 250px; background: white; border-right: 1px solid #e0e0e0; padding: 20px 0; }
    .sidebar-menu { list-style: none; }
    .sidebar-menu li { border-bottom: 1px solid #f0f0f0; }
    .sidebar-menu a {
      display: flex; align-items: center; gap: 12px;
      padding: 15px 25px; color: #555; text-decoration: none;
      transition: all 0.3s; cursor: pointer;
    }
    .sidebar-menu a:hover, .sidebar-menu a.active {
      background: #f0f2f5; color: #667eea;
      border-left: 4px solid #667eea; padding-left: 21px;
    }
    .sidebar-menu span { font-size: 16px; }

    .content { flex: 1; padding: 30px; overflow-y: auto; }
    .page { display: none; }
    .page.active { display: block; }

    .page-header { margin-bottom: 30px; }
    .page-header h1 { color: #003d82; font-size: 28px; margin-bottom: 10px; }
    .page-header p { color: #999; }

    .card {
      background: white; padding: 25px; border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      margin-bottom: 20px;
    }
    .card h2 { color: #003d82; margin-bottom: 20px; font-size: 20px; }

    .stats-grid {
      display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px; margin-bottom: 30px;
    }
    .stat-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white; padding: 20px; border-radius: 10px; text-align: center;
      box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
      transition: transform 0.3s;
    }
    .stat-card:hover { transform: translateY(-5px); }
    .stat-card .value { font-size: 32px; font-weight: 700; margin: 10px 0; }
    .stat-card .label { font-size: 14px; opacity: 0.9; }

    .charts-grid {
      display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
      gap: 20px;
    }
    .chart-container {
      background: white; padding: 20px; border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      position: relative; height: 400px;
    }
    .chart-container h3 { color: #003d82; margin-bottom: 20px; }

    .project-card {
      background: white; border: 1px solid #e0e0e0;
      padding: 20px; border-radius: 10px; margin-bottom: 15px;
      transition: all 0.3s;
    }
    .project-card:hover { box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); border-color: #667eea; }
    .project-header { display: flex; justify-content: space-between; align-items: start; margin-bottom: 15px; }
    .project-title { color: #003d82; font-size: 18px; font-weight: 600; }
    .project-domain { background: #667eea; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .project-description { color: #666; margin-bottom: 15px; line-height: 1.6; }
    .project-info {
      display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
      gap: 15px; margin-bottom: 15px; font-size: 14px;
    }
    .project-info-item { border-left: 3px solid #667eea; padding-left: 10px; }
    .project-info-label { color: #999; font-size: 12px; }
    .project-info-value { color: #003d82; font-weight: 600; }
    .progress-bar { background: #e0e0e0; height: 8px; border-radius: 4px; overflow: hidden; margin-top: 10px; }
    .progress-fill { background: linear-gradient(90deg, #667eea, #764ba2); height: 100%; transition: width 0.3s; }
    .project-actions { display: flex; gap: 10px; margin-top: 15px; }

    .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
    .status-en_cours { background: #d4edda; color: #155724; }
    .status-termine { background: #cfe2ff; color: #0c5de4; }
    .status-suspendu { background: #f8d7da; color: #842029; }

    .btn {
      padding: 10px 20px; border: none; border-radius: 5px;
      cursor: pointer; font-weight: 600; transition: all 0.3s;
      text-decoration: none; display: inline-block;
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

    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; margin-bottom: 8px; color: #555; font-weight: 600; }
    .form-group input, .form-group textarea, .form-group select {
      width: 100%; padding: 10px;
      border: 1px solid #ddd; border-radius: 5px;
      font-size: 14px;
    }
    .form-group textarea { min-height: 100px; resize: vertical; }
    .form-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 20px;
    }

    .alert { padding: 15px; border-radius: 5px; margin-bottom: 20px; }
    .alert-info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }

    .header-info {
      background: linear-gradient(135deg, #f8f9ff 0%, #e8ecff 100%);
      padding: 20px; border-radius: 5px;
      border-left: 4px solid #667eea; margin-bottom: 20px;
    }
    .header-info p { margin: 8px 0; color: #555; }
    .header-info strong { color: #003d82; }

    .empty-state { text-align: center; padding: 60px 20px; color: #999; }
    .empty-state h3 { color: #555; margin-bottom: 10px; }

    @media (max-width: 768px) {
      .main-container { flex-direction: column; }
      .sidebar {
        width: 100%; border-right: none; border-bottom: 1px solid #e0e0e0;
        display: flex; overflow-x: auto;
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

  <div class="main-container">
    <div class="sidebar">
      <ul class="sidebar-menu">
        <li><a class="nav-link active" data-page="dashboard" onclick="showPage('dashboard', event)"><span>📊</span> Accueil</a></li>
        <li><a class="nav-link" data-page="mes-projets" onclick="showPage('mes-projets', event)"><span>📁</span> Mes Projets</a></li>
        <li><a class="nav-link" data-page="nouveau-projet" onclick="showPage('nouveau-projet', event)"><span>➕</span> Nouveau Projet</a></li>
        <li><a class="nav-link" data-page="profil" onclick="showPage('profil', event)"><span>👤</span> Mon Profil</a></li>
      </ul>
    </div>

    <div class="content">
      <!-- DASHBOARD -->
      <div id="dashboard" class="page active">
        <div class="page-header">
          <h1>🎓 Espace Candidat</h1>
          <p>Bienvenue sur la plateforme de cartographie des projets de recherche ESMT</p>
        </div>

        <div class="header-info">
          <p><strong>📧 Email :</strong> <span id="userEmail"></span></p>
          <p><strong>👤 Nom :</strong> <span id="userNom"></span></p>
          <p><strong>🏢 Institution :</strong> <span id="userInstitution"></span></p>
        </div>

        <div class="alert alert-info">
          <strong>ℹ️ Information :</strong>
          Vous pouvez déclarer vos projets de recherche et suivre leur avancement.
          Seuls vos projets personnels vous sont visibles.
        </div>

        <div class="stats-grid">
          <div class="stat-card"><div class="label">Mes Projets</div><div class="value" id="mesProjetCount">0</div></div>
          <div class="stat-card"><div class="label">En Cours</div><div class="value" id="projetEnCoursCount">0</div></div>
          <div class="stat-card"><div class="label">Terminés</div><div class="value" id="projetTermineCount">0</div></div>
          <div class="stat-card"><div class="label">Budget Total</div><div class="value" id="budgetTotal">0 F</div></div>
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

      <!-- MES PROJETS -->
      <div id="mes-projets" class="page">
        <div class="page-header">
          <h1>📁 Mes Projets</h1>
          <p>Consultez et gérez vos projets de recherche</p>
        </div>

        <button class="btn btn-primary" onclick="showPage('nouveau-projet', event)">➕ Ajouter un Nouveau Projet</button>

        <div id="projectsList" style="margin-top: 20px;">
          <div class="empty-state">
            <h3>Aucun projet déclaré</h3>
            <p>Créez votre premier projet pour le partager avec la communauté de recherche</p>
          </div>
        </div>
      </div>

      <!-- NOUVEAU PROJET -->
      <div id="nouveau-projet" class="page">
        <div class="page-header">
          <h1 id="projectFormTitle">➕ Déclarer un Nouveau Projet</h1>
          <p>Complétez les informations de votre projet de recherche</p>
        </div>

        <div class="card">
          <h2>Formulaire de Déclaration</h2>
          <form id="projectForm">
            <div class="form-grid">
              <div class="form-group">
                <label>Titre du Projet *</label>
                <input type="text" id="projectTitle" required>
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
              <textarea id="projectDescription" required></textarea>
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
                <input type="number" id="projectBudget" required min="0">
              </div>
            </div>

            <div class="form-grid">
              <div class="form-group">
                <label>Institution *</label>
                <input type="text" id="projectInstitution" required>
              </div>
              <div class="form-group">
                <label>Statut *</label>
                <select id="projectStatus" required>
                  <option value="EN_COURS">En Cours</option>
                  <option value="SUSPENDU">Suspendu</option>
                  <option value="TERMINE">Terminé</option>
                </select>
              </div>
              <div class="form-group">
                <label>Taux d'Avancement (%) *</label>
                <input type="number" id="projectProgress" required min="0" max="100" value="0">
              </div>
            </div>

            <!-- ✅ AJOUT: participants -->
            <div class="form-group">
              <label>Participants (IDs séparés par virgule)</label>
              <input type="text" id="projectParticipantIds" placeholder="Ex: 2,4,7">
              <small style="color:#777;display:block;margin-top:6px">
                Le responsable du projet est automatiquement vous (utilisateur connecté).
              </small>
            </div>

            <div style="display: flex; gap: 10px;">
              <button type="submit" class="btn btn-success">💾 Enregistrer le Projet</button>
              <button type="reset" class="btn btn-secondary">🔄 Réinitialiser</button>
            </div>
          </form>
        </div>
      </div>

      <!-- PROFIL -->
      <div id="profil" class="page">
        <div class="page-header">
          <h1>👤 Mon Profil</h1>
          <p>Gestion de vos informations personnelles</p>
        </div>

        <div class="card">
          <h2>Informations Personnelles</h2>
          <div class="header-info">
            <p><strong>📧 Email :</strong> <span id="profileEmail"></span></p>
            <p><strong>👤 Nom Complet :</strong> <span id="profileNom"></span></p>
            <p><strong>🏢 Institution :</strong> <span id="profileInstitution"></span></p>
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

            <button type="submit" class="btn btn-primary">💾 Enregistrer les modifications</button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <script>
    // ✅ Fonctions globales pour les onclick inline
    window.showPage = function(pageId, event) {
      if (event) event.preventDefault();

      document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
      document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));

      const page = document.getElementById(pageId);
      if (page) page.classList.add('active');

      const navLink = document.querySelector(`[data-page="${pageId}"]`);
      if (navLink) navLink.classList.add('active');
    };

    let charts = {};
    let mesProjets = [];
    let editProjectId = null;

    document.addEventListener('DOMContentLoaded', async () => {
      window.editProject = editProject;
      window.deleteProject = deleteProject;

      document.getElementById('logoutBtn').addEventListener('click', onLogout);
      document.getElementById('projectForm').addEventListener('submit', onSaveProject);
      document.getElementById('profileForm').addEventListener('submit', onUpdateProfile);

      try {
        await loadMe();
        await loadProjectsData();
      } catch (e) {
        console.error('Init error:', e);
        alert("Erreur chargement. Vérifie que tu es bien connecté.");
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
        throw new Error(`HTTP ${response.status} ${response.statusText}: ${text}`);
      }

      const ct = response.headers.get('content-type') || '';
      if (ct.includes('application/json')) return response.json();
      return response.text();
    }

    async function loadMe() {
      const me = await apiRequest('/api/users/me');

      document.getElementById('userEmail').textContent = me.email || '';
      document.getElementById('userNom').textContent = me.nom || '';
      document.getElementById('userInstitution').textContent = me.institution || '';

      const displayName = (me.nom && me.nom.trim().length > 0)
        ? me.nom
        : (me.email ? me.email.split('@')[0] : 'Candidat');

      document.getElementById('displayNameNav').textContent = displayName;
      document.getElementById('userAvatarNav').textContent = displayName.charAt(0).toUpperCase();

      document.getElementById('profileEmail').textContent = me.email || '';
      document.getElementById('profileNom').textContent = me.nom || '';
      document.getElementById('profileInstitution').textContent = me.institution || '';

      document.getElementById('editNom').value = me.nom || '';
      document.getElementById('editInstitution').value = me.institution || '';
    }

    async function onLogout(e) {
      e.preventDefault();
      if (!confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) return;
      window.location.href = '/logout';
    }

    function getDomaineId(domaineNom) {
      const domaines = { "IA": 1, "Santé": 2, "Énergie": 3, "Télécoms": 4, "Autre": 1 };
      return domaines[domaineNom] || 1;
    }

    function parseParticipantIds() {
      const raw = document.getElementById('projectParticipantIds').value || '';
      return raw
        .split(',')
        .map(s => s.trim())
        .filter(s => s.length > 0)
        .map(s => Number(s))
        .filter(n => Number.isFinite(n));
    }

    async function onSaveProject(event) {
      event.preventDefault();

      const payload = {
        titreProjet: document.getElementById('projectTitle').value,
        domaineId: getDomaineId(document.getElementById('projectDomain').value),
        description: document.getElementById('projectDescription').value,
        dateDebut: document.getElementById('projectStartDate').value,
        dateFin: document.getElementById('projectEndDate').value,
        budgetEstime: parseFloat(document.getElementById('projectBudget').value || '0'),
        statutProjet: document.getElementById('projectStatus').value,
        niveauAvancement: parseInt(document.getElementById('projectProgress').value || '0', 10),
        institution: document.getElementById('projectInstitution').value,

        // ✅ AJOUT: participants attendus par ProjetDTO (participantIds)
        participantIds: parseParticipantIds()
      };

      try {
        if (editProjectId) {
          await apiRequest('/api/projects/' + editProjectId, { method: 'PUT', body: JSON.stringify(payload) });
          alert('✅ Projet modifié avec succès!');
        } else {
          await apiRequest('/api/projects', { method: 'POST', body: JSON.stringify(payload) });
          alert('✅ Projet créé avec succès!');
        }

        editProjectId = null;
        document.getElementById('projectFormTitle').textContent = '➕ Déclarer un Nouveau Projet';
        document.getElementById('projectForm').reset();
        document.getElementById('projectParticipantIds').value = '';

        window.showPage('mes-projets', null);
        await loadProjectsData();
      } catch (err) {
        console.error(err);
        alert("Erreur lors de l'enregistrement du projet.");
      }
    }

    async function loadProjectsData() {
      const data = await apiRequest('/api/projects');

      mesProjets = (data || []).map(p => ({
        id: p.projectId,
        titre: p.titreProjet,
        domaine: p.domaineNom || 'Non spécifié',
        description: p.description || '',
        dateDebut: p.dateDebut || '',
        dateFin: p.dateFin || '',
        budget: Number(p.budgetEstime || 0),
        statut: (p.statutProjet || '').toUpperCase(),
        avancement: Number(p.niveauAvancement || 0),
        institution: p.institution || '',

        // ✅ Bonus affichage (si backend renvoie)
        responsableNom: p.responsableNom || '',
        participantNames: p.participantNames || []
      }));

      updateStats();
      displayProjects();
      initCharts();
    }

    function updateStats() {
      const enCours = mesProjets.filter(p => p.statut === 'EN_COURS').length;
      const termine = mesProjets.filter(p => p.statut === 'TERMINE').length;
      const budget = mesProjets.reduce((sum, p) => sum + (p.budget || 0), 0);

      document.getElementById('mesProjetCount').textContent = String(mesProjets.length);
      document.getElementById('projetEnCoursCount').textContent = String(enCours);
      document.getElementById('projetTermineCount').textContent = String(termine);
      document.getElementById('budgetTotal').textContent = budget.toLocaleString('fr-FR') + ' F';
    }

    function displayProjects() {
      const container = document.getElementById('projectsList');
      const recent = document.getElementById('recentProjects');

      if (mesProjets.length === 0) {
        const empty = `
          <div class="empty-state">
            <h3>Aucun projet déclaré</h3>
            <p>Créez votre premier projet pour le partager avec la communauté de recherche</p>
          </div>
        `;
        container.innerHTML = empty;
        if (recent) recent.innerHTML = empty;
        return;
      }

      const html = mesProjets.map(projet => `
        <div class="project-card">
          <div class="project-header">
            <div>
              <div class="project-title">\${escapeHtml(projet.titre)}</div>
              <div style="margin-top: 5px;">
                <span class="project-domain">\${escapeHtml(projet.domaine)}</span>
              </div>
              <div style="margin-top: 8px; color:#555; font-size: 13px">
                <strong>Responsable:</strong> \${escapeHtml(projet.responsableNom || 'Vous')}
              </div>
              <div style="margin-top: 4px; color:#555; font-size: 13px">
                <strong>Participants:</strong>
                \${escapeHtml((projet.participantNames && projet.participantNames.length > 0) ? projet.participantNames.join(', ') : '—')}
              </div>
            </div>
            <div>
              <span class="status-badge status-\${escapeHtml((projet.statut || '').toLowerCase())}">
                \${escapeHtml(projet.statut)}
              </span>
            </div>
          </div>

          <div class="project-description">\${escapeHtml(projet.description)}</div>

          <div class="project-info">
            <div class="project-info-item">
              <div class="project-info-label">Début</div>
              <div class="project-info-value">\${escapeHtml(projet.dateDebut)}</div>
            </div>
            <div class="project-info-item">
              <div class="project-info-label">Fin Prévue</div>
              <div class="project-info-value">\${escapeHtml(projet.dateFin)}</div>
            </div>
            <div class="project-info-item">
              <div class="project-info-label">Budget</div>
              <div class="project-info-value">\${(projet.budget || 0).toLocaleString('fr-FR')} F</div>
            </div>
            <div class="project-info-item">
              <div class="project-info-label">Avancement</div>
              <div class="project-info-value">\${projet.avancement}%</div>
            </div>
          </div>

          <div class="progress-bar">
            <div class="progress-fill" style="width: \${projet.avancement}%"></div>
          </div>

          <div class="project-actions">
            <button class="btn btn-primary btn-small" onclick="editProject(\${projet.id})">✏️ Modifier</button>
            <button class="btn btn-danger btn-small" onclick="deleteProject(\${projet.id})">🗑️ Supprimer</button>
          </div>
        </div>
      `).join('');

      container.innerHTML = html;

      if (recent) {
        recent.innerHTML = mesProjets.slice(0, 3).map(p => `
          <div class="project-card">
            <div class="project-title">\${escapeHtml(p.titre)}</div>
            <div class="project-description">\${escapeHtml(p.description)}</div>
          </div>
        `).join('');
      }
    }

    async function deleteProject(id) {
      if (!confirm('Êtes-vous sûr de vouloir supprimer ce projet ?')) return;

      try {
        await apiRequest('/api/projects/' + id, { method: 'DELETE' });
        mesProjets = mesProjets.filter(p => p.id !== id);
        updateStats();
        displayProjects();
        initCharts();
        alert('✅ Projet supprimé avec succès!');
      } catch (e) {
        console.error(e);
        alert("Erreur lors de la suppression.");
      }
    }

    function editProject(id) {
      const projet = mesProjets.find(p => p.id === id);
      if (!projet) return;

      editProjectId = id;
      window.showPage('nouveau-projet', null);

      document.getElementById('projectFormTitle').textContent = '✏️ Modifier le Projet';
      document.getElementById('projectTitle').value = projet.titre || '';
      document.getElementById('projectDescription').value = projet.description || '';
      document.getElementById('projectStartDate').value = projet.dateDebut ? String(projet.dateDebut).substring(0, 10) : '';
      document.getElementById('projectEndDate').value = projet.dateFin ? String(projet.dateFin).substring(0, 10) : '';
      document.getElementById('projectBudget').value = projet.budget || 0;
      document.getElementById('projectStatus').value = projet.statut || 'EN_COURS';
      document.getElementById('projectInstitution').value = projet.institution || '';
      document.getElementById('projectProgress').value = projet.avancement || 0;

      // participants: si on a les IDs, on peut les remettre
      // sinon on laisse vide.
      document.getElementById('projectParticipantIds').value = '';
    }

    async function onUpdateProfile(event) {
      event.preventDefault();

      const payload = {
        nom: document.getElementById('editNom').value,
        institution: document.getElementById('editInstitution').value
      };

      try {
        const data = await apiRequest('/api/users/me', { method: 'PUT', body: JSON.stringify(payload) });
        alert('✅ Profil mis à jour avec succès!');

        document.getElementById('userNom').textContent = data.nom || '';
        document.getElementById('userInstitution').textContent = data.institution || '';
        document.getElementById('profileNom').textContent = data.nom || '';
        document.getElementById('profileInstitution').textContent = data.institution || '';

        const displayName = data.nom || (data.email ? data.email.split('@')[0] : 'Candidat');
        document.getElementById('displayNameNav').textContent = displayName;
        document.getElementById('userAvatarNav').textContent = displayName.charAt(0).toUpperCase();
      } catch (e) {
        console.error(e);
        alert("Erreur lors de la mise à jour du profil.");
      }
    }

    function initCharts() {
      Object.values(charts).forEach(chart => { if (chart) chart.destroy(); });
      charts = {};

      const ctxStatus = document.getElementById('statusChart');
      if (ctxStatus) {
        const enCours = mesProjets.filter(p => p.statut === 'EN_COURS').length;
        const termine = mesProjets.filter(p => p.statut === 'TERMINE').length;
        const suspendu = mesProjets.filter(p => p.statut === 'SUSPENDU').length;

        const labels = [];
        const data = [];
        if (enCours > 0) { labels.push('En Cours'); data.push(enCours); }
        if (termine > 0) { labels.push('Terminé'); data.push(termine); }
        if (suspendu > 0) { labels.push('Suspendu'); data.push(suspendu); }

        if (data.length > 0) {
          charts.status = new Chart(ctxStatus, {
            type: 'doughnut',
            data: { labels, datasets: [{ data, backgroundColor: ['#28a745', '#007bff', '#dc3545'] }] },
            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
          });
        }
      }

      const ctxProgress = document.getElementById('progressChart');
      if (ctxProgress && mesProjets.length > 0) {
        charts.progress = new Chart(ctxProgress, {
          type: 'bar',
          data: {
            labels: mesProjets.map(p => (p.titre || '').substring(0, 15)),
            datasets: [{ label: 'Avancement (%)', data: mesProjets.map(p => p.avancement), backgroundColor: '#667eea' }]
          },
          options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { x: { max: 100 } }
          }
        });
      }
    }

    function escapeHtml(str) {
      return String(str ?? '').replace(/[&<>"']/g, s => ({
        '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
      }[s]));
    }
  </script>
</body>
</html>