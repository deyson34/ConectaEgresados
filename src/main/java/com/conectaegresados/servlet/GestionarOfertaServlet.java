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

@WebServlet("/gestionar_oferta")
public class GestionarOfertaServlet extends HttpServlet {

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
                String empresa = request.getParameter("empresa");
                String sector = request.getParameter("sector");
                String lugar = request.getParameter("lugar");
                String modalidad = request.getParameter("modalidad");
                String rangoSalarial = request.getParameter("rango_salarial");
                String descripcion = request.getParameter("descripcion");
                String requisitos = request.getParameter("requisitos");
                String fechaCierre = request.getParameter("fecha_cierre");
                
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO oferta_laboral (titulo, empresa, sector, lugar, modalidad, " +
                    "rango_salarial, descripcion, requisitos, fecha_cierre, activa) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)")) {
                    pstmt.setString(1, titulo);
                    pstmt.setString(2, empresa);
                    pstmt.setString(3, sector);
                    pstmt.setString(4, lugar);
                    pstmt.setString(5, modalidad);
                    pstmt.setString(6, rangoSalarial);
                    pstmt.setString(7, descripcion);
                    pstmt.setString(8, requisitos);
                    pstmt.setString(9, fechaCierre);
                    pstmt.executeUpdate();
                }
                
                session.setAttribute("mensaje", "✅ Oferta publicada correctamente");
                
            } else if ("activar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE oferta_laboral SET activa = 1 WHERE id_oferta = ?")) {
                    pstmt.setInt(1, id);
                    pstmt.executeUpdate();
                }
                session.setAttribute("mensaje", "✅ Oferta activada");
                
            } else if ("desactivar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "UPDATE oferta_laboral SET activa = 0 WHERE id_oferta = ?")) {
                    pstmt.setInt(1, id);
                    pstmt.executeUpdate();
                }
                session.setAttribute("mensaje", "✅ Oferta desactivada");
            }
            
        } catch (Exception e) {
            session.setAttribute("mensaje", "❌ Error: " + e.getMessage());
        }
        
        response.sendRedirect("admin_ofertas.jsp");
    }
}