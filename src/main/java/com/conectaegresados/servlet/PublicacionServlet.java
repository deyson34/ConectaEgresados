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

@WebServlet("/publicacion")
public class PublicacionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        int idUsuario = usuario.getIdUsuario();
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            
            if ("crear".equals(accion)) {
                // Crear nueva publicación (hilo principal)
                String titulo = request.getParameter("titulo");
                String contenido = request.getParameter("contenido");
                
                if (titulo == null || contenido == null || titulo.isEmpty() || contenido.isEmpty()) {
                    request.setAttribute("error", "⚠️ Completa todos los campos");
                    request.getRequestDispatcher("nueva_publicacion.jsp").forward(request, response);
                    return;
                }
                
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO publicacion_foro (titulo, contenido, id_usuario, id_padre) VALUES (?, ?, ?, NULL)")) {
                    pstmt.setString(1, titulo);
                    pstmt.setString(2, contenido);
                    pstmt.setInt(3, idUsuario);
                    pstmt.executeUpdate();
                }
                
                response.sendRedirect("foro.jsp");
                
            } else if ("responder".equals(accion)) {
                // Responder a una publicación
                String idPadreStr = request.getParameter("id_padre");
                String contenido = request.getParameter("contenido");
                
                if (idPadreStr == null || contenido == null || contenido.isEmpty()) {
                    response.sendRedirect("foro.jsp");
                    return;
                }
                
                int idPadre = Integer.parseInt(idPadreStr);
                
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO publicacion_foro (titulo, contenido, id_usuario, id_padre) VALUES (NULL, ?, ?, ?)")) {
                    pstmt.setString(1, contenido);
                    pstmt.setInt(2, idUsuario);
                    pstmt.setInt(3, idPadre);
                    pstmt.executeUpdate();
                }
                
                response.sendRedirect("hilo.jsp?id=" + idPadre);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "❌ Error: " + e.getMessage());
            request.getRequestDispatcher("nueva_publicacion.jsp").forward(request, response);
        }
    }
}