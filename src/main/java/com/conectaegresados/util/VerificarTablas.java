/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.conectaegresados.util;

import com.conectaegresados.dao.DatabaseConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class VerificarTablas {
    public static void main(String[] args) {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("📋 LISTA DE TABLAS EN TU BASE DE DATOS:\n");

            ResultSet rs = stmt.executeQuery("SHOW TABLES");
            int contador = 0;
            while (rs.next()) {
                String nombreTabla = rs.getString(1);
                System.out.println("✅ " + nombreTabla);
                contador++;
            }

            System.out.println("\n🎯 Total de tablas: " + contador + " de 15");

            if (contador == 15) {
                System.out.println("🎉 ¡TODAS LAS TABLAS ESTÁN CREADAS! ¡PERFECTO!");
            } else {
                System.out.println("⚠️ Faltan " + (15 - contador) + " tablas por crear");
            }

        } catch (Exception e) {
            System.out.println("❌ ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}