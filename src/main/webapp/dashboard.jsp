<%-- 
    Document   : dashboard
    Created on : 25 set. 2026, 8:01:18 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
<%@page import="java.util.Calendar"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean esAdmin = (usuario.getIdRol() == 1);

    int hora = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
    String saludo = (hora < 12) ? "Buenos días" : (hora < 19) ? "Buenas tardes" : "Buenas noches";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConectaEgresados - Panel Principal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-body">
    <jsp:include page="sidebar.jsp" />

    <div class="content">
        <!-- 🎯 AQUÍ ENVOLVEMOS TODO EN EL CONTENEDOR CENTRADO -->
        <div class="dashboard-container">

            <div class="welcome-card">
                <div class="welcome-text">
                    <p class="welcome-greeting"><%= saludo %></p>
                    <h1>¡Bienvenido, <span class="welcome-nombre"><%= usuario.getNombres() %></span>!</h1>
                    <p class="welcome-role">Has iniciado sesión como <strong><%= usuario.getNombreRol() %></strong>. Aquí tenés un acceso rápido a lo más usado.</p>
                    <div class="welcome-actions">
                        <% if (esAdmin) { %>
                            <a href="admin_usuarios.jsp" class="welcome-btn welcome-btn-solid">Gestionar usuarios</a>
                            <a href="admin_reportes.jsp" class="welcome-btn welcome-btn-outline">Ver reportes</a>
                        <% } else { %>
                            <a href="directorio.jsp" class="welcome-btn welcome-btn-solid">Ver directorio</a>
                            <a href="cursos.jsp" class="welcome-btn welcome-btn-outline">Explorar cursos</a>
                        <% } %>
                    </div>
                </div>

                <div class="welcome-illustration">
                    <svg width="120" height="120" viewBox="0 0 150 150" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="75" cy="75" r="70" fill="rgba(16,185,129,0.12)"/>
                        <circle cx="75" cy="75" r="52" fill="rgba(16,185,129,0.18)"/>
                        <circle cx="75" cy="72" r="36" fill="#10b981"/>
                        <path d="M75 50 L104 62 L75 72 L46 62 Z" fill="#d1fae5"/>
                        <path d="M60 66 V80 C60 86 66.5 91 75 91 C83.5 91 90 86 90 80 V66"
                              fill="none" stroke="#052e26" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
                        <line x1="104" y1="62" x2="104" y2="78" stroke="#052e26" stroke-width="3" stroke-linecap="round"/>
                        <circle cx="30" cy="30" r="4" fill="#10b981" opacity="0.6"/>
                        <circle cx="128" cy="40" r="3" fill="#d1fae5" opacity="0.7"/>
                        <circle cx="120" cy="118" r="5" fill="#10b981" opacity="0.5"/>
                        <circle cx="24" cy="112" r="3" fill="#d1fae5" opacity="0.6"/>
                    </svg>
                </div>
            </div>

            <% if (esAdmin) { %>
                <div class="card card-acento card-morado">
                    <h3>Panel de Administrador</h3>
                    <p>Tenés acceso a todas las opciones de gestión en el menú lateral izquierdo: usuarios, egresados, reportes y configuración del sistema.</p>
                </div>
            <% } else { %>
                <div class="card card-acento card-verde">
                    <h3>Panel de Egresado</h3>
                    <p>Explorá cursos, ofertas laborales, eventos y conectá con otros egresados en el directorio.</p>
                </div>
            <% } %>

        </div>
    </div>
</body>
</html>