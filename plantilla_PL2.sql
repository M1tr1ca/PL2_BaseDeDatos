\pset pager off

SET client_encoding = 'UTF8';

BEGIN;

\echo 'creando tablas BBDD discos'

--ENTIDADES + ATRIBUTOS MULTIVALUADOS

CREATE TABLE IF NOT EXISTS Grupo (
    url_grupo TEXT UNIQUE NOT NULL,
    nombre TEXT UNIQUE NOT NULL,
    
    CONSTRAINT grupo_pk PRIMARY KEY (nombre)
);
--Grupo (Nombre, URL) 


CREATE TABLE IF NOT EXISTS Usuario (
    nombre TEXT NOT NULL,
    nombre_usuario TEXT NOT NULL UNIQUE, 
    email TEXT NOT NULL,
    password1 TEXT NOT NULL,
    
    CONSTRAINT usuario_pk PRIMARY KEY (nombre_usuario)
);
--Usuario(Nombre,Nombre_Usuario, Password, Email) 


CREATE TABLE IF NOT EXISTS Disco (
    Titulo_Disco TEXT NOT NULL, 
    Año_publicacion_Disco INT NOT NULL,
    País TEXT NOT NULL, 
    url_portada TEXT NOT NULL,
    nombre_grupo TEXT NOT NULL, 
    
    CONSTRAINT disco_pk PRIMARY KEY (Año_publicacion_Disco, Titulo_Disco),
    CONSTRAINT disco_fk FOREIGN KEY (nombre_grupo) REFERENCES Grupo(nombre) MATCH FULL
);
--Disco (Año_publicacion, Título, Url_Portada, Nombre_Grupo) 


CREATE TABLE IF NOT EXISTS Cancion (
    Titulo TEXT NOT NULL, 
    Duracion INTERVAL,
    Titulo_Disco TEXT NOT NULL,
    Año_publicacion_Disco INT NOT NULL,
    
    CONSTRAINT cancion_pk PRIMARY KEY (Titulo, Titulo_Disco, Año_publicacion_Disco),
    CONSTRAINT cancion_fk FOREIGN KEY (Titulo_Disco, Año_publicacion_Disco) REFERENCES Disco(Titulo_Disco,Año_publicacion_Disco) MATCH FULL
    );
--Canción (Título_Disco, Año_publicación_Disco, Título, Duración) 

CREATE TABLE IF NOT EXISTS Edicion (
    Titulo_Disco TEXT NOT NULL, 
    Año_publicacion_Disco INT NOT NULL, 
    Formato TEXT NOT NULL, 
    Año_Edicion INT NOT NULL, 
    País TEXT NOT NULL, 

    CONSTRAINT pk_Edicion PRIMARY KEY (Titulo_Disco, Año_Edicion, País ,Formato, Año_publicacion_Disco),
    CONSTRAINT fk_Titulo_Disco FOREIGN KEY (Titulo_Disco, Año_publicacion_Disco) REFERENCES Disco(Titulo_Disco, Año_publicacion_Disco)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
--Edición (Titulo_Disco, Año_publicacion_Disco, Formato, Año_Edición, País) 


CREATE TABLE IF NOT EXISTS Genero (
    Genero TEXT NOT NULL,
    Titulo_Disco TEXT NOT NULL,
    Año_publicacion INT,
    CONSTRAINT Genero_pk PRIMARY KEY (Genero),
    CONSTRAINT Titulo_Disco_fk FOREIGN KEY (Titulo_Disco, Año_publicacion) REFERENCES Disco(Titulo_Disco, Año_publicacion_Disco) MATCH FULL,
    CONSTRAINT Año_publicacion_uq UNIQUE (Año_publicacion)
);
--Género (Titulo_Disco , Año_publicacion_Disco, Género) 

--REALCIONES:

CREATE TABLE IF NOT EXISTS Tiene (
    Formato_Ediciones TEXT NOT NULL, 
    Año_Edicion INT NOT NULL, 
    País_Ediciones TEXT NOT NULL, 
    Nombre_Usuario TEXT NOT NULL, 
    Estado TEXT NOT NULL, 
    Titulo_Disco TEXT NOT NULL,
    Año_publicacion_Disco INT NOT NULL,
    
    CONSTRAINT tiene_pk PRIMARY KEY (Formato_Ediciones, Año_Edicion, País_Ediciones, Titulo_Disco, Año_publicacion_Disco, Nombre_Usuario),  
    
    -- FK de Edicion
    CONSTRAINT tiene_fk FOREIGN KEY (Formato_Ediciones, Año_Edicion, País_Ediciones, Titulo_Disco, Año_publicacion_Disco) 
    REFERENCES Edicion(Titulo_Disco, Año_Edicion, País ,Formato, Año_publicacion_Disco) MATCH FULL,
    
    -- FK de Usuario
    CONSTRAINT tiene_fk2 FOREIGN KEY (Nombre_Usuario) 
    REFERENCES Usuario(nombre_usuario) MATCH FULL
);

--Tiene (Formato_Ediciones, Año_publicación_Ediciones, País_Ediciones, Nombre_usuario, Estado) 

CREATE TABLE IF NOT EXISTS Desea(
    Titulo_Disco TEXT NOT NULL, 
    Año_publicacion_Disco INT NOT NULL, 
    Nombre_Usuario TEXT NOT NULL, 
    
    CONSTRAINT desea_pk PRIMARY KEY (Titulo_Disco, Año_publicacion_Disco, Nombre_Usuario), 
    
    -- FK de Disco
    CONSTRAINT desea_fk FOREIGN KEY (Titulo_Disco, Año_publicacion_Disco) 
    REFERENCES Disco(Titulo_Disco, Año_publicacion_Disco) MATCH FULL,
    
    -- FK de Usuario
    CONSTRAINT desea_fk2 FOREIGN KEY (Nombre_Usuario) 
    REFERENCES Usuario(nombre_usuario) MATCH FULL
);
--Desea (Título_Disco, Año_Publicacion_Disco,NOmbre_Usuario)


\echo 'creando un esquema temporal'



-- Create temporary tables in the temporal schema
CREATE TEMPORARY TABLE temp_Canciones(
    ID INT,
    Titulo_Cancion VARCHAR,
    Duracion INTERVAL
);

CREATE TEMPORARY TABLE temp_Discos(
    id_discos INT,
    Titulo_Disco VARCHAR,
    Año_Publicacion_Disco INT,
    id_grupo INT,
    Nombre_Grupo VARCHAR,
    Url_Grupo VARCHAR,
    Genero VARCHAR,
    Url_Portada VARCHAR
);

CREATE TEMPORARY TABLE temp_Ediciones(
    ID INT,
    Año_Publicación INT,
    Pais_De_La_Edicion VARCHAR,
    Formato VARCHAR
);

CREATE TEMPORARY TABLE temp_Usuarios_tiene_edicion(
    Nombre_Usuario VARCHAR,
    titulo_Disco VARCHAR,
    Pais_De_La_Edicion VARCHAR,
    Anno_Lanzamiento INT
);

CREATE TEMPORARY TABLE temp_Usuarios_desea_disco(
    Nombre VARCHAR,
    Titulo VARCHAR,
    Anno_Lanzamiento VARCHAR
);

CREATE TEMPORARY TABLE temp_Usuarios (
    Nombre VARCHAR,
    Nombre_Usuario VARCHAR,
    Email VARCHAR,
    Password1 VARCHAR
);


COPY temp_Canciones (ID, Titulo_Cancion, Duracion)
FROM 'C:/UAH/BaseDeDatos/PL2_BaseDeDatos/canciones.csv'
DELIMITER ';'
CSV HEADER
NULL 'NULL';


COPY temp_Discos (id_discos, Titulo_Disco, Año_Publicacion_Disco, id_grupo, Nombre_Grupo , Url_Grupo, Genero, Url_Portada)
FROM 'C:/UAH/BaseDeDatos/PL2_BaseDeDatos/discos.csv'
DELIMITER ';'
CSV HEADER
NULL 'NULL';

COPY temp_Ediciones (ID, Año_Publicación, Pais_De_La_Edicion, Formato)
FROM 'C:/UAH/BaseDeDatos/PL2_BaseDeDatos/ediciones.csv'
DELIMITER ';'
CSV HEADER
NULL 'NULL';

COPY temp_Usuarios_desea_disco (Nombre, Titulo, Anno_Lanzamiento)
FROM 'C:/UAH/BaseDeDatos/PL2_BaseDeDatos/usuario_desea_disco.csv'
DELIMITER ';'
CSV HEADER
NULL 'NULL';

COPY temp_Usuarios (Nombre, Nombre_Usuario, Email, Password1)
FROM 'C:/UAH/BaseDeDatos/PL2_BaseDeDatos/usuarios.csv'
DELIMITER ';'
CSV HEADER
NULL 'NULL';


/* SELECT
    Titulo_Disco,        -- Título del disco
    Año_Publicacion_Disco -- Año de publicación
FROM temp_Discos; */

-- Load data from CSV files into the temporary tables

-- Insert data from temporary tables into the final tables
INSERT INTO Grupo (url_grupo, nombre)
SELECT DISTINCT Url_Grupo, Nombre_Grupo
FROM temp_Discos;

INSERT INTO Usuario (nombre, nombre_usuario, password1, email)
SELECT DISTINCT Nombre, Nombre_Usuario, Password1, Email 
FROM temp_Usuarios;

INSERT INTO Disco (Titulo_Disco, Año_publicacion_Disco, País, url_portada, nombre_grupo)
SELECT DISTINCT ON (d.Titulo_Disco, d.Año_Publicacion_Disco) d.Titulo_Disco, d.Año_Publicacion_Disco, e.Pais_De_La_Edicion, COALESCE(d.Url_Portada, 'NULL'), d.Nombre_Grupo
FROM temp_Discos d
JOIN temp_Ediciones e ON d.id_discos = e.ID;

INSERT INTO Cancion (Titulo, Duracion, Titulo_Disco, Año_publicacion_Disco)
SELECT DISTINCT ON (c.Titulo_Cancion, d.Titulo_Disco, d.Año_Publicacion_Disco) c.Titulo_Cancion, c.Duracion, d.Titulo_Disco, d.Año_Publicacion_Disco
FROM temp_Canciones c
JOIN temp_Discos d ON c.ID = d.id_discos
WHERE (d.Titulo_Disco, d.Año_Publicacion_Disco) IN (SELECT Titulo_Disco, Año_publicacion_Disco FROM Disco);



INSERT INTO Edicion (Titulo_Disco, Año_publicacion_Disco, Formato, Año_Edicion, País)
SELECT DISTINCT ON (d.Titulo_Disco, d.Año_publicacion_Disco, e.Formato, e.Año_Publicación, e.Pais_De_La_Edicion )d.Titulo_Disco, d.Año_publicacion_Disco, e.Formato, e.Año_Publicación, e.Pais_De_La_Edicion 
FROM temp_Ediciones e
JOIN temp_Discos d ON e.ID = d.id_discos;


/* INSERT INTO Genero (Genero, Titulo_Disco, Año_publicacion)
SELECT d.Genero, d.Titulo_Disco, d.Año_publicacion 
FROM temp_Discos d;
SELECT REPLACE(REPLACE(STRING_AGG(nombre_columna, ', '), '[', ''), ']', '') AS resultado
FROM tu_tabla; */
-- arreglar el funcionamiento de Genero 

INSERT INTO Tiene (Formato_Ediciones, Año_publicacion_Ediciones, País_Ediciones, Nombre_Usuario, Estado)
SELECT Formato_Ediciones, Año_publicacion_Ediciones, País_Ediciones, Nombre_Usuario, Estado FROM temp_Usuarios_tiene_edicion;

INSERT INTO Desea (Titulo_Disco, Año_publicacion_Disco, Nombre_Usuario)
SELECT Titulo_Disco, Año_publicacion_Disco, Nombre_Usuario FROM temp_Usuarios_desea_disco;
-- Replace, REGEST-REPLACE, 



SET search_path='nombre del esquema o esquemas utilizados'; 

/* echo 'Cargando datos' */


\echo insertando datos en el esquema final

\echo Consulta 1: texto de la consulta

\echo Consulta n:


ROLLBACK;                       -- importante! permite correr el script multiples veces...p






/* /* CREATE TEMP TABLE temp_genero_concatenado AS
SELECT 
    Titulo_Disco, 
    Año_publicacion,
    REPLACE(REPLACE(STRING_AGG(generos, ', '), '[', ''), ']', '') AS concatenado
FROM temp_genero_array
GROUP BY Titulo_Disco, Año_publicacion; */


CREATE TEMPORARY TABLE temp_genero_array AS
SELECT 
    string_to_array(Genero, ',') AS generos,  -- Convertir la cadena de géneros en un array
    Titulo_Disco,                            -- Título del disco desde temp_discos
    Año_publicacion                          -- Año de publicación desde temp_discos
FROM temp_Discos;

-- Insert into genero (Genero, Titulo_Disco, Año_publicacion) SELECT unnest(generos), Titulo_Disco, Año_publicacion FROM temp_genero_array;



-- Crear una tabla temporal que contenga cada elemento del array en filas y una agregación concatenada
CREATE TEMP TABLE temp_genero_expandido AS
SELECT 
    unnest(generos) AS genero,                     -- Descompone el array en filas
    Titulo_Disco,                                  -- Mantiene el título del disco
    Año_publicacion,                               -- Mantiene el año de publicación
    REPLACE(REPLACE(STRING_AGG(unnest(generos), ', '), '[', ''), ']', '') AS concatenado -- Concatenar todos los géneros
FROM temp_genero_array
GROUP BY Titulo_Disco, Año_publicacion, genero;   -- Agrupar para evitar duplicados


--[POP, ROCK,....], Titulo,Año
--Pop, titulo, año
--Rock, titulo, año */








