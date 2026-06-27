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
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    IdEmpresa INT NULL,
    FOREIGN KEY (IdEmpresa) REFERENCES EMPRESA(Id)
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
    Email VARCHAR(75) NOT NULL UNIQUE,
    Nombre VARCHAR(30) NOT NULL,
    Apellido VARCHAR(30) NOT NULL,
    Activo BIT NOT NULL DEFAULT 0,
    EsAdmin BIT NOT NULL,
    PermisoEscritura BIT NOT NULL DEFAULT 0, -- Permiso directo
    EmailVerificado BIT NOT NULL DEFAULT 0,
    IdPuesto INT NOT NULL,                  -- Clave foránea al puesto ocupado (ej: Owner, Developer )
    IdSeniority INT NULL,                        -- Clave foránea del seniority ocupado (ej: Junior, Senior, SS)
    IdArea INT NOT NULL,                         -- NO Nullable (el Owner necesita área Direccion)
    IdEmpresa INT NOT NULL,                 -- Clave foránea de la empresa del usuario
    FOREIGN KEY (IdPuesto) REFERENCES PUESTO(Id),
    FOREIGN KEY (IdArea) REFERENCES AREA(Id),
    FOREIGN KEY (IdEmpresa) REFERENCES EMPRESA(Id),
    FOREIGN KEY (IdSeniority) REFERENCES SENIORITY(Id)
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

--  CREACIÓN TABLA IMAGEN USUARIO
CREATE TABLE IMAGEN_USUARIO (
    IdUsuario INT PRIMARY KEY,
    Imagen VARCHAR(200) NOT NULL,

    CONSTRAINT FK_Imagen_Usuario FOREIGN KEY (IdUsuario) REFERENCES Usuario(Id)
)
GO

-- CREACIÓN TABLA AUDITORIA
CREATE TABLE Auditoria (
    IdAuditoria INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioId INT NOT NULL,
    Entidad VARCHAR(50) NOT NULL, -- 'Proyecto', 'Sprint', 'Ticket'
    EntidadId INT NOT NULL,       -- ID del objeto afectado
    Accion VARCHAR(10) NOT NULL,  -- 'INSERT', 'UPDATE', 'DELETE'
    CampoModificado VARCHAR(100), -- Nombre de la propiedad o campo
    ValorAnterior NVARCHAR(MAX),
    ValorNuevo NVARCHAR(MAX),
    Descripcion NVARCHAR(500),    -- Justificación del cambio
    Fecha DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UsuarioId) REFERENCES USUARIO(Id)
)
GO

/*-------------------------------------------------------------------------------
2.1. -- Quitar Constrains a las tablas y agrega restricciones de columnas conjuntas
---------------------------------------------------------------------------------*/

DECLARE @ConstraintName NVARCHAR(200);

SELECT @ConstraintName = kc.name
FROM sys.key_constraints kc
INNER JOIN sys.tables t ON t.object_id = kc.parent_object_id
WHERE t.name = 'AREA'
  AND kc.type = 'UQ';

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE AREA DROP CONSTRAINT ' + @ConstraintName);
END
GO

CREATE UNIQUE INDEX UX_AREA_Nombre_Empresa
ON AREA (IdEmpresa, Nombre)
WHERE IdEmpresa IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_AREA_Nombre_Sistema
ON AREA (Nombre)
WHERE IdEmpresa IS NULL;
GO

DECLARE @ConstraintName NVARCHAR(200);

SELECT @ConstraintName = kc.name
FROM sys.key_constraints kc
INNER JOIN sys.tables t ON t.object_id = kc.parent_object_id
WHERE t.name = 'PUESTO'
  AND kc.type = 'UQ';

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE PUESTO DROP CONSTRAINT ' + @ConstraintName);
END
GO

CREATE UNIQUE INDEX UX_PUESTO_Nombre_Empresa
ON PUESTO (IdEmpresa, Nombre)
WHERE IdEmpresa IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_PUESTO_Nombre_Sistema
ON PUESTO (Nombre)
WHERE IdEmpresa IS NULL;
GO

CREATE UNIQUE INDEX UX_ESTADO_Nombre_Empresa
ON ESTADO (IdEmpresa, Nombre)
WHERE IdEmpresa IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_ESTADO_Nombre_Sistema
ON ESTADO (Nombre)
WHERE IdEmpresa IS NULL;
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
GO

-- MOCKUP --
-- 1. Insertar Empresa de prueba 
IF NOT EXISTS (SELECT 1 FROM EMPRESA WHERE Nombre = 'Phantom inc.')
BEGIN
    INSERT INTO EMPRESA (Nombre) VALUES ('Phantom inc.');
END
GO

-- 2. Insertar Usuario de prueba
IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE NombreUsuario = 'phantom_user')
BEGIN
    DECLARE @IdEmpresa INT;
    SELECT @IdEmpresa = Id FROM EMPRESA WHERE Nombre = 'Phantom inc.';

    DECLARE @IdPuesto INT;
    SELECT @IdPuesto = Id FROM PUESTO WHERE Nombre = 'Owner';

    DECLARE @IdArea INT;
    SELECT @IdArea = Id FROM AREA WHERE Nombre = 'Direccion';

    -- Insertamos el usuario
    INSERT INTO USUARIO (NombreUsuario, PasswordHash, Email, Nombre, Apellido, Activo, PermisoEscritura, IdPuesto, IdArea, IdEmpresa)
    VALUES ('phantom_user', '123', 'gasparin@gmail.com', 'Casper', 'Gasparin', 1, 1, @IdPuesto, @IdArea, @IdEmpresa);
END

--MODIFICACIONES, EJECUTARLAS SI O SI

ALTER TABLE USUARIO
ADD EmailVerificado BIT NOT NULL DEFAULT 0;
--UPDATE USUARIO SET EmailVerificado = 1 WHERE NombreUsuario = 'phantom_user'
UPDATE USUARIO SET EmailVerificado = 1 WHERE EmailVerificado = 0;

CREATE TABLE USUARIO_TOKEN(
    Id INT PRIMARY KEY IDENTITY(1,1),
    IdUsuario INT NOT NULL, 
    Token VARCHAR(200) NOT NULL, 
    Tipo VARCHAR(30) NOT NULL, 
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaExpiracion DATETIME NOT NULL,
    FechaUso DATETIME NULL,
    Usado BIT NOT NULL DEFAULT 0,

    FOREIGN KEY (IdUsuario) REFERENCES USUARIO(Id)
)

-- Puesto se le agrega idEmpresa null
alter table PUESTO add IdEmpresa INT NULL;
alter table PUESTO add CONSTRAINT FK_PUESTO_EMPRESA FOREIGN KEY (IdEmpresa) REFERENCES EMPRESA(Id);

-- Seniority + Usuario
CREATE TABLE SENIORITY (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(30) NOT NULL UNIQUE
);
GO

IF NOT EXISTS (SELECT 1 FROM SENIORITY WHERE Nombre = 'Junior')
    INSERT INTO SENIORITY (Nombre) VALUES ('Junior');

IF NOT EXISTS (SELECT 1 FROM SENIORITY WHERE Nombre = 'Semi Senior')
    INSERT INTO SENIORITY (Nombre) VALUES ('Semi Senior');

IF NOT EXISTS (SELECT 1 FROM SENIORITY WHERE Nombre = 'Senior')
    INSERT INTO SENIORITY (Nombre) VALUES ('Senior');

IF NOT EXISTS (SELECT 1 FROM SENIORITY WHERE Nombre = 'Lead')
    INSERT INTO SENIORITY (Nombre) VALUES ('Lead');
GO

ALTER TABLE USUARIO
ADD EsAdmin BIT NOT NULL CONSTRAINT DF_USUARIO_EsAdmin DEFAULT 0;
GO

ALTER TABLE USUARIO
ADD IdSeniority INT NULL;
GO

ALTER TABLE USUARIO
ADD CONSTRAINT FK_USUARIO_SENIORITY
FOREIGN KEY (IdSeniority) REFERENCES SENIORITY(Id);
GO

update USUARIO Set EsAdmin = 1 where Nombre = 'phantom_user';

GO


