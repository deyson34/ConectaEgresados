/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.conectaegresados.conectaegresados;

import com.conectaegresados.dao.UsuarioDAO;
import com.conectaegresados.model.Usuario;
import java.util.Scanner;

public class PruebaLogin {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        System.out.println("========================================");
        System.out.println("   INICIO DE SESIÓN - CONECTA EGRESADOS");
        System.out.println("========================================\n");

        System.out.println("📧 Correo: admin@conectaegresados.edu");
        System.out.println("🔑 Contraseña: admin123\n");
        
        System.out.print("Ingresa tu correo: ");
        String correo = scanner.nextLine().trim();
        
        System.out.print("Ingresa tu contraseña: ");
        String contrasena = scanner.nextLine().trim();

        System.out.println("\n🔍 Verificando...");

        Usuario usuario = usuarioDAO.iniciarSesion(correo, contrasena);

        if (usuario != null) {
            System.out.println("\n✅ ¡INICIO DE SESIÓN EXITOSO! 🎉");
            System.out.println("👤 Bienvenido: " + usuario.getNombres() + " " + usuario.getApellidos());
            System.out.println("📧 Correo: " + usuario.getCorreo());
            System.out.println("🎭 Rol: " + usuario.getNombreRol());
            
            if (usuario.getIdRol() == 1) {
                System.out.println("\n🔧 Tienes acceso de ADMINISTRADOR");
                System.out.println("Puedes gestionar usuarios, cursos, eventos, ofertas...");
            } else {
                System.out.println("\n📚 Tienes acceso de EGRESADO");
                System.out.println("Puedes ver cursos, ofertas, eventos y actualizar tu perfil");
            }
        } else {
            System.out.println("\n❌ INICIO DE SESIÓN FALLIDO");
            System.out.println("Verifica tu correo y contraseña");
        }

        scanner.close();
    }
}