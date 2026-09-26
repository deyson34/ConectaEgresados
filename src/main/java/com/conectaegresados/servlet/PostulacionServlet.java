/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.conectaegresados.servlet;

import com.conectaegresados.dao.DatabaseConnection;
import com.conectaegresados.model.Usuario;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/postular")
public class PostulacionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String idOfertaStr = request.getParameter("id_oferta");
        if (idOfertaStr == null) {
            response.sendRedirect("ofertas.jsp");
            return;
        }
        
        try {
            int idOferta = Integer.parseInt(idOfertaStr);
            int idUsuario = usuario.getIdUsuario();
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO postulacion (id_usuario, id_oferta, estado) VALUES (?, ?, 'postulado')")) {
                pstmt.setInt(1, idUsuario);
                pstmt.setInt(2, idOferta);
                pstmt.executeUpdate();
            }
            
            session.setAttribute("mensaje_exito", "✅ ¡Te has postulado correctamente a la oferta!");
            
        } catch (NumberFormatException e) {
            session.setAttribute("mensaje_error", "❌ ID de oferta inválido");
        } catch (Exception e) {
            if (e.getMessage() != null && e.getMessage().contains("Duplicate")) {
                session.setAttribute("mensaje_error", "⚠️ Ya te has postulado a esta oferta");
            } else {
                session.setAttribute("mensaje_error", "❌ Error: " + e.getMessage());
            }
        }
        
        response.sendRedirect("mis_postulaciones.jsp");
    }
}