/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.conectaegresados.util;

import com.conectaegresados.dao.DatabaseConnection;
import java.sql.Connection;

public class ProbarConexion {
    public static void main(String[] args) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            System.out.println("✅ ¡CONEXIÓN EXITOSA! 🎉");
            System.out.println("Conectado a: " + Config.DB_NAME);
            System.out.println("Host: " + Config.DB_HOST);
        } catch (Exception e) {
            System.out.println("❌ ERROR DE CONEXIÓN:");
            System.out.println("Mensaje: " + e.getMessage());
            e.printStackTrace();
        }
    }
}