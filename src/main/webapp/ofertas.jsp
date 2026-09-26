<%-- 
    Document   : ofertas
    Created on : 25 set. 2026, 10:09:49 p. m.
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
    <title>Ofertas Laborales - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1000px; margin: 30px auto; padding: 20px; }
        .menu { background: #2d3748; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 20px; }
        .menu a:hover { color: #667eea; }
        .oferta-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 4px solid #f6ad55; }
        .oferta-card h3 { color: #2d3748; margin-bottom: 8px; }
        .oferta-card p { color: #718096; margin-bottom: 5px; font-size: 14px; }
        .btn-postular { background: #ed8936; color: white; padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-postular:hover { background: #dd6b20; }
        .btn-detalle { background: #667eea; color: white; padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; margin-right: 10px; }
        .badge { background: #edf2f7; padding: 4px 10px; border-radius: 15px; font-size: 12px; margin-right: 5px; }
        .badge.activa { background: #c6f6d5; color: #22543d; }
    </style>
</head>
<body style="background:#f7fafc;">
    <jsp:include page="sidebar.jsp" />
    
    <div class="container">
        <h1 style="color:#2d3748; margin-bottom:20px;">💼 Ofertas Laborales Disponibles</h1>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(
                    "SELECT * FROM oferta_laboral WHERE activa = 1 ORDER BY fecha_publicacion DESC")) {
                
                boolean hayOfertas = false;
                while (rs.next()) {
                    hayOfertas = true;
                    int idOferta = rs.getInt("id_oferta");
                    String titulo = rs.getString("titulo");
                    String empresa = rs.getString("empresa");
                    String descripcion = rs.getString("descripcion");
                    String rangoSalarial = rs.getString("rango_salarial");
                    String modalidad = rs.getString("modalidad");
                    String sector = rs.getString("sector");
                    String lugar = rs.getString("lugar");
                    String fechaCierre = rs.getString("fecha_cierre");
        %>
                    <div class="oferta-card">
                        <h3><%= titulo %> - <%= empresa %></h3>
                        <p><strong>Descripción:</strong> <%= descripcion != null && descripcion.length() > 150 ? descripcion.substring(0, 150) + "..." : descripcion %></p>
                        <p>
                            <span class="badge">💰 <%= rangoSalarial != null ? rangoSalarial : "No especificado" %></span>
                            <span class="badge">📍 <%= modalidad != null ? modalidad : "Presencial" %></span>
                            <span class="badge">🏢 <%= sector != null ? sector : "General" %></span>
                            <span class="badge">🌆 <%= lugar != null ? lugar : "No especificado" %></span>
                            <span class="badge activa">📅 Cierre: <%= fechaCierre != null ? fechaCierre : "Sin fecha" %></span>
                        </p>
                        <br>
                        <a href="oferta_detalle.jsp?id=<%= idOferta %>" class="btn-detalle">📖 Ver Detalle</a>
                        <% if (!esAdmin) { %>
                            <a href="postular?id_oferta=<%= idOferta %>" class="btn-postular">📨 Postularme</a>
                        <% } %>
                    </div>
        <%
                }
                if (!hayOfertas) {
                    out.println("<p style='color:#a0aec0; text-align:center; padding:40px;'>No hay ofertas laborales disponibles en este momento.</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>