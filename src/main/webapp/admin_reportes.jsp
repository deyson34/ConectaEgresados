<%-- 
    Document   : admin_reportes
    Created on : 26 set. 2026, 12:06:05 a. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
<%@page import="java.sql.*"%>
<%@page import="com.conectaegresados.dao.DatabaseConnection"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || usuario.getIdRol() != 1) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Estadísticas generales
    int totalUsuarios = 0, totalEgresados = 0, totalAdmins = 0;
    int totalCursos = 0, totalInscripciones = 0;
    int totalOfertas = 0, totalPostulaciones = 0;
    int totalEventos = 0, totalAsistencias = 0;
    int totalPublicaciones = 0, totalRespuestas = 0;
    
    try (Connection conn = DatabaseConnection.getConnection();
         Statement stmt = conn.createStatement()) {
        
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM usuario");
        if (rs.next()) totalUsuarios = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM usuario WHERE id_rol = 2");
        if (rs.next()) totalEgresados = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM usuario WHERE id_rol = 1");
        if (rs.next()) totalAdmins = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM curso");
        if (rs.next()) totalCursos = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM inscripcion");
        if (rs.next()) totalInscripciones = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM oferta_laboral");
        if (rs.next()) totalOfertas = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM postulacion");
        if (rs.next()) totalPostulaciones = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM evento");
        if (rs.next()) totalEventos = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM asistencia");
        if (rs.next()) totalAsistencias = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM publicacion_foro WHERE id_padre IS NULL");
        if (rs.next()) totalPublicaciones = rs.getInt(1);
        
        rs = stmt.executeQuery("SELECT COUNT(*) FROM publicacion_foro WHERE id_padre IS NOT NULL");
        if (rs.next()) totalRespuestas = rs.getInt(1);
        
    } catch (Exception e) { }
    
    // Función para calcular porcentaje de barra
    int maxValor = Math.max(Math.max(totalEgresados, totalInscripciones), Math.max(totalPostulaciones, totalAsistencias));
    if (maxValor == 0) maxValor = 1;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reportes y Estadísticas - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1100px; margin: 30px auto; padding: 20px; }
        .menu { background: #1a202c; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 18px; }
        .btn-volver { display: inline-block; margin-bottom: 20px; color: #718096; text-decoration: none; }
        .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .stat-card h2 { font-size: 32px; margin: 5px 0; color: #667eea; }
        .stat-card p { color: #718096; font-size: 13px; margin: 0; }
        .report-card { background: white; padding: 25px; border-radius: 12px; margin-bottom: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .report-card h3 { color: #2d3748; margin-bottom: 20px; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        .bar-row { display: flex; align-items: center; margin-bottom: 12px; }
        .bar-label { width: 180px; font-size: 14px; color: #4a5568; }
        .bar-container { flex: 1; background: #edf2f7; height: 28px; border-radius: 14px; overflow: hidden; margin: 0 15px; }
        .bar-fill { height: 100%; border-radius: 14px; display: flex; align-items: center; padding-left: 10px; color: white; font-size: 12px; font-weight: bold; transition: width 1s; }
        .bar-count { width: 60px; text-align: right; font-weight: bold; color: #2d3748; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px 12px; text-align: left; border-bottom: 1px solid #e2e8f0; font-size: 14px; }
        th { background: #f7fafc; color: #4a5568; }
        .btn-exportar { background: #9f7aea; color: white; padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; margin-bottom: 20px; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="menu">
        <a href="admin_dashboard.jsp">⚙️ Panel Admin</a>
        <a href="admin_usuarios.jsp">👥 Usuarios</a>
        <a href="admin_cursos.jsp">📚 Cursos</a>
        <a href="admin_ofertas.jsp">💼 Ofertas</a>
        <a href="admin_eventos.jsp">📅 Eventos</a>
        <a href="admin_reportes.jsp">📊 Reportes</a>
        <a href="logout" style="float:right; color:#fc8181;">🚪 Cerrar Sesión</a>
    </div>
    
    <div class="container">
        <a href="admin_dashboard.jsp" class="btn-volver">← Volver al Panel</a>
        <h1 style="color:#2d3748; margin-bottom:25px;">📊 Reportes y Estadísticas del Sistema</h1>
        
        <!-- Tarjetas de estadísticas generales -->
        <div class="stat-grid">
            <div class="stat-card">
                <div style="font-size:28px;">👥</div>
                <h2><%= totalUsuarios %></h2>
                <p>Usuarios Totales</p>
            </div>
            <div class="stat-card">
                <div style="font-size:28px;">📚</div>
                <h2><%= totalCursos %></h2>
                <p>Cursos Creados</p>
            </div>
            <div class="stat-card">
                <div style="font-size:28px;">💼</div>
                <h2><%= totalOfertas %></h2>
                <p>Ofertas Laborales</p>
            </div>
            <div class="stat-card">
                <div style="font-size:28px;">📅</div>
                <h2><%= totalEventos %></h2>
                <p>Eventos Programados</p>
            </div>
        </div>
        
        <!-- Gráfico de barras: Participación -->
        <div class="report-card">
            <h3>📈 Participación General</h3>
            
            <div class="bar-row">
                <div class="bar-label">👨‍🎓 Egresados</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: <%= (totalEgresados * 100 / maxValor) %>%; background: linear-gradient(90deg, #667eea, #764ba2);">
                        <%= totalEgresados > 0 ? totalEgresados : "" %>
                    </div>
                </div>
                <div class="bar-count"><%= totalEgresados %></div>
            </div>
            
            <div class="bar-row">
                <div class="bar-label">📝 Inscripciones a Cursos</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: <%= (totalInscripciones * 100 / maxValor) %>%; background: linear-gradient(90deg, #48bb78, #38a169);">
                        <%= totalInscripciones > 0 ? totalInscripciones : "" %>
                    </div>
                </div>
                <div class="bar-count"><%= totalInscripciones %></div>
            </div>
            
            <div class="bar-row">
                <div class="bar-label">📨 Postulaciones Laborales</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: <%= (totalPostulaciones * 100 / maxValor) %>%; background: linear-gradient(90deg, #ed8936, #dd6b20);">
                        <%= totalPostulaciones > 0 ? totalPostulaciones : "" %>
                    </div>
                </div>
                <div class="bar-count"><%= totalPostulaciones %></div>
            </div>
            
            <div class="bar-row">
                <div class="bar-label">🎫 Asistencias a Eventos</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: <%= (totalAsistencias * 100 / maxValor) %>%; background: linear-gradient(90deg, #38b2ac, #319795);">
                        <%= totalAsistencias > 0 ? totalAsistencias : "" %>
                    </div>
                </div>
                <div class="bar-count"><%= totalAsistencias %></div>
            </div>
            
            <div class="bar-row">
                <div class="bar-label">💬 Publicaciones en Foro</div>
                <div class="bar-container">
                    <div class="bar-fill" style="width: <%= (totalPublicaciones * 100 / maxValor) %>%; background: linear-gradient(90deg, #9f7aea, #805ad5);">
                        <%= totalPublicaciones > 0 ? totalPublicaciones : "" %>
                    </div>
                </div>
                <div class="bar-count"><%= totalPublicaciones %></div>
            </div>
        </div>
        
        <!-- Tabla: Últimos usuarios registrados -->
        <div class="report-card">
            <h3>👥 Últimos Egresados Registrados</h3>
            <table>
                <tr>
                    <th>Nombre Completo</th>
                    <th>Correo</th>
                    <th>Ciudad</th>
                    <th>Fecha de Registro</th>
                </tr>
                <%
                    try (Connection conn = DatabaseConnection.getConnection();
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery(
                            "SELECT nombres, apellidos, correo, ciudad_pais, fecha_registro " +
                            "FROM usuario WHERE id_rol = 2 ORDER BY fecha_registro DESC LIMIT 10")) {
                        
                        boolean hayDatos = false;
                        while (rs.next()) {
                            hayDatos = true;
                            String nombre = rs.getString("nombres") + " " + rs.getString("apellidos");
                            String correo = rs.getString("correo");
                            String ciudad = rs.getString("ciudad_pais") != null ? rs.getString("ciudad_pais") : "—";
                            String fecha = rs.getString("fecha_registro");
                %>
                <tr>
                    <td><%= nombre %></td>
                    <td><%= correo %></td>
                    <td><%= ciudad %></td>
                    <td><%= fecha %></td>
                </tr>
                <%
                        }
                        if (!hayDatos) {
                            out.println("<tr><td colspan='4' style='color:#a0aec0; text-align:center;'>No hay egresados registrados aún</td></tr>");
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='4' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </table>
        </div>
        
        <!-- Tabla: Cursos más populares -->
        <div class="report-card">
            <h3>📚 Cursos con Más Inscripciones</h3>
            <table>
                <tr>
                    <th>Curso</th>
                    <th>Instructor</th>
                    <th>Inscritos</th>
                    <th>Estado</th>
                </tr>
                <%
                    try (Connection conn = DatabaseConnection.getConnection();
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery(
                            "SELECT c.titulo, c.instructor, c.estado, COUNT(i.id_inscripcion) as inscritos " +
                            "FROM curso c LEFT JOIN inscripcion i ON c.id_curso = i.id_curso " +
                            "GROUP BY c.id_curso ORDER BY inscritos DESC LIMIT 5")) {
                        
                        boolean hayDatos = false;
                        while (rs.next()) {
                            hayDatos = true;
                            String titulo = rs.getString("titulo");
                            String instructor = rs.getString("instructor") != null ? rs.getString("instructor") : "—";
                            int inscritos = rs.getInt("inscritos");
                            String estado = rs.getString("estado");
                %>
                <tr>
                    <td><strong><%= titulo %></strong></td>
                    <td><%= instructor %></td>
                    <td><%= inscritos %> alumnos</td>
                    <td><span style="color: <%= "activo".equals(estado) ? "#48bb78" : "#f56565" %>;"><%= estado %></span></td>
                </tr>
                <%
                        }
                        if (!hayDatos) {
                            out.println("<tr><td colspan='4' style='color:#a0aec0; text-align:center;'>No hay cursos creados</td></tr>");
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='4' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </table>
        </div>
        
        <!-- Resumen del foro -->
        <div class="report-card">
            <h3>💬 Actividad del Foro</h3>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div style="text-align: center; padding: 20px; background: #f7fafc; border-radius: 10px;">
                    <h2 style="color: #9f7aea; font-size: 36px; margin: 0;"><%= totalPublicaciones %></h2>
                    <p style="color: #718096; margin: 5px 0 0 0;">Publicaciones (Hilos)</p>
                </div>
                <div style="text-align: center; padding: 20px; background: #f7fafc; border-radius: 10px;">
                    <h2 style="color: #667eea; font-size: 36px; margin: 0;"><%= totalRespuestas %></h2>
                    <p style="color: #718096; margin: 5px 0 0 0;">Respuestas / Comentarios</p>
                </div>
            </div>
        </div>
        
        <!-- Botón para imprimir/exportar -->
        <div style="text-align: center; margin-top: 30px;">
            <button onclick="window.print()" class="btn-exportar">🖨️ Imprimir / Exportar Reporte</button>
        </div>
    </div>
</body>
</html>