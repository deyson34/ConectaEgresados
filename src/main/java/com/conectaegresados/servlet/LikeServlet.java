/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.conectaegresados.servlet;

import com.conectaegresados.dao.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/like")
public class LikeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idPubStr = request.getParameter("id");
        if (idPubStr == null) {
            response.sendRedirect("foro.jsp");
            return;
        }
        
        try {
            int idPublicacion = Integer.parseInt(idPubStr);
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE publicacion_foro SET me_gusta = me_gusta + 1 WHERE id_publicacion = ?")) {
                pstmt.setInt(1, idPublicacion);
                pstmt.executeUpdate();
            }
            
            response.sendRedirect("hilo.jsp?id=" + idPublicacion);
            
        } catch (Exception e) {
            response.sendRedirect("foro.jsp");
        }
    }
}