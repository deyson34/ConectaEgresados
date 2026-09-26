<%-- 
    Document   : hilo
    Created on : 25 set. 2026, 10:41:33 p. m.
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
    String idPubStr = request.getParameter("id");
    int idPublicacion = 0;
    if (idPubStr != null) {
        try { idPublicacion = Integer.parseInt(idPubStr); } catch (Exception e) {}
    }
    
    String titulo = "", contenido = "", autor = "", fecha = "";
    int likes = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Publicación - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 800px; margin: 30px auto; padding: 20px; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .respuesta { background: #f7fafc; padding: 15px; border-radius: 8px; margin-bottom: 10px; border-left: 3px solid #9f7aea; }
        .btn-like { background: #ed8936; color: white; padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-like:hover { background: #dd6b20; }
        .btn-volver { color: #718096; text-decoration: none; display: inline-block; margin-bottom: 20px; }
        .meta { font-size: 12px; color: #a0aec0; margin-bottom: 15px; }
        textarea { width: 100%; padding: 10px; border: 2px solid #e2e8f0; border-radius: 8px; font-family: inherit; }
        .btn-responder { background: #9f7aea; color: white; padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; margin-top: 10px; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="container">
        <a href="foro.jsp" class="btn-volver">← Volver al foro</a>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection()) {
                // Obtener publicación principal
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT p.*, u.nombres, u.apellidos FROM publicacion_foro p " +
                    "JOIN usuario u ON p.id_usuario = u.id_usuario WHERE p.id_publicacion = ?")) {
                    pstmt.setInt(1, idPublicacion);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
                        titulo = rs.getString("titulo");
                        contenido = rs.getString("contenido");
                        autor = rs.getString("nombres") + " " + rs.getString("apellidos");
                        fecha = rs.getString("fecha_publicacion");
                        likes = rs.getInt("me_gusta");
                    }
                }
        %>
        
        <div class="card">
            <h1 style="color:#2d3748; margin-bottom:10px;"><%= titulo != null ? titulo : "Sin título" %></h1>
            <p class="meta">👤 Por: <%= autor %> | 📅 <%= fecha %></p>
            <p style="color:#4a5568; font-size:16px; line-height:1.6;"><%= contenido %></p>
            <hr style="margin:20px 0;">
            <a href="like?id=<%= idPublicacion %>" class="btn-like">❤️ Me gusta (<%= likes %>)</a>
        </div>
        
        <div class="card">
            <h3 style="color:#4a5568; margin-bottom:15px;">💬 Respuestas</h3>
            
            <%
                // Obtener respuestas
                try (PreparedStatement pstmt2 = conn.prepareStatement(
                    "SELECT p.*, u.nombres, u.apellidos FROM publicacion_foro p " +
                    "JOIN usuario u ON p.id_usuario = u.id_usuario " +
                    "WHERE p.id_padre = ? ORDER BY p.fecha_publicacion ASC")) {
                    pstmt2.setInt(1, idPublicacion);
                    ResultSet rs2 = pstmt2.executeQuery();
                    boolean hayRespuestas = false;
                    while (rs2.next()) {
                        hayRespuestas = true;
                        String respContenido = rs2.getString("contenido");
                        String respAutor = rs2.getString("nombres") + " " + rs2.getString("apellidos");
                        String respFecha = rs2.getString("fecha_publicacion");
            %>
                        <div class="respuesta">
                            <p style="color:#2d3748;"><%= respContenido %></p>
                            <p class="meta" style="margin-bottom:0;">👤 <%= respAutor %> | 📅 <%= respFecha %></p>
                        </div>
            <%
                    }
                    if (!hayRespuestas) {
                        out.println("<p style='color:#a0aec0;'>Aún no hay respuestas. ¡Sé el primero en comentar!</p>");
                    }
                }
            %>
            
            <hr style="margin:20px 0;">
            
            <h4 style="color:#4a5568; margin-bottom:10px;">✏️ Escribe tu respuesta:</h4>
            <form action="publicacion" method="POST">
                <input type="hidden" name="accion" value="responder">
                <input type="hidden" name="id_padre" value="<%= idPublicacion %>">
                <textarea name="contenido" rows="3" required placeholder="Escribe tu comentario..."></textarea>
                <button type="submit" class="btn-responder">📨 Enviar respuesta</button>
            </form>
        </div>
        
        <%
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>