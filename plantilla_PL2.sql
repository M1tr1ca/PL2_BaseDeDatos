\pset pager off

SET client_encoding = 'UTF8';

BEGIN;

CREATE SCHEMA albumes;



/* CREATE TABLE IF NOT EXISTS Persona (
    DNI CHAR(9) NOT NULL,
    Nombre TEXT UNIQUE,
    Edad INT,
    CONSTRAINT Persona_pk PRIMARY KEY (DNI)
);

CREATE TABLE IF NOT EXISTS Automóvil (
    Matrícula CHAR(7) NOT NULL,
    Marca TEXT,
    Modelo TEXT,
    Kilómetros INT,
    DNI_Persona CHAR(9) NOT NULL,
    CONSTRAINT Automóvil_pk PRIMARY KEY (Matrícula),
    CONSTRAINT Persona_fk FOREIGN KEY (DNI_Persona) REFERENCES Persona (DNI) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
); */

/* CREATE TABLE IF NOT EXISTS Persona (
    DNI CHAR(9) NOT NULL,
    Nombre TEXT UNIQUE,
    Edad INT,
    CONSTRAINT Persona_pk PRIMARY KEY (DNI)
);

CREATE TABLE IF NOT EXISTS Automóvil (
    Matrícula CHAR(7) NOT NULL,
    Marca TEXT,
    Modelo TEXT,
    Kilómetros INT,
    CONSTRAINT Automóvil_pk PRIMARY KEY (Matrícula)
);

CREATE TABLE Conduce (
    DNI_Persona CHAR(9) NOT NULL,
    Matrícula_Automóvil CHAR(7) NOT NULL,
    CONSTRAINT Conduce_pk PRIMARY KEY (DNI_Persona, Matrícula_Automóvil),
    CONSTRAINT Persona_fk FOREIGN KEY (DNI_Persona) REFERENCES Persona (DNI) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Automóvil_fk FOREIGN KEY (Matrícula_Automóvil) REFERENCES Automóvil (Matrícula) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE
); */



CREATE TABLE IF NOT EXISTS albumes.grupo (
    url_grupo CHAR(100) UNIQUE NOT NULL,
    nombre TEXT UNIQUE NOT NULL,
    
    CONSTRAINT grupo_pk PRIMARY KEY (nombre),

);

CREATE TABLE albumes.usuario (
    nombre_usuario CHAR(25) NOT NULL UNIQUE,
    password CHAR(25) NOT NULL,
    email CHAR(25) NOT NULL UNIQUE,
    nombre CHAR(25) NOT NULL
    
    CONSTRAINT usuario_pk PRIMARY KEY (nombre_usuario),
);



CREATE TABLE albumes.disco (
    Titulo_Disco CHAR(25) NOT NULL, 
    Año_publiculacion_Disco ) NOT NULL, 
    País CHAR(25) NOT NULL, 
    url_portada CHAR(100) NOT NULL,
    nombre_grupo CHAR(25) NOT NULL,

    CONSTRAINT disco_pk PRIMARY KEY (Titulo_Disco), 
    CONSTRAINT disco_fk FOREIGN KEY (nombre_grupo) REFERENCES albumes.grupo (nombre) MATCH FULL
);

CREATE TABLE IF NOT EXISTS Edicion (
    Titulo_Disco CHAR(25) NOT NULL, 
    Año_publiculacion_Disco IN NOT NULL, 
    Formato CHAR(25) NOT NULL, 
    Año_Edición INT NOT NULL, 
    País CHAR(25) NOT NULL, 
    CONSTRAINT Formato_pk PRIMARY KEY (Genero),
    CONSTRAINT Año_Edición_pk PRIMARY KEY (Titulo_Disco),
    CONSTRAINT País_pk PRIMARY KEY (País),
    CONSTRAINT Año_publiculacion_Disco_pk FOREIGN KEY (Año_publiculacion_Disco),
    CONSTRAINT Titulo_Disco_pk FOREIGN KEY (Titulo_Disco),
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Genero (
    Genero CHAR(25) NOT NULL,
    Titulo_Disco CHAR(25) NOT NULL,
    Año_publicacion TEXT UNIQUE,
    CONSTRAINT Genero_pk PRIMARY KEY (Genero),
    CONSTRAINT Titulo_Disco_pk FOREIGN KEY (Titulo_Disco),
    CONSTRAINT Automóvil_pk FOREIGN KEY (Año_publicacion),
    ON DELETE RESTRICT ON UPDATE CASCADE
);

\echo 'creando un esquema temporal'


SET search_path='nombre del esquema o esquemas utilizados';

\echo 'Cargando datos'


\echo insertando datos en el esquema final

\echo Consulta 1: texto de la consulta

\echo Consulta n:


ROLLBACK;                       -- importante! permite correr el script multiples veces...p