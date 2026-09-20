/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// =====================================================
// NO TOCAR, PELIGRO INMINENTE , ME TOMO MEDIO DIA CONECTAR ESTA ####
// =====================================================

package com.conectaegresados.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Config {
    private static final Properties props = new Properties();
    
    static {
        try (InputStream input = Config.class.getClassLoader()
                .getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new RuntimeException("❌ No se encontró config.properties");
            }
            props.load(input);
        } catch (IOException e) {
            throw new RuntimeException("❌ Error leyendo configuración: " + e.getMessage());
        }
    }
    
    public static final String DB_HOST = props.getProperty("db.host");
    public static final String DB_PORT = props.getProperty("db.port");
    public static final String DB_NAME = props.getProperty("db.name");
    public static final String DB_USER = props.getProperty("db.user");
    public static final String DB_PASSWORD = props.getProperty("db.password");
    
    public static final String DB_URL = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME 
        + "?useSSL=true"
        + "&requireSSL=true"
        + "&allowPublicKeyRetrieval=true"
        + "&useUnicode=true"
        + "&characterEncoding=utf8"
        + "&serverTimezone=UTC";
    
    public static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
}