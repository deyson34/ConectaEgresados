<%-- 
    Document   : directorio
    Created on : 26 set. 2026, 9:39:51 a. m.
    Author     : Usuario
--%>

<%-- 
    Document   : directorio
    Created on : 26 set. 2026, 9:39:51 a. m.
    Author     : Usuario
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.conectaegresados.model.Usuario"%>
<%@page import="java.sql.*"%>
<%@page import="com.conectaegresados.dao.DatabaseConnection"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) { response.sendRedirect("login.jsp"); return; }
    
    String busqueda = request.getParameter("q") != null ? request.getParameter("q") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Directorio - ConectaEgresados</title>
    <link rel="stylesheet" href="css/style.css">
    
    <!-- ✅ ESTILOS LOCALES basados en el welcome del dashboard (NO toca tu CSS) -->
    <style>
        /* Tarjetas de egresados - mismo efecto que .card del dashboard */
        .dir-card {
            background: rgba(15, 23, 42, 0.55);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 14px;
            padding: 22px 26px;
            text-align: left;
            transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
        }
        .dir-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 25px rgba(0,0,0,0.3);
            border-color: rgba(16, 185, 129, 0.3);
        }
        
        /* Nombre del egresado - blanco como welcome-card h1 */
        .dir-nombre {
            color: #ffffff;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 6px;
        }
        
        /* Carrera - verde claro como welcome-greeting */
        .dir-carrera {
            color: #34d399;
            font-size: 14px;
            margin-bottom: 10px;
            font-weight: 500;
        }
        
        /* Ciudad y correo - gris claro como welcome-role */
        .dir-dato {
            color: #cbd5e1;
            font-size: 13px;
            margin-bottom: 4px;
        }
        
        /* Input buscador - semitransparente como los botones outline */
        .dir-input {
            flex: 1;
            min-width: 250px;
            padding: 10px 14px;
            border: 1px solid rgba(255,255,255,0.25);
            border-radius: 8px;
            background: rgba(255,255,255,0.08);
            color: #ffffff;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s, background 0.2s;
        }
        .dir-input:focus {
            border-color: #10b981;
            background: rgba(255,255,255,0.12);
        }
        .dir-input::placeholder {
            color: #94a3b8;
        }
        
        /* Botón buscar - igual que welcome-btn-solid */
        .dir-btn-buscar {
            background: #10b981;
            color: #052e26;
            padding: 10px 22px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }
        .dir-btn-buscar:hover {
            background: #d1fae5;
            transform: translateY(-1px);
        }
        
        /* Botón limpiar - igual que welcome-btn-outline */
        .dir-btn-limpiar {
            background: rgba(255,255,255,0.08);
            color: #ffffff;
            border: 1px solid rgba(255,255,255,0.25);
            padding: 10px 22px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.2s;
            display: inline-block;
        }
        .dir-btn-limpiar:hover {
            background: rgba(255,255,255,0.16);
            text-decoration: none;
        }
        
        /* Botón LinkedIn - outline verde */
        .dir-btn-linkedin {
            background: rgba(16,185,129,0.15);
            color: #34d399;
            border: 1px solid rgba(16,185,129,0.4);
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin-top: 8px;
            transition: background 0.2s;
        }
        .dir-btn-linkedin:hover {
            background: rgba(16,185,129,0.3);
            text-decoration: none;
            color: #ffffff;
        }
        
        /* Texto del total */
        .dir-total {
            color: #cbd5e1;
            margin-top: 20px;
            font-size: 14px;
        }
        .dir-total strong {
            color: #34d399;
            font-size: 16px;
        }
        
        /* Mensaje sin resultados */
        .dir-vacio {
            grid-column: 1 / -1;
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
    <div class="dir-greeting">Red de Contactos</div>
    <h1 class="dir-titulo">Directorio de Egresados</h1>
    
    <!-- Buscador -->
    <div class="card">
        <form method="GET" action="directorio.jsp" style="display:flex; gap:10px; flex-wrap:wrap; align-items:center;">
            <input type="text" name="q" value="<%= busqueda %>" placeholder="Buscar por nombre, carrera o ciudad..." class="dir-input">
            <button type="submit" class="dir-btn-buscar">🔍 Buscar</button>
            <% if (!busqueda.isEmpty()) { %>
                <a href="directorio.jsp" class="dir-btn-limpiar">✖️ Limpiar</a>
            <% } %>
        </form>
    </div>
    
    <div class="stats-grid">
        <%
            int contador = 0;
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT u.nombres, u.apellidos, u.correo, u.ciudad_pais, u.telefono, " +
                    "p.carrera, p.anio_egreso, p.linkedin " +
                    "FROM usuario u LEFT JOIN perfil_egresado p ON u.id_usuario = p.id_usuario " +
                    "WHERE u.id_rol = 2 AND u.activo = 1 " +
                    "AND (u.nombres LIKE ? OR u.apellidos LIKE ? OR p.carrera LIKE ? OR u.ciudad_pais LIKE ?) " +
                    "ORDER BY u.apellidos, u.nombres")) {
                
                String param = "%" + busqueda + "%";
                pstmt.setString(1, param);
                pstmt.setString(2, param);
                pstmt.setString(3, param);
                pstmt.setString(4, param);
                ResultSet rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    contador++;
                    String nombre = rs.getString("nombres") + " " + rs.getString("apellidos");
                    String correo = rs.getString("correo");
                    String ciudad = rs.getString("ciudad_pais") != null ? rs.getString("ciudad_pais") : "—";
                    String carrera = rs.getString("carrera") != null ? rs.getString("carrera") : "Carrera no especificada";
                    int anio = rs.getInt("anio_egreso");
                    String linkedin = rs.getString("linkedin");
        %>
        <div class="dir-card">
            <div class="dir-nombre"><%= nombre %></div>
            <div class="dir-carrera">🎓 <%= carrera %> <%= anio > 0 ? "· Promoción " + anio : "" %></div>
            <div class="dir-dato">📍 <%= ciudad %></div>
            <div class="dir-dato">📧 <%= correo %></div>
            <% if (linkedin != null && !linkedin.isEmpty()) { %>
                <a href="<%= linkedin %>" target="_blank" class="dir-btn-linkedin">🔗 Ver LinkedIn</a>
            <% } %>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println("<div class='dir-vacio' style='color:#fca5a5;'>❌ Error: " + e.getMessage() + "</div>");
            }
            
            if (contador == 0) {
                out.println("<div class='dir-vacio'>No se encontraron egresados" + (busqueda.isEmpty() ? "" : " con el término '<strong style='color:#fff;'>" + busqueda + "</strong>'") + "</div>");
            }
        %>
    </div>
    
    <p class="dir-total">📋 Total de egresados encontrados: <strong><%= contador %></strong></p>
</div>
</body>
</html>