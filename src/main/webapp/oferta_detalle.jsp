<%-- 
    Document   : oferta_detalle
    Created on : 25 set. 2026, 10:10:04 p. m.
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
    String idOfertaStr = request.getParameter("id");
    int idOferta = 0;
    if (idOfertaStr != null) {
        try { idOferta = Integer.parseInt(idOfertaStr); } catch (Exception e) {}
    }
    
    String titulo = "", empresa = "", descripcion = "", requisitos = "", rangoSalarial = "", modalidad = "", sector = "", lugar = "", fechaPublicacion = "", fechaCierre = "";
    boolean yaPostulado = false;
    
    try (Connection conn = DatabaseConnection.getConnection()) {
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM oferta_laboral WHERE id_oferta = ?")) {
            pstmt.setInt(1, idOferta);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                titulo = rs.getString("titulo");
                empresa = rs.getString("empresa");
                descripcion = rs.getString("descripcion");
                requisitos = rs.getString("requisitos");
                rangoSalarial = rs.getString("rango_salarial");
                modalidad = rs.getString("modalidad");
                sector = rs.getString("sector");
                lugar = rs.getString("lugar");
                fechaPublicacion = rs.getString("fecha_publicacion");
                fechaCierre = rs.getString("fecha_cierre");
            }
        }
        
        if (!esAdmin) {
            try (PreparedStatement pstmt2 = conn.prepareStatement(
                "SELECT * FROM postulacion WHERE id_usuario = ? AND id_oferta = ?")) {
                pstmt2.setInt(1, usuario.getIdUsuario());
                pstmt2.setInt(2, idOferta);
                ResultSet rs2 = pstmt2.executeQuery();
                yaPostulado = rs2.next();
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
        .btn-postular { background: #ed8936; color: white; padding: 12px 30px; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 16px; margin-top: 20px; }
        .btn-postular:hover { background: #dd6b20; }
        .btn-volver { color: #718096; text-decoration: none; display: inline-block; margin-top: 20px; }
        .postulado { background: #edf2f7; color: #4a5568; padding: 12px 30px; border-radius: 8px; display: inline-block; margin-top: 20px; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="container">
        <div class="card">
            <h1 style="color:#2d3748; margin-bottom:10px;">💼 <%= titulo %></h1>
            <h3 style="color:#718096; margin-bottom:20px;">🏢 <%= empresa %></h3>
            
            <hr style="margin:20px 0;">
            
            <h3 style="color:#4a5568;">📝 Descripción del puesto:</h3>
            <p style="color:#4a5568; margin-bottom:15px;"><%= descripcion != null ? descripcion : "Sin descripción" %></p>
            
            <h3 style="color:#4a5568;">✅ Requisitos:</h3>
            <p style="color:#4a5568; margin-bottom:15px;"><%= requisitos != null ? requisitos : "No especificados" %></p>
            
            <hr style="margin:20px 0;">
            
            <p><strong>💰 Rango salarial:</strong> <%= rangoSalarial != null ? rangoSalarial : "No especificado" %></p>
            <p><strong>📍 Modalidad:</strong> <%= modalidad != null ? modalidad : "Presencial" %></p>
            <p><strong>🏢 Sector:</strong> <%= sector != null ? sector : "General" %></p>
            <p><strong>🌆 Lugar:</strong> <%= lugar != null ? lugar : "No especificado" %></p>
            <p><strong>📅 Publicado:</strong> <%= fechaPublicacion != null ? fechaPublicacion : "Sin fecha" %></p>
            <p><strong>⏰ Fecha de cierre:</strong> <%= fechaCierre != null ? fechaCierre : "Sin fecha límite" %></p>
            
            <% if (!esAdmin) { %>
                <% if (yaPostulado) { %>
                    <div class="postulado">✅ Ya te has postulado a esta oferta</div>
                <% } else { %>
                    <a href="postular?id_oferta=<%= idOferta %>" class="btn-postular">📨 Postularme ahora</a>
                <% } %>
            <% } %>
            
            <br>
            <a href="ofertas.jsp" class="btn-volver">← Volver a la lista de ofertas</a>
        </div>
    </div>
</body>
</html>