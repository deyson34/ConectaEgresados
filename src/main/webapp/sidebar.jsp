<%-- 
    Document   : sidebar
    Created on : 26 set. 2026, 9:26:30?a. m.
    Author     : Usuario
--%>

<%@page import="com.conectaegresados.model.Usuario"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean esAdmin = (usuario.getIdRol() == 1);
    String paginaActual = request.getRequestURI();
%>
<div class="sidebar">
    <h2>ConectaEgresados</h2>
    <div class="user-info">
        <%= usuario.getNombres() %> <%= usuario.getApellidos() %><br>
        <span class="badge <%= esAdmin ? "admin" : "egresado" %>"><%= usuario.getNombreRol() %></span>
    </div>
    
    <a href="dashboard.jsp" class="<%= paginaActual.contains("dashboard") ? "active" : "" %>">Inicio</a>
    <a href="perfil.jsp" class="<%= paginaActual.contains("perfil") ? "active" : "" %>">Mi Perfil</a>
    <a href="directorio.jsp" class="<%= paginaActual.contains("directorio") ? "active" : "" %>">Directorio</a>
    <a href="cursos.jsp" class="<%= paginaActual.contains("curso") ? "active" : "" %>">Cursos</a>
    <a href="mis_cursos.jsp" class="<%= paginaActual.contains("mis_cursos") ? "active" : "" %>">Mis Cursos</a>
    <a href="ofertas.jsp" class="<%= paginaActual.contains("oferta") ? "active" : "" %>">Ofertas</a>
    <a href="mis_postulaciones.jsp" class="<%= paginaActual.contains("postulacion") ? "active" : "" %>">Mis Postulaciones</a>
    <a href="eventos.jsp" class="<%= paginaActual.contains("evento") ? "active" : "" %>">Eventos</a>
    <a href="mis_eventos.jsp" class="<%= paginaActual.contains("mis_eventos") ? "active" : "" %>">Mis Eventos</a>
    <a href="foro.jsp" class="<%= paginaActual.contains("foro") || paginaActual.contains("hilo") || paginaActual.contains("publicacion") ? "active" : "" %>">Foro</a>
    
    <% if (esAdmin) { %>
        <div class="section-title">Admin</div>
        <a href="admin_usuarios.jsp" class="admin-only">Usuarios</a>
        <a href="admin_cursos.jsp" class="admin-only">Cursos</a>
        <a href="admin_ofertas.jsp" class="admin-only">Ofertas</a>
        <a href="admin_eventos.jsp" class="admin-only">Eventos</a>
        <a href="admin_reportes.jsp" class="admin-only">Reportes</a>
    <% } %>
    
    <a href="logout" class="logout">Salir</a>
</div>