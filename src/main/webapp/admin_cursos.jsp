<%-- 
    Document   : admin_cursos
    Created on : 25 set. 2026, 11:47:43 p. m.
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
    <title>Gestionar Cursos - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1100px; margin: 30px auto; padding: 20px; }
        .menu { background: #1a202c; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 18px; }
        .btn-nuevo { background: #48bb78; color: white; padding: 10px 20px; border: none; border-radius: 8px; text-decoration: none; display: inline-block; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background: #48bb78; color: white; }
        .btn-accion { padding: 5px 10px; border: none; border-radius: 4px; text-decoration: none; font-size: 12px; margin-right: 5px; }
        .btn-editar { background: #667eea; color: white; }
        .btn-eliminar { background: #f56565; color: white; }
        .btn-volver { display: inline-block; margin-bottom: 20px; color: #718096; text-decoration: none; }
        .modal-form { background: white; padding: 25px; border-radius: 12px; margin-bottom: 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.1); }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .btn-guardar { background: #48bb78; color: white; padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; }
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
        <h1 style="color:#2d3748; margin-bottom:20px;">📚 Gestionar Cursos</h1>
        
        <% if (request.getAttribute("mensaje") != null) { %>
            <div style="padding:12px; background:#d1fae5; color:#065f46; border-radius:8px; margin-bottom:20px;">
                <%= request.getAttribute("mensaje") %>
            </div>
        <% } %>
        
        <!-- Formulario Crear Curso -->
        <div class="modal-form">
            <h3 style="margin-bottom:15px;">➕ Crear Nuevo Curso</h3>
            <form action="gestionar_curso" method="POST">
                <input type="hidden" name="accion" value="crear">
                <div class="form-row">
                    <div class="form-group">
                        <label>Título:</label>
                        <input type="text" name="titulo" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                    </div>
                    <div class="form-group">
                        <label>Instructor:</label>
                        <input type="text" name="instructor" style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Duración (horas):</label>
                        <input type="number" name="duracion" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                    </div>
                    <div class="form-group">
                        <label>Cupo máximo:</label>
                        <input type="number" name="cupo" value="50" style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Fecha de inicio:</label>
                        <input type="date" name="fecha_inicio" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                    </div>
                    <div class="form-group">
                        <label>Fecha de fin:</label>
                        <input type="date" name="fecha_fin" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;">
                    </div>
                </div>
                <div class="form-group">
                    <label>Descripción:</label>
                    <textarea name="descripcion" rows="3" style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px;"></textarea>
                </div>
                <button type="submit" class="btn-guardar">💾 Crear Curso</button>
            </form>
        </div>
        
        <!-- Lista de Cursos -->
        <table>
            <tr>
                <th>Título</th>
                <th>Instructor</th>
                <th>Fechas</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
            <%
                try (Connection conn = DatabaseConnection.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT * FROM curso ORDER BY fecha_inicio DESC")) {
                    
                    while (rs.next()) {
                        int id = rs.getInt("id_curso");
                        String titulo = rs.getString("titulo");
                        String instructor = rs.getString("instructor");
                        String fechaIni = rs.getString("fecha_inicio");
                        String fechaFin = rs.getString("fecha_fin");
                        String estado = rs.getString("estado");
            %>
            <tr>
                <td><%= titulo %></td>
                <td><%= instructor != null ? instructor : "—" %></td>
                <td><%= fechaIni %> al <%= fechaFin %></td>
                <td><strong style="color:<%= "activo".equals(estado) ? "#48bb78" : "#f56565" %>;"><%= estado %></strong></td>
                <td>
                    <a href="gestionar_curso?accion=eliminar&id=<%= id %>" class="btn-accion btn-eliminar" onclick="return confirm('¿Eliminar este curso?')">Eliminar</a>
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