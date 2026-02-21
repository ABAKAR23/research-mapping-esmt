<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion - Cartographie ESMT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .login-card { width: 100%; max-width: 400px; padding: 2rem; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); background: white; text-align: center; }
        .btn-google { background-color: white; border: 1px solid #dadce0; color: #3c4043; font-weight: 500; }
        .btn-google:hover { background-color: #f7f8f8; border-color: #d2e3fc; }
    </style>
</head>
<body>

<div class="login-card">
    <img src="https://www.esmt.sn/sites/default/files/logo_esmt.png" alt="Logo ESMT" style="width: 150px; margin-bottom: 20px;">
    <h3 class="mb-4">Recherche & Cartographie</h3>
    <p class="text-muted mb-4">Connectez-vous pour accéder à la plateforme</p>

    <%-- Affichage des erreurs si l'AuthFilter nous renvoie ici --%>
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger p-2" style="font-size: 0.9rem;">
            <%= request.getParameter("error").equals("auth_required") ? "Connexion requise !" : "Erreur d'authentification" %>
        </div>
    <% } %>

    <%-- Le bouton qui pointe vers votre LoginServlet --%>
    <a href="login" class="btn btn-google d-flex align-items-center justify-content-center gap-2 py-2 w-100">
        <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg" width="20" alt="Google">
        Se connecter avec Google
    </a>
</div>

</body>
</html>