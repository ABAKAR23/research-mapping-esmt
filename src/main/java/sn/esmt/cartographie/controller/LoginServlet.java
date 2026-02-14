package sn.esmt.cartographie.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String clientId = "702863322358-11ua2d664998o2dsvenekm7ti6u2477d.apps.googleusercontent.com";
        String redirectUri = "http://localhost:8080/research-mapping-esmt/callback";

        // URL de Google pour demander l'autorisation
        String googleUrl = "https://accounts.google.com/o/oauth2/v2/auth?" +
                "client_id=" + clientId +
                "&redirect_uri=" + redirectUri +
                "&response_type=code" +
                "&scope=openid%20email%20profile";

        response.sendRedirect(googleUrl);
    }
}