<%-- 
    Document   : registro
    Created on : 25 set. 2026, 8:31:32 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConectaEgresados - Registro</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-body">
    <div class="login-container register-container">

        <div class="login-logo">
            <svg width="56" height="56" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
                <circle cx="32" cy="32" r="30" fill="#064e3b"/>
                <circle cx="32" cy="32" r="30" fill="none" stroke="#10b981" stroke-width="2"/>
                <path d="M32 16 L52 24 L32 32 L12 24 Z" fill="#10b981"/>
                <path d="M20 27.5 V37 C20 40 25.5 43 32 43 C38.5 43 44 40 44 37 V27.5" 
                      fill="none" stroke="#d1fae5" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
                <line x1="52" y1="24" x2="52" y2="35" stroke="#d1fae5" stroke-width="2.2" stroke-linecap="round"/>
            </svg>
        </div>

        <h1>Registro de Egresado</h1>
        <p class="subtitle">Crea tu cuenta para acceder al sistema</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("exito") != null) { %>
            <div class="alert success"><%= request.getAttribute("exito") %></div>
        <% } %>

        <form action="registro" method="POST">

            <div class="form-group">
                <label>DNI / C.E.</label>
                <input type="text" name="dni_ce" required maxlength="15" placeholder="Ej: 71234567">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Nombres</label>
                    <input type="text" name="nombres" required placeholder="Ej: María">
                </div>
                <div class="form-group">
                    <label>Apellidos</label>
                    <input type="text" name="apellidos" required placeholder="Ej: González Pérez">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Correo electrónico</label>
                    <input type="email" name="correo" required placeholder="tucorreo@ejemplo.com" autocomplete="email">
                </div>
                <div class="form-group">
                    <label>Teléfono</label>
                    <input type="text" name="telefono" maxlength="20" placeholder="Ej: 912345678">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Fecha de nacimiento</label>
                    <input type="date" name="fecha_nacimiento">
                </div>
                <div class="form-group">
                    <label>Ciudad / País</label>
                    <input type="text" name="ciudad_pais" placeholder="Ej: Arequipa, Perú">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Contraseña</label>
                    <input type="password" name="contrasena" required minlength="6" placeholder="Mínimo 6 caracteres" autocomplete="new-password">
                </div>
                <div class="form-group">
                    <label>Confirmar contraseña</label>
                    <input type="password" name="confirmar_contrasena" required autocomplete="new-password">
                </div>
            </div>

            <button type="submit" class="btn btn-primary login-btn">Registrarme</button>
        </form>

        <p class="footer-text">¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión aquí</a></p>
    </div>
</body>
</html>