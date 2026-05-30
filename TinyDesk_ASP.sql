create database TinyDesk_Web
COLLATE Latin1_General_CI_AI
GO
USE TinyDesk_Web; 
GO
/*-------------------------------------------------------------------------------
		1. TABLAS INDEPENDIENTES (Sin Claves Foráneas)
---------------------------------------------------------------------------------*/
CREATE TABLE EMPRESA (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL UNIQUE
)
GO

CREATE TABLE PRIORIDAD (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Nombre VARCHAR(30) NOT NULL UNIQUE
)
GO

CREATE TABLE PUESTO (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL UNIQUE
)
GO
/*-------------------------------------------------------------------------------
		2. TABLAS ASOCIADAS A LA EMPRESA (Multi-Empresa)
---------------------------------------------------------------------------------*/
-- CREACIÓN TABLA ÁREA (Con IdEmpresa para que cada empresa tenga sus áreas)
CREATE TABLE AREA (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Nombre VARCHAR(30) NOT NULL UNIQUE,
    IdEmpresa INT NULL, -- NULL indica que es un Área Global (o podés asociarlo a la empresa)
    FOREIGN KEY (IdEmpresa) REFERENCES EMPRESA(Id)
)
GO
-- CREACIÓN TABLA ESTADO (Con IdEmpresa)
CREATE TABLE ESTADO (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Nombre VARCHAR(30) NOT NULL,
    EsFinal BIT NOT NULL DEFAULT 0,
    EsSistema BIT NOT NULL DEFAULT 0,
    IdEmpresa INT NULL, -- NULL indica que son estados por defecto del sistema
    FOREIGN KEY (IdEmpresa) REFERENCES EMPRESA(Id)
)
GO
-- CREACIÓN TABLA USUARIO (Verrsión Limpia sin ROL y con PUESTO)
CREATE TABLE USUARIO (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    NombreUsuario VARCHAR(30) NOT NULL UNIQUE,
    PasswordHash VARCHAR(200) NOT NULL,
    Nombre VARCHAR(30) NOT NULL,
    Apellido VARCHAR(30) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    PermisoEscritura BIT NOT NULL DEFAULT 0, -- Permiso directo
    IdPuesto INT NOT NULL,                   -- Clave foránea al puesto ocupado (ej: Owner, Developer)
    IdArea INT NOT NULL,                         -- NO Nullable (el Owner necesita área Direccion)
    IdEmpresa INT NOT NULL,                  -- Clave foránea de la empresa del usuario
    FOREIGN KEY (IdPuesto) REFERENCES PUESTO(Id),
    FOREIGN KEY (IdArea) REFERENCES AREA(Id),
    FOREIGN KEY (IdEmpresa) REFERENCES EMPRESA(Id)
)
GO
-- CREACIÓN TABLA PROYECTO
CREATE TABLE PROYECTO (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Nombre VARCHAR(30) NOT NULL,
    Descripcion VARCHAR(250) NOT NULL,
    FechaInicio DATE NOT NULL CHECK(FechaInicio >= CAST(GETDATE() AS DATE)),
    FechaFin DATE,
    FechaEstimadaFin DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    IdEstado INT NOT NULL,
    IdEmpresa INT NOT NULL, -- El proyecto pertenece a una empresa
	
    CONSTRAINT CK_Proyecto_FechaFin CHECK (FechaFin IS NULL OR FechaFin >= FechaInicio),
    CONSTRAINT CK_Proyecto_FechaEstimada CHECK (FechaEstimadaFin >= FechaInicio),
    FOREIGN KEY (IdEstado) REFERENCES ESTADO(Id),
    FOREIGN KEY (IdEmpresa) REFERENCES EMPRESA(Id)
)
GO
-- CREACIÓN TABLA SPRINT
CREATE TABLE SPRINT (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    NumeroSprint INT NOT NULL,
    FechaInicio DATE NOT NULL CHECK(FechaInicio >= CAST(GETDATE() AS DATE)),
    FechaFin DATE,
    FechaEstimadaFin DATE NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    IdProyecto INT NOT NULL,
    IdEstado INT NOT NULL,
    IdArea INT NOT NULL,

    CONSTRAINT CK_Sprint_FechaFin CHECK (FechaFin IS NULL OR FechaFin >= FechaInicio),
    CONSTRAINT CK_Sprint_FechaEstimada CHECK (FechaEstimadaFin >= FechaInicio),
    FOREIGN KEY (IdProyecto) REFERENCES PROYECTO(Id),
    FOREIGN KEY (IdEstado) REFERENCES ESTADO(Id),
    FOREIGN KEY (IdArea) REFERENCES AREA(Id)
)
GO
-- CREACIÓN TABLA TICKET
CREATE TABLE TICKET (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    FechaInicio DATE NOT NULL CHECK(FechaInicio >= CAST(GETDATE() AS DATE)),
    FechaFin DATE,
    FechaEstimadaFin DATE NOT NULL,
    Descripcion VARCHAR(150) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,
    IdPrioridad INT NOT NULL,
    IdUsuario INT NOT NULL,
    IdEstado INT NOT NULL,
    IdSprint INT NOT NULL,

    CONSTRAINT CK_Ticket_FechaFin CHECK (FechaFin IS NULL OR FechaFin >= FechaInicio),
    CONSTRAINT CK_Ticket_FechaEstimada CHECK (FechaEstimadaFin >= FechaInicio),
    FOREIGN KEY (IdPrioridad) REFERENCES PRIORIDAD(Id),
    FOREIGN KEY (IdUsuario) REFERENCES USUARIO(Id),
    FOREIGN KEY (IdEstado) REFERENCES ESTADO(Id),
    FOREIGN KEY (IdSprint) REFERENCES SPRINT(Id)
)
GO
/*-------------------------------------------------------------------------------
				3. INSERCIÓN DE DATOS OBLIGATORIOS (SEMILLA)
---------------------------------------------------------------------------------*/
-- PUESTOS POR DEFECTO del sistema
IF NOT EXISTS (SELECT 1 FROM PUESTO WHERE Nombre = 'Owner')
BEGIN
    INSERT INTO PUESTO (Nombre) VALUES ('Owner');
END
GO
-- ESTADOS POR DEFECTO DEL SISTEMA (IdEmpresa = NULL para que sean globales)
IF NOT EXISTS (SELECT 1 FROM ESTADO WHERE Nombre = 'Pendiente' AND IdEmpresa IS NULL)
BEGIN
    INSERT INTO ESTADO (Nombre, EsFinal, EsSistema, IdEmpresa) VALUES ('Pendiente', 0, 1, NULL);
END
IF NOT EXISTS (SELECT 1 FROM ESTADO WHERE Nombre = 'En Progreso' AND IdEmpresa IS NULL)
BEGIN
    INSERT INTO ESTADO (Nombre, EsFinal, EsSistema, IdEmpresa) VALUES ('En Progreso', 0, 1, NULL);
END
IF NOT EXISTS (SELECT 1 FROM ESTADO WHERE Nombre = 'Finalizado' AND IdEmpresa IS NULL)
BEGIN
    INSERT INTO ESTADO (Nombre, EsFinal, EsSistema, IdEmpresa) VALUES ('Finalizado', 1, 1, NULL);
END
GO
-- PRIORIDADES POR DEFECTO
IF NOT EXISTS (SELECT 1 FROM PRIORIDAD WHERE Nombre = 'Baja')
BEGIN
    INSERT INTO PRIORIDAD (Nombre) VALUES ('Baja');
END
IF NOT EXISTS (SELECT 1 FROM PRIORIDAD WHERE Nombre = 'Media')
BEGIN
    INSERT INTO PRIORIDAD (Nombre) VALUES ('Media');
END
IF NOT EXISTS (SELECT 1 FROM PRIORIDAD WHERE Nombre = 'Alta')
BEGIN
    INSERT INTO PRIORIDAD (Nombre) VALUES ('Alta');
END
GO
-- AREAS POR DEFECTO
IF NOT EXISTS (SELECT 1 FROM AREA WHERE Nombre = 'Direccion')
BEGIN
    INSERT INTO AREA (Nombre) VALUES ('Direccion');
END
