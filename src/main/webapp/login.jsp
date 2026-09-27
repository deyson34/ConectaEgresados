<%-- 
    Document   : login
    Created on : 25 set. 2026, 7:39:24 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConectaEgresados - Iniciar Sesión</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-body">
    <div class="login-container">

        <!-- Logo institucional (SVG inline, en tono verde acorde al sistema) -->
        <div class="login-logo">
            <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
                <circle cx="32" cy="32" r="30" fill="#064e3b"/>
                <circle cx="32" cy="32" r="30" fill="none" stroke="#10b981" stroke-width="2"/>
                <path d="M32 16 L52 24 L32 32 L12 24 Z" fill="#10b981"/>
                <path d="M20 27.5 V37 C20 40 25.5 43 32 43 C38.5 43 44 40 44 37 V27.5" 
                      fill="none" stroke="#d1fae5" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
                <line x1="52" y1="24" x2="52" y2="35" stroke="#d1fae5" stroke-width="2.2" stroke-linecap="round"/>
            </svg>
        </div>

        <h1>ConectaEgresados</h1>
        <p class="subtitle">Sistema de Seguimiento de Egresados</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="login" method="POST">
            <div class="form-group">
                <label>Correo electrónico</label>
                <input type="email" name="correo" required placeholder="tucorreo@ejemplo.com" autocomplete="email">
            </div>

            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="contrasena" required placeholder="Tu contraseña" autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-primary login-btn">Ingresar</button>
        </form>

        <p class="footer-text">¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a></p>
        <p class="footer-text small">© 2026 Universidad de la Vida</p>
    </div>
</body>
</html>