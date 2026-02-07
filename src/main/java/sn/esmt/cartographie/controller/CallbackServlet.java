package sn.esmt.cartographie.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.*;
import java.util.Properties;

@WebServlet("/callback")
public class CallbackServlet extends HttpServlet {

    private String clientId;
    private String clientSecret;
    private final String REDIRECT_URI = "http://localhost:8080/research-mapping-esmt/callback";

    @Override
    public void init() throws ServletException {
        // Chargement des identifiants depuis le fichier properties
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                throw new ServletException("Désolé, impossible de trouver config.properties");
            }
            prop.load(input);
            this.clientId = prop.getProperty("google.client.id");
            this.clientSecret = prop.getProperty("google.client.secret");
        } catch (IOException ex) {
            throw new ServletException("Erreur lors du chargement de la configuration OAuth", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null) {
            response.sendRedirect("index.jsp?error=access_denied");
            return;
        }

        try {
            HttpClient client = HttpClient.newHttpClient();

            // Utilisation des variables chargées dynamiquement
            String body = "code=" + code +
                    "&client_id=" + clientId +
                    "&client_secret=" + clientSecret +
                    "&redirect_uri=" + REDIRECT_URI +
                    "&grant_type=authorization_code";

            HttpRequest tokenRequest = HttpRequest.newBuilder()
                    .uri(URI.create("https://oauth2.googleapis.com/token"))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();

            HttpResponse<String> tokenResponse = client.send(tokenRequest, HttpResponse.BodyHandlers.ofString());
            JsonObject jsonToken = JsonParser.parseString(tokenResponse.body()).getAsJsonObject();

            if (jsonToken.has("access_token")) {
                String accessToken = jsonToken.get("access_token").getAsString();

                HttpRequest userRequest = HttpRequest.newBuilder()
                        .uri(URI.create("https://www.googleapis.com/oauth2/v3/userinfo"))
                        .header("Authorization", "Bearer " + accessToken)
                        .GET()
                        .build();

                HttpResponse<String> userResponse = client.send(userRequest, HttpResponse.BodyHandlers.ofString());
                JsonObject userInfo = JsonParser.parseString(userResponse.body()).getAsJsonObject();

                HttpSession session = request.getSession();
                session.setAttribute("user_email", userInfo.get("email").getAsString());
                session.setAttribute("user_name", userInfo.get("name").getAsString());
                session.setAttribute("is_authenticated", true);

                response.sendRedirect("projets");
            } else {
                response.sendRedirect("index.jsp?error=invalid_token");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=auth_failed");
        }
    }
}