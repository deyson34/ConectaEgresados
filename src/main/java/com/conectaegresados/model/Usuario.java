/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.conectaegresados.model;

public class Usuario {
    private int idUsuario;
    private String dniCe;
    private String nombres;
    private String apellidos;
    private String correo;
    private String contrasena;
    private String telefono;
    private String fechaNacimiento;
    private String ciudadPais;
    private int idRol;
    private boolean activo;

    // =====================================================
    // CONSTRUCTORES
    // =====================================================
    public Usuario() {}

    public Usuario(String correo, String contrasena) {
        this.correo = correo;
        this.contrasena = contrasena;
    }

    // =====================================================
    // GETTERS Y SETTERS
    // =====================================================
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getDniCe() { return dniCe; }
    public void setDniCe(String dniCe) { this.dniCe = dniCe; }

    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getContrasena() { return contrasena; }
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(String fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }

    public String getCiudadPais() { return ciudadPais; }
    public void setCiudadPais(String ciudadPais) { this.ciudadPais = ciudadPais; }

    public int getIdRol() { return idRol; }
    public void setIdRol(int idRol) { this.idRol = idRol; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }
    
    // =====================================================
    // OBTENER NOMBRE DEL ROL
    // =====================================================
    public String getNombreRol() {
        switch (idRol) {
            case 1: return "Administrador";
            case 2: return "Egresado";
            default: return "Desconocido";
        }
    }
}