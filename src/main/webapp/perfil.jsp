<%-- 
    Document   : perfil
    Created on : 25 set. 2026, 8:56:01 p. m.
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
    boolean esAdmin = (usuario.getIdRol() == 1);
    
    // Obtener datos del perfil
    String carrera = "";
    int anioEgreso = 0;
    String linkedin = "";
    String biografia = "";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(
            "SELECT carrera, anio_egreso, linkedin, biografia FROM perfil_egresado WHERE id_usuario = ?")) {
        pstmt.setInt(1, idUsuario);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            carrera = rs.getString("carrera") != null ? rs.getString("carrera") : "No especificado";
            anioEgreso = rs.getInt("anio_egreso");
            linkedin = rs.getString("linkedin") != null ? rs.getString("linkedin") : "";
            biografia = rs.getString("biografia") != null ? rs.getString("biografia") : "Sin biografía";
        }
    } catch (Exception e) {
        carrera = "Error al cargar";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mi Perfil - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container { max-width: 900px; margin: 30px auto; padding: 20px; }
        .card { background: white; padding: 25px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .card h2 { color: #4a5568; margin-bottom: 15px; border-bottom: 2px solid #667eea; padding-bottom: 8px; }
        .info-row { display: flex; margin-bottom: 10px; }
        .info-label { font-weight: 600; color: #718096; width: 200px; }
        .info-value { color: #2d3748; }
        .btn-edit { background: #667eea; color: white; padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-edit:hover { background: #5a67d8; }
        .badge { background: #edf2f7; padding: 4px 10px; border-radius: 15px; font-size: 12px; margin-right: 5px; display: inline-block; margin-bottom: 5px; }
        .experiencia-item { border-left: 3px solid #667eea; padding-left: 15px; margin-bottom: 15px; }
        .menu { background: #2d3748; padding: 15px; margin-bottom: 20px; }
        .menu a { color: white; text-decoration: none; margin-right: 20px; }
        .menu a:hover { color: #667eea; }
    </style>
</head>
<body style="background:#f7fafc;">
    <div class="menu">
        <a href="dashboard.jsp">🏠 Inicio</a>
        <a href="perfil.jsp">👤 Mi Perfil</a>
        <a href="cursos.jsp">📚 Cursos</a>
        <a href="ofertas.jsp">💼 Ofertas</a>
        <a href="logout" style="float:right; color:#fc8181;">🚪 Cerrar Sesión</a>
    </div>
    
    <div class="container">
        <div class="card">
            <h2>👤 Datos Personales</h2>
            <div class="info-row"><div class="info-label">Nombre completo:</div><div class="info-value"><%= usuario.getNombres() %> <%= usuario.getApellidos() %></div></div>
            <div class="info-row"><div class="info-label">DNI / C.E.:</div><div class="info-value"><%= usuario.getDniCe() %></div></div>
            <div class="info-row"><div class="info-label">Correo:</div><div class="info-value"><%= usuario.getCorreo() %></div></div>
            <div class="info-row"><div class="info-label">Teléfono:</div><div class="info-value"><%= usuario.getTelefono() != null ? usuario.getTelefono() : "No especificado" %></div></div>
            <div class="info-row"><div class="info-label">Ciudad / País:</div><div class="info-value"><%= usuario.getCiudadPais() != null ? usuario.getCiudadPais() : "No especificado" %></div></div>
            <div class="info-row"><div class="info-label">Rol:</div><div class="info-value"><span class="badge" style="background:#667eea; color:white;"><%= usuario.getNombreRol() %></span></div></div>
            <br>
            <a href="editar_perfil.jsp" class="btn-edit">✏️ Editar Perfil</a>
        </div>
        
        <div class="card">
            <h2>🎓 Información de Egresado</h2>
            <div class="info-row"><div class="info-label">Carrera:</div><div class="info-value"><%= carrera %></div></div>
            <div class="info-row"><div class="info-label">Año de egreso:</div><div class="info-value"><%= anioEgreso > 0 ? anioEgreso : "No especificado" %></div></div>
            <div class="info-row"><div class="info-label">LinkedIn:</div><div class="info-value"><%= !linkedin.isEmpty() ? "<a href='" + linkedin + "' target='_blank'>" + linkedin + "</a>" : "No especificado" %></div></div>
            <div class="info-row"><div class="info-label">Biografía:</div><div class="info-value"><%= biografia %></div></div>
        </div>
        
        <div class="card">
            <h2>📜 Información Académica</h2>
            <%
                try (Connection conn = DatabaseConnection.getConnection();
                     PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT grado_obtenido, anio_graduacion, institucion FROM informacion_academica WHERE id_usuario = ? ORDER BY anio_graduacion DESC")) {
                    pstmt.setInt(1, idUsuario);
                    ResultSet rs = pstmt.executeQuery();
                    boolean hayDatos = false;
                    while (rs.next()) {
                        hayDatos = true;
                        String grado = rs.getString("grado_obtenido");
                        int anio = rs.getInt("anio_graduacion");
                        String institucion = rs.getString("institucion");
            %>
                        <div class="experiencia-item">
                            <strong><%= grado %></strong> - <%= institucion %><br>
                            <small style="color:#718096;">Año: <%= anio %></small>
                        </div>
            <%
                    }
                    if (!hayDatos) {
                        out.println("<p style='color:#a0aec0;'>No hay información académica registrada.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                }
            %>
        </div>
        
        <div class="card">
            <h2>💼 Experiencia Laboral</h2>
            <%
                try (Connection conn = DatabaseConnection.getConnection();
                     PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT empresa, cargo, fecha_inicio, fecha_fin, es_actual, sector FROM experiencia_laboral WHERE id_usuario = ? ORDER BY fecha_inicio DESC")) {
                    pstmt.setInt(1, idUsuario);
                    ResultSet rs = pstmt.executeQuery();
                    boolean hayDatos = false;
                    while (rs.next()) {
                        hayDatos = true;
                        String empresa = rs.getString("empresa");
                        String cargo = rs.getString("cargo");
                        String fechaInicio = rs.getString("fecha_inicio");
                        String fechaFin = rs.getString("fecha_fin");
                        boolean actual = rs.getBoolean("es_actual");
                        String sector = rs.getString("sector");
            %>
                        <div class="experiencia-item">
                            <strong><%= cargo %></strong> en <%= empresa %>
                            <% if (actual) { %><span class="badge" style="background:#48bb78; color:white;">Actual</span><% } %><br>
                            <small style="color:#718096;"><%= fechaInicio %> - <%= fechaFin != null ? fechaFin : "Presente" %> | Sector: <%= sector != null ? sector : "No especificado" %></small>
                        </div>
            <%
                    }
                    if (!hayDatos) {
                        out.println("<p style='color:#a0aec0;'>No hay experiencia laboral registrada.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                }
            %>
        </div>
        
        <div class="card">
            <h2>⚡ Habilidades</h2>
            <%
                try (Connection conn = DatabaseConnection.getConnection();
                     PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT ch.nombre_habilidad, ch.tipo, he.nivel_dominio " +
                        "FROM habilidad_egresado he JOIN catalogo_habilidad ch ON he.id_habilidad = ch.id_habilidad " +
                        "WHERE he.id_usuario = ?")) {
                    pstmt.setInt(1, idUsuario);
                    ResultSet rs = pstmt.executeQuery();
                    boolean hayDatos = false;
                    while (rs.next()) {
                        hayDatos = true;
                        String habilidad = rs.getString("nombre_habilidad");
                        String tipo = rs.getString("tipo");
                        int nivel = rs.getInt("nivel_dominio");
            %>
                        <span class="badge"><%= habilidad %> (<%= tipo %>) - <%= nivel %>%</span>
            <%
                    }
                    if (!hayDatos) {
                        out.println("<p style='color:#a0aec0;'>No hay habilidades registradas.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                }
            %>
        </div>
    </div>
</body>
</html>