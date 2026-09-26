<%-- 
    Document   : registro
    Created on : 25 set. 2026, 8:31:32 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ConectaEgresados - Registro</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="login-container" style="width:500px;">
        <h1>🎓 Registro de Egresado</h1>
        <p class="subtitle">Crea tu cuenta para acceder al sistema</p>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("exito") != null) { %>
            <div class="alert" style="background:#d1fae5;color:#065f46;border:1px solid #6ee7b7;">
                <%= request.getAttribute("exito") %>
            </div>
        <% } %>
        
        <form action="registro" method="POST">
            <div class="form-group">
                <label>📄 DNI / C.E.:</label>
                <input type="text" name="dni_ce" required maxlength="15" placeholder="Ej: 71234567">
            </div>
            
            <div class="form-group">
                <label>👤 Nombres:</label>
                <input type="text" name="nombres" required placeholder="Ej: María">
            </div>
            
            <div class="form-group">
                <label>👤 Apellidos:</label>
                <input type="text" name="apellidos" required placeholder="Ej: González Pérez">
            </div>
            
            <div class="form-group">
                <label>📧 Correo electrónico:</label>
                <input type="email" name="correo" required placeholder="tucorreo@ejemplo.com">
            </div>
            
            <div class="form-group">
                <label>📱 Teléfono:</label>
                <input type="text" name="telefono" maxlength="20" placeholder="Ej: 912345678">
            </div>
            
            <div class="form-group">
                <label>🎂 Fecha de nacimiento:</label>
                <input type="date" name="fecha_nacimiento">
            </div>
            
            <div class="form-group">
                <label>📍 Ciudad / País:</label>
                <input type="text" name="ciudad_pais" placeholder="Ej: Arequipa, Perú">
            </div>
            
            <div class="form-group">
                <label>🔑 Contraseña:</label>
                <input type="password" name="contrasena" required minlength="6" placeholder="Mínimo 6 caracteres">
            </div>
            
            <div class="form-group">
                <label>🔑 Confirmar contraseña:</label>
                <input type="password" name="confirmar_contrasena" required>
            </div>
            
            <button type="submit" class="btn-primary">📝 Registrarme</button>
        </form>
        
        <p class="footer-text">¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión aquí</a></p>
    </div>
</body>
</html>