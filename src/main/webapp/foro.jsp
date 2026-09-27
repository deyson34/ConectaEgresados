<%-- 
    Document   : foro
    Created on : 25 set. 2026, 10:41:06 p. m.
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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Foro - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    
    <!-- Estilos locales SOLO para lo específico del foro -->
    <style>
        .foro-publicacion {
            border-left: 4px solid #10b981;
        }
        .foro-titulo {
            color: #ffffff;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .foro-contenido {
            color: #cbd5e1;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .foro-meta {
            font-size: 12px;
            color: #94a3b8;
            margin-bottom: 12px;
        }
        .foro-btn-nuevo {
            background: #10b981;
            color: #052e26;
            padding: 10px 22px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 25px;
            transition: background 0.2s, transform 0.2s;
        }
        .foro-btn-nuevo:hover {
            background: #d1fae5;
            transform: translateY(-1px);
            text-decoration: none;
        }
        .foro-btn-ver {
            background: rgba(255,255,255,0.08);
            color: #ffffff;
            border: 1px solid rgba(255,255,255,0.25);
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: background 0.2s;
        }
        .foro-btn-ver:hover {
            background: rgba(255,255,255,0.16);
            text-decoration: none;
            color: #ffffff;
        }
        .foro-vacio {
            text-align: center;
            color: #94a3b8;
            padding: 40px 20px;
            font-size: 15px;
        }
    </style>
</head>
<body class="body">
    <jsp:include page="sidebar.jsp" />
    
    <div class="content">
        <!-- Título estilo welcome (usa tus clases globales) -->
        <div class="dir-greeting">Comunidad</div>
        <h1 class="dir-titulo">Foro de Experiencias</h1>
        <p style="color:#cbd5e1; margin-bottom:25px; font-size:15px;">Comparte tus experiencias, consejos y casos de éxito con otros egresados</p>
        
        <a href="nueva_publicacion.jsp" class="foro-btn-nuevo">✏️ Nueva Publicación</a>
        
        <%
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(
                    "SELECT p.*, u.nombres, u.apellidos FROM publicacion_foro p " +
                    "JOIN usuario u ON p.id_usuario = u.id_usuario " +
                    "WHERE p.id_padre IS NULL " +
                    "ORDER BY p.fecha_publicacion DESC")) {
                
                boolean hayPublicaciones = false;
                while (rs.next()) {
                    hayPublicaciones = true;
                    int idPublicacion = rs.getInt("id_publicacion");
                    String titulo = rs.getString("titulo");
                    String contenido = rs.getString("contenido");
                    String fecha = rs.getString("fecha_publicacion");
                    int likes = rs.getInt("me_gusta");
                    String autor = rs.getString("nombres") + " " + rs.getString("apellidos");
        %>
                    <div class="card foro-publicacion">
                        <div class="foro-titulo"><%= titulo != null ? titulo : "Sin título" %></div>
                        <p class="foro-contenido"><%= contenido != null && contenido.length() > 200 ? contenido.substring(0, 200) + "..." : contenido %></p>
                        <p class="foro-meta">👤 Por: <%= autor %> &nbsp;|&nbsp; 📅 <%= fecha %> &nbsp;|&nbsp; ❤️ <%= likes %> me gusta</p>
                        <a href="hilo.jsp?id=<%= idPublicacion %>" class="foro-btn-ver">📖 Ver publicación completa</a>
                    </div>
        <%
                }
                if (!hayPublicaciones) {
                    out.println("<div class='card foro-vacio'>Aún no hay publicaciones. ¡Sé el primero en compartir tu experiencia! ✨</div>");
                }
            } catch (Exception e) {
                out.println("<div class='card foro-vacio' style='color:#fca5a5;'>❌ Error: " + e.getMessage() + "</div>");
            }
        %>
    </div>
</body>
</html>