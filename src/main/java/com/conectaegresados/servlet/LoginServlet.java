/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.conectaegresados.servlet;

import com.conectaegresados.dao.UsuarioDAO;
import com.conectaegresados.model.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener datos del formulario
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        
        // 2. Validar
        if (correo == null || contrasena == null || correo.isEmpty() || contrasena.isEmpty()) {
            request.setAttribute("error", "⚠️ Completa todos los campos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // 3. Intentar login
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.iniciarSesion(correo, contrasena);
        
        if (usuario != null) {
            // ✅ ÉXITO - guardar en sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario);
            session.setAttribute("nombreUsuario", usuario.getNombres() + " " + usuario.getApellidos());
            session.setAttribute("rolUsuario", usuario.getNombreRol());
            
            // 4. Redirigir según rol
            response.sendRedirect("dashboard.jsp");
        } else {
            // ❌ FALLO
            request.setAttribute("error", "❌ Correo o contraseña incorrectos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}