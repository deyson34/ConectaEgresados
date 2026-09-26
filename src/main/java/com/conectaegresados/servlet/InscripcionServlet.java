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

@WebServlet("/inscripcion")
public class InscripcionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String idCursoStr = request.getParameter("id_curso");
        if (idCursoStr == null) {
            response.sendRedirect("cursos.jsp");
            return;
        }
        
        try {
            int idCurso = Integer.parseInt(idCursoStr);
            int idUsuario = usuario.getIdUsuario();
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO inscripcion (id_usuario, id_curso, estado, progreso) VALUES (?, ?, 'inscrito', 0)")) {
                pstmt.setInt(1, idUsuario);
                pstmt.setInt(2, idCurso);
                pstmt.executeUpdate();
            }
            
            // ✅ Inscripción exitosa
            session.setAttribute("mensaje_exito", "✅ ¡Te has inscrito correctamente al curso!");
            
        } catch (NumberFormatException e) {
            session.setAttribute("mensaje_error", "❌ ID de curso inválido");
        } catch (Exception e) {
            if (e.getMessage() != null && e.getMessage().contains("Duplicate")) {
                session.setAttribute("mensaje_error", "⚠️ Ya estás inscrito en este curso");
            } else {
                session.setAttribute("mensaje_error", "❌ Error: " + e.getMessage());
            }
        }
        
        response.sendRedirect("mis_cursos.jsp");
    }
}