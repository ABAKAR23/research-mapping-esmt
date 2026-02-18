<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Projets - Research Mapping ESMT</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/tables.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/responsive.css" rel="stylesheet">
</head>
<body data-user-role="${sessionScope.user_role}" data-user-id="${sessionScope.user_id}" data-load-projects="true">
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/projets">
                        <i class="bi bi-folder"></i> Projets
                    </a>
                </li>
                <c:if test="${sessionScope.user_role eq 'Gestionnaire' or sessionScope.user_role eq 'Admin'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/utilisateurs">
                            <i class="bi bi-people"></i> Utilisateurs
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/rapports">
                            <i class="bi bi-file-earmark-bar-graph"></i> Rapports
                        </a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.user_role eq 'Admin'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                            <i class="bi bi-gear"></i> Administration
                        </a>
                    </li>
                </c:if>
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
                        <i class="bi bi-folder"></i> Liste des Projets
                    </h1>
                    <p class="text-muted">
                        <c:choose>
                            <c:when test="${sessionScope.user_role eq 'Candidat'}">
                                Gérez vos projets de recherche
                            </c:when>
                            <c:otherwise>
                                Gérez l'ensemble des projets de recherche
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <c:if test="${sessionScope.user_role eq 'Candidat' or sessionScope.user_role eq 'Gestionnaire' or sessionScope.user_role eq 'Admin'}">
                    <a href="${pageContext.request.contextPath}/projets/nouveau" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Déclarer un projet
                    </a>
                </c:if>
            </div>

            <!-- Filters Section -->
            <div class="card mb-4">
                <div class="card-body">
                    <form id="filtersForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="filterDomain" class="form-label">
                                <i class="bi bi-tag"></i> Domaine
                            </label>
                            <select class="form-select" id="filterDomain" name="domain">
                                <option value="">Tous les domaines</option>
                                <option value="Intelligence Artificielle">Intelligence Artificielle</option>
                                <option value="Big Data">Big Data</option>
                                <option value="IoT">IoT</option>
                                <option value="Blockchain">Blockchain</option>
                                <option value="Cybersécurité">Cybersécurité</option>
                                <option value="Cloud Computing">Cloud Computing</option>
                                <option value="Développement Web">Développement Web</option>
                                <option value="Développement Mobile">Développement Mobile</option>
                                <option value="DevOps">DevOps</option>
                                <option value="Machine Learning">Machine Learning</option>
                                <option value="Réseaux">Réseaux</option>
                                <option value="Systèmes embarqués">Systèmes embarqués</option>
                                <option value="Autre">Autre</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="filterStatus" class="form-label">
                                <i class="bi bi-flag"></i> Statut
                            </label>
                            <select class="form-select" id="filterStatus" name="status">
                                <option value="">Tous les statuts</option>
                                <option value="En attente">En attente</option>
                                <option value="En cours">En cours</option>
                                <option value="Terminé">Terminé</option>
                                <option value="Annulé">Annulé</option>
                            </select>
                        </div>
                        <c:if test="${sessionScope.user_role eq 'Gestionnaire' or sessionScope.user_role eq 'Admin'}">
                            <div class="col-md-3">
                                <label for="filterResponsable" class="form-label">
                                    <i class="bi bi-person"></i> Responsable
                                </label>
                                <select class="form-select" id="filterResponsable" name="responsable">
                                    <option value="">Tous les responsables</option>
                                </select>
                            </div>
                        </c:if>
                        <div class="col-md-3">
                            <label for="filterSearch" class="form-label">
                                <i class="bi bi-search"></i> Recherche
                            </label>
                            <input type="text" class="form-control" id="filterSearch" name="search" 
                                   placeholder="Titre ou description...">
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
                <p class="mt-3 text-muted">Chargement des projets...</p>
            </div>

            <!-- Projects Table -->
            <div class="card" id="projectsTableCard">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover" id="projectsTable">
                            <thead>
                                <tr>
                                    <th>Titre</th>
                                    <th>Domaine</th>
                                    <th>Statut</th>
                                    <th>Date début</th>
                                    <th>Date fin</th>
                                    <th>Budget (FCFA)</th>
                                    <th>Avancement (%)</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="projectsTableBody">
                                <!-- Projects will be loaded dynamically by projects.js -->
                            </tbody>
                        </table>
                    </div>

                    <!-- Empty State -->
                    <div id="emptyState" class="text-center py-5" style="display: none;">
                        <i class="bi bi-folder-x display-1 text-muted"></i>
                        <h4 class="mt-3">Aucun projet trouvé</h4>
                        <p class="text-muted">
                            <c:choose>
                                <c:when test="${sessionScope.user_role eq 'Candidat'}">
                                    Vous n'avez pas encore de projet. Commencez par déclarer votre premier projet.
                                </c:when>
                                <c:otherwise>
                                    Aucun projet ne correspond aux critères de recherche.
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${sessionScope.user_role eq 'Candidat' or sessionScope.user_role eq 'Gestionnaire' or sessionScope.user_role eq 'Admin'}">
                            <a href="${pageContext.request.contextPath}/projets/nouveau" class="btn btn-primary mt-3">
                                <i class="bi bi-plus-circle"></i> Déclarer un projet
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Pagination Footer -->
                <div class="card-footer" id="paginationFooter" style="display: none;">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="text-muted">
                            Affichage de <span id="pageStart">1</span> à <span id="pageEnd">10</span> 
                            sur <span id="totalProjects">0</span> projets
                        </div>
                        <nav aria-label="Pagination des projets">
                            <ul class="pagination mb-0" id="paginationList">
                                <!-- Pagination will be generated dynamically -->
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </main>

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
                    <p>Êtes-vous sûr de vouloir supprimer ce projet ?</p>
                    <p class="text-danger"><strong>Cette action est irréversible.</strong></p>
                    <p class="mb-0">Projet : <strong id="deleteProjectTitle"></strong></p>
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
    <script type="module" src="${pageContext.request.contextPath}/js/api.js"></script>
    <script type="module" src="${pageContext.request.contextPath}/js/projects.js"></script>
</body>
</html>
