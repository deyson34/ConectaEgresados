<%-- 
    Document   : mis_cursos
    Created on : 25 set. 2026, 9:53:55 p. m.
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
    <title>Mis Cursos - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 900px; margin: 30px auto; padding: 20px; }
        .menu { background: #2d3748; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 20px; }
        .curso-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-left: 4px solid #48bb78; }
        .progreso-bar { background: #edf2f7; height: 20px; border-radius: 10px; overflow: hidden; margin-top: 10px; }
        .progreso-fill { background: linear-gradient(90deg, #48bb78, #68d391); height: 100%; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="menu">
        <a href="dashboard.jsp">🏠 Inicio</a>
        <a href="perfil.jsp">👤 Mi Perfil</a>
        <a href="cursos.jsp">📚 Cursos</a>
        <a href="mis_cursos.jsp">📝 Mis Cursos</a>
        <a href="ofertas.jsp">💼 Ofertas</a>
        <a href="logout" style="float:right; color:#fc8181;">🚪 Cerrar Sesión</a>
    </div>
    
    <div class="container">
        <h1 style="color:#2d3748; margin-bottom:20px;">📝 Mis Cursos Inscritos</h1>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT c.titulo, c.descripcion, i.estado, i.progreso, i.fecha_inscripcion " +
                    "FROM inscripcion i JOIN curso c ON i.id_curso = c.id_curso " +
                    "WHERE i.id_usuario = ? ORDER BY i.fecha_inscripcion DESC")) {
                pstmt.setInt(1, idUsuario);
                ResultSet rs = pstmt.executeQuery();
                boolean hayCursos = false;
                while (rs.next()) {
                    hayCursos = true;
                    String titulo = rs.getString("titulo");
                    String estado = rs.getString("estado");
                    int progreso = rs.getInt("progreso");
                    String fechaInsc = rs.getString("fecha_inscripcion");
        %>
                    <div class="curso-card">
                        <h3 style="color:#2d3748;"><%= titulo %></h3>
                        <p style="color:#718096; font-size:14px;">Inscrito el: <%= fechaInsc %></p>
                        <p><strong>Estado:</strong> 
                            <span style="color: <%= estado.equals("finalizado") ? "#48bb78" : "#ed8936" %>;">
                                <%= estado.toUpperCase() %>
                            </span>
                        </p>
                        <p><strong>Progreso:</strong> <%= progreso %>%</p>
                        <div class="progreso-bar">
                            <div class="progreso-fill" style="width: <%= progreso %>%;"></div>
                        </div>
                    </div>
        <%
                }
                if (!hayCursos) {
                    out.println("<p style='color:#a0aec0; text-align:center; padding:40px;'>Aún no estás inscrito en ningún curso. <a href='cursos.jsp'>Ver cursos disponibles</a></p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>