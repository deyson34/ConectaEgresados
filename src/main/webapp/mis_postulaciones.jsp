<%-- 
    Document   : mis_postulaciones
    Created on : 25 set. 2026, 10:10:16 p. m.
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
    int idUsuario = usuario.getIdUsuario();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mis Postulaciones - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 900px; margin: 30px auto; padding: 20px; }
        .menu { background: #2d3748; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 20px; }
        .postulacion-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 4px solid #ed8936; }
    </style>
</head>
<body style="background:#f7fafc;">
    <jsp:include page="sidebar.jsp" />
    
    <div class="container">
        <h1 style="color:#2d3748; margin-bottom:20px;">📨 Mis Postulaciones Laborales</h1>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT o.titulo, o.empresa, p.estado, p.fecha_postulacion " +
                    "FROM postulacion p JOIN oferta_laboral o ON p.id_oferta = o.id_oferta " +
                    "WHERE p.id_usuario = ? ORDER BY p.fecha_postulacion DESC")) {
                pstmt.setInt(1, idUsuario);
                ResultSet rs = pstmt.executeQuery();
                boolean hayPostulaciones = false;
                while (rs.next()) {
                    hayPostulaciones = true;
                    String titulo = rs.getString("titulo");
                    String empresa = rs.getString("empresa");
                    String estado = rs.getString("estado");
                    String fechaPost = rs.getString("fecha_postulacion");
        %>
                    <div class="postulacion-card">
                        <h3 style="color:#2d3748;"><%= titulo %> - <%= empresa %></h3>
                        <p style="color:#718096; font-size:14px;">Postulado el: <%= fechaPost %></p>
                        <p><strong>Estado:</strong> 
                            <span style="color: <%= estado.equals("aceptado") ? "#48bb78" : estado.equals("rechazado") ? "#f56565" : "#ed8936" %>;">
                                <%= estado.toUpperCase() %>
                            </span>
                        </p>
                    </div>
        <%
                }
                if (!hayPostulaciones) {
                    out.println("<p style='color:#a0aec0; text-align:center; padding:40px;'>Aún no te has postulado a ninguna oferta. <a href='ofertas.jsp'>Ver ofertas disponibles</a></p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>