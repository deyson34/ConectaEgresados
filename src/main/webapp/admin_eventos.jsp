<%-- 
    Document   : admin_eventos
    Created on : 26 set. 2026, 12:04:19 a. m.
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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestionar Eventos - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1100px; margin: 30px auto; padding: 20px; }
        .menu { background: #1a202c; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 18px; }
        .btn-volver { display: inline-block; margin-bottom: 20px; color: #718096; text-decoration: none; }
        .form-card { background: white; padding: 25px; border-radius: 12px; margin-bottom: 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.1); }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        input, select, textarea { width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 6px; margin-top: 5px; }
        .btn-guardar { background: #38b2ac; color: white; padding: 12px 25px; border: none; border-radius: 8px; cursor: pointer; font-size: 15px; margin-top: 10px; }
        .btn-guardar:hover { background: #319795; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background: #38b2ac; color: white; }
        .btn-accion { padding: 5px 10px; border: none; border-radius: 4px; text-decoration: none; font-size: 12px; margin-right: 5px; }
        .btn-eliminar { background: #f56565; color: white; }
        .badge { padding: 3px 8px; border-radius: 10px; font-size: 11px; }
        .virtual { background: #bee3f8; color: #2c5282; }
        .presencial { background: #c6f6d5; color: #22543d; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="menu">
        <a href="dashboard.jsp">🏠 Inicio</a>
        <a href="admin_usuarios.jsp">👥 Usuarios</a>
        <a href="admin_cursos.jsp">📚 Cursos</a>
        <a href="admin_ofertas.jsp">💼 Ofertas</a>
        <a href="admin_eventos.jsp">📅 Eventos</a>
        <a href="admin_reportes.jsp">📊 Reportes</a>
        <a href="logout" style="float:right; color:#fc8181;">🚪 Cerrar Sesión</a>
    </div>
    
    <div class="container">
        <a href="dashboard.jsp" class="btn-volver">← Volver al Inicio</a>
        <h1 style="color:#2d3748; margin-bottom:20px;">📅 Gestionar Eventos</h1>
        
        <% if (session.getAttribute("mensaje") != null) { %>
            <div style="padding:12px; background:#d1fae5; color:#065f46; border-radius:8px; margin-bottom:20px;">
                <%= session.getAttribute("mensaje") %>
                <% session.removeAttribute("mensaje"); %>
            </div>
        <% } %>
        
        <!-- Formulario Crear Evento -->
        <div class="form-card">
            <h3 style="margin-bottom:15px;">➕ Crear Nuevo Evento</h3>
            <form action="gestionar_evento" method="POST">
                <input type="hidden" name="accion" value="crear">
                <div class="form-row">
                    <div>
                        <label>Título del Evento:</label>
                        <input type="text" name="titulo" required placeholder="Ej: Feria de Empleo 2026">
                    </div>
                    <div>
                        <label>Modalidad:</label>
                        <select name="modalidad">
                            <option value="Presencial">Presencial</option>
                            <option value="Virtual">Virtual</option>
                            <option value="Híbrido">Híbrido</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div>
                        <label>Fecha y Hora:</label>
                        <input type="datetime-local" name="fecha_hora" required>
                    </div>
                    <div>
                        <label>Cupo Máximo:</label>
                        <input type="number" name="cupo" value="100">
                    </div>
                </div>
                <div>
                    <label>Lugar / Enlace:</label>
                    <input type="text" name="lugar" placeholder="Dirección o link de Zoom">
                </div>
                <div>
                    <label>Descripción:</label>
                    <textarea name="descripcion" rows="3" placeholder="De qué trata el evento..."></textarea>
                </div>
                <button type="submit" class="btn-guardar">📅 Crear Evento</button>
            </form>
        </div>
        
        <!-- Lista de Eventos -->
        <h3 style="margin:25px 0 15px;">📋 Eventos Programados</h3>
        <table>
            <tr>
                <th>Título</th>
                <th>Fecha y Hora</th>
                <th>Modalidad</th>
                <th>Asistentes</th>
                <th>Acciones</th>
            </tr>
            <%
                try (Connection conn = DatabaseConnection.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery(
                        "SELECT e.*, (SELECT COUNT(*) FROM asistencia WHERE id_evento = e.id_evento) as total_asistentes " +
                        "FROM evento e ORDER BY e.fecha_hora DESC")) {
                    
                    while (rs.next()) {
                        int id = rs.getInt("id_evento");
                        String titulo = rs.getString("titulo");
                        String fechaHora = rs.getString("fecha_hora");
                        String modalidad = rs.getString("modalidad") != null ? rs.getString("modalidad") : "Presencial";
                        int asistentes = rs.getInt("total_asistentes");
            %>
            <tr>
                <td><strong><%= titulo %></strong></td>
                <td><%= fechaHora %></td>
                <td>
                    <span class="badge <%= modalidad.equalsIgnoreCase("Virtual") ? "virtual" : "presencial" %>">
                        <%= modalidad %>
                    </span>
                </td>
                <td><%= asistentes %> registrados</td>
                <td>
                    <a href="gestionar_evento?accion=eliminar&id=<%= id %>" class="btn-accion btn-eliminar" onclick="return confirm('¿Eliminar este evento?')">Eliminar</a>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>
</body>
</html>