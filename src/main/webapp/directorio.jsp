<%-- 
    Document   : directorio
    Created on : 26 set. 2026, 9:39:51 a. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
<%@page import="java.sql.*"%>
<%@page import="com.conectaegresados.dao.DatabaseConnection"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) { response.sendRedirect("login.jsp"); return; }
    
    String busqueda = request.getParameter("q") != null ? request.getParameter("q") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Directorio - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<jsp:include page="sidebar.jsp" />
<div class="content">
    <h1>👥 Directorio de Egresados</h1>
    
    <!-- Buscador -->
    <div class="card">
        <form method="GET" action="directorio.jsp" style="display:flex; gap:10px;">
            <input type="text" name="q" value="<%= busqueda %>" placeholder="Buscar por nombre, carrera o ciudad..." style="flex:1; padding:12px; border:2px solid #e2e8f0; border-radius:8px;">
            <button type="submit" class="btn btn-primary">🔍 Buscar</button>
            <% if (!busqueda.isEmpty()) { %>
                <a href="directorio.jsp" class="btn btn-warning">✖️ Limpiar</a>
            <% } %>
        </form>
    </div>
    
    <div class="stats-grid">
        <%
            int contador = 0;
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT u.nombres, u.apellidos, u.correo, u.ciudad_pais, u.telefono, " +
                    "p.carrera, p.anio_egreso, p.linkedin " +
                    "FROM usuario u LEFT JOIN perfil_egresado p ON u.id_usuario = p.id_usuario " +
                    "WHERE u.id_rol = 2 AND u.activo = 1 " +
                    "AND (u.nombres LIKE ? OR u.apellidos LIKE ? OR p.carrera LIKE ? OR u.ciudad_pais LIKE ?) " +
                    "ORDER BY u.apellidos, u.nombres")) {
                
                String param = "%" + busqueda + "%";
                pstmt.setString(1, param);
                pstmt.setString(2, param);
                pstmt.setString(3, param);
                pstmt.setString(4, param);
                ResultSet rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    contador++;
                    String nombre = rs.getString("nombres") + " " + rs.getString("apellidos");
                    String correo = rs.getString("correo");
                    String ciudad = rs.getString("ciudad_pais") != null ? rs.getString("ciudad_pais") : "—";
                    String carrera = rs.getString("carrera") != null ? rs.getString("carrera") : "Carrera no especificada";
                    int anio = rs.getInt("anio_egreso");
                    String linkedin = rs.getString("linkedin");
        %>
        <div class="card" style="text-align:left;">
            <h3 style="margin-bottom:5px; color:#2d3748;"><%= nombre %></h3>
            <p style="color:#667eea; font-size:14px; margin-bottom:8px;">🎓 <%= carrera %> <%= anio > 0 ? "· Promoción " + anio : "" %></p>
            <p style="font-size:13px; color:#718096;">📍 <%= ciudad %></p>
            <p style="font-size:13px; color:#718096;">📧 <%= correo %></p>
            <% if (linkedin != null && !linkedin.isEmpty()) { %>
                <a href="<%= linkedin %>" target="_blank" class="btn btn-sm btn-primary" style="margin-top:10px;">🔗 Ver LinkedIn</a>
            <% } %>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
            
            if (contador == 0) {
                out.println("<div class='card' style='grid-column:1/-1; text-align:center; color:#a0aec0;'>No se encontraron egresados" + (busqueda.isEmpty() ? "" : " con el término '" + busqueda + "'") + "</div>");
            }
        %>
    </div>
    
    <p style="color:#718096; margin-top:15px;">📋 Total de egresados encontrados: <strong><%= contador %></strong></p>
</div>
</body>
</html>