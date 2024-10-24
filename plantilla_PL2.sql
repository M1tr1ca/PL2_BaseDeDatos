\pset pager off

SET client_encoding = 'UTF8';

BEGIN;

echo 'creando tablas BBDD discos'

--ENTIDADES + ATRIBUTOS MULTIVALUADOS

CREATE TABLE IF NOT EXISTS Grupo (
    url_grupo VARCHAR(100) UNIQUE NOT NULL,
    nombre CHAR(25) UNIQUE NOT NULL,
    
    CONSTRAINT grupo_pk PRIMARY KEY (nombre)
);
--Grupo (Nombre, URL) 


CREATE TABLE IF NOT EXISTS Usuario (
    nombre CHAR(25) NOT NULL,
    nombre_usuario CHAR(25) NOT NULL UNIQUE, 
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    
    CONSTRAINT usuario_pk PRIMARY KEY (nombre_usuario)
);
--Usuario(Nombre,Nombre_Usuario, Password, Email) 


CREATE TABLE IF NOT EXISTS Disco (
    Titulo_Disco CHAR(25) NOT NULL, 
    Año_publicacion_Disco INT NOT NULL,
    País CHAR(25) NOT NULL, 
    url_portada VARCHAR(100) NOT NULL,
    nombre_grupo CHAR(25) NOT NULL, 
    
    CONSTRAINT disco_pk PRIMARY KEY (Titulo_Disco), 
    CONSTRAINT disco_fk FOREIGN KEY (nombre_grupo) REFERENCES Albumes_Grupo(nombre) MATCH FULL
);
--Disco (Año_publicacion, Título, Url_Portada, Nombre_Grupo) 


CREATE TABLE IF NOT EXISTS Cancion (
    Titulo CHAR(25) NOT NULL, 
    Duracion INT NOT NULL,
    Titulo_Disco CHAR(25) NOT NULL,
    Año_publicacion_Disco INT NOT NULL,
    
    CONSTRAINT cancion_pk PRIMARY KEY (Titulo),
    CONSTRAINT cancion_fk FOREIGN KEY (Titulo_Disco,Año_publicacion_Disco) REFERENCES Disco(Titulo_Disco) MATCH FULL
    );
--Canción (Título_Disco, Año_publicación_Disco, Título, Duración) 

CREATE TABLE IF NOT EXISTS Edicion (
    Titulo_Disco CHAR(25) NOT NULL, 
    Año_publicacion_Disco INT NOT NULL, 
    Formato CHAR(25) NOT NULL, 
    Año_Edicion INT NOT NULL, 
    País CHAR(25) NOT NULL, 
    CONSTRAINT pk_Edicion PRIMARY KEY (Titulo_Disco, Año_Edicion, País),
    CONSTRAINT fk_Año_publicacion_Disco FOREIGN KEY (Año_publicacion_Disco) REFERENCES Album(Año_Publicacion)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_Titulo_Disco FOREIGN KEY (Titulo_Disco) REFERENCES Album(Titulo)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
--Edición (Titulo_Disco, Año_publicacion_Disco, Formato, Año_Edición, País) 


CREATE TABLE IF NOT EXISTS Genero (
    Genero VARCHAR(25) NOT NULL,
    Titulo_Disco VARCHAR(25) NOT NULL,
    Año_publicacion INT,
    CONSTRAINT Genero_pk PRIMARY KEY (Genero),
    CONSTRAINT Titulo_Disco_fk FOREIGN KEY (Titulo_Disco) REFERENCES Disco(Titulo),
    CONSTRAINT Año_publicacion_uq UNIQUE (Año_publicacion)
);
--Género (Titulo_Disco , Año_publicacion_Disco, Género) 

--REALCIONES:

CREATE TABLE IF NOT EXISTS Tiene (
    Formato_Ediciones CHAR(25) NOT NULL, 
    Año_publicacion_Ediciones INT NOT NULL, 
    País_Ediciones CHAR(25) NOT NULL, 
    Nombre_Usuario CHAR(25) NOT NULL, 
    Estado CHAR(25) NOT NULL, 
    
    CONSTRAINT tiene_pk PRIMARY KEY (Formato_Ediciones, Año_publicacion_Ediciones, País_Ediciones, Nombre_Usuario), 
    
    -- FK de Edicion
    CONSTRAINT tiene_fk FOREIGN KEY (Formato_Ediciones, Año_publicacion_Ediciones, País_Ediciones) 
    REFERENCES Edicion(Formato, Año_Edicion, País) MATCH FULL,
    
    -- FK de Usuario
    CONSTRAINT tiene_fk2 FOREIGN KEY (Nombre_Usuario) 
    REFERENCES Usuario(nombre_usuario) MATCH FULL
);

--Tiene (Formato_Ediciones, Año_publicación_Ediciones, País_Ediciones, Nombre_usuario, Estado) 

CREATE TABLE IF NOT EXISTS Desea(
    Titulo_Disco CHAR(25) NOT NULL, 
    Año_publicacion_Disco INT NOT NULL, 
    Nombre_Usuario CHAR(25) NOT NULL, 
    
    CONSTRAINT desea_pk PRIMARY KEY (Titulo_Disco, Año_publicacion_Disco, Nombre_Usuario), 
    
    -- FK de Disco
    CONSTRAINT desea_fk FOREIGN KEY (Titulo_Disco, Año_publicacion_Disco) 
    REFERENCES Disco(Titulo_Disco, Año_publicacion_Disco) MATCH FULL,
    
    -- FK de Usuario
    CONSTRAINT desea_fk2 FOREIGN KEY (Nombre_Usuario) 
    REFERENCES Usuario(nombre_usuario) MATCH FULL
)
--Desea (Título_Disco, Año_Publicacion_Disco, Nombre_Usuaio) 


echo 'creando un esquema temporal'


CREATE SCHEMA IF NOT EXISTS temporal;

SET search_path TO temporal;

-- Create temporary tables in the temporal schema
CREATE TEMPORARY TABLE temp_Canciones(
    ID VARCHAR,
    Titulo_Cancion VARCHAR
    Duracion TIME,
);

CREATE TEMPORARY TABLE temp_Discos(
    id_discos INT,
    Titulo_Disco VARCHAR,
    Año_Publicacion_Disco INT,
    Nombre_Grupo VARCHAR,
    Url_Grupo VARCHAR,
    Genero VARCHAR,
    Url_Portada VARCHAR
);

CREATE TEMPORARY TABLE temp_Ediciones(
    ID VARCHAR,
    Año_Publicación INT,
    Pais_De_La_Edicion VARCHAR,
    Formato VARCHAR,
);

CREATE TEMPORARY TABLE temp_Usuarios_tiene_edicion(
    Nombre_Usuario VARCHAR,
    titulo_Disco Varchar,
    Pais_De_La_Edicion VARCHAR,
    Anno_Lanzamiento VARCHAR,
);

CREATE TEMPORARY TABLE temp_Usuarios_desea_disco(
    Nombre VARCHAR,
    Titulo VARCHAR,
    Año VARCHAR,
    Lanzamiento VARCHAR
);

CREATE TEMPORARY TABLE temp_Usuarios (
    Nombre VARCHAR,
    Nombre_Usuario VARCHAR,
    Email VARCHAR,
    Password1 VARCHAR
);

Create TEMPORARY TABLE temp_Genero (
    Genero VARCHAR,
);


COPY temp_Canciones (Titulo, Duracion, Titulo_Disco)
FROM 'canciones.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_Discos (id_discos, Nombre_Disco, Año_Publicacion_Disco, Nombre_Grupo, Url_Grupo, Genero, Url_Portada)
FROM 'discos.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_Ediciones (ID, Año_Publicación, Pais_De_La_Edicion, Formato)
FROM 'ediciones.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_Usuarios_tiene_edicion (Nombre_Usuario, itulo_Disco, Pais_De_La_Edicion, Anno_Lanzamiento)
FROM 'usuarios_tiene_edicion.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_Usuarios_desea_disco (Nombre, Titulo, Año, Lanzamiento)
FROM 'usuarios_desea_disco.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_Usuarios (Nombre, Nombre_Usuario, Email, Password1)
FROM 'usuarios.csv'
DELIMITER ';'
CSV HEADER;

COPY temp_Genero (Genero)
FROM 'disco.csv'
DELIMITER ';'
CSV HEADER;


-- Load data from CSV files into the temporary tables

-- Insert data from temporary tables into the final tables
INSERT INTO Grupo (url_grupo, nombre)
SELECT Url_Grupo, Nombre_Grupo FROM temp_Discos;

INSERT INTO Usuario (nombre_usuario, password, email, nombre)
SELECT Nombre_Usuario, Password1, Email, Nombre FROM temp_Usuarios;

INSERT INTO Disco (Titulo_Disco, Año_publicacion_Disco, País, url_portada, nombre_grupo)
SELECT d.Nombre_Disco, d.Año_Publicacion_Disco, e.Pais_De_La_Edicion, d.Url_Portada, d.Nombre_Grupo
FROM temp_Discos d
JOIN temp_Ediciones e ON d.id_discos = e.ID;

INSERT INTO Cancion (Titulo, Duracion, Titulo_Disco, Año_publicacion_Disco)--Ver como hacer el insert del titulo disco y año publicacion disco
SELECT c.Titulo_Cancion, c.Duracion, d.Titulo_Disco, d.Año_publicacion_Disco
FROM temp_Canciones c 
JOIN temp_Discos d ON c.Titulo_Disco = d.Nombre_Disco;

INSERT INTO Edicion (Titulo_Disco, Año_publicacion_Disco, Formato, Año_Edicion, País)
SELECT d.Titulo_Disco, d.Año_publicacion_Disco, e.Formato, e.Año_Edicion, e.Pais_De_La_Edicion 
FROM temp_Ediciones e
JOIN temp_Discos d ON e.ID = d.id_discos;

INSERT INTO Genero (Genero, Titulo_Disco, Año_publicacion)
SELECT g.Genero, d.Titulo_Disco, Año_publicacion 
FROM temp_Genero g;
-- arreglar el funcionamiento de Genero 

INSERT INTO Tiene (Formato_Ediciones, Año_publicacion_Ediciones, País_Ediciones, Nombre_Usuario, Estado)
SELECT Formato_Ediciones, Año_publicacion_Ediciones, País_Ediciones, Nombre_Usuario, Estado FROM temp_Usuarios_tiene_edicion;

INSERT INTO Desea (Titulo_Disco, Año_publicacion_Disco, Nombre_Usuario)
SELECT Titulo_Disco, Año_publicacion_Disco, Nombre_Usuario FROM temp_Usuarios_desea_disco;
-- Replace, REGEST-REPLACE, 



SET search_path='nombre del esquema o esquemas utilizados'; 

echo 'Cargando datos'


echo insertando datos en el esquema final

echo Consulta 1: texto de la consulta

echo Consulta n:


ROLLBACK;                       -- importante! permite correr el script multiples veces...p