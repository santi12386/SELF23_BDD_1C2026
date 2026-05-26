USE GD1C2026;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'PROYECTO_S.E.L.F')
BEGIN
    EXEC('CREATE SCHEMA [PROYECTO_S.E.L.F]');
END;
GO

DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Habitacion;
GO
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Prop_estado;
GO
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Propuesta;
GO
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Hospedaje;
GO


CREATE TABLE [PROYECTO_S.E.L.F].Hospedaje (
    Hosp_id_hospedaje INT IDENTITY(1,1) NOT NULL,
    Hosp_id_direccion NVARCHAR(100) NOT NULL,
    Hosp_hora_checkin TIME NOT NULL, 
    Hosp_hora_checkout TIME NOT NULL,

    CONSTRAINT PK_Hospedaje PRIMARY KEY (Hosp_id_hospedaje)
);
GO

INSERT INTO [PROYECTO_S.E.L.F].Hospedaje (
    Hosp_id_direccion,
    Hosp_hora_checkin,
    Hosp_hora_checkout
)
SELECT DISTINCT
    Hospedaje_Pais,
    Hospedaje_Check_In,
    Hospedaje_Check_Out
FROM [GD1C2026].[gd_esquema].[Maestra]
WHERE Hospedaje_Check_In IS NOT NULL
  AND Hospedaje_Check_Out IS NOT NULL
  AND Hospedaje_Pais IS NOT NULL;
GO

SELECT * FROM [PROYECTO_S.E.L.F].Hospedaje;
GO


CREATE TABLE [PROYECTO_S.E.L.F].Habitacion (
    Habi_id_habitacion INT IDENTITY(1,1) NOT NULL,
    Habi_id_hospedaje INT,
    Habi_tipo_hospedaje NVARCHAR(100) NOT NULL,
    Habi_precio DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_Habitacion PRIMARY KEY (Habi_id_habitacion),

    CONSTRAINT FK_Hospedaje FOREIGN KEY (Habi_id_hospedaje) REFERENCES [PROYECTO_S.E.L.F].Hospedaje(Hosp_id_hospedaje)
);
GO

INSERT INTO [PROYECTO_S.E.L.F].Habitacion (
    Habi_tipo_hospedaje,
    Habi_precio
)
SELECT DISTINCT
    Habitacion_Nombre,
    Habitacion_Precio_Noche
FROM [GD1C2026].[gd_esquema].[Maestra]
WHERE Habitacion_Nombre IS NOT NULL
  AND Habitacion_Descripcion IS NOT NULL
  AND Habitacion_Precio_Noche IS NOT NULL;
GO

SELECT * FROM [PROYECTO_S.E.L.F].Habitacion;
GO


CREATE TABLE [PROYECTO_S.E.L.F].Propuesta (
    Prop_id_propuesta INT IDENTITY(1,1) NOT NULL,
    Prop_id_solicitud INT NOT NULL,
    Prop_id_agente INT NOT NULL,

    Prop_estado NVARCHAR(50) NOT NULL,
    Prop_fecha DATETIME NOT NULL,
    Prop_fecha_vigencia DATETIME NOT NULL,
    Prop_fecha_inicio DATETIME NOT NULL,
    Prop_fecha_hasta DATETIME NOT NULL,
    Prop_subtotal DECIMAL(18,2) NOT NULL,
    Prop_descuento DECIMAL(18,2) NOT NULL,
    Prop_importe_total DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_Propuesta PRIMARY KEY (Prop_id_propuesta)
);
GO

INSERT INTO [PROYECTO_S.E.L.F].Propuesta (
    Prop_id_solicitud,
    Prop_id_agente,
    Prop_estado,
    Prop_fecha,
    Prop_fecha_vigencia,
    Prop_fecha_inicio,
    Prop_fecha_hasta,
    Prop_subtotal,
    Prop_descuento,
    Prop_importe_total
)
SELECT
    Solicitud_Nro_Solicitud,
    Agente_Legajo,
    Propuesta_Estado,
    Propuesta_Fecha_Emision,
    Propuesta_Vigencia_Hasta,
    Propuesta_Fecha_Desde,
    Propuesta_Fecha_Hasta,
    Propuesta_Subtotal,
    Propuesta_Descuento,
    Propuesta_Importe_Total
FROM [GD1C2026].[gd_esquema].[Maestra]
WHERE Propuesta_Nro_Propuesta IS NOT NULL
  AND Propuesta_Estado IS NOT NULL
  AND Propuesta_Fecha_Emision IS NOT NULL
  AND Propuesta_Fecha_Desde IS NOT NULL
  AND Propuesta_Fecha_Hasta IS NOT NULL
  AND Propuesta_Subtotal IS NOT NULL
  AND Propuesta_Descuento IS NOT NULL
  AND Propuesta_Importe_Total IS NOT NULL
  AND Agente_Legajo IS NOT NULL;
GO

SELECT * FROM [PROYECTO_S.E.L.F].Propuesta;
GO

CREATE TABLE [PROYECTO_S.E.L.F].Prop_estado (
    P_Est_Estado NVARCHAR(50) NOT NULL,
    P_Est_Nombre INT,

    CONSTRAINT PK_Prop_estado PRIMARY KEY (P_Est_Nombre)
);
GO

INSERT INTO [PROYECTO_S.E.L.F].Prop_estado (
    P_Est_Estado,
    P_Est_Nombre
)
SELECT DISTINCT
    Propuesta_Estado,
    Propuesta_Nro_Propuesta
FROM [GD1C2026].[gd_esquema].[Maestra]
WHERE Propuesta_Estado IS NOT NULL;
GO

SELECT * FROM [PROYECTO_S.E.L.F].Prop_estado;
GO