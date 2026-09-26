<%-- 
    Document   : curso_detalle
    Created on : 25 set. 2026, 9:53:41 p. m.
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
    String idCursoStr = request.getParameter("id");
    int idCurso = 0;
    if (idCursoStr != null) {
        try { idCurso = Integer.parseInt(idCursoStr); } catch (Exception e) {}
    }
    
    String titulo = "", descripcion = "", instructor = "", fechaInicio = "", fechaFin = "";
    int duracion = 0, cupo = 0;
    boolean yaInscrito = false;
    
    try (Connection conn = DatabaseConnection.getConnection()) {
        // Obtener datos del curso
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM curso WHERE id_curso = ?")) {
            pstmt.setInt(1, idCurso);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                titulo = rs.getString("titulo");
                descripcion = rs.getString("descripcion");
                duracion = rs.getInt("duracion_horas");
                instructor = rs.getString("instructor");
                fechaInicio = rs.getString("fecha_inicio");
                fechaFin = rs.getString("fecha_fin");
                cupo = rs.getInt("cupo_maximo");
            }
        }
        
        // Verificar si ya está inscrito
        if (!esAdmin) {
            try (PreparedStatement pstmt2 = conn.prepareStatement(
                "SELECT * FROM inscripcion WHERE id_usuario = ? AND id_curso = ?")) {
                pstmt2.setInt(1, usuario.getIdUsuario());
                pstmt2.setInt(2, idCurso);
                ResultSet rs2 = pstmt2.executeQuery();
                yaInscrito = rs2.next();
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
        .btn-inscribir { background: #48bb78; color: white; padding: 12px 30px; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 16px; margin-top: 20px; }
        .btn-inscribir:hover { background: #38a169; }
        .btn-volver { color: #718096; text-decoration: none; display: inline-block; margin-top: 20px; }
        .inscrito { background: #edf2f7; color: #4a5568; padding: 12px 30px; border-radius: 8px; display: inline-block; margin-top: 20px; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="container">
        <div class="card">
            <h1 style="color:#2d3748; margin-bottom:20px;">📖 <%= titulo %></h1>
            <p style="color:#4a5568; font-size:16px; margin-bottom:20px;"><%= descripcion != null ? descripcion : "Sin descripción" %></p>
            <hr style="margin:20px 0;">
            <p><strong>⏱️ Duración:</strong> <%= duracion %> horas</p>
            <p><strong>👨‍🏫 Instructor:</strong> <%= instructor != null ? instructor : "Por definir" %></p>
            <p><strong>📅 Fecha de inicio:</strong> <%= fechaInicio %></p>
            <p><strong>📅 Fecha de fin:</strong> <%= fechaFin %></p>
            <p><strong>👥 Cupo máximo:</strong> <%= cupo %> personas</p>
            
            <% if (!esAdmin) { %>
                <% if (yaInscrito) { %>
                    <div class="inscrito">✅ Ya estás inscrito en este curso</div>
                <% } else { %>
                    <a href="inscripcion?id_curso=<%= idCurso %>" class="btn-inscribir">✍️ Inscribirme ahora</a>
                <% } %>
            <% } %>
            
            <br>
            <a href="cursos.jsp" class="btn-volver">← Volver a la lista de cursos</a>
        </div>
    </div>
</body>
</html>