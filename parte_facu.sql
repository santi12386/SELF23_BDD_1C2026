USE GD1C2026;
GO


IF OBJECT_ID('[PROYECTO_S.E.L.F].Item_detalle', 'U') IS NOT NULL DROP TABLE [PROYECTO_S.E.L.F].Item_detalle;
IF OBJECT_ID('[PROYECTO_S.E.L.F].Item_hospedaje', 'U') IS NOT NULL DROP TABLE [PROYECTO_S.E.L.F].Item_hospedaje;
IF OBJECT_ID('[PROYECTO_S.E.L.F].Propuesta', 'U') IS NOT NULL DROP TABLE [PROYECTO_S.E.L.F].Propuesta;
IF OBJECT_ID('[PROYECTO_S.E.L.F].Prop_estado', 'U') IS NOT NULL DROP TABLE [PROYECTO_S.E.L.F].Prop_estado;
IF OBJECT_ID('[PROYECTO_S.E.L.F].Habitacion', 'U') IS NOT NULL DROP TABLE [PROYECTO_S.E.L.F].Habitacion;
IF OBJECT_ID('[PROYECTO_S.E.L.F].Hospedaje', 'U') IS NOT NULL DROP TABLE [PROYECTO_S.E.L.F].Hospedaje;


DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Hospedaje;
GO
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Habitacion;
GO
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Prop_estado;
GO
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Propuesta;
GO
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_hospedaje;
GO
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_detalle;
GO

CREATE TABLE [PROYECTO_S.E.L.F].Hospedaje (
    Hosp_id_hospedaje INT IDENTITY(1,1) PRIMARY KEY,
    Hosp_id_direccion NVARCHAR(100) NOT NULL,
    Hosp_hora_checkin TIME NOT NULL, 
    Hosp_hora_checkout TIME NOT NULL
);

CREATE TABLE [PROYECTO_S.E.L.F].Habitacion (
    Habi_id_habitacion INT IDENTITY(1,1) PRIMARY KEY,
    Habi_id_hospedaje INT FOREIGN KEY REFERENCES [PROYECTO_S.E.L.F].Hospedaje(Hosp_id_hospedaje),
    Habi_tipo_hospedaje NVARCHAR(100) NOT NULL,
    Habi_precio DECIMAL(18,2) NOT NULL
);

CREATE TABLE [PROYECTO_S.E.L.F].Prop_estado (
    P_Est_Estado NVARCHAR(50) NOT NULL,
    P_Est_Nombre INT PRIMARY KEY
);

CREATE TABLE [PROYECTO_S.E.L.F].Propuesta (
    Prop_id_propuesta INT IDENTITY(1,1) PRIMARY KEY,
    Prop_id_solicitud INT NOT NULL,
    Prop_id_agente INT NOT NULL,
    Prop_estado NVARCHAR(50) NOT NULL, 
    Prop_fecha DATETIME NOT NULL,
    Prop_fecha_vigencia DATETIME NOT NULL,
    Prop_fecha_inicio DATETIME NOT NULL,
    Prop_fecha_hasta DATETIME NOT NULL,
    Prop_subtotal DECIMAL(18,2) NOT NULL,
    Prop_descuento DECIMAL(18,2) NOT NULL,
    Prop_importe_total DECIMAL(18,2) NOT NULL
);

CREATE TABLE [PROYECTO_S.E.L.F].Item_hospedaje (
    I_Hospedaje_id_item INT IDENTITY(1,1) PRIMARY KEY,
    I_Hospedaje_id_habitacion INT FOREIGN KEY REFERENCES [PROYECTO_S.E.L.F].Habitacion(Habi_id_habitacion),
    I_Hospedaje_fecha_ingreso DATETIME NOT NULL,
    I_Hospedaje_fecha_egreso DATETIME NOT NULL,
    I_Hospedaje_cant_personas INT NOT NULL,
    I_Hospedaje_precio_unit DECIMAL(18,2) NOT NULL,
    I_Hospedaje_subtotal DECIMAL(18,2) NOT NULL
);

CREATE TABLE [PROYECTO_S.E.L.F].Item_detalle (
    I_Detalle_id_item_detalle INT IDENTITY(1,1) PRIMARY KEY,
    I_Detalle_id_propuesta INT FOREIGN KEY REFERENCES [PROYECTO_S.E.L.F].Propuesta(Prop_id_propuesta), 
    I_Detalle_id_hospedaje INT FOREIGN KEY REFERENCES [PROYECTO_S.E.L.F].Item_hospedaje(I_Hospedaje_id_item)
);
GO


CREATE PROCEDURE [PROYECTO_S.E.L.F].InsertHospedaje
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Hospedaje (
        Hosp_id_direccion,
        Hosp_hora_checkin,
        Hosp_hora_checkout
    )
    SELECT DISTINCT
        Hospedaje_Direccion,
        Hospedaje_Check_In,
        Hospedaje_Check_Out
    FROM gd_esquema.Maestra
    WHERE Hospedaje_Check_In IS NOT NULL
      AND Hospedaje_Check_Out IS NOT NULL
      AND Hospedaje_Pais IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].InsertHabitacion
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Habitacion (
        Habi_id_hospedaje,
        Habi_tipo_hospedaje,
        Habi_precio
    )
    SELECT DISTINCT
        H.Hosp_id_hospedaje,
        M.Habitacion_Nombre,
        M.Habitacion_Precio_Noche
    FROM gd_esquema.Maestra M
    INNER JOIN [PROYECTO_S.E.L.F].Hospedaje H 
        ON M.Hospedaje_Direccion = H.Hosp_id_direccion
       AND M.Hospedaje_Check_In = H.Hosp_hora_checkin
       AND M.Hospedaje_Check_Out = H.Hosp_hora_checkout
    WHERE M.Habitacion_Nombre IS NOT NULL
      AND M.Habitacion_Descripcion IS NOT NULL
      AND M.Habitacion_Precio_Noche IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].InsertPropEstado
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Prop_estado (
        P_Est_Estado,
        P_Est_Nombre
    )
    SELECT DISTINCT
        Propuesta_Estado,
        Propuesta_Nro_Propuesta
    FROM gd_esquema.Maestra
    WHERE Propuesta_Estado IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].InsertPropuesta
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Propuesta (
        Prop_id_solicitud, Prop_id_agente, Prop_estado, Prop_fecha, 
        Prop_fecha_vigencia, Prop_fecha_inicio, Prop_fecha_hasta, 
        Prop_subtotal, Prop_descuento, Prop_importe_total
    )
    SELECT DISTINCT 
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
    FROM gd_esquema.Maestra
    WHERE Propuesta_Nro_Propuesta IS NOT NULL
      AND Propuesta_Estado IS NOT NULL
      AND Propuesta_Fecha_Emision IS NOT NULL
      AND Propuesta_Fecha_Desde IS NOT NULL
      AND Propuesta_Fecha_Hasta IS NOT NULL
      AND Propuesta_Subtotal IS NOT NULL
      AND Propuesta_Descuento IS NOT NULL
      AND Propuesta_Importe_Total IS NOT NULL
      AND Agente_Legajo IS NOT NULL;
END;
GO


CREATE PROCEDURE [PROYECTO_S.E.L.F].InsertItemHospedaje
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Item_hospedaje (
        I_Hospedaje_id_habitacion,
        I_Hospedaje_fecha_ingreso,
        I_Hospedaje_fecha_egreso,
        I_Hospedaje_cant_personas,
        I_Hospedaje_precio_unit,
        I_Hospedaje_subtotal
    )
    SELECT DISTINCT
        H.Habi_id_habitacion,
        M.Detalle_Propuesta_Hospedaje_Fecha_Desde,
        M.Detalle_Propuesta_Hospedaje_Fecha_Hasta,
        M.Detalle_Propuesta_Hospedaje_Cant,
        M.Detalle_Propuesta_Hospedaje_Precio,
        M.Detalle_Propuesta_Hospedaje_Subtotal
    FROM gd_esquema.Maestra M
    INNER JOIN [PROYECTO_S.E.L.F].Hospedaje Hosp 
        ON M.Hospedaje_Direccion = Hosp.Hosp_id_direccion
    INNER JOIN [PROYECTO_S.E.L.F].Habitacion H 
        ON Hosp.Hosp_id_hospedaje = H.Habi_id_hospedaje
       AND M.Habitacion_Nombre = H.Habi_tipo_hospedaje
    WHERE M.Detalle_Propuesta_Hospedaje_Fecha_Desde IS NOT NULL
      AND M.Detalle_Propuesta_Hospedaje_Fecha_Hasta IS NOT NULL
      AND M.Detalle_Propuesta_Hospedaje_Cant IS NOT NULL
      AND M.Detalle_Propuesta_Hospedaje_Precio IS NOT NULL
      AND M.Detalle_Propuesta_Hospedaje_Subtotal IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].InsertItemDetalle
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Item_detalle (
        I_Detalle_id_propuesta,
        I_Detalle_id_hospedaje
    )
    SELECT DISTINCT
        p.Prop_id_propuesta,
        ih.I_Hospedaje_id_item
    FROM gd_esquema.Maestra m
    JOIN [PROYECTO_S.E.L.F].Propuesta p 
        ON m.Solicitud_Nro_Solicitud = p.Prop_id_solicitud 
       AND m.Agente_Legajo = p.Prop_id_agente 
       AND m.Propuesta_Fecha_Emision = p.Prop_fecha
    JOIN [PROYECTO_S.E.L.F].Hospedaje hosp 
        ON m.Hospedaje_Direccion = hosp.Hosp_id_direccion
    JOIN [PROYECTO_S.E.L.F].Habitacion hab 
        ON hosp.Hosp_id_hospedaje = hab.Habi_id_hospedaje
       AND m.Habitacion_Nombre = hab.Habi_tipo_hospedaje
    JOIN [PROYECTO_S.E.L.F].Item_hospedaje ih 
        ON hab.Habi_id_habitacion = ih.I_Hospedaje_id_habitacion
       AND m.Detalle_Propuesta_Hospedaje_Fecha_Desde = ih.I_Hospedaje_fecha_ingreso
       AND m.Detalle_Propuesta_Hospedaje_Fecha_Hasta = ih.I_Hospedaje_fecha_egreso
       AND m.Detalle_Propuesta_Hospedaje_Cant = ih.I_Hospedaje_cant_personas
       AND m.Detalle_Propuesta_Hospedaje_Precio = ih.I_Hospedaje_precio_unit
    WHERE m.Propuesta_Nro_Propuesta IS NOT NULL 
      AND m.Detalle_Propuesta_Hospedaje_Fecha_Desde IS NOT NULL;
END;
GO




GO

EXEC [PROYECTO_S.E.L.F].InsertHospedaje;
EXEC [PROYECTO_S.E.L.F].InsertPropEstado;
EXEC [PROYECTO_S.E.L.F].InsertHabitacion;
EXEC [PROYECTO_S.E.L.F].InsertPropuesta;
EXEC [PROYECTO_S.E.L.F].InsertItemHospedaje;
EXEC [PROYECTO_S.E.L.F].InsertItemDetalle;
GO

SELECT * FROM [PROYECTO_S.E.L.F].Hospedaje;
SELECT * FROM [PROYECTO_S.E.L.F].Habitacion;
SELECT * FROM [PROYECTO_S.E.L.F].Prop_estado;
SELECT * FROM [PROYECTO_S.E.L.F].Propuesta;
SELECT * FROM [PROYECTO_S.E.L.F].Item_hospedaje;
SELECT * FROM [PROYECTO_S.E.L.F].Item_detalle;
GO