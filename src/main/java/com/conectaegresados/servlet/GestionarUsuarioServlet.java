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

@WebServlet("/gestionar_usuario")
public class GestionarUsuarioServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario admin = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (admin == null || admin.getIdRol() != 1) {
            response.sendRedirect("dashboard.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");
        
        if (accion == null || idStr == null) {
            response.sendRedirect("admin_usuarios.jsp");
            return;
        }
        
        try {
            int idUsuario = Integer.parseInt(idStr);
            
            if (idUsuario == admin.getIdUsuario()) {
                session.setAttribute("mensaje_error", "❌ No puedes modificar tu propia cuenta desde aquí");
                response.sendRedirect("admin_usuarios.jsp");
                return;
            }
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                switch (accion) {
                    case "activar":
                        try (PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE usuario SET activo = 1 WHERE id_usuario = ?")) {
                            pstmt.setInt(1, idUsuario);
                            pstmt.executeUpdate();
                        }
                        session.setAttribute("mensaje", "✅ Usuario activado correctamente");
                        break;
                        
                    case "desactivar":
                        try (PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE usuario SET activo = 0 WHERE id_usuario = ?")) {
                            pstmt.setInt(1, idUsuario);
                            pstmt.executeUpdate();
                        }
                        session.setAttribute("mensaje", "✅ Usuario desactivado correctamente");
                        break;
                        
                    case "hacer_admin":
                        try (PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE usuario SET id_rol = 1 WHERE id_usuario = ?")) {
                            pstmt.setInt(1, idUsuario);
                            pstmt.executeUpdate();
                        }
                        session.setAttribute("mensaje", "✅ Usuario ahora es Administrador");
                        break;
                }
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("mensaje_error", "❌ ID inválido");
        } catch (Exception e) {
            session.setAttribute("mensaje_error", "❌ Error: " + e.getMessage());
        }
        
        response.sendRedirect("admin_usuarios.jsp");
    }
}