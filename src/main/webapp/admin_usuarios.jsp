<%-- 
    Document   : admin_usuarios
    Created on : 25 set. 2026, 11:46:39 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
<%@page import="java.sql.*"%>
<%@page import="com.conectaegresados.dao.DatabaseConnection"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || usuario.getIdRol() != 1) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestionar Usuarios - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1100px; margin: 30px auto; padding: 20px; }
        .menu { background: #1a202c; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 18px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background: #667eea; color: white; }
        tr:hover { background: #f7fafc; }
        .btn-accion { padding: 5px 10px; border: none; border-radius: 4px; text-decoration: none; font-size: 12px; margin-right: 5px; }
        .btn-activar { background: #48bb78; color: white; }
        .btn-desactivar { background: #f56565; color: white; }
        .btn-admin { background: #9f7aea; color: white; }
        .badge { padding: 3px 8px; border-radius: 10px; font-size: 11px; }
        .badge.admin { background: #e9d8fd; color: #553c9a; }
        .badge.egresado { background: #c6f6d5; color: #22543d; }
        .badge.inactivo { background: #fed7d7; color: #9b2c2c; }
        .btn-volver { display: inline-block; margin-bottom: 20px; color: #718096; text-decoration: none; }
    </style>
</head>
<body style="background:#f7fafc;">
    <jsp:include page="sidebar.jsp" />
    
    <div class="container">
        <a href="dashboard.jsp" class="btn-volver">← Volver al Inicio</a>
        <h1 style="color:#2d3748; margin-bottom:20px;">👥 Gestionar Usuarios</h1>
        
        <% if (request.getAttribute("mensaje") != null) { %>
            <div style="padding:12px; background:#d1fae5; color:#065f46; border-radius:8px; margin-bottom:20px;">
                <%= request.getAttribute("mensaje") %>
            </div>
        <% } %>
        
        <table>
            <tr>
                <th>Nombre Completo</th>
                <th>Correo</th>
                <th>Rol</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
            <%
                try (Connection conn = DatabaseConnection.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery(
                        "SELECT id_usuario, nombres, apellidos, correo, id_rol, activo FROM usuario ORDER BY apellidos, nombres")) {
                    
                    while (rs.next()) {
                        int idU = rs.getInt("id_usuario");
                        String nombre = rs.getString("nombres") + " " + rs.getString("apellidos");
                        String correo = rs.getString("correo");
                        int rol = rs.getInt("id_rol");
                        boolean activo = rs.getBoolean("activo");
            %>
            <tr>
                <td><%= nombre %></td>
                <td><%= correo %></td>
                <td>
                    <span class="badge <%= rol == 1 ? "admin" : "egresado" %>">
                        <%= rol == 1 ? "Administrador" : "Egresado" %>
                    </span>
                </td>
                <td>
                    <span class="badge <%= activo ? "egresado" : "inactivo" %>">
                        <%= activo ? "Activo" : "Inactivo" %>
                    </span>
                </td>
                <td>
                    <% if (idU != usuario.getIdUsuario()) { %>
                        <% if (activo) { %>
                            <a href="gestionar_usuario?accion=desactivar&id=<%= idU %>" class="btn-accion btn-desactivar">Desactivar</a>
                        <% } else { %>
                            <a href="gestionar_usuario?accion=activar&id=<%= idU %>" class="btn-accion btn-activar">Activar</a>
                        <% } %>
                        <% if (rol != 1) { %>
                            <a href="gestionar_usuario?accion=hacer_admin&id=<%= idU %>" class="btn-accion btn-admin">Hacer Admin</a>
                        <% } %>
                    <% } else { %>
                        <em>Tu cuenta</em>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>
</body>
</html>