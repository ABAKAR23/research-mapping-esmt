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
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 420px;
            }

            .logo {
                text-align: center;
                margin-bottom: 30px;
            }

            .logo h1 {
                color: #4a5568;
                font-size: 24px;
            }

            .logo p {
                color: #718096;
                margin-top: 6px;
                font-size: 14px;
            }

            .form-group {
                margin-bottom: 18px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                color: #4a5568;
                font-weight: 600;
            }

            input {
                width: 100%;
                padding: 12px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                outline: none;
                transition: border-color 0.3s;
                font-size: 15px;
            }

            input:focus {
                border-color: #667eea;
            }

            .btn-primary {
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

            .btn-primary:hover {
                background: #5a67d8;
            }

            .divider {
                display: flex;
                align-items: center;
                margin: 22px 0;
                color: #a0aec0;
                font-size: 13px;
            }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                border-bottom: 1px solid #e2e8f0;
                margin: 0 10px;
            }

            .btn-google {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                width: 100%;
                padding: 12px;
                background: white;
                color: #4a5568;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                transition: border-color 0.3s, box-shadow 0.3s;
            }

            .btn-google:hover {
                border-color: #4285F4;
                box-shadow: 0 2px 8px rgba(66, 133, 244, 0.25);
            }

            .error {
                color: #e53e3e;
                background: #fff5f5;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 18px;
                text-align: center;
            }

            .success {
                color: #38a169;
                background: #f0fff4;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 18px;
                text-align: center;
            }
        </style>
    </head>

    <body>
        <div class="login-container">
            <div class="logo">
                <h1>🔬 ESMT Research</h1>
                <p>Plateforme de Cartographie de la Recherche</p>
            </div>

            <% if (request.getParameter("error") !=null) { %>
                <div class="error">Identifiants incorrects. Veuillez réessayer.</div>
                <% } %>

                    <% if (request.getParameter("logout") !=null) { %>
                        <div class="success">Vous avez été déconnecté avec succès.</div>
                        <% } %>

                            <form method="post" action="/login">
                                <div class="form-group">
                                    <label for="username">Email professionnel</label>
                                    <input type="email" id="username" name="username" required
                                        placeholder="votre.nom@esmt.sn">
                                </div>
                                <div class="form-group">
                                    <label for="password">Mot de passe</label>
                                    <input type="password" id="password" name="password" required
                                        placeholder="••••••••">
                                </div>
                                <button type="submit" class="btn-primary">Se connecter</button>
                            </form>

                            <div class="divider">ou</div>

                            <!-- ✅ Authentification OAuth 2.0 Google -->
                            <a href="/oauth2/authorization/google" class="btn-google">
                                <svg width="20" height="20" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                                        fill="#4285F4" />
                                    <path
                                        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                                        fill="#34A853" />
                                    <path
                                        d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                                        fill="#FBBC05" />
                                    <path
                                        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                                        fill="#EA4335" />
                                </svg>
                                Se connecter avec Google
                            </a>
        </div>
    </body>

    </html>