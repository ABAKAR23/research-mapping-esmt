package sn.esmt.cartographie.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

@WebServlet("/import-csv")
@MultipartConfig // Obligatoire pour la réception de fichiers
public class ImportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("import.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("file"); // Récupère le fichier du formulaire

        int count = 0;
        try (BufferedReader br = new BufferedReader(new InputStreamReader(filePart.getInputStream()))) {
            String line;
            // On saute la première ligne si c'est une entête
            br.readLine();

            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                // Logique pour tester la lecture
                System.out.println("Importation du projet : " + data[0]);
                // TODO: Appeler ici ton DAO pour insérer en Base de Données
                count++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("message", count + " projets importés avec succès !");
        request.getRequestDispatcher("import.jsp").forward(request, response);
    }
}