<%-- 
    Document   : nueva_publicacion
    Created on : 25 set. 2026, 10:41:20 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
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
    <title>Nueva Publicación - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 700px; margin: 30px auto; padding: 20px; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .btn-publicar { width: 100%; padding: 14px; background: #9f7aea; color: white; border: none; border-radius: 8px; font-size: 16px; cursor: pointer; }
        .btn-publicar:hover { background: #805ad5; }
        .btn-volver { color: #718096; text-decoration: none; display: inline-block; margin-top: 15px; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="container">
        <div class="card">
            <h1 style="color:#2d3748; margin-bottom:20px;">✏️ Nueva Publicación</h1>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert error"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form action="publicacion" method="POST">
                <input type="hidden" name="accion" value="crear">
                
                <div class="form-group">
                    <label>📝 Título:</label>
                    <input type="text" name="titulo" required maxlength="200" placeholder="Ej: ¡Conseguí trabajo gracias a los cursos!">
                </div>
                
                <div class="form-group">
                    <label>💬 Contenido:</label>
                    <textarea name="contenido" rows="8" required style="width:100%; padding:10px; border:2px solid #e2e8f0; border-radius:8px; font-family:inherit;" placeholder="Cuéntanos tu experiencia, consejos o caso de éxito..."></textarea>
                </div>
                
                <button type="submit" class="btn-publicar">📢 Publicar</button>
            </form>
            
            <a href="foro.jsp" class="btn-volver">← Volver al foro</a>
        </div>
    </div>
</body>
</html>