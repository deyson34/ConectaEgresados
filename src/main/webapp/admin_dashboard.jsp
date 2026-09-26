<%-- 
    Document   : admin_dashboard
    Created on : 25 set. 2026, 11:50:53 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
<%@page import="java.sql.*"%>
<%@page import="com.conectaegresados.dao.DatabaseConnection"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || usuario.getIdRol() != 1) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Contadores para el panel
    int totalUsuarios = 0, totalCursos = 0, totalOfertas = 0, totalEventos = 0;
    
    try (Connection conn = DatabaseConnection.getConnection();
         Statement stmt = conn.createStatement()) {
        
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM usuario WHERE activo = 1");
        if (rs.next()) totalUsuarios = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM curso WHERE estado = 'activo'");
        if (rs.next()) totalCursos = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM oferta_laboral WHERE activa = 1");
        if (rs.next()) totalOfertas = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM evento");
        if (rs.next()) totalEventos = rs.getInt(1);
        
    } catch (Exception e) { }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Panel de Administración - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1100px; margin: 30px auto; padding: 20px; }
        .menu { background: #1a202c; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 18px; }
        .menu a:hover { color: #9f7aea; }
        .card-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 12px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .stat-card h2 { font-size: 36px; margin: 10px 0; color: #667eea; }
        .stat-card.admin h2 { color: #9f7aea; }
        .stat-card.cursos h2 { color: #48bb78; }
        .stat-card.ofertas h2 { color: #ed8936; }
        .stat-card.eventos h2 { color: #38b2ac; }
        .btn-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .btn-admin { padding: 20px; border-radius: 10px; color: white; text-decoration: none; font-weight: bold; text-align: center; font-size: 16px; }
        .btn-cursos { background: linear-gradient(135deg, #48bb78, #38a169); }
        .btn-ofertas { background: linear-gradient(135deg, #ed8936, #dd6b20); }
        .btn-eventos { background: linear-gradient(135deg, #38b2ac, #319795); }
        .btn-usuarios { background: linear-gradient(135deg, #667eea, #5a67d8); }
        .btn-reportes { background: linear-gradient(135deg, #9f7aea, #805ad5); }
        .btn-volver { display: inline-block; margin-top: 20px; color: #718096; text-decoration: none; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="menu">
        <a href="admin_dashboard.jsp">⚙️ Panel Admin</a>
        <a href="admin_usuarios.jsp">👥 Usuarios</a>
        <a href="admin_cursos.jsp">📚 Cursos</a>
        <a href="admin_ofertas.jsp">💼 Ofertas</a>
        <a href="admin_eventos.jsp">📅 Eventos</a>
        <a href="admin_reportes.jsp">📊 Reportes</a>
        <a href="dashboard.jsp" style="float:right;">🏠 Volver al Inicio</a>
        <a href="logout" style="float:right; margin-right:15px; color:#fc8181;">🚪 Cerrar Sesión</a>
    </div>
    
    <div class="container">
        <h1 style="color:#2d3748; margin-bottom:30px;">⚙️ Panel de Administración</h1>
        
        <div class="card-grid">
            <div class="stat-card admin">
                <div style="font-size:24px;">👥</div>
                <h2><%= totalUsuarios %></h2>
                <p style="color:#718096;">Usuarios Activos</p>
            </div>
            <div class="stat-card cursos">
                <div style="font-size:24px;">📚</div>
                <h2><%= totalCursos %></h2>
                <p style="color:#718096;">Cursos Activos</p>
            </div>
            <div class="stat-card ofertas">
                <div style="font-size:24px;">💼</div>
                <h2><%= totalOfertas %></h2>
                <p style="color:#718096;">Ofertas Publicadas</p>
            </div>
            <div class="stat-card eventos">
                <div style="font-size:24px;">📅</div>
                <h2><%= totalEventos %></h2>
                <p style="color:#718096;">Eventos Programados</p>
            </div>
        </div>
        
        <h2 style="color:#4a5568; margin-bottom:20px;">🔧 Gestión de Módulos</h2>
        <div class="btn-grid">
            <a href="admin_usuarios.jsp" class="btn-admin btn-usuarios">👥 Gestionar Usuarios</a>
            <a href="admin_cursos.jsp" class="btn-admin btn-cursos">📚 Gestionar Cursos</a>
            <a href="admin_ofertas.jsp" class="btn-admin btn-ofertas">💼 Gestionar Ofertas</a>
            <a href="admin_eventos.jsp" class="btn-admin btn-eventos">📅 Gestionar Eventos</a>
            <a href="admin_reportes.jsp" class="btn-admin btn-reportes" style="grid-column: span 2;">📊 Ver Reportes y Estadísticas</a>
        </div>
        
        <a href="dashboard.jsp" class="btn-volver">← Volver al Dashboard Principal</a>
    </div>
</body>
</html>