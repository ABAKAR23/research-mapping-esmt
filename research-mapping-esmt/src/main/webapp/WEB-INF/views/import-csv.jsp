<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import CSV - ESMT Research Mapping</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: #f0f2f5; 
            padding: 20px;
        }
        .container {
            max-width: 800px;
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
        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .card h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }
        .form-group input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 2px dashed #667eea;
            border-radius: 5px;
            background: #f8f9fa;
            cursor: pointer;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: background 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-primary:hover {
            background: #5568d3;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        .format-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .format-info code {
            background: #e9ecef;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
        }
        .format-info pre {
            background: #e9ecef;
            padding: 10px;
            border-radius: 5px;
            overflow-x: auto;
            margin-top: 10px;
        }
        #report {
            white-space: pre-wrap;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            max-height: 400px;
            overflow-y: auto;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📥 Import de Projets depuis CSV</h1>
            <p>Importez plusieurs projets en une seule fois</p>
        </div>

        <div class="card">
            <h2>Format CSV Requis</h2>
            <div class="alert alert-info">
                <strong>Format attendu :</strong> Le fichier CSV doit contenir les colonnes suivantes (avec en-tête) :
            </div>
            <div class="format-info">
                <p><strong>Colonnes :</strong></p>
                <ul>
                    <li><code>Titre</code> - Titre du projet (obligatoire)</li>
                    <li><code>Description</code> - Description du projet</li>
                    <li><code>DateDebut</code> - Date de début (format: yyyy-MM-dd)</li>
                    <li><code>DateFin</code> - Date de fin (format: yyyy-MM-dd)</li>
                    <li><code>Statut</code> - Statut du projet (EN_COURS, TERMINE, SUSPENDU)</li>
                    <li><code>Budget</code> - Budget estimé (nombre)</li>
                    <li><code>Institution</code> - Institution</li>
                    <li><code>Avancement</code> - Niveau d'avancement (0-100)</li>
                    <li><code>Domaine</code> - Domaine de recherche (obligatoire)</li>
                    <li><code>ResponsableEmail</code> - Email du responsable (obligatoire)</li>
                    <li><code>ParticipantsEmails</code> - Emails des participants (séparés par ;)</li>
                </ul>
                <p><strong>Exemple :</strong></p>
                <pre>Titre,Description,DateDebut,DateFin,Statut,Budget,Institution,Avancement,Domaine,ResponsableEmail,ParticipantsEmails
Projet IA,Description du projet,2024-01-01,2024-12-31,EN_COURS,500000,ESMT,50,Intelligence Artificielle,admin@esmt.sn,user1@esmt.sn;user2@esmt.sn</pre>
            </div>
        </div>

        <div class="card">
            <h2>Importer un Fichier CSV</h2>
            
            <div id="messageArea"></div>
            
            <form id="importForm" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="csvFile">Sélectionner le fichier CSV :</label>
                    <input type="file" id="csvFile" name="file" accept=".csv" required>
                </div>
                
                <div style="display: flex; gap: 10px;">
                    <button type="submit" class="btn btn-primary">Importer</button>
                    <a href="/dashboard" class="btn btn-secondary">Retour au Dashboard</a>
                </div>
            </form>

            <div id="reportArea" style="display: none; margin-top: 20px;">
                <h3>Rapport d'Importation</h3>
                <div id="report"></div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('importForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const fileInput = document.getElementById('csvFile');
            const file = fileInput.files[0];
            
            if (!file) {
                showMessage('Veuillez sélectionner un fichier CSV', 'danger');
                return;
            }
            
            if (!file.name.toLowerCase().endsWith('.csv')) {
                showMessage('Le fichier doit être au format CSV (.csv)', 'danger');
                return;
            }
            
            const formData = new FormData();
            formData.append('file', file);
            
            // Afficher un message de chargement
            showMessage('Importation en cours...', 'info');
            document.getElementById('reportArea').style.display = 'none';
            
            try {
                const response = await fetch('/api/javaee/import/csv', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                
                if (response.ok && result.success) {
                    showMessage('Importation terminée avec succès !', 'success');
                    document.getElementById('reportArea').style.display = 'block';
                    document.getElementById('report').textContent = result.report || 'Aucun détail disponible';
                } else {
                    showMessage('Erreur lors de l\'importation: ' + (result.error || 'Erreur inconnue'), 'danger');
                }
            } catch (error) {
                showMessage('Erreur lors de l\'importation: ' + error.message, 'danger');
            }
        });
        
        function showMessage(message, type) {
            const messageArea = document.getElementById('messageArea');
            messageArea.innerHTML = '<div class="alert alert-' + type + '">' + message + '</div>';
            
            // Faire défiler vers le message
            messageArea.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    </script>
</body>
</html>
