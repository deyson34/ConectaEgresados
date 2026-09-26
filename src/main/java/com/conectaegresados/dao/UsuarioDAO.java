/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.conectaegresados.dao;

import com.conectaegresados.model.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {
    
    // =====================================================
    // VALIDAR INICIO DE SESIÓN
    // =====================================================
    public Usuario iniciarSesion(String correo, String contrasena) {
    String sql = "SELECT id_usuario, dni_ce, nombres, apellidos, correo, contrasena, " +
                 "telefono, fecha_nacimiento, ciudad_pais, id_rol, activo " +
                 "FROM usuario " +
                 "WHERE correo = ? AND contrasena = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setString(1, correo);
        pstmt.setString(2, contrasena);
        
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // Verificar si está activo
            boolean activo = rs.getBoolean("activo");
            if (!activo) {
                System.out.println("⚠️ Usuario desactivado");
                return null;
            }
            
            // ✅ AHORA SÍ traemos TODOS los campos
            Usuario usuario = new Usuario();
            usuario.setIdUsuario(rs.getInt("id_usuario"));
            usuario.setDniCe(rs.getString("dni_ce"));           // ← DNI
            usuario.setNombres(rs.getString("nombres"));
            usuario.setApellidos(rs.getString("apellidos"));
            usuario.setCorreo(rs.getString("correo"));
            usuario.setContrasena(rs.getString("contrasena"));
            usuario.setTelefono(rs.getString("telefono"));       // ← Teléfono
            usuario.setFechaNacimiento(rs.getString("fecha_nacimiento"));
            usuario.setCiudadPais(rs.getString("ciudad_pais"));  // ← Ciudad/País
            usuario.setIdRol(rs.getInt("id_rol"));
            usuario.setActivo(activo);
            
            return usuario;
        }
        
    } catch (SQLException e) {
        System.out.println("❌ Error en la base de datos: " + e.getMessage());
    }
    
    return null;
}
}