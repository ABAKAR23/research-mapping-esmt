<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Importation des données - ESMT</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light">
        <div class="container mt-5">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Importer des Projets (Fichier CSV)</h4>
                </div>
                <div class="card-body">
                    <div class="alert alert-warning">
                        <strong>Format attendu (CSV avec en-tête) :</strong><br>
                        <code>Titre, Description, DateDebut(yyyy-MM-dd), DateFin(yyyy-MM-dd), Statut, Budget, Institution, Avancement, Domaine, ResponsableEmail, ParticipantsEmails(sep=;)</code>
                    </div>

                    <form action="/import-csv" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="file" class="form-label">Choisir le fichier .csv</label>
                            <input class="form-control" type="file" id="file" name="file" accept=".csv" required>
                        </div>
                        <button type="submit" class="btn btn-success">Lancer l'importation</button>
                        <a href="/dashboard" class="btn btn-secondary">Retour au Dashboard</a>
                    </form>

                    <% if(request.getAttribute("message") !=null) { %>
                        <div class="alert alert-<%= request.getAttribute(" messageType") !=null ?
                            request.getAttribute("messageType") : "info" %> mt-3">
                            <%= request.getAttribute("message") %>
                        </div>
                        <% } %>
                </div>
            </div>
        </div>
    </body>

    </html>