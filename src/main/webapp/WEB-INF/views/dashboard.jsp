<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ESMT Research Mapping</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }

        .navbar {
            background: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .navbar h1 {
            color: #003d82;
            font-size: 24px;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .username {
            font-weight: 600;
            color: #333;
        }

        .btn-logout {
            padding: 8px 16px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-logout:hover {
            background: #c82333;
        }

        .container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .welcome-section {
            margin-bottom: 2rem;
        }

        .welcome-section h2 {
            color: #003d82;
            margin-bottom: 10px;
        }

        .auth-info-box {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 2rem;
            border-left: 5px solid #28a745;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .auth-info-box h3 {
            color: #003d82;
            margin-bottom: 15px;
        }

        .auth-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 15px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }

        .detail-item .label {
            font-weight: 600;
            color: #666;
        }

        .detail-item .value {
            color: #333;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div>
            <h1>🔬 ESMT Research Mapping</h1>
        </div>
        <div class="nav-right">
            <div class="user-info">
                <span class="username">
                    <sec:authentication property="principal.attributes['name']" />
                </span>
            </div>
            <form action="/logout" method="post" style="display: inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button type="submit" class="btn-logout">Déconnexion</button>
            </form>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="welcome-section">
            <h2>Bienvenue, <sec:authentication property="principal.attributes['name']" />! 👋</h2>
            <p>Vous êtes connecté avec OAuth 2.0</p>
        </div>

        <div class="auth-info-box">
            <h3>✅ Statut d'authentification OAuth 2.0</h3>
            <div class="auth-details">
                <div class="detail-item">
                    <span class="label">Statut:</span>
                    <span class="value">🟢 AUTHENTIFIÉ</span>
                </div>
                <div class="detail-item">
                    <span class="label">Email:</span>
                    <span class="value"><sec:authentication property="principal.attributes['email']" /></span>
                </div>
                <div class="detail-item">
                    <span class="label">ID Utilisateur:</span>
                    <span class="value"><sec:authentication property="principal.attributes['sub']" /></span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>