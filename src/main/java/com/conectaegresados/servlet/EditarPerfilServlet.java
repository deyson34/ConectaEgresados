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
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/editar_perfil")
public class EditarPerfilServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int idUsuario = usuario.getIdUsuario();
        String telefono = request.getParameter("telefono");
        String ciudadPais = request.getParameter("ciudad_pais");
        String carrera = request.getParameter("carrera");
        String anioEgresoStr = request.getParameter("anio_egreso");
        String linkedin = request.getParameter("linkedin");
        String biografia = request.getParameter("biografia");
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            
            // 1. Actualizar datos básicos del usuario
            try (PreparedStatement pstmt = conn.prepareStatement(
                "UPDATE usuario SET telefono = ?, ciudad_pais = ? WHERE id_usuario = ?")) {
                pstmt.setString(1, telefono);
                pstmt.setString(2, ciudadPais);
                pstmt.setInt(3, idUsuario);
                pstmt.executeUpdate();
            }
            
            // Actualizar en el objeto de sesión también
            usuario.setTelefono(telefono);
            usuario.setCiudadPais(ciudadPais);
            
            // 2. Actualizar o insertar perfil de egresado
            int anioEgreso = 0;
            try {
                if (anioEgresoStr != null && !anioEgresoStr.isEmpty()) {
                    anioEgreso = Integer.parseInt(anioEgresoStr);
                }
            } catch (NumberFormatException e) {
                anioEgreso = 0;
            }
            
            // Verificar si ya existe perfil
            boolean existePerfil = false;
            try (PreparedStatement pstmt = conn.prepareStatement(
                "SELECT id_perfil FROM perfil_egresado WHERE id_usuario = ?")) {
                pstmt.setInt(1, idUsuario);
                ResultSet rs = pstmt.executeQuery();
                existePerfil = rs.next();
            }
            
            if (existePerfil) {
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE perfil_egresado SET carrera = ?, anio_egreso = ?, linkedin = ?, biografia = ? WHERE id_usuario = ?")) {
                    pstmt.setString(1, carrera);
                    if (anioEgreso > 0) pstmt.setInt(2, anioEgreso); else pstmt.setNull(2, java.sql.Types.INTEGER);
                    pstmt.setString(3, linkedin);
                    pstmt.setString(4, biografia);
                    pstmt.setInt(5, idUsuario);
                    pstmt.executeUpdate();
                }
            } else {
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO perfil_egresado (id_usuario, carrera, anio_egreso, linkedin, biografia) VALUES (?, ?, ?, ?, ?)")) {
                    pstmt.setInt(1, idUsuario);
                    pstmt.setString(2, carrera);
                    if (anioEgreso > 0) pstmt.setInt(3, anioEgreso); else pstmt.setNull(3, java.sql.Types.INTEGER);
                    pstmt.setString(4, linkedin);
                    pstmt.setString(5, biografia);
                    pstmt.executeUpdate();
                }
            }
            
            request.setAttribute("exito", "✅ ¡Perfil actualizado correctamente!");
            request.getRequestDispatcher("editar_perfil.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "❌ Error al actualizar: " + e.getMessage());
            request.getRequestDispatcher("editar_perfil.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("editar_perfil.jsp").forward(request, response);
    }
}