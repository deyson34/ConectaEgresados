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

@WebServlet("/gestionar_curso")
public class GestionarCursoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarAccion(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarAccion(request, response);
    }
    
    private void procesarAccion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario admin = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (admin == null || admin.getIdRol() != 1) {
            response.sendRedirect("dashboard.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("crear".equals(accion)) {
                String titulo = request.getParameter("titulo");
                String descripcion = request.getParameter("descripcion");
                String instructor = request.getParameter("instructor");
                int duracion = Integer.parseInt(request.getParameter("duracion"));
                int cupo = Integer.parseInt(request.getParameter("cupo"));
                String fechaInicio = request.getParameter("fecha_inicio");
                String fechaFin = request.getParameter("fecha_fin");
                
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO curso (titulo, descripcion, instructor, duracion_horas, " +
                    "cupo_maximo, fecha_inicio, fecha_fin, estado, id_administrador) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, 'activo', ?)")) {
                    pstmt.setString(1, titulo);
                    pstmt.setString(2, descripcion);
                    pstmt.setString(3, instructor);
                    pstmt.setInt(4, duracion);
                    pstmt.setInt(5, cupo);
                    pstmt.setString(6, fechaInicio);
                    pstmt.setString(7, fechaFin);
                    pstmt.setInt(8, admin.getIdUsuario());
                    pstmt.executeUpdate();
                }
                
                session.setAttribute("mensaje", "✅ Curso creado correctamente");
                
            } else if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                try (PreparedStatement pstmt = conn.prepareStatement("DELETE FROM curso WHERE id_curso = ?")) {
                    pstmt.setInt(1, id);
                    pstmt.executeUpdate();
                }
                session.setAttribute("mensaje", "✅ Curso eliminado");
            }
            
        } catch (Exception e) {
            session.setAttribute("mensaje_error", "❌ Error: " + e.getMessage());
        }
        
        response.sendRedirect("admin_cursos.jsp");
    }
}