<%-- 
    Document   : dashboard
    Created on : 25 set. 2026, 8:01:18 p. m.
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
    boolean esAdmin = (usuario.getIdRol() == 1);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ConectaEgresados - Panel Principal</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .sidebar { width: 250px; background: #2d3748; min-height: 100vh; padding: 20px; float: left; }
        .sidebar a { display: block; color: #cbd5e0; padding: 12px; text-decoration: none; border-radius: 8px; margin-bottom: 5px; }
        .sidebar a:hover { background: #4a5568; color: white; }
        .sidebar a.admin-only { background: #9f7aea; color: white; }
        .content { margin-left: 270px; padding: 30px; }
        .header { background: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        .card { background: white; padding: 20px; border-radius: 10px; margin-bottom: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .badge { background: #667eea; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge.admin { background: #9f7aea; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2 style="color:white; margin-bottom:20px;">🎓 ConectaEgresados</h2>
        <p style="color:#a0aec0; font-size:12px; margin-bottom:20px;">
            <%= usuario.getNombres() %> <%= usuario.getApellidos() %><br>
            <span class="badge <%= esAdmin ? "admin" : "" %>"><%= usuario.getNombreRol() %></span>
        </p>
        
        <a href="dashboard.jsp">🏠 Inicio</a>
        <a href="perfil.jsp">👤 Mi Perfil</a>
        <a href="cursos.jsp">📚 Cursos</a>
        <a href="mis_cursos.jsp">📝 Mis Cursos</a>
        <a href="ofertas.jsp">💼 Ofertas Laborales</a>
        <a href="eventos.jsp">📅 Eventos</a>
        <a href="foro.jsp">💬 Foro</a>
        
        <% if (esAdmin) { %>
            <hr style="border-color:#4a5568; margin:15px 0;">
            <p style="color:#a0aec0; font-size:11px; margin-bottom:10px;">⚙️ ADMINISTRACIÓN</p>
            <a href="admin_usuarios.jsp" class="admin-only">👥 Gestionar Usuarios</a>
            <a href="admin_cursos.jsp" class="admin-only">📚 Gestionar Cursos</a>
            <a href="admin_ofertas.jsp" class="admin-only">💼 Gestionar Ofertas</a>
            <a href="admin_eventos.jsp" class="admin-only">📅 Gestionar Eventos</a>
            <a href="admin_reportes.jsp" class="admin-only">📊 Reportes y Estadísticas</a>
        <% } %>
        
        <hr style="border-color:#4a5568; margin:15px 0;">
        <a href="logout" style="color:#fc8181;">🚪 Cerrar Sesión</a>
    </div>
    
    <div class="content">
        <div class="header">
            <h1>¡Bienvenido, <%= usuario.getNombres() %>! 👋</h1>
            <p>Has iniciado sesión como <strong><%= usuario.getNombreRol() %></strong></p>
        </div>
        
        <div class="card">
            <h3>📋 Resumen</h3>
            <p>Correo: <%= usuario.getCorreo() %></p>
            <p>DNI: <%= usuario.getDniCe() %></p>
        </div>
        
        <% if (esAdmin) { %>
            <div class="card" style="border-left: 4px solid #9f7aea;">
                <h3>🔧 Panel de Administrador</h3>
                <p>Tienes acceso a todas las opciones de gestión del sistema.</p>
            </div>
        <% } else { %>
            <div class="card" style="border-left: 4px solid #667eea;">
                <h3>📚 Panel de Egresado</h3>
                <p>Explora cursos, ofertas laborales y eventos disponibles para ti.</p>
            </div>
        <% } %>
    </div>
</body>
</html>