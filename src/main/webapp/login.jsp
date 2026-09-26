<%-- 
    Document   : login
    Created on : 25 set. 2026, 7:39:24 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ConectaEgresados - Iniciar Sesión</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="login-container">
        <h1>🎓 ConectaEgresados</h1>
        <p class="subtitle">Sistema de Seguimiento de Egresados</p>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <form action="login" method="POST">
            <div class="form-group">
                <label>📧 Correo electrónico:</label>
                <input type="email" name="correo" required placeholder="tucorreo@ejemplo.com">
            </div>
            
            <div class="form-group">
                <label>🔑 Contraseña:</label>
                <input type="password" name="contrasena" required placeholder="Tu contraseña">
            </div>
            
            <button type="submit" class="btn-primary">Ingresar</button>
        </form>
        
        <p class="footer-text">¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a></p>
        <p class="footer-text small">© 2026 Universidad de la Vida</p>
    </div>
</body>
</html>