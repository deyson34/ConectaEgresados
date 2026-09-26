<%-- 
    Document   : foro
    Created on : 25 set. 2026, 10:41:06 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
<%@page import="java.sql.*"%>
<%@page import="com.conectaegresados.dao.DatabaseConnection"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Foro - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1000px; margin: 30px auto; padding: 20px; }
        .menu { background: #2d3748; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 20px; }
        .menu a:hover { color: #667eea; }
        .publicacion-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 4px solid #9f7aea; }
        .publicacion-card h3 { color: #2d3748; margin-bottom: 8px; }
        .publicacion-card p { color: #718096; margin-bottom: 5px; font-size: 14px; }
        .btn-nuevo { background: #9f7aea; color: white; padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; margin-bottom: 20px; }
        .btn-nuevo:hover { background: #805ad5; }
        .btn-ver { background: #667eea; color: white; padding: 6px 14px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 13px; }
        .badge { background: #edf2f7; padding: 4px 10px; border-radius: 15px; font-size: 12px; margin-right: 5px; }
        .meta { font-size: 12px; color: #a0aec0; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="menu">
        <a href="dashboard.jsp">🏠 Inicio</a>
        <a href="perfil.jsp">👤 Mi Perfil</a>
        <a href="cursos.jsp">📚 Cursos</a>
        <a href="ofertas.jsp">💼 Ofertas</a>
        <a href="eventos.jsp">📅 Eventos</a>
        <a href="foro.jsp">💬 Foro</a>
        <a href="logout" style="float:right; color:#fc8181;">🚪 Cerrar Sesión</a>
    </div>
    
    <div class="container">
        <h1 style="color:#2d3748; margin-bottom:10px;">💬 Foro de Experiencias y Casos de Éxito</h1>
        <p style="color:#718096; margin-bottom:20px;">Comparte tus experiencias, consejos y casos de éxito con otros egresados</p>
        
        <a href="nueva_publicacion.jsp" class="btn-nuevo">✏️ Nueva Publicación</a>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(
                    "SELECT p.*, u.nombres, u.apellidos FROM publicacion_foro p " +
                    "JOIN usuario u ON p.id_usuario = u.id_usuario " +
                    "WHERE p.id_padre IS NULL " +
                    "ORDER BY p.fecha_publicacion DESC")) {
                
                boolean hayPublicaciones = false;
                while (rs.next()) {
                    hayPublicaciones = true;
                    int idPublicacion = rs.getInt("id_publicacion");
                    String titulo = rs.getString("titulo");
                    String contenido = rs.getString("contenido");
                    String fecha = rs.getString("fecha_publicacion");
                    int likes = rs.getInt("me_gusta");
                    String autor = rs.getString("nombres") + " " + rs.getString("apellidos");
        %>
                    <div class="publicacion-card">
                        <h3><%= titulo != null ? titulo : "Sin título" %></h3>
                        <p><%= contenido != null && contenido.length() > 200 ? contenido.substring(0, 200) + "..." : contenido %></p>
                        <p class="meta">👤 Por: <%= autor %> | 📅 <%= fecha %> | ❤️ <%= likes %> me gusta</p>
                        <br>
                        <a href="hilo.jsp?id=<%= idPublicacion %>" class="btn-ver">📖 Ver publicación completa</a>
                    </div>
        <%
                }
                if (!hayPublicaciones) {
                    out.println("<p style='color:#a0aec0; text-align:center; padding:40px;'>Aún no hay publicaciones. ¡Sé el primero en compartir tu experiencia!</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>