USE GD1C2026;
GO

DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Aspectos;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Encuestas;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Items_Venta;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Ventas;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Medios_De_Pago;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Canales;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Clientes;
GO

DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Aspecto;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Encuesta;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].item_venta;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Venta;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Medio_de_pago;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Canal_de_venta;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Cliente;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.schemas WHERE name = 'PROYECTO_S.E.L.F'
)
BEGIN
    EXEC('CREATE SCHEMA [PROYECTO_S.E.L.F]');
END;
GO

CREATE TABLE [PROYECTO_S.E.L.F].Cliente (
    Clie_id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    Clie_id_direccion INT NULL,
    Clie_nombre VARCHAR(255),
    Clie_dni VARCHAR(255)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Canal_de_venta (
    Canal_id_canal INT IDENTITY(1,1) PRIMARY KEY,
    Canal_tipo VARCHAR(255)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Medio_de_pago (
    Medio_id INT IDENTITY(1,1) PRIMARY KEY,
    Medio_pago_name VARCHAR(255)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Venta (
    Vent_nro_de_venta BIGINT PRIMARY KEY,
    Vent_id_canal INT NULL,
    Vent_id_medio_de_pago INT NULL,
    Vent_id_cliente INT NOT NULL,
    Vent_id_agente INT NULL,
    Vent_id_propuesta INT NULL,
    Vent_fecha DATE,
    Vent_subtotal DECIMAL(18,2),
    Vent_descuento DECIMAL(18,2),
    Vent_importe_total DECIMAL(18,2),

    CONSTRAINT FK_Venta_Canal
        FOREIGN KEY (Vent_id_canal)
        REFERENCES [PROYECTO_S.E.L.F].Canal_de_venta(Canal_id_canal),

    CONSTRAINT FK_Venta_MedioPago
        FOREIGN KEY (Vent_id_medio_de_pago)
        REFERENCES [PROYECTO_S.E.L.F].Medio_de_pago(Medio_id),

    CONSTRAINT FK_Venta_Cliente
        FOREIGN KEY (Vent_id_cliente)
        REFERENCES [PROYECTO_S.E.L.F].Cliente(Clie_id_cliente)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].item_venta (
    IVenta_id_item_venta INT IDENTITY(1,1) PRIMARY KEY,
    IVenta_nro_de_venta BIGINT NOT NULL,
    IVenta_codigo_reserva VARCHAR(255),

    CONSTRAINT FK_ItemVenta_Venta
        FOREIGN KEY (IVenta_nro_de_venta)
        REFERENCES [PROYECTO_S.E.L.F].Venta(Vent_nro_de_venta)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Encuesta (
    Encu_id_encuesta BIGINT PRIMARY KEY,
    Encu_id_cliente INT NOT NULL,
    Encu_id_agente INT NULL,
    Encu_fecha DATE,
    Encu_comentario VARCHAR(MAX),

    CONSTRAINT FK_Encuesta_Cliente
        FOREIGN KEY (Encu_id_cliente)
        REFERENCES [PROYECTO_S.E.L.F].Cliente(Clie_id_cliente)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Aspecto (
    Aspe_id_aspecto INT IDENTITY(1,1) PRIMARY KEY,
    Aspe_id_encuesta BIGINT NOT NULL,
    Aspe_nombre VARCHAR(255),
    Aspe_puntaje INT,

    CONSTRAINT FK_Aspecto_Encuesta
        FOREIGN KEY (Aspe_id_encuesta)
        REFERENCES [PROYECTO_S.E.L.F].Encuesta(Encu_id_encuesta)
);
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Clientes
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Cliente (
        Clie_nombre,
        Clie_dni
    )
    SELECT DISTINCT
        CONCAT(Cliente_Nombre, ' ', Cliente_Apellido),
        Cliente_Dni
    FROM gd_esquema.Maestra
    WHERE Cliente_Dni IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Canales
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Canal_de_venta (
        Canal_tipo
    )
    SELECT DISTINCT
        Venta_Canal_Venta
    FROM gd_esquema.Maestra
    WHERE Venta_Canal_Venta IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Medios_De_Pago
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Medio_de_pago (
        Medio_pago_name
    )
    SELECT DISTINCT
        Venta_Medio_Pago
    FROM gd_esquema.Maestra
    WHERE Venta_Medio_Pago IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Ventas
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Venta (
        Vent_nro_de_venta,
        Vent_id_canal,
        Vent_id_medio_de_pago,
        Vent_id_cliente,
        Vent_fecha,
        Vent_subtotal,
        Vent_descuento,
        Vent_importe_total
    )
    SELECT
        m.Venta_Nro_Venta,
        MAX(c.Canal_id_canal),
        MAX(mp.Medio_id),
        MAX(cl.Clie_id_cliente),
        MAX(m.Venta_Fecha_Venta),
        MAX(m.Venta_Subtotal),
        MAX(m.Venta_Descuento),
        MAX(m.Venta_Importe_Total)
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Cliente cl
        ON cl.Clie_dni = m.Cliente_Dni
    LEFT JOIN [PROYECTO_S.E.L.F].Canal_de_venta c
        ON c.Canal_tipo = m.Venta_Canal_Venta
    LEFT JOIN [PROYECTO_S.E.L.F].Medio_de_pago mp
        ON mp.Medio_pago_name = m.Venta_Medio_Pago
    WHERE m.Venta_Nro_Venta IS NOT NULL
    GROUP BY m.Venta_Nro_Venta;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Items_Venta
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].item_venta (
        IVenta_nro_de_venta,
        IVenta_codigo_reserva
    )
    SELECT DISTINCT
        Venta_Nro_Venta,
        Detalle_Venta_Vuelo_Cod_Reserva
    FROM gd_esquema.Maestra
    WHERE Venta_Nro_Venta IS NOT NULL
      AND Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL

    UNION

    SELECT DISTINCT
        Venta_Nro_Venta,
        Detalle_Venta_Hospedaje_Cod_Reserva
    FROM gd_esquema.Maestra
    WHERE Venta_Nro_Venta IS NOT NULL
      AND Detalle_Venta_Hospedaje_Cod_Reserva IS NOT NULL

    UNION

    SELECT DISTINCT
        Venta_Nro_Venta,
        Detalle_Venta_Excursion_Cod_Reserva
    FROM gd_esquema.Maestra
    WHERE Venta_Nro_Venta IS NOT NULL
      AND Detalle_Venta_Excursion_Cod_Reserva IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Encuestas
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Encuesta (
        Encu_id_encuesta,
        Encu_id_cliente,
        Encu_fecha,
        Encu_comentario
    )
    SELECT
        m.Encuesta_Codigo_Encuesta,
        MAX(cl.Clie_id_cliente),
        MAX(m.Encuesta_Fecha_Encuesta),
        MAX(CAST(m.Encuesta_Comentarios AS VARCHAR(MAX)))
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Cliente cl
        ON cl.Clie_dni = m.Cliente_Dni
    WHERE m.Encuesta_Codigo_Encuesta IS NOT NULL
    GROUP BY m.Encuesta_Codigo_Encuesta;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Aspectos
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Aspecto (
        Aspe_id_encuesta,
        Aspe_nombre,
        Aspe_puntaje
    )
    SELECT DISTINCT
        m.Encuesta_Codigo_Encuesta,
        m.Aspecto_Aspecto,
        m.Detalle_Encuesta_Puntaje
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Encuesta e
        ON e.Encu_id_encuesta = m.Encuesta_Codigo_Encuesta
    WHERE m.Encuesta_Codigo_Encuesta IS NOT NULL
      AND m.Aspecto_Aspecto IS NOT NULL;
END;
GO

EXEC [PROYECTO_S.E.L.F].Migrar_Clientes;
EXEC [PROYECTO_S.E.L.F].Migrar_Canales;
EXEC [PROYECTO_S.E.L.F].Migrar_Medios_De_Pago;
EXEC [PROYECTO_S.E.L.F].Migrar_Ventas;
EXEC [PROYECTO_S.E.L.F].Migrar_Items_Venta;
EXEC [PROYECTO_S.E.L.F].Migrar_Encuestas;
EXEC [PROYECTO_S.E.L.F].Migrar_Aspectos;
GO