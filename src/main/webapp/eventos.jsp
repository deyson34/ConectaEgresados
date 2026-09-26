<%-- 
    Document   : eventos
    Created on : 25 set. 2026, 10:27:32 p. m.
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
    <title>Eventos - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1000px; margin: 30px auto; padding: 20px; }
        .menu { background: #2d3748; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 20px; }
        .menu a:hover { color: #667eea; }
        .evento-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 4px solid #38b2ac; }
        .evento-card h3 { color: #2d3748; margin-bottom: 8px; }
        .evento-card p { color: #718096; margin-bottom: 5px; font-size: 14px; }
        .btn-registrar { background: #38b2ac; color: white; padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-registrar:hover { background: #319795; }
        .btn-detalle { background: #667eea; color: white; padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; margin-right: 10px; }
        .badge { background: #edf2f7; padding: 4px 10px; border-radius: 15px; font-size: 12px; margin-right: 5px; }
        .badge.virtual { background: #bee3f8; color: #2c5282; }
        .badge.presencial { background: #c6f6d5; color: #22543d; }
    </style>
</head>
<body style="background:#f7fafc;">
    <jsp:include page="sidebar.jsp" />
    
    <div class="container">
        <h1 style="color:#2d3748; margin-bottom:20px;">📅 Eventos y Encuentros de Egresados</h1>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(
                    "SELECT * FROM evento ORDER BY fecha_hora DESC")) {
                
                boolean hayEventos = false;
                while (rs.next()) {
                    hayEventos = true;
                    int idEvento = rs.getInt("id_evento");
                    String titulo = rs.getString("titulo");
                    String descripcion = rs.getString("descripcion");
                    String fechaHora = rs.getString("fecha_hora");
                    String lugar = rs.getString("lugar");
                    String modalidad = rs.getString("modalidad") != null ? rs.getString("modalidad") : "Presencial";
                    int cupo = rs.getInt("cupo_maximo");
        %>
                    <div class="evento-card">
                        <h3><%= titulo %></h3>
                        <p><strong>Descripción:</strong> <%= descripcion != null ? descripcion : "Sin descripción" %></p>
                        <p>
                            <span class="badge">🕐 <%= fechaHora %></span>
                            <span class="badge <%= modalidad.equalsIgnoreCase("Virtual") ? "virtual" : "presencial" %>">📍 <%= modalidad %></span>
                            <span class="badge">🏛️ <%= lugar != null ? lugar : "Por definir" %></span>
                            <span class="badge">👥 Cupo: <%= cupo > 0 ? cupo : "Ilimitado" %></span>
                        </p>
                        <br>
                        <a href="evento_detalle.jsp?id=<%= idEvento %>" class="btn-detalle">📖 Ver Detalle</a>
                        <% if (!esAdmin) { %>
                            <a href="asistencia?id_evento=<%= idEvento %>" class="btn-registrar">🎫 Registrar Asistencia</a>
                        <% } %>
                    </div>
        <%
                }
                if (!hayEventos) {
                    out.println("<p style='color:#a0aec0; text-align:center; padding:40px;'>No hay eventos programados en este momento.</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>