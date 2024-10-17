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
    nombre_usuario CHAR(25) NOT NULL UNIQUE, 
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    nombre CHAR(25) NOT NULL,
    
    CONSTRAINT usuario_pk PRIMARY KEY (nombre_usuario)
);
--Usuario(Nombre_Usuario, Password, Email, Nombre) 


CREATE TABLE IF NOT EXISTS Disco (
    Titulo_Disco CHAR(25) NOT NULL, 
    Año_publiculacion_Disco INT NOT NULL,
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
    Año_publiculacion_Disco INT NOT NULL,
    
    CONSTRAINT cancion_pk PRIMARY KEY (Titulo),
    CONSTRAINT cancion_fk FOREIGN KEY (Titulo_Disco,Año_publicacion_Disco) REFERENCES Disco(Titulo_Disco) MATCH FULL
    );
--Canción (Título_Disco, Año_publicación_Disco, Título, Duración) 

CREATE TABLE IF NOT EXISTS Edicion (
    Titulo_Disco CHAR(25) NOT NULL, 
    Año_publiculacion_Disco INT NOT NULL, 
    Formato CHAR(25) NOT NULL, 
    Año_Edicion INT NOT NULL, 
    País CHAR(25) NOT NULL, 
    CONSTRAINT pk_Edicion PRIMARY KEY (Titulo_Disco, Año_Edicion, País),
    CONSTRAINT fk_Año_publiculacion_Disco FOREIGN KEY (Año_publiculacion_Disco) REFERENCES Album(Año_Publicacion)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_Titulo_Disco FOREIGN KEY (Titulo_Disco) REFERENCES Album(Titulo)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
--Edición (Titulo_Disco, Año_publiculacion_Disco, Formato, Año_Edición, País) 


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
    Año_publiculacion_Ediciones INT NOT NULL, 
    País_Ediciones CHAR(25) NOT NULL, 
    Nombre_Usuario CHAR(25) NOT NULL, 
    Estado CHAR(25) NOT NULL, 
    
    CONSTRAINT tiene_pk PRIMARY KEY (Formato_Ediciones, Año_publiculacion_Ediciones, País_Ediciones, Nombre_Usuario), 
    
    -- FK de Edicion
    CONSTRAINT tiene_fk FOREIGN KEY (Formato_Ediciones, Año_publiculacion_Ediciones, País_Ediciones) 
    REFERENCES Edicion(Formato, Año_Edicion, País) MATCH FULL,
    
    -- FK de Usuario
    CONSTRAINT tiene_fk2 FOREIGN KEY (Nombre_Usuario) 
    REFERENCES Usuario(nombre_usuario) MATCH FULL
);

--Tiene (Formato_Ediciones, Año_publicación_Ediciones, País_Ediciones, Nombre_usuario, Estado) 

CREATE TABLE IF NOT EXISTS Desea(
    Titulo_Disco CHAR(25) NOT NULL, 
    Año_publiculacion_Disco INT NOT NULL, 
    Nombre_Usuario CHAR(25) NOT NULL, 
    
    CONSTRAINT desea_pk PRIMARY KEY (Titulo_Disco, Año_publiculacion_Disco, Nombre_Usuario), 
    
    -- FK de Disco
    CONSTRAINT desea_fk FOREIGN KEY (Titulo_Disco, Año_publiculacion_Disco) 
    REFERENCES Disco(Titulo_Disco, Año_publicacion_Disco) MATCH FULL,
    
    -- FK de Usuario
    CONSTRAINT desea_fk2 FOREIGN KEY (Nombre_Usuario) 
    REFERENCES Usuario(nombre_usuario) MATCH FULL
)
--Desea (Título_Disco, Año_Publicacion_Disco, Nombre_Usuaio) 


echo 'creando un esquema temporal'


/* CREATE SCHEMA IF NOT EXISTS temporal;

SET search_path TO temporal;

-- Create temporary tables in the temporal schema
CREATE TABLE temporal.Grupo AS TABLE Grupo WITH NO DATA;
CREATE TABLE temporal.Usuario AS TABLE Usuario WITH NO DATA;
CREATE TABLE temporal.Disco AS TABLE Disco WITH NO DATA;
CREATE TABLE temporal.Cancion AS TABLE Cancion WITH NO DATA;
CREATE TABLE temporal.Edicion AS TABLE Edicion WITH NO DATA;
CREATE TABLE temporal.Genero AS TABLE Genero WITH NO DATA;
CREATE TABLE temporal.Tiene AS TABLE Tiene WITH NO DATA;
CREATE TABLE temporal.Desea AS TABLE Desea WITH NO DATA;


SET search_path='nombre del esquema o esquemas utilizados'; */

echo 'Cargando datos'


echo insertando datos en el esquema final

echo Consulta 1: texto de la consulta

echo Consulta n:


ROLLBACK;                       -- importante! permite correr el script multiples veces...p