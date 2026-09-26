<%-- 
    Document   : admin_ofertas
    Created on : 26 set. 2026, 12:00:33 a. m.
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
    <title>Gestionar Ofertas - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 1100px; margin: 30px auto; padding: 20px; }
        .menu { background: #1a202c; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 18px; }
        .btn-volver { display: inline-block; margin-bottom: 20px; color: #718096; text-decoration: none; }
        .form-card { background: white; padding: 25px; border-radius: 12px; margin-bottom: 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.1); }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        input, select, textarea { width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 6px; margin-top: 5px; }
        .btn-guardar { background: #ed8936; color: white; padding: 12px 25px; border: none; border-radius: 8px; cursor: pointer; font-size: 15px; margin-top: 10px; }
        .btn-guardar:hover { background: #dd6b20; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background: #ed8936; color: white; }
        .btn-accion { padding: 5px 10px; border: none; border-radius: 4px; text-decoration: none; font-size: 12px; margin-right: 5px; }
        .btn-desactivar { background: #f56565; color: white; }
        .btn-activar { background: #48bb78; color: white; }
        .badge { padding: 3px 8px; border-radius: 10px; font-size: 11px; }
        .activa { background: #c6f6d5; color: #22543d; }
        .inactiva { background: #fed7d7; color: #9b2c2c; }
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
        <h1 style="color:#2d3748; margin-bottom:20px;">💼 Gestionar Ofertas Laborales</h1>
        
        <% if (session.getAttribute("mensaje") != null) { %>
            <div style="padding:12px; background:#d1fae5; color:#065f46; border-radius:8px; margin-bottom:20px;">
                <%= session.getAttribute("mensaje") %>
                <% session.removeAttribute("mensaje"); %>
            </div>
        <% } %>
        
        <!-- Formulario Crear Oferta -->
        <div class="form-card">
            <h3 style="margin-bottom:15px;">➕ Publicar Nueva Oferta</h3>
            <form action="gestionar_oferta" method="POST">
                <input type="hidden" name="accion" value="crear">
                <div class="form-row">
                    <div>
                        <label>Título del Puesto:</label>
                        <input type="text" name="titulo" required placeholder="Ej: Ingeniero de Software">
                    </div>
                    <div>
                        <label>Empresa:</label>
                        <input type="text" name="empresa" required placeholder="Nombre de la empresa">
                    </div>
                </div>
                <div class="form-row">
                    <div>
                        <label>Área/Sector:</label>
                        <input type="text" name="sector" placeholder="Ej: Tecnología, Educación...">
                    </div>
                    <div>
                        <label>Lugar:</label>
                        <input type="text" name="lugar" placeholder="Ciudad o enlace">
                    </div>
                </div>
                <div class="form-row">
                    <div>
                        <label>Modalidad:</label>
                        <select name="modalidad">
                            <option value="Presencial">Presencial</option>
                            <option value="Remoto">Remoto</option>
                            <option value="Híbrido">Híbrido</option>
                        </select>
                    </div>
                    <div>
                        <label>Rango Salarial:</label>
                        <input type="text" name="rango_salarial" placeholder="Ej: S/ 2500 - S/ 3500">
                    </div>
                </div>
                <div>
                    <label>Descripción del Puesto:</label>
                    <textarea name="descripcion" rows="4" required placeholder="Funciones, responsabilidades..."></textarea>
                </div>
                <div>
                    <label>Requisitos:</label>
                    <textarea name="requisitos" rows="3" placeholder="Experiencia, estudios, habilidades..."></textarea>
                </div>
                <div class="form-row">
                    <div>
                        <label>Fecha de Cierre:</label>
                        <input type="date" name="fecha_cierre" required>
                    </div>
                </div>
                <button type="submit" class="btn-guardar">🚀 Publicar Oferta</button>
            </form>
        </div>
        
        <!-- Lista de Ofertas -->
        <h3 style="margin:25px 0 15px;">📋 Ofertas Publicadas</h3>
        <table>
            <tr>
                <th>Puesto</th>
                <th>Empresa</th>
                <th>Estado</th>
                <th>Postulaciones</th>
                <th>Acciones</th>
            </tr>
            <%
                try (Connection conn = DatabaseConnection.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery(
                        "SELECT o.*, (SELECT COUNT(*) FROM postulacion WHERE id_oferta = o.id_oferta) as total_postulaciones " +
                        "FROM oferta_laboral o ORDER BY fecha_publicacion DESC")) {
                    
                    while (rs.next()) {
                        int id = rs.getInt("id_oferta");
                        String titulo = rs.getString("titulo");
                        String empresa = rs.getString("empresa");
                        boolean activa = rs.getBoolean("activa");
                        int postulaciones = rs.getInt("total_postulaciones");
            %>
            <tr>
                <td><strong><%= titulo %></strong></td>
                <td><%= empresa %></td>
                <td>
                    <span class="badge <%= activa ? "activa" : "inactiva" %>">
                        <%= activa ? "✅ Activa" : "❌ Inactiva" %>
                    </span>
                </td>
                <td><%= postulaciones %> postulantes</td>
                <td>
                    <% if (activa) { %>
                        <a href="gestionar_oferta?accion=desactivar&id=<%= id %>" class="btn-accion btn-desactivar">Desactivar</a>
                    <% } else { %>
                        <a href="gestionar_oferta?accion=activar&id=<%= id %>" class="btn-accion btn-activar">Activar</a>
                    <% } %>
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