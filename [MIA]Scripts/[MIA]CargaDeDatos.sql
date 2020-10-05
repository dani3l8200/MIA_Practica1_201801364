DROP DATABASE IF EXISTS Practica1;

CREATE DATABASE MIA_Practica1;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
	
ALTER USER 'root'@'localhost' identified with mysql_native_password by 'JuanAnonymo2000@';

USE MIA_Practica1;

SELECT * FROM TablaTemporal;

CREATE TABLE TablaTemporal(
	idTemporal INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre_compania VARCHAR(200) NOT NULL,
	contacto_compania VARCHAR(200) NOT NULL,
    correo_compania varchar(200) not null, 
    telefono_compania varchar(12) not null,
    tipo char(2) not null,
	nombre varchar(200) not null, 
    correo varchar(200) not null, 
    telefono varchar(12) not null,
    fecha_registro datetime not null, 
    direccion varchar(200) not null, 
    ciudad varchar(50) not null, 
    codigo_postal int(10) not null,
	region varchar(200) not null, 
    producto varchar(200) not null, 
    categoria_producto varchar(200) not null, 
    cantidad int(100) not null, 
    precio_unitario double not null
);

DELIMITER $$
	CREATE PROCEDURE SP_EliminarTemporal()
	BEGIN
    SET SQL_SAFE_UPDATES = 0;
	DELETE FROM TablaTemporal;
    END;
$$