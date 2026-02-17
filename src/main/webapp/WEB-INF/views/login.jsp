<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - ESMT Research Mapping</title>
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
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background: white;
            padding: 50px 40px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px;
        }

        .logo {
            text-align: center;
            margin-bottom: 40px;
        }

        .logo h1 {
            color: #003d82;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .logo p {
            color: #666;
            font-size: 12px;
            font-style: italic;
        }

        h2 {
            color: #333;
            font-size: 24px;
            margin-bottom: 10px;
            text-align: center;
        }

        .subtitle {
            color: #999;
            text-align: center;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #eee;
            border-radius: 5px;
            font-size: 1em;
            transition: border-color 0.3s;
        }

        input:focus {
            outline: none;
            border-color: #667eea;
        }

        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
            margin-bottom: 15px;
        }

        button:hover {
            transform: translateY(-2px);
        }

        .error {
            color: #e74c3c;
            font-size: 0.9em;
            margin-top: 5px;
            padding: 10px;
            background: #fadbd8;
            border-radius: 5px;
            display: none;
        }

        .success {
            color: #27ae60;
            font-size: 0.9em;
            margin-top: 5px;
            padding: 10px;
            background: #d5f4e6;
            border-radius: 5px;
            display: none;
        }

        .divider {
            text-align: center;
            margin: 20px 0;
            color: #999;
        }

        .oauth-buttons {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .btn-oauth {
            padding: 12px;
            border: 2px solid #ddd;
            background: white;
            color: #333;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-oauth:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .link {
            text-align: center;
            margin-top: 20px;
        }

        .link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <h1>🔬 ESMT Research Mapping</h1>
            <p>ECOLE SUPERIEURE MULTINATIONALE DES TELECOMMUNICATIONS</p>
        </div>

        <h2>Connexion</h2>
        <p class="subtitle">Bienvenue! Veuillez vous connecter.</p>

        <div id="error" class="error"></div>
        <div id="success" class="success"></div>

        <form onsubmit="handleLogin(event)">
            <div class="form-group">
                <label for="email">👤 Email</label>
                <input type="email" id="email" name="email" required placeholder="Entrez votre email">
            </div>

            <div class="form-group">
                <label for="password">🔐 Mot de passe</label>
                <input type="password" id="password" name="password" required placeholder="Entrez votre mot de passe">
            </div>

            <button type="submit">Se Connecter</button>
        </form>

        <div class="divider">OU</div>

        <div class="oauth-buttons">
            <a href="/oauth2/authorization/google" class="btn-oauth">
                <img src="https://www.gstatic.com/images/branding/product/1x/googleg_standard_color_92dp.png" alt="Google" width="20">
                Se connecter avec Google
            </a>
        </div>

        <div class="link">
            Pas de compte? <a href="/register.jsp">S'inscrire</a>
        </div>
    </div>

    <script>
        function handleLogin(event) {
            event.preventDefault();

            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const errorDiv = document.getElementById('error');
            const successDiv = document.getElementById('success');

            errorDiv.style.display = 'none';
            successDiv.style.display = 'none';

            fetch('/api/auth/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    email: email,
                    password: password
                })
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(data => {
                        throw new Error(data.message || 'Erreur serveur');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.token) {
                    localStorage.setItem('token', data.token);
                    localStorage.setItem('user', JSON.stringify(data));
                    successDiv.textContent = '✅ Connexion réussie! Redirection...';
                    successDiv.style.display = 'block';
                    setTimeout(() => {
                        window.location.href = '/dashboard';
                    }, 1500);
                } else {
                    errorDiv.textContent = '❌ ' + (data.message || 'Identifiants incorrects');
                    errorDiv.style.display = 'block';
                }
            })
            .catch(error => {
                errorDiv.textContent = '❌ ' + error.message;
                errorDiv.style.display = 'block';
                console.error('Erreur:', error);
            });
        }
    </script>
</body>
</html>