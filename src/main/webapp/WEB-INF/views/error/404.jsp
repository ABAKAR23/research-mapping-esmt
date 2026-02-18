<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page non trouvée - ESMT Research Mapping</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        
        .error-container {
            text-align: center;
            padding: 40px;
            max-width: 600px;
        }
        
        .logo {
            margin-bottom: 30px;
        }
        
        .logo img {
            max-width: 200px;
            height: auto;
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }
        
        .error-code {
            font-size: 120px;
            font-weight: 900;
            line-height: 1;
            margin-bottom: 20px;
            text-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            animation: bounce 2s ease-in-out infinite;
        }
        
        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
        }
        
        .error-title {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .error-message {
            font-size: 18px;
            margin-bottom: 30px;
            opacity: 0.9;
            line-height: 1.6;
        }
        
        .error-details {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 30px;
            font-size: 14px;
            backdrop-filter: blur(10px);
        }
        
        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .btn-home:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
            color: #5568d3;
        }
        
        .suggestions {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .suggestions h3 {
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        .suggestions ul {
            list-style: none;
            padding: 0;
        }
        
        .suggestions li {
            margin: 10px 0;
        }
        
        .suggestions a {
            color: white;
            text-decoration: none;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
            transition: border-color 0.3s;
        }
        
        .suggestions a:hover {
            border-bottom-color: white;
        }
        
        @media (max-width: 768px) {
            .error-code {
                font-size: 80px;
            }
            
            .error-title {
                font-size: 28px;
            }
            
            .error-message {
                font-size: 16px;
            }
            
            .error-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="logo">
            <img src="https://www.esmt.sn/sites/default/files/logo_esmt.png" alt="ESMT Logo">
        </div>
        
        <div class="error-code">404</div>
        
        <h1 class="error-title">Page non trouvée</h1>
        
        <p class="error-message">
            Désolé, la page que vous recherchez n'existe pas ou a été déplacée. 
            Peut-être avez-vous mal saisi l'adresse ou la page a été supprimée.
        </p>
        
        <% if (request.getAttribute("javax.servlet.error.request_uri") != null) { %>
        <div class="error-details">
            <strong>URL demandée :</strong><br>
            <%= request.getAttribute("javax.servlet.error.request_uri") %>
        </div>
        <% } %>
        
        <a href="${pageContext.request.contextPath}/dashboard" class="btn-home">
            <span>🏠</span>
            Retour au tableau de bord
        </a>
        
        <div class="suggestions">
            <h3>Suggestions :</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/dashboard">📊 Tableau de bord</a></li>
                <li><a href="${pageContext.request.contextPath}/projets">📁 Mes projets</a></li>
                <li><a href="${pageContext.request.contextPath}/projets/nouveau">➕ Déclarer un projet</a></li>
                <li><a href="${pageContext.request.contextPath}/profil">👤 Mon profil</a></li>
            </ul>
        </div>
    </div>
</body>
</html>
