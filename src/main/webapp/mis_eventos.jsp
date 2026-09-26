<%-- 
    Document   : mis_eventos
    Created on : 25 set. 2026, 10:27:58 p. m.
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
    <title>Mis Eventos - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 900px; margin: 30px auto; padding: 20px; }
        .menu { background: #2d3748; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 20px; }
        .evento-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 4px solid #38b2ac; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="menu">
        <a href="dashboard.jsp">🏠 Inicio</a>
        <a href="perfil.jsp">👤 Mi Perfil</a>
        <a href="cursos.jsp">📚 Cursos</a>
        <a href="ofertas.jsp">💼 Ofertas</a>
        <a href="eventos.jsp">📅 Eventos</a>
        <a href="mis_eventos.jsp">🎫 Mis Eventos</a>
        <a href="foro.jsp">💬 Foro</a>
        <a href="logout" style="float:right; color:#fc8181;">🚪 Cerrar Sesión</a>
    </div>
    
    <div class="container">
        <h1 style="color:#2d3748; margin-bottom:20px;">🎫 Eventos a los que estoy registrado</h1>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT e.titulo, e.fecha_hora, e.lugar, e.modalidad, a.confirmado, a.fecha_registro " +
                    "FROM asistencia a JOIN evento e ON a.id_evento = e.id_evento " +
                    "WHERE a.id_usuario = ? ORDER BY e.fecha_hora DESC")) {
                pstmt.setInt(1, idUsuario);
                ResultSet rs = pstmt.executeQuery();
                boolean hayEventos = false;
                while (rs.next()) {
                    hayEventos = true;
                    String titulo = rs.getString("titulo");
                    String fechaHora = rs.getString("fecha_hora");
                    String lugar = rs.getString("lugar");
                    String modalidad = rs.getString("modalidad");
                    boolean confirmado = rs.getBoolean("confirmado");
        %>
                    <div class="evento-card">
                        <h3 style="color:#2d3748;"><%= titulo %></h3>
                        <p style="color:#718096; font-size:14px;">📅 <%= fechaHora %> | 📍 <%= modalidad %> | 🏛️ <%= lugar != null ? lugar : "Por definir" %></p>
                        <p><strong>Estado:</strong> 
                            <% if (confirmado) { %>
                                <span style="color:#48bb78;">✅ Asistencia confirmada</span>
                            <% } else { %>
                                <span style="color:#ed8936;">⏳ Pendiente de confirmación</span>
                            <% } %>
                        </p>
                    </div>
        <%
                }
                if (!hayEventos) {
                    out.println("<p style='color:#a0aec0; text-align:center; padding:40px;'>Aún no estás registrado en ningún evento. <a href='eventos.jsp'>Ver eventos disponibles</a></p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>