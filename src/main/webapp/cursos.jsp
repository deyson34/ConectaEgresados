<%-- 
    Document   : cursos
    Created on : 25 set. 2026, 9:53:27 p. m.
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
    boolean esAdmin = (usuario.getIdRol() == 1);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cursos - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1000px; margin: 30px auto; padding: 20px; }
        .menu { background: #2d3748; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 20px; }
        .menu a:hover { color: #667eea; }
        .curso-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 4px solid #667eea; }
        .curso-card h3 { color: #2d3748; margin-bottom: 8px; }
        .curso-card p { color: #718096; margin-bottom: 5px; font-size: 14px; }
        .btn-inscribir { background: #48bb78; color: white; padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-inscribir:hover { background: #38a169; }
        .btn-detalle { background: #667eea; color: white; padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; margin-right: 10px; }
        .btn-detalle:hover { background: #5a67d8; }
        .badge { background: #edf2f7; padding: 4px 10px; border-radius: 15px; font-size: 12px; margin-right: 5px; }
        .btn-admin { background: #9f7aea; color: white; padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; margin-bottom: 20px; }
    </style>
</head>
<body style="background:#f7fafc;">
    <jsp:include page="sidebar.jsp" />
    
    <div class="container">
        <h1 style="color:#2d3748; margin-bottom:20px;">📚 Cursos de Capacitación Disponibles</h1>
        
        <% if (esAdmin) { %>
            <a href="admin_cursos.jsp" class="btn-admin">⚙️ Gestionar Cursos (Admin)</a>
        <% } %>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(
               "SELECT * FROM curso WHERE estado = 'activo' ORDER BY fecha_inicio")) {
                boolean hayCursos = false;
                while (rs.next()) {
                    hayCursos = true;
                    int idCurso = rs.getInt("id_curso");
                    String titulo = rs.getString("titulo");
                    String descripcion = rs.getString("descripcion");
                    int duracion = rs.getInt("duracion_horas");
                    String instructor = rs.getString("instructor");
                    String fechaInicio = rs.getString("fecha_inicio");
                    String fechaFin = rs.getString("fecha_fin");
                    int cupo = rs.getInt("cupo_maximo");
        %>
                    <div class="curso-card">
                        <h3><%= titulo %></h3>
                        <p><strong>Descripción:</strong> <%= descripcion != null ? descripcion : "Sin descripción" %></p>
                        <p>
                            <span class="badge">⏱️ <%= duracion %> horas</span>
                            <span class="badge">👨‍🏫 <%= instructor != null ? instructor : "Por definir" %></span>
                            <span class="badge">📅 <%= fechaInicio %> al <%= fechaFin %></span>
                            <span class="badge">👥 Cupo: <%= cupo %></span>
                        </p>
                        <br>
                        <a href="curso_detalle.jsp?id=<%= idCurso %>" class="btn-detalle">📖 Ver Detalle</a>
                        <% if (!esAdmin) { %>
                            <a href="inscripcion?id_curso=<%= idCurso %>" class="btn-inscribir">✍️ Inscribirme</a>
                        <% } %>
                    </div>
        <%
                }
                if (!hayCursos) {
                    out.println("<p style='color:#a0aec0; text-align:center; padding:40px;'>No hay cursos disponibles en este momento.</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>