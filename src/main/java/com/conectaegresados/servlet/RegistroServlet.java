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

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener datos del formulario
        String dniCe = request.getParameter("dni_ce");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String fechaNacimiento = request.getParameter("fecha_nacimiento");
        String ciudadPais = request.getParameter("ciudad_pais");
        String contrasena = request.getParameter("contrasena");
        String confirmarContrasena = request.getParameter("confirmar_contrasena");
        
        // 2. Validar contraseñas coincidan
        if (!contrasena.equals(confirmarContrasena)) {
            request.setAttribute("error", "❌ Las contraseñas no coinciden");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }
        
        // 3. Validar longitud de contraseña
        if (contrasena.length() < 6) {
            request.setAttribute("error", "❌ La contraseña debe tener al menos 6 caracteres");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }
        
        // 4. Insertar en la base de datos
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuario (dni_ce, nombres, apellidos, correo, contrasena, telefono, fecha_nacimiento, ciudad_pais, id_rol) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 2)")) {
            
            pstmt.setString(1, dniCe);
            pstmt.setString(2, nombres);
            pstmt.setString(3, apellidos);
            pstmt.setString(4, correo);
            pstmt.setString(5, contrasena);
            pstmt.setString(6, telefono);
            
            if (fechaNacimiento != null && !fechaNacimiento.isEmpty()) {
                pstmt.setDate(7, java.sql.Date.valueOf(fechaNacimiento));
            } else {
                pstmt.setNull(7, java.sql.Types.DATE);
            }
            
            pstmt.setString(8, ciudadPais);
            
            int filasInsertadas = pstmt.executeUpdate();
            
            if (filasInsertadas > 0) {
                // ✅ ÉXITO
                request.setAttribute("exito", "✅ ¡Registro exitoso! Ahora puedes iniciar sesión");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "❌ No se pudo completar el registro");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            // Manejar error de DNI o correo duplicado
            if (e.getMessage() != null && e.getMessage().contains("Duplicate")) {
                request.setAttribute("error", "❌ El DNI o correo ya están registrados");
            } else {
                request.setAttribute("error", "❌ Error: " + e.getMessage());
            }
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }
}