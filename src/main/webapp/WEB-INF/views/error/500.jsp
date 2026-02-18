<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Erreur Serveur - ESMT Research Mapping</title>
    
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
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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
        
        .error-icon {
            font-size: 100px;
            margin-bottom: 20px;
            animation: shake 1s ease-in-out infinite;
        }
        
        @keyframes shake {
            0%, 100% {
                transform: translateX(0);
            }
            25% {
                transform: translateX(-10px);
            }
            75% {
                transform: translateX(10px);
            }
        }
        
        .error-code {
            font-size: 120px;
            font-weight: 900;
            line-height: 1;
            margin-bottom: 20px;
            text-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
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
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            font-size: 14px;
            backdrop-filter: blur(10px);
            text-align: left;
            max-height: 200px;
            overflow-y: auto;
        }
        
        .error-details strong {
            display: block;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .error-details pre {
            color: #ffebee;
            font-size: 12px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            background: white;
            color: #dc3545;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            margin-right: 10px;
        }
        
        .btn-home:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
            color: #c82333;
        }
        
        .btn-contact {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 15px 30px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            border: 2px solid white;
        }
        
        .btn-contact:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-3px);
        }
        
        .actions {
            margin-top: 30px;
        }
        
        .support-info {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .support-info h3 {
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        .support-info p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .support-info a {
            color: white;
            text-decoration: underline;
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
            
            .actions {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="logo">
            <img src="https://www.esmt.sn/sites/default/files/logo_esmt.png" alt="ESMT Logo">
        </div>
        
        <div class="error-icon">⚠️</div>
        
        <div class="error-code">500</div>
        
        <h1 class="error-title">Erreur Serveur</h1>
        
        <p class="error-message">
            Une erreur interne s'est produite sur le serveur. 
            Nos équipes techniques ont été informées et travaillent pour résoudre le problème.
            Veuillez réessayer dans quelques instants.
        </p>
        
        <% if (exception != null && request.getParameter("debug") != null) { %>
        <div class="error-details">
            <strong>Détails de l'erreur (mode debug) :</strong>
            <pre><%= exception.getMessage() != null ? exception.getMessage() : exception.getClass().getName() %></pre>
        </div>
        <% } %>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-home">
                <span>🏠</span>
                Retour à l'accueil
            </a>
            <a href="mailto:support@esmt.sn?subject=Erreur 500 - ESMT Research Mapping" class="btn-contact">
                <span>✉️</span>
                Contacter le support
            </a>
        </div>
        
        <div class="support-info">
            <h3>Besoin d'aide ?</h3>
            <p>
                Si le problème persiste, n'hésitez pas à contacter notre équipe technique :<br>
                <strong>Email :</strong> <a href="mailto:support@esmt.sn">support@esmt.sn</a><br>
                <strong>Téléphone :</strong> +221 33 859 89 00
            </p>
        </div>
    </div>
</body>
</html>
