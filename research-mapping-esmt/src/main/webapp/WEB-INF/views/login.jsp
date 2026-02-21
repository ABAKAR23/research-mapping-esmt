<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - ESMT Research Mapping</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
        }
        .logo { text-align: center; margin-bottom: 30px; }
        .logo h1 { color: #4a5568; font-size: 24px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; color: #4a5568; font-weight: 600; }
        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            outline: none;
            transition: border-color 0.3s;
        }
        input:focus { border-color: #667eea; }
        button {
            width: 100%;
            padding: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        button:hover { background: #5a67d8; }
        .error { color: #e53e3e; background: #fff5f5; padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center; }
        .success { color: #38a169; background: #f0fff4; padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <h1>ESMT Research</h1>
            <p>Cartographie de la Recherche</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
            <div class="error">Identifiants incorrects. Veuillez réessayer.</div>
        <% } %>
        
        <% if (request.getParameter("logout") != null) { %>
            <div class="success">Vous avez été déconnecté avec succès.</div>
        <% } %>

        <form method="post" action="/login">
            <div class="form-group">
                <label for="username">Email professionnel</label>
                <input type="email" id="username" name="username" required placeholder="votre.nom@esmt.sn">
            </div>
            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" id="password" name="password" required placeholder="••••••••">
            </div>
            <button type="submit">Se connecter</button>
        </form>
    </div>
</body>
</html>