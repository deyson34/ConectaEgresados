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

@WebServlet("/gestionar_evento")
public class GestionarEventoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesar(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesar(request, response);
    }
    
    private void procesar(HttpServletRequest request, HttpServletResponse response)
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
                String fechaHora = request.getParameter("fecha_hora");
                String lugar = request.getParameter("lugar");
                String modalidad = request.getParameter("modalidad");
                int cupo = Integer.parseInt(request.getParameter("cupo"));
                
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO evento (titulo, descripcion, fecha_hora, lugar, modalidad, " +
                    "cupo_maximo, id_administrador) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                    pstmt.setString(1, titulo);
                    pstmt.setString(2, descripcion);
                    pstmt.setString(3, fechaHora);
                    pstmt.setString(4, lugar);
                    pstmt.setString(5, modalidad);
                    pstmt.setInt(6, cupo);
                    pstmt.setInt(7, admin.getIdUsuario());
                    pstmt.executeUpdate();
                }
                
                session.setAttribute("mensaje", "✅ Evento creado correctamente");
                
            } else if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                try (PreparedStatement pstmt = conn.prepareStatement("DELETE FROM evento WHERE id_evento = ?")) {
                    pstmt.setInt(1, id);
                    pstmt.executeUpdate();
                }
                session.setAttribute("mensaje", "✅ Evento eliminado");
            }
            
        } catch (Exception e) {
            session.setAttribute("mensaje", "❌ Error: " + e.getMessage());
        }
        
        response.sendRedirect("admin_eventos.jsp");
    }
}