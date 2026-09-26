<%-- 
    Document   : editar_perfil
    Created on : 25 set. 2026, 8:56:25 p. m.
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
    <title>Editar Perfil - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 600px; margin: 30px auto; padding: 20px; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .card h2 { color: #4a5568; margin-bottom: 20px; }
        .btn-save { width: 100%; padding: 14px; background: #48bb78; color: white; border: none; border-radius: 8px; font-size: 16px; cursor: pointer; }
        .btn-save:hover { background: #38a169; }
        .btn-cancel { display: block; text-align: center; margin-top: 10px; color: #718096; text-decoration: none; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="container">
        <div class="card">
            <h2>✏️ Editar Mi Perfil</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("exito") != null) { %>
                <div class="alert" style="background:#d1fae5;color:#065f46;border:1px solid #6ee7b7;"><%= request.getAttribute("exito") %></div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/editar_perfil" method="POST">
                <div class="form-group">
                    <label>📱 Teléfono:</label>
                    <input type="text" name="telefono" value="<%= usuario.getTelefono() != null ? usuario.getTelefono() : "" %>">
                </div>
                
                <div class="form-group">
                    <label>📍 Ciudad / País:</label>
                    <input type="text" name="ciudad_pais" value="<%= usuario.getCiudadPais() != null ? usuario.getCiudadPais() : "" %>">
                </div>
                
                <div class="form-group">
                    <label>🎓 Carrera:</label>
                    <input type="text" name="carrera" placeholder="Ej: Ingeniería de Sistemas">
                </div>
                
                <div class="form-group">
                    <label>📅 Año de egreso:</label>
                    <input type="number" name="anio_egreso" min="1950" max="2030" placeholder="Ej: 2022">
                </div>
                
                <div class="form-group">
                    <label>🔗 LinkedIn (URL):</label>
                    <input type="url" name="linkedin" placeholder="https://linkedin.com/in/tu-perfil">
                </div>
                
                <div class="form-group">
                    <label>📝 Biografía:</label>
                    <textarea name="biografia" rows="4" style="width:100%; padding:10px; border:2px solid #e2e8f0; border-radius:8px;" placeholder="Cuéntanos sobre ti..."></textarea>
                </div>
                
                <button type="submit" class="btn-save">💾 Guardar Cambios</button>
                <a href="perfil.jsp" class="btn-cancel">← Volver al perfil</a>
            </form>
        </div>
    </div>
</body>
</html>