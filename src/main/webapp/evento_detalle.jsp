<%-- 
    Document   : evento_detalle
    Created on : 25 set. 2026, 10:27:44 p. m.
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
    String idEventoStr = request.getParameter("id");
    int idEvento = 0;
    if (idEventoStr != null) {
        try { idEvento = Integer.parseInt(idEventoStr); } catch (Exception e) {}
    }
    
    String titulo = "", descripcion = "", fechaHora = "", lugar = "", modalidad = "";
    int cupo = 0;
    boolean yaRegistrado = false;
    
    try (Connection conn = DatabaseConnection.getConnection()) {
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM evento WHERE id_evento = ?")) {
            pstmt.setInt(1, idEvento);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                titulo = rs.getString("titulo");
                descripcion = rs.getString("descripcion");
                fechaHora = rs.getString("fecha_hora");
                lugar = rs.getString("lugar");
                modalidad = rs.getString("modalidad") != null ? rs.getString("modalidad") : "Presencial";
                cupo = rs.getInt("cupo_maximo");
            }
        }
        
        if (!esAdmin) {
            try (PreparedStatement pstmt2 = conn.prepareStatement(
                "SELECT * FROM asistencia WHERE id_usuario = ? AND id_evento = ?")) {
                pstmt2.setInt(1, usuario.getIdUsuario());
                pstmt2.setInt(2, idEvento);
                ResultSet rs2 = pstmt2.executeQuery();
                yaRegistrado = rs2.next();
            }
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= titulo %> - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 800px; margin: 30px auto; padding: 20px; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .btn-registrar { background: #38b2ac; color: white; padding: 12px 30px; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 16px; margin-top: 20px; }
        .btn-registrar:hover { background: #319795; }
        .btn-volver { color: #718096; text-decoration: none; display: inline-block; margin-top: 20px; }
        .registrado { background: #edf2f7; color: #4a5568; padding: 12px 30px; border-radius: 8px; display: inline-block; margin-top: 20px; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="container">
        <div class="card">
            <h1 style="color:#2d3748; margin-bottom:10px;">📅 <%= titulo %></h1>
            
            <hr style="margin:20px 0;">
            
            <h3 style="color:#4a5568;">📝 Descripción:</h3>
            <p style="color:#4a5568; margin-bottom:15px;"><%= descripcion != null ? descripcion : "Sin descripción" %></p>
            
            <hr style="margin:20px 0;">
            
            <p><strong>🕐 Fecha y hora:</strong> <%= fechaHora %></p>
            <p><strong>📍 Modalidad:</strong> <%= modalidad %></p>
            <p><strong>🏛️ Lugar / Enlace:</strong> <%= lugar != null ? lugar : "Por definir" %></p>
            <p><strong>👥 Cupo máximo:</strong> <%= cupo > 0 ? cupo + " personas" : "Ilimitado" %></p>
            
            <% if (!esAdmin) { %>
                <% if (yaRegistrado) { %>
                    <div class="registrado">✅ Ya estás registrado para este evento</div>
                <% } else { %>
                    <a href="asistencia?id_evento=<%= idEvento %>" class="btn-registrar">🎫 Registrar mi asistencia</a>
                <% } %>
            <% } %>
            
            <br>
            <a href="eventos.jsp" class="btn-volver">← Volver a la lista de eventos</a>
        </div>
    </div>
</body>
</html>