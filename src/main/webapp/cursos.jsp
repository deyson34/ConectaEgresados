<%-- 
    Document   : cursos
    Created on : 25 set. 2026, 9:53:27 p. m.
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
    
    <!-- Estilos locales SOLO para cursos -->
    <style>
        .curso-card {
            border-left: 4px solid #10b981;
        }
        .curso-titulo {
            color: #ffffff;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .curso-desc {
            color: #cbd5e1;
            font-size: 14px;
            margin-bottom: 12px;
        }
        .curso-badge {
            background: rgba(16,185,129,0.15);
            color: #6ee7b7;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            margin-right: 6px;
            display: inline-block;
            margin-bottom: 6px;
        }
        .curso-btn-detalle {
            background: rgba(255,255,255,0.08);
            color: #ffffff;
            border: 1px solid rgba(255,255,255,0.25);
            padding: 8px 18px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
            transition: background 0.2s;
        }
        .curso-btn-detalle:hover {
            background: rgba(255,255,255,0.16);
            text-decoration: none;
            color: #ffffff;
        }
        .curso-btn-inscribir {
            background: #10b981;
            color: #052e26;
            padding: 8px 18px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: background 0.2s, transform 0.2s;
        }
        .curso-btn-inscribir:hover {
            background: #d1fae5;
            transform: translateY(-1px);
            text-decoration: none;
        }
        .curso-btn-admin {
            background: rgba(124,58,237,0.2);
            color: #c4b5fd;
            border: 1px solid rgba(124,58,237,0.4);
            padding: 10px 22px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 25px;
            transition: background 0.2s;
        }
        .curso-btn-admin:hover {
            background: rgba(124,58,237,0.35);
            text-decoration: none;
            color: #ffffff;
        }
        .curso-vacio {
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
        <!-- Título estilo welcome -->
        <div class="dir-greeting">Capacitación</div>
        <h1 class="dir-titulo">Cursos Disponibles</h1>
        <p style="color:#cbd5e1; margin-bottom:25px; font-size:15px;">Mejora tus habilidades con nuestros cursos de capacitación continua</p>
        
        <% if (esAdmin) { %>
            <a href="admin_cursos.jsp" class="curso-btn-admin">⚙️ Gestionar Cursos (Admin)</a>
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
                    <div class="card curso-card">
                        <div class="curso-titulo"><%= titulo %></div>
                        <p class="curso-desc"><strong style="color:#6ee7b7;">Descripción:</strong> <%= descripcion != null ? descripcion : "Sin descripción" %></p>
                        <div style="margin-bottom:15px;">
                            <span class="curso-badge">⏱️ <%= duracion %> horas</span>
                            <span class="curso-badge">👨‍🏫 <%= instructor != null ? instructor : "Por definir" %></span>
                            <span class="curso-badge">📅 <%= fechaInicio %> al <%= fechaFin %></span>
                            <span class="curso-badge">👥 Cupo: <%= cupo %></span>
                        </div>
                        <a href="curso_detalle.jsp?id=<%= idCurso %>" class="curso-btn-detalle">📖 Ver Detalle</a>
                        <% if (!esAdmin) { %>
                            <a href="inscripcion?id_curso=<%= idCurso %>" class="curso-btn-inscribir">✍️ Inscribirme</a>
                        <% } %>
                    </div>
        <%
                }
                if (!hayCursos) {
                    out.println("<div class='card curso-vacio'>No hay cursos disponibles en este momento. ¡Vuelve pronto! ✨</div>");
                }
            } catch (Exception e) {
                out.println("<div class='card curso-vacio' style='color:#fca5a5;'>❌ Error: " + e.getMessage() + "</div>");
            }
        %>
    </div>
</body>
</html>