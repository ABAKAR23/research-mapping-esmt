<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Utilisateurs - Research Mapping ESMT</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/tables.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/responsive.css" rel="stylesheet">
</head>
<body data-user-role="${sessionScope.user_role}" data-user-id="${sessionScope.user_id}" data-load-users="true">
    <!-- Access Denied Check -->
    <c:if test="${sessionScope.user_role ne 'Admin'}">
        <div class="container mt-5">
            <div class="alert alert-danger text-center" role="alert">
                <i class="bi bi-shield-exclamation display-1"></i>
                <h2 class="mt-3">Accès Refusé</h2>
                <p>Vous n'avez pas les droits nécessaires pour accéder à cette page.</p>
                <p>Cette section est réservée aux administrateurs uniquement.</p>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary mt-3">
                    <i class="bi bi-house"></i> Retour au tableau de bord
                </a>
            </div>
        </div>
        <% return; %>
    </c:if>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-diagram-3"></i> Research Mapping ESMT
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" 
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle"></i> ${sessionScope.user_name}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><span class="dropdown-item-text"><strong>Rôle:</strong> ${sessionScope.user_role}</span></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profil">
                                <i class="bi bi-person"></i> Mon Profil
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right"></i> Déconnexion
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-sticky">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                        <i class="bi bi-speedometer2"></i> Tableau de Bord
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/projets">
                        <i class="bi bi-folder"></i> Projets
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/utilisateurs">
                        <i class="bi bi-people"></i> Utilisateurs
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/rapports">
                        <i class="bi bi-file-earmark-bar-graph"></i> Rapports
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                        <i class="bi bi-gear"></i> Administration
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h2">
                        <i class="bi bi-people"></i> Gestion des Utilisateurs
                    </h1>
                    <p class="text-muted">
                        Gérez les utilisateurs et leurs droits d'accès
                    </p>
                </div>
            </div>

            <!-- Filters Section -->
            <div class="card mb-4">
                <div class="card-body">
                    <form id="filtersForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="filterRole" class="form-label">
                                <i class="bi bi-shield"></i> Rôle
                            </label>
                            <select class="form-select" id="filterRole" name="role">
                                <option value="">Tous les rôles</option>
                                <option value="Candidat">CANDIDAT</option>
                                <option value="Gestionnaire">GESTIONNAIRE</option>
                                <option value="Admin">ADMIN</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="filterSearch" class="form-label">
                                <i class="bi bi-search"></i> Recherche
                            </label>
                            <input type="text" class="form-control" id="filterSearch" name="search" 
                                   placeholder="Nom, email ou institution...">
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-funnel"></i> Filtrer
                            </button>
                            <button type="reset" class="btn btn-secondary" id="resetFilters">
                                <i class="bi bi-x-circle"></i> Réinitialiser
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Loading State -->
            <div id="loadingState" class="text-center py-5" style="display: none;">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Chargement...</span>
                </div>
                <p class="mt-3 text-muted">Chargement des utilisateurs...</p>
            </div>

            <!-- Users Table -->
            <div class="card" id="usersTableCard">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover" id="usersTable">
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Email</th>
                                    <th>Rôle</th>
                                    <th>Institution</th>
                                    <th>Date inscription</th>
                                    <th>Statut</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="usersTableBody">
                                <!-- Users will be loaded dynamically by JavaScript -->
                            </tbody>
                        </table>
                    </div>

                    <!-- Empty State -->
                    <div id="emptyState" class="text-center py-5" style="display: none;">
                        <i class="bi bi-people-x display-1 text-muted"></i>
                        <h4 class="mt-3">Aucun utilisateur trouvé</h4>
                        <p class="text-muted">
                            Aucun utilisateur ne correspond aux critères de recherche.
                        </p>
                    </div>
                </div>

                <!-- Pagination Footer -->
                <div class="card-footer" id="paginationFooter" style="display: none;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="text-muted">
                            Affichage de <span id="pageStart">1</span> à <span id="pageEnd">10</span> 
                            sur <span id="totalUsers">0</span> utilisateurs
                        </div>
                        <nav aria-label="Pagination des utilisateurs">
                            <ul class="pagination mb-0" id="paginationList">
                                <!-- Pagination will be generated dynamically -->
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Edit Role Modal -->
    <div class="modal fade" id="editRoleModal" tabindex="-1" aria-labelledby="editRoleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="editRoleModalLabel">
                        <i class="bi bi-shield"></i> Modifier le rôle
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Utilisateur : <strong id="editUserName"></strong></p>
                    <div class="mb-3">
                        <label for="newRole" class="form-label">Nouveau rôle</label>
                        <select class="form-select" id="newRole">
                            <option value="Candidat">CANDIDAT</option>
                            <option value="Gestionnaire">GESTIONNAIRE</option>
                            <option value="Admin">ADMIN</option>
                        </select>
                    </div>
                    <input type="hidden" id="editUserId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="confirmEditRoleBtn">
                        <i class="bi bi-check-circle"></i> Modifier
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteModalLabel">
                        <i class="bi bi-exclamation-triangle"></i> Confirmer la suppression
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Êtes-vous sûr de vouloir supprimer cet utilisateur ?</p>
                    <p class="text-danger"><strong>Cette action est irréversible.</strong></p>
                    <p class="mb-0">Utilisateur : <strong id="deleteUserName"></strong></p>
                    <input type="hidden" id="deleteUserId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">
                        <i class="bi bi-trash"></i> Supprimer
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/js/api.js"></script>
    <script>
        // State
        let allUsers = [];
        let filteredUsers = [];
        const itemsPerPage = 10;
        let currentPage = 1;

        // DOM Elements
        const loadingState = document.getElementById('loadingState');
        const usersTableCard = document.getElementById('usersTableCard');
        const usersTableBody = document.getElementById('usersTableBody');
        const emptyState = document.getElementById('emptyState');
        const paginationFooter = document.getElementById('paginationFooter');
        const filterRole = document.getElementById('filterRole');
        const filterSearch = document.getElementById('filterSearch');
        const filtersForm = document.getElementById('filtersForm');
        const resetFiltersBtn = document.getElementById('resetFilters');

        // Modals
        const editRoleModal = new bootstrap.Modal(document.getElementById('editRoleModal'));
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));

        // Check user role
        const userRole = document.body.getAttribute('data-user-role');
        if (userRole !== 'Admin') {
            return; // Exit if not admin (access denied is shown in JSP)
        }

        // Load users on page load
        if (document.body.getAttribute('data-load-users') === 'true') {
            loadUsers();
        }

        // Load users from API
        async function loadUsers() {
            try {
                loadingState.style.display = 'block';
                usersTableCard.style.display = 'none';

                const response = await API.getAllUsers();
                allUsers = response || [];
                filteredUsers = [...allUsers];

                displayUsers();
            } catch (error) {
                console.error('Error loading users:', error);
                showError('Erreur lors du chargement des utilisateurs');
            } finally {
                loadingState.style.display = 'none';
                usersTableCard.style.display = 'block';
            }
        }

        // Display users in table
        function displayUsers() {
            usersTableBody.innerHTML = '';

            if (filteredUsers.length === 0) {
                emptyState.style.display = 'block';
                paginationFooter.style.display = 'none';
                return;
            }

            emptyState.style.display = 'none';
            paginationFooter.style.display = 'block';

            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = Math.min(startIndex + itemsPerPage, filteredUsers.length);
            const usersToDisplay = filteredUsers.slice(startIndex, endIndex);

            usersToDisplay.forEach(user => {
                const row = createUserRow(user);
                usersTableBody.appendChild(row);
            });

            updatePagination();
        }

        // Create user row
        function createUserRow(user) {
            const tr = document.createElement('tr');

            // Status badge
            const statusBadge = user.actif 
                ? '<span class="badge bg-success">Actif</span>' 
                : '<span class="badge bg-secondary">Inactif</span>';

            // Role badge color
            let roleBadgeClass = 'bg-secondary';
            if (user.role === 'Admin') roleBadgeClass = 'bg-danger';
            else if (user.role === 'Gestionnaire') roleBadgeClass = 'bg-warning';
            else if (user.role === 'Candidat') roleBadgeClass = 'bg-info';

            // Format date
            const dateInscription = user.dateInscription 
                ? new Date(user.dateInscription).toLocaleDateString('fr-FR')
                : 'N/A';

            tr.innerHTML = `
                <td>${escapeHtml(user.nom || 'N/A')}</td>
                <td>${escapeHtml(user.email || 'N/A')}</td>
                <td><span class="badge ${roleBadgeClass}">${escapeHtml(user.role || 'N/A')}</span></td>
                <td>${escapeHtml(user.institution || 'N/A')}</td>
                <td>${dateInscription}</td>
                <td>${statusBadge}</td>
                <td class="text-end">
                    <div class="btn-group" role="group">
                        <button class="btn btn-sm btn-outline-primary" onclick="editUserRole(${user.id})" title="Modifier le rôle">
                            <i class="bi bi-shield"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-${user.actif ? 'warning' : 'success'}" 
                                onclick="toggleUserStatus(${user.id}, ${user.actif})" 
                                title="${user.actif ? 'Désactiver' : 'Activer'}">
                            <i class="bi bi-${user.actif ? 'pause' : 'play'}-circle"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger" onclick="deleteUser(${user.id})" title="Supprimer">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </td>
            `;

            return tr;
        }

        // Edit user role
        window.editUserRole = function(userId) {
            const user = allUsers.find(u => u.id === userId);
            if (!user) return;

            document.getElementById('editUserId').value = userId;
            document.getElementById('editUserName').textContent = user.nom;
            document.getElementById('newRole').value = user.role;

            editRoleModal.show();
        };

        // Confirm edit role
        document.getElementById('confirmEditRoleBtn').addEventListener('click', async function() {
            const userId = document.getElementById('editUserId').value;
            const newRole = document.getElementById('newRole').value;

            try {
                await API.updateUserRole(userId, newRole);
                showSuccess('Rôle modifié avec succès');
                editRoleModal.hide();
                loadUsers();
            } catch (error) {
                console.error('Error updating role:', error);
                showError('Erreur lors de la modification du rôle');
            }
        });

        // Toggle user status (activate/deactivate)
        window.toggleUserStatus = async function(userId, currentStatus) {
            const user = allUsers.find(u => u.id === userId);
            if (!user) return;

            const action = currentStatus ? 'désactiver' : 'activer';
            const confirmMsg = `Voulez-vous vraiment ${action} l'utilisateur ${user.nom} ?`;

            if (!confirm(confirmMsg)) return;

            try {
                await API.toggleUserStatus(userId, !currentStatus);
                showSuccess(`Utilisateur ${action === 'désactiver' ? 'désactivé' : 'activé'} avec succès`);
                loadUsers();
            } catch (error) {
                console.error('Error toggling user status:', error);
                showError(`Erreur lors de la ${action === 'désactiver' ? 'désactivation' : 'activation'} de l'utilisateur`);
            }
        };

        // Delete user
        window.deleteUser = function(userId) {
            const user = allUsers.find(u => u.id === userId);
            if (!user) return;

            document.getElementById('deleteUserId').value = userId;
            document.getElementById('deleteUserName').textContent = user.nom;

            deleteModal.show();
        };

        // Confirm delete
        document.getElementById('confirmDeleteBtn').addEventListener('click', async function() {
            const userId = document.getElementById('deleteUserId').value;

            try {
                await API.deleteUser(userId);
                showSuccess('Utilisateur supprimé avec succès');
                deleteModal.hide();
                loadUsers();
            } catch (error) {
                console.error('Error deleting user:', error);
                showError('Erreur lors de la suppression de l\'utilisateur');
            }
        });

        // Filter users
        function filterUsers() {
            const roleFilter = filterRole.value;
            const searchFilter = filterSearch.value.toLowerCase();

            filteredUsers = allUsers.filter(user => {
                const matchesRole = !roleFilter || user.role === roleFilter;
                const matchesSearch = !searchFilter || 
                    (user.nom && user.nom.toLowerCase().includes(searchFilter)) ||
                    (user.email && user.email.toLowerCase().includes(searchFilter)) ||
                    (user.institution && user.institution.toLowerCase().includes(searchFilter));

                return matchesRole && matchesSearch;
            });

            currentPage = 1;
            displayUsers();
        }

        // Event listeners
        filtersForm.addEventListener('submit', function(e) {
            e.preventDefault();
            filterUsers();
        });

        resetFiltersBtn.addEventListener('click', function() {
            filterRole.value = '';
            filterSearch.value = '';
            filteredUsers = [...allUsers];
            currentPage = 1;
            displayUsers();
        });

        // Pagination
        function updatePagination() {
            const totalPages = Math.ceil(filteredUsers.length / itemsPerPage);
            const startIndex = (currentPage - 1) * itemsPerPage + 1;
            const endIndex = Math.min(currentPage * itemsPerPage, filteredUsers.length);

            document.getElementById('pageStart').textContent = startIndex;
            document.getElementById('pageEnd').textContent = endIndex;
            document.getElementById('totalUsers').textContent = filteredUsers.length;

            const paginationList = document.getElementById('paginationList');
            paginationList.innerHTML = '';

            // Previous button
            const prevLi = document.createElement('li');
            prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
            prevLi.innerHTML = `<a class="page-link" href="#" onclick="changePage(${currentPage - 1}); return false;">Précédent</a>`;
            paginationList.appendChild(prevLi);

            // Page numbers
            for (let i = 1; i <= totalPages; i++) {
                if (i === 1 || i === totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
                    const li = document.createElement('li');
                    li.className = `page-item ${i === currentPage ? 'active' : ''}`;
                    li.innerHTML = `<a class="page-link" href="#" onclick="changePage(${i}); return false;">${i}</a>`;
                    paginationList.appendChild(li);
                } else if (i === currentPage - 2 || i === currentPage + 2) {
                    const li = document.createElement('li');
                    li.className = 'page-item disabled';
                    li.innerHTML = '<a class="page-link" href="#">...</a>';
                    paginationList.appendChild(li);
                }
            }

            // Next button
            const nextLi = document.createElement('li');
            nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
            nextLi.innerHTML = `<a class="page-link" href="#" onclick="changePage(${currentPage + 1}); return false;">Suivant</a>`;
            paginationList.appendChild(nextLi);
        }

        // Change page
        window.changePage = function(page) {
            const totalPages = Math.ceil(filteredUsers.length / itemsPerPage);
            if (page < 1 || page > totalPages) return;
            currentPage = page;
            displayUsers();
        };

        // Utility functions
        function escapeHtml(text) {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text ? text.replace(/[&<>"']/g, m => map[m]) : '';
        }

        function showSuccess(message) {
            alert(message); // Replace with toast notification if available
        }

        function showError(message) {
            alert(message); // Replace with toast notification if available
        }
    </script>
</body>
</html>
