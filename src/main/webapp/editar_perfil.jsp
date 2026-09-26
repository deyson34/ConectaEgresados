<%-- 
    Document   : editar_perfil
    Created on : 25 set. 2026, 8:56:25 p. m.
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Perfil - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .tabs { display: flex; border-bottom: 2px solid #e2e8f0; margin-bottom: 25px; flex-wrap: wrap; }
        .tab-btn { padding: 12px 20px; background: none; border: none; cursor: pointer; font-size: 14px; font-weight: 600; color: #718096; border-bottom: 3px solid transparent; margin-bottom: -2px; transition: all 0.2s; }
        .tab-btn:hover { color: #667eea; }
        .tab-btn.active { color: #667eea; border-bottom-color: #667eea; }
        .tab-content { display: none; }
        .tab-content.active { display: block; animation: fadeIn 0.3s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .item-list { margin-top: 15px; }
        .item { background: #f7fafc; padding: 12px 15px; border-radius: 8px; margin-bottom: 10px; border-left: 3px solid #667eea; }
        .item small { color: #718096; }
    </style>
</head>
<body style="background:#f7fafc;">
<jsp:include page="sidebar.jsp" />
<div class="content">
    <h1>✏️ Editar Mi Perfil</h1>
    
    <% 
        String mensaje = (String) session.getAttribute("mensaje");
        if (mensaje != null) {
            session.removeAttribute("mensaje");
    %>
        <div class="alert success" style="padding: 12px; background: #d1fae5; color: #065f46; border-radius: 6px; margin-bottom: 20px;"><%= mensaje %></div>
    <% } %>
    
    <!-- PESTAÑAS -->
    <div class="tabs">
        <button class="tab-btn active" onclick="openTab(event, 'datos')">👤 Datos Personales</button>
        <button class="tab-btn" onclick="openTab(event, 'academica')">📜 Académica</button>
        <button class="tab-btn" onclick="openTab(event, 'laboral')">💼 Laboral</button>
        <button class="tab-btn" onclick="openTab(event, 'habilidades')">⚡ Habilidades</button>
    </div>
    
    <!-- PESTAÑA 1: DATOS PERSONALES -->
    <div id="datos" class="tab-content active">
        <div class="card">
            <h3>👤 Información Básica</h3>
            <form action="editar_perfil" method="POST">
                <div class="form-group">
                    <label>📱 Teléfono:</label>
                    <input type="text" name="telefono" value="<%= usuario.getTelefono() != null ? usuario.getTelefono() : "" %>">
                </div>
                <div class="form-group">
                    <label>📍 Ciudad / País:</label>
                    <input type="text" name="ciudad_pais" value="<%= usuario.getCiudadPais() != null ? usuario.getCiudadPais() : "" %>">
                </div>
                <div class="form-group">
                    <label>🎓 Carrera:</label>
                    <input type="text" name="carrera" placeholder="Ej: Ingeniería de Sistemas">
                </div>
                <div class="form-group">
                    <label>📅 Año de egreso:</label>
                    <input type="number" name="anio_egreso" min="1950" max="2030" placeholder="Ej: 2022">
                </div>
                <div class="form-group">
                    <label>🔗 LinkedIn (URL):</label>
                    <input type="url" name="linkedin" placeholder="https://linkedin.com/in/tu-perfil">
                </div>
                <div class="form-group">
                    <label>📝 Biografía:</label>
                    <textarea name="biografia" rows="4" placeholder="Cuéntanos sobre ti..."></textarea>
                </div>
                <button type="submit" class="btn btn-success">💾 Guardar Cambios</button>
            </form>
        </div>
    </div>
    
    <!-- PESTAÑA 2: INFORMACIÓN ACADÉMICA -->
    <div id="academica" class="tab-content">
        <div class="card">
            <h3>📜 Agregar Título / Grado</h3>
            <form action="perfil_detalle" method="POST">
                <input type="hidden" name="tipo" value="academica">
                <div class="form-group">
                    <label>Grado / Título obtenido:</label>
                    <input type="text" name="grado" required placeholder="Ej: Bachiller en Ingeniería de Sistemas">
                </div>
                <div class="form-group">
                    <label>Institución:</label>
                    <input type="text" name="institucion" required placeholder="Ej: Universidad de la Vida">
                </div>
                <div class="form-group">
                    <label>Año de graduación:</label>
                    <input type="number" name="anio_graduacion" min="1950" max="2030" required>
                </div>
                <button type="submit" class="btn btn-primary">➕ Agregar</button>
            </form>
            
            <div class="item-list">
                <h4 style="margin-top:20px; color:#4a5568;">📋 Registrados:</h4>
                <% 
                    try (java.sql.Connection conn = com.conectaegresados.dao.DatabaseConnection.getConnection();
                         java.sql.PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT grado_obtenido, institucion, anio_graduacion FROM informacion_academica WHERE id_usuario = ? ORDER BY anio_graduacion DESC")) {
                        pstmt.setInt(1, usuario.getIdUsuario());
                        java.sql.ResultSet rs = pstmt.executeQuery();
                        boolean hay = false;
                        while (rs.next()) {
                            hay = true;
                %>
                <div class="item">
                    <strong><%= rs.getString("grado_obtenido") %></strong><br>
                    <small><%= rs.getString("institucion") %> · <%= rs.getInt("anio_graduacion") %></small>
                </div>
                <%
                        }
                        if (!hay) out.println("<p style='color:#a0aec0;'>No hay registros aún.</p>");
                    } catch (Exception e) { out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>"); }
                %>
            </div>
        </div>
    </div>
    
    <!-- PESTAÑA 3: EXPERIENCIA LABORAL -->
    <div id="laboral" class="tab-content">
        <div class="card">
            <h3>💼 Agregar Experiencia Laboral</h3>
            <form action="perfil_detalle" method="POST">
                <input type="hidden" name="tipo" value="laboral">
                <div class="form-group">
                    <label>Empresa:</label>
                    <input type="text" name="empresa" required>
                </div>
                <div class="form-group">
                    <label>Cargo:</label>
                    <input type="text" name="cargo" required>
                </div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px;">
                    <div class="form-group">
                        <label>Fecha inicio:</label>
                        <input type="date" name="fecha_inicio">
                    </div>
                    <div class="form-group">
                        <label>Fecha fin:</label>
                        <input type="date" name="fecha_fin">
                    </div>
                </div>
                <div class="form-group">
                    <label>Sector:</label>
                    <input type="text" name="sector" placeholder="Ej: Tecnología, Educación...">
                </div>
                <div class="form-group" style="display:flex; align-items:center; gap:10px;">
                    <input type="checkbox" name="es_actual" value="1" style="width:auto;">
                    <label style="margin:0;">Es mi trabajo actual</label>
                </div>
                <button type="submit" class="btn btn-success">➕ Agregar</button>
            </form>
            
            <div class="item-list">
                <h4 style="margin-top:20px; color:#4a5568;">📋 Registrados:</h4>
                <% 
                    try (java.sql.Connection conn = com.conectaegresados.dao.DatabaseConnection.getConnection();
                         java.sql.PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT empresa, cargo, fecha_inicio, fecha_fin, es_actual, sector FROM experiencia_laboral WHERE id_usuario = ? ORDER BY fecha_inicio DESC")) {
                        pstmt.setInt(1, usuario.getIdUsuario());
                        java.sql.ResultSet rs = pstmt.executeQuery();
                        boolean hay = false;
                        while (rs.next()) {
                            hay = true;
                %>
                <div class="item">
                    <strong><%= rs.getString("cargo") %></strong> en <%= rs.getString("empresa") %>
                    <% if (rs.getBoolean("es_actual")) { %><span class="badge activo">Actual</span><% } %><br>
                    <small><%= rs.getString("fecha_inicio") %> - <%= rs.getString("fecha_fin") != null ? rs.getString("fecha_fin") : "Presente" %> · <%= rs.getString("sector") != null ? rs.getString("sector") : "—" %></small>
                </div>
                <%
                        }
                        if (!hay) out.println("<p style='color:#a0aec0;'>No hay registros aún.</p>");
                    } catch (Exception e) { out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>"); }
                %>
            </div>
        </div>
    </div>
    
    <!-- PESTAÑA 4: HABILIDADES -->
    <div id="habilidades" class="tab-content">
        <div class="card">
            <h3>⚡ Agregar Habilidad</h3>
            <form action="perfil_detalle" method="POST">
                <input type="hidden" name="tipo" value="habilidad">
                <div style="display:grid; grid-template-columns:2fr 1fr 1fr; gap:15px;">
                    <div class="form-group">
                        <label>Habilidad:</label>
                        <input type="text" name="habilidad" required placeholder="Ej: Java, Python, Liderazgo...">
                    </div>
                    <div class="form-group">
                        <label>Tipo:</label>
                        <select name="tipo_habilidad">
                            <option value="Técnica">Técnica</option>
                            <option value="Blanda">Blanda</option>
                            <option value="Idioma">Idioma</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Nivel (1-100):</label>
                        <input type="number" name="nivel" min="1" max="100" value="70">
                    </div>
                </div>
                <button type="submit" class="btn btn-purple">➕ Agregar</button>
            </form>
            
            <div class="item-list">
                <h4 style="margin-top:20px; color:#4a5568;">📋 Registradas:</h4>
                <% 
                    try (java.sql.Connection conn = com.conectaegresados.dao.DatabaseConnection.getConnection();
                         java.sql.PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT ch.nombre_habilidad, ch.tipo, he.nivel_dominio " +
                            "FROM habilidad_egresado he JOIN catalogo_habilidad ch ON he.id_habilidad = ch.id_habilidad " +
                            "WHERE he.id_usuario = ?")) {
                        pstmt.setInt(1, usuario.getIdUsuario());
                        java.sql.ResultSet rs = pstmt.executeQuery();
                        boolean hay = false;
                        while (rs.next()) {
                            hay = true;
                %>
                <span class="badge" style="margin-bottom:8px; font-size:13px;"><%= rs.getString("nombre_habilidad") %> · <%= rs.getString("tipo") %> · <%= rs.getInt("nivel_dominio") %>%</span>
                <%
                        }
                        if (!hay) out.println("<p style='color:#a0aec0;'>No hay habilidades registradas aún.</p>");
                    } catch (Exception e) { out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>"); }
                %>
            </div>
        </div>
    </div>
    
    <a href="perfil.jsp" style="display:inline-block; margin-top:20px; color:#718096;">← Volver a ver mi perfil</a>
</div>

<script>
function openTab(evt, tabName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tab-content");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].className = tabcontent[i].className.replace(" active", "");
    }
    tablinks = document.getElementsByClassName("tab-btn");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(tabName).className += " active";
    evt.currentTarget.className += " active";
}
</script>
</body>
</html>