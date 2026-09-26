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

@WebServlet("/asistencia")
public class AsistenciaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String idEventoStr = request.getParameter("id_evento");
        if (idEventoStr == null) {
            response.sendRedirect("eventos.jsp");
            return;
        }
        
        try {
            int idEvento = Integer.parseInt(idEventoStr);
            int idUsuario = usuario.getIdUsuario();
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO asistencia (id_usuario, id_evento, confirmado) VALUES (?, ?, 1)")) {
                pstmt.setInt(1, idUsuario);
                pstmt.setInt(2, idEvento);
                pstmt.executeUpdate();
            }
            
            session.setAttribute("mensaje_exito", "✅ ¡Te has registrado correctamente al evento!");
            
        } catch (NumberFormatException e) {
            session.setAttribute("mensaje_error", "❌ ID de evento inválido");
        } catch (Exception e) {
            if (e.getMessage() != null && e.getMessage().contains("Duplicate")) {
                session.setAttribute("mensaje_error", "⚠️ Ya estás registrado en este evento");
            } else {
                session.setAttribute("mensaje_error", "❌ Error: " + e.getMessage());
            }
        }
        
        response.sendRedirect("mis_eventos.jsp");
    }
}