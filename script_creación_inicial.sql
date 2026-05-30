USE GD1C2026;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'PROYECTO_S.E.L.F')
BEGIN
    EXEC('CREATE SCHEMA [PROYECTO_S.E.L.F]');
END;
GO

DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Aspectos;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Encuestas;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Items_Vuelo;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Items_Excursion;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Items_Hospedaje_Propuesta;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Item_Detalle_Propuesta;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Items_Venta;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Ventas;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Medios_De_Pago;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Canales;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Propuestas;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Estados_Propuesta;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Habitaciones;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Hospedajes;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Vuelos;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Aeropuertos;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Codigos_Pais;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Aerolineas;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Excursiones;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Proveedores;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Items_Ciudad;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Sol_Cotizaciones;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Ciudades;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Clientes;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Agentes;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Agencias;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Direcciones;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Localidades;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Provincias;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_Paises;
GO

  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Aspecto;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Encuesta;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_vuelo;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_excursion;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_detalle;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_detalle_propuesta;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_hospedaje;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_venta;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Venta;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Propuesta;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Prop_estado;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Habitacion;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Hospedaje;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Vuelo;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Aeropuerto;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Codigo_pais;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Aerolinea;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Excursion;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Proveedor;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Item_ciudad;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Sol_cotizacion;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Ciudad;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Medio_de_pago;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Canal_de_venta;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Agente;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Agencia;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Cliente;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Direccion;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Localidad;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Provincia;
  DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].Pais;
GO

CREATE TABLE [PROYECTO_S.E.L.F].Pais (
    Pais_id INT IDENTITY(1,1) PRIMARY KEY,
    Pais_nombre NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Provincia (
    Prov_id INT IDENTITY(1,1) PRIMARY KEY,
    Prov_id_pais INT NOT NULL,
    Prov_nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Provincia UNIQUE (Prov_id_pais, Prov_nombre),
    CONSTRAINT FK_Provincia_Pais FOREIGN KEY (Prov_id_pais)
        REFERENCES [PROYECTO_S.E.L.F].Pais(Pais_id)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Localidad (
    Loca_id_localidad INT IDENTITY(1,1) PRIMARY KEY,
    Loca_id_provincia INT NOT NULL,
    Loca_nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Localidad UNIQUE (Loca_id_provincia, Loca_nombre),
    CONSTRAINT FK_Localidad_Provincia FOREIGN KEY (Loca_id_provincia)
        REFERENCES [PROYECTO_S.E.L.F].Provincia(Prov_id)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Direccion (
    Dire_id_direccion INT IDENTITY(1,1) PRIMARY KEY,
    Dire_id_localidad INT NOT NULL,
    Dire_calle NVARCHAR(200) NOT NULL,
    Dire_numero NVARCHAR(20) NOT NULL,
    CONSTRAINT UQ_Direccion UNIQUE (Dire_id_localidad, Dire_calle, Dire_numero),
    CONSTRAINT FK_Direccion_Localidad FOREIGN KEY (Dire_id_localidad)
        REFERENCES [PROYECTO_S.E.L.F].Localidad(Loca_id_localidad)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Cliente (
    Clie_id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    Clie_id_direccion INT NULL,
    Clie_nombre NVARCHAR(100) NOT NULL,
    Clie_apellido NVARCHAR(100) NULL,
    Clie_dni NVARCHAR(20) NULL,
    Clie_fecha_nac DATE NULL,
    Clie_telefono NVARCHAR(50) NULL,
    Clie_mail NVARCHAR(100) NULL,
    CONSTRAINT FK_Cliente_Direccion FOREIGN KEY (Clie_id_direccion)
        REFERENCES [PROYECTO_S.E.L.F].Direccion(Dire_id_direccion)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Agencia (
    Agen_id_agencia BIGINT PRIMARY KEY,
    Agen_id_direccion INT NOT NULL,
    Agen_telefono NVARCHAR(50) NULL,
    Agen_mail NVARCHAR(100) NULL,
    CONSTRAINT FK_Agencia_Direccion FOREIGN KEY (Agen_id_direccion)
        REFERENCES [PROYECTO_S.E.L.F].Direccion(Dire_id_direccion)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Agente (
    Agt_id_agente INT IDENTITY(1,1) PRIMARY KEY,
    Agt_id_agencia BIGINT NOT NULL,
    Agt_id_direccion INT NOT NULL,
    Agt_dni NVARCHAR(20) NULL,
    Agt_nombre NVARCHAR(100) NOT NULL,
    Agt_apellido NVARCHAR(100) NOT NULL,
    Agt_fecha_nac DATE NULL,
    Agt_telefono NVARCHAR(50) NULL,
    Agt_mail NVARCHAR(100) NULL,
    Agt_legajo BIGINT NOT NULL UNIQUE,
    CONSTRAINT FK_Agente_Agencia FOREIGN KEY (Agt_id_agencia)
        REFERENCES [PROYECTO_S.E.L.F].Agencia(Agen_id_agencia),
    CONSTRAINT FK_Agente_Direccion FOREIGN KEY (Agt_id_direccion)
        REFERENCES [PROYECTO_S.E.L.F].Direccion(Dire_id_direccion)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Ciudad (
    Ciud_id_ciudad INT IDENTITY(1,1) PRIMARY KEY,
    Ciud_nombre NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Sol_cotizacion (
    Sol_id_solicitud BIGINT PRIMARY KEY,
    Sol_id_cliente INT NOT NULL,
    Sol_id_agente INT NOT NULL,
    Sol_fecha DATE NOT NULL,
    Sol_fecha_inicio DATE NULL,
    Sol_fecha_fin DATE NULL,
    Sol_cant_pasajeros INT NOT NULL,
    Sol_observaciones NVARCHAR(255) NULL,
    Sol_presupuesto DECIMAL(18,2) NULL,
    CONSTRAINT FK_SolCotizacion_Cliente FOREIGN KEY (Sol_id_cliente)
        REFERENCES [PROYECTO_S.E.L.F].Cliente(Clie_id_cliente),
    CONSTRAINT FK_SolCotizacion_Agente FOREIGN KEY (Sol_id_agente)
        REFERENCES [PROYECTO_S.E.L.F].Agente(Agt_id_agente)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Item_ciudad (
    I_Ciudad_id_ciudad INT NOT NULL,
    I_Ciudad_id_solicitud BIGINT NOT NULL,
    I_Ciudad_cant_dias INT NOT NULL,
    I_Ciudad_item_observaciones NVARCHAR(255) NULL,
    CONSTRAINT PK_Item_ciudad PRIMARY KEY (I_Ciudad_id_ciudad, I_Ciudad_id_solicitud),
    CONSTRAINT FK_ItemCiudad_Ciudad FOREIGN KEY (I_Ciudad_id_ciudad)
        REFERENCES [PROYECTO_S.E.L.F].Ciudad(Ciud_id_ciudad),
    CONSTRAINT FK_ItemCiudad_SolCotizacion FOREIGN KEY (I_Ciudad_id_solicitud)
        REFERENCES [PROYECTO_S.E.L.F].Sol_cotizacion(Sol_id_solicitud)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Proveedor (
    Prov_id INT IDENTITY(1,1) PRIMARY KEY,
    Prov_nombre NVARCHAR(255) NOT NULL,
    Prov_mail NVARCHAR(255) NULL,
    Prov_telefono NVARCHAR(255) NULL,
    CONSTRAINT UQ_Proveedor UNIQUE (Prov_nombre, Prov_mail, Prov_telefono)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Excursion (
    Excu_id_excursion INT IDENTITY(1,1) PRIMARY KEY,
    Excu_id_proveedor INT NOT NULL,
    Excu_nombre NVARCHAR(255) NOT NULL,
    Excu_horario DATETIME NULL,
    Excu_duracion INT NULL,
    CONSTRAINT UQ_Excursion UNIQUE (Excu_id_proveedor, Excu_nombre, Excu_horario, Excu_duracion),
    CONSTRAINT FK_Excursion_Proveedor FOREIGN KEY (Excu_id_proveedor)
        REFERENCES [PROYECTO_S.E.L.F].Proveedor(Prov_id)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Aerolinea (
    AeroL_id_aerolinea INT IDENTITY(1,1) PRIMARY KEY,
    AeroL_nombre NVARCHAR(255) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Codigo_pais (
    Cod_pais_id INT IDENTITY(1,1) PRIMARY KEY,
    Cod_pais_nombre NVARCHAR(255) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Aeropuerto (
    AeroP_id_aeropuerto INT IDENTITY(1,1) PRIMARY KEY,
    AeroP_id_pais INT NULL,
    AeroP_id_cod_pais INT NULL,
    AeroP_nombre NVARCHAR(255) NOT NULL UNIQUE,
    CONSTRAINT FK_Aeropuerto_Pais FOREIGN KEY (AeroP_id_pais)
        REFERENCES [PROYECTO_S.E.L.F].Pais(Pais_id),
    CONSTRAINT FK_Aeropuerto_CodigoPais FOREIGN KEY (AeroP_id_cod_pais)
        REFERENCES [PROYECTO_S.E.L.F].Codigo_pais(Cod_pais_id)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Vuelo (
    Vuel_id_vuelo INT IDENTITY(1,1) PRIMARY KEY,
    Vuel_id_aeropuerto_salida INT NOT NULL,
    Vuel_id_aeropuerto_llegada INT NOT NULL,
    Vuel_id_aerolinea INT NOT NULL,
    Vuel_fecha_salida DATETIME NULL,
    Vuel_fecha_llegada DATETIME NULL,
    CONSTRAINT UQ_Vuelo UNIQUE (
        Vuel_id_aeropuerto_salida,
        Vuel_id_aeropuerto_llegada,
        Vuel_id_aerolinea,
        Vuel_fecha_salida,
        Vuel_fecha_llegada
    ),
    CONSTRAINT FK_Vuelo_Aeropuerto_Salida FOREIGN KEY (Vuel_id_aeropuerto_salida)
        REFERENCES [PROYECTO_S.E.L.F].Aeropuerto(AeroP_id_aeropuerto),
    CONSTRAINT FK_Vuelo_Aeropuerto_Llegada FOREIGN KEY (Vuel_id_aeropuerto_llegada)
        REFERENCES [PROYECTO_S.E.L.F].Aeropuerto(AeroP_id_aeropuerto),
    CONSTRAINT FK_Vuelo_Aerolinea FOREIGN KEY (Vuel_id_aerolinea)
        REFERENCES [PROYECTO_S.E.L.F].Aerolinea(AeroL_id_aerolinea)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Hospedaje (
    Hosp_id_hospedaje INT IDENTITY(1,1) PRIMARY KEY,
    Hosp_id_direccion INT NOT NULL,
    Hosp_hora_checkin TIME NULL,
    Hosp_hora_checkout TIME NULL,
    CONSTRAINT UQ_Hospedaje UNIQUE (Hosp_id_direccion, Hosp_hora_checkin, Hosp_hora_checkout),
    CONSTRAINT FK_Hospedaje_Direccion FOREIGN KEY (Hosp_id_direccion)
        REFERENCES [PROYECTO_S.E.L.F].Direccion(Dire_id_direccion)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Habitacion (
    Habi_id_habitacion INT IDENTITY(1,1) PRIMARY KEY,
    Habi_id_hospedaje INT NOT NULL,
    Habi_nombre NVARCHAR(100) NOT NULL,
    Habi_descripcion NVARCHAR(255) NULL,
    Habi_precio DECIMAL(18,2) NOT NULL,
    CONSTRAINT UQ_Habitacion UNIQUE (Habi_id_hospedaje, Habi_nombre, Habi_precio),
    CONSTRAINT FK_Habitacion_Hospedaje FOREIGN KEY (Habi_id_hospedaje)
        REFERENCES [PROYECTO_S.E.L.F].Hospedaje(Hosp_id_hospedaje)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Prop_estado (
    P_Est_id_estado INT IDENTITY(1,1) PRIMARY KEY,
    P_Est_nombre NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Propuesta (
    Prop_id_propuesta BIGINT PRIMARY KEY,
    Prop_id_solicitud BIGINT NOT NULL,
    Prop_id_agente INT NOT NULL,
    Prop_id_estado INT NOT NULL,
    Prop_fecha DATETIME NOT NULL,
    Prop_fecha_vigencia DATETIME NULL,
    Prop_fecha_inicio DATETIME NULL,
    Prop_fecha_hasta DATETIME NULL,
    Prop_subtotal DECIMAL(18,2) NULL,
    Prop_descuento DECIMAL(18,2) NULL,
    Prop_importe_total DECIMAL(18,2) NULL,
    CONSTRAINT FK_Propuesta_Solicitud FOREIGN KEY (Prop_id_solicitud)
        REFERENCES [PROYECTO_S.E.L.F].Sol_cotizacion(Sol_id_solicitud),
    CONSTRAINT FK_Propuesta_Agente FOREIGN KEY (Prop_id_agente)
        REFERENCES [PROYECTO_S.E.L.F].Agente(Agt_id_agente),
    CONSTRAINT FK_Propuesta_Estado FOREIGN KEY (Prop_id_estado)
        REFERENCES [PROYECTO_S.E.L.F].Prop_estado(P_Est_id_estado)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Canal_de_venta (
    Canal_id_canal INT IDENTITY(1,1) PRIMARY KEY,
    Canal_tipo NVARCHAR(255) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Medio_de_pago (
    Medio_id INT IDENTITY(1,1) PRIMARY KEY,
    Medio_pago_nombre NVARCHAR(255) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Venta (
    Vent_nro_de_venta BIGINT PRIMARY KEY,
    Vent_id_canal INT NULL,
    Vent_id_medio_de_pago INT NULL,
    Vent_id_cliente INT NOT NULL,
    Vent_id_agente INT NULL,
    Vent_id_propuesta BIGINT NULL,
    Vent_fecha DATE NULL,
    Vent_subtotal DECIMAL(18,2) NULL,
    Vent_descuento DECIMAL(18,2) NULL,
    Vent_importe_total DECIMAL(18,2) NULL,
    CONSTRAINT FK_Venta_Canal FOREIGN KEY (Vent_id_canal)
        REFERENCES [PROYECTO_S.E.L.F].Canal_de_venta(Canal_id_canal),
    CONSTRAINT FK_Venta_MedioPago FOREIGN KEY (Vent_id_medio_de_pago)
        REFERENCES [PROYECTO_S.E.L.F].Medio_de_pago(Medio_id),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (Vent_id_cliente)
        REFERENCES [PROYECTO_S.E.L.F].Cliente(Clie_id_cliente),
    CONSTRAINT FK_Venta_Agente FOREIGN KEY (Vent_id_agente)
        REFERENCES [PROYECTO_S.E.L.F].Agente(Agt_id_agente),
    CONSTRAINT FK_Venta_Propuesta FOREIGN KEY (Vent_id_propuesta)
        REFERENCES [PROYECTO_S.E.L.F].Propuesta(Prop_id_propuesta)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Item_venta (
    I_Venta_id_item_venta INT IDENTITY(1,1) PRIMARY KEY,
    I_Venta_nro_de_venta BIGINT NOT NULL,
    I_Venta_Tipo NVARCHAR(50) NOT NULL,
    I_Venta_codigo_reserva NVARCHAR(255) NULL,
    CONSTRAINT FK_ItemVenta_Venta FOREIGN KEY (I_Venta_nro_de_venta)
        REFERENCES [PROYECTO_S.E.L.F].Venta(Vent_nro_de_venta),
    CONSTRAINT UQ_ItemVenta UNIQUE (I_Venta_nro_de_venta, I_Venta_Tipo, I_Venta_codigo_reserva)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Item_hospedaje (
    I_Hospedaje_id_item INT IDENTITY(1,1) PRIMARY KEY,
    I_Hospedaje_id_habitacion INT NOT NULL,
    I_Hospedaje_fecha_ingreso DATETIME NOT NULL,
    I_Hospedaje_fecha_egreso DATETIME NOT NULL,
    I_Hospedaje_cant_personas INT NOT NULL,
    I_Hospedaje_precio_unit DECIMAL(18,2) NOT NULL,
    I_Hospedaje_subtotal DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_ItemHospedaje_Habitacion FOREIGN KEY (I_Hospedaje_id_habitacion)
        REFERENCES [PROYECTO_S.E.L.F].Habitacion(Habi_id_habitacion),
    CONSTRAINT UQ_ItemHospedaje UNIQUE (
        I_Hospedaje_id_habitacion,
        I_Hospedaje_fecha_ingreso,
        I_Hospedaje_fecha_egreso,
        I_Hospedaje_cant_personas,
        I_Hospedaje_precio_unit
    )
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Item_detalle (
    I_Detalle_id_item_detalle INT IDENTITY(1,1) PRIMARY KEY,
    I_Detalle_id_propuesta BIGINT NOT NULL,
    I_Detalle_Tipo NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_ItemDetalle_Propuesta FOREIGN KEY (I_Detalle_id_propuesta)
        REFERENCES [PROYECTO_S.E.L.F].Propuesta(Prop_id_propuesta),
    CONSTRAINT UQ_ItemDetalle UNIQUE (I_Detalle_id_propuesta, I_Detalle_Tipo)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Item_excursion (
    I_Excursion_id_item INT PRIMARY KEY,
    I_Excursion_id_excursion INT NOT NULL,
    I_Excursion_fecha DATETIME NULL,
    I_Excursion_cantidad INT NULL,
    I_Excursion_precio_unit DECIMAL(18,2) NULL,
    I_Excursion_subtotal DECIMAL(18,2) NULL,
    CONSTRAINT FK_ItemExcursion_ItemVenta FOREIGN KEY (I_Excursion_id_item)
        REFERENCES [PROYECTO_S.E.L.F].Item_venta(I_Venta_id_item_venta),
    CONSTRAINT FK_ItemExcursion_Excursion FOREIGN KEY (I_Excursion_id_excursion)
        REFERENCES [PROYECTO_S.E.L.F].Excursion(Excu_id_excursion)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Item_vuelo (
    I_Vuelo_id_item INT PRIMARY KEY,
    I_Vuelo_id_vuelo INT NOT NULL,
    I_Vuelo_cant_pasajes INT NULL,
    I_Vuelo_precio_unit DECIMAL(18,2) NULL,
    I_Vuelo_subtotal DECIMAL(18,2) NULL,
    CONSTRAINT FK_ItemVuelo_ItemVenta FOREIGN KEY (I_Vuelo_id_item)
        REFERENCES [PROYECTO_S.E.L.F].Item_venta(I_Venta_id_item_venta),
    CONSTRAINT FK_ItemVuelo_Vuelo FOREIGN KEY (I_Vuelo_id_vuelo)
        REFERENCES [PROYECTO_S.E.L.F].Vuelo(Vuel_id_vuelo)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Encuesta (
    Encu_id_encuesta BIGINT PRIMARY KEY,
    Encu_id_cliente INT NOT NULL,
    Encu_id_agente INT NULL,
    Encu_fecha DATE NULL,
    Encu_comentario NVARCHAR(MAX) NULL,
    CONSTRAINT FK_Encuesta_Cliente FOREIGN KEY (Encu_id_cliente)
        REFERENCES [PROYECTO_S.E.L.F].Cliente(Clie_id_cliente),
    CONSTRAINT FK_Encuesta_Agente FOREIGN KEY (Encu_id_agente)
        REFERENCES [PROYECTO_S.E.L.F].Agente(Agt_id_agente)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].Aspecto (
    Aspe_id_aspecto INT IDENTITY(1,1) PRIMARY KEY,
    Aspe_id_encuesta BIGINT NOT NULL,
    Aspe_nombre NVARCHAR(255) NOT NULL,
    Aspe_puntaje INT NULL,
    CONSTRAINT FK_Aspecto_Encuesta FOREIGN KEY (Aspe_id_encuesta)
        REFERENCES [PROYECTO_S.E.L.F].Encuesta(Encu_id_encuesta)
);
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Paises
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Pais (Pais_nombre)
    SELECT DISTINCT Pais_nombre
    FROM (
        SELECT Aeropuerto_Salida_Pais AS Pais_nombre FROM gd_esquema.Maestra
        UNION
        SELECT Aeropuerto_Llegada_Pais FROM gd_esquema.Maestra
        UNION
        SELECT Hospedaje_Pais FROM gd_esquema.Maestra
        UNION
        SELECT Aerolinea_Pais FROM gd_esquema.Maestra
        UNION
        SELECT N'Argentina'
    ) p
    WHERE p.Pais_nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Provincias
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Provincia (Prov_id_pais, Prov_nombre)
    SELECT DISTINCT
        p.Pais_id,
        src.Provincia
    FROM (
        SELECT m.Agencia_Provincia AS Provincia
        FROM gd_esquema.Maestra m
        WHERE m.Agencia_Provincia IS NOT NULL
        UNION
        SELECT m.Agente_Provincia
        FROM gd_esquema.Maestra m
        WHERE m.Agente_Provincia IS NOT NULL
        UNION
        SELECT m.Cliente_Provincia
        FROM gd_esquema.Maestra m
        WHERE m.Cliente_Provincia IS NOT NULL
    ) src
    INNER JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = N'Argentina';

    INSERT INTO [PROYECTO_S.E.L.F].Provincia (Prov_id_pais, Prov_nombre)
    SELECT
        p.Pais_id,
        N'Sin provincia'
    FROM [PROYECTO_S.E.L.F].Pais p
    WHERE NOT EXISTS (
        SELECT 1
        FROM [PROYECTO_S.E.L.F].Provincia pr
        WHERE pr.Prov_id_pais = p.Pais_id
          AND pr.Prov_nombre = N'Sin provincia'
    );
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Localidades
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Localidad (Loca_id_provincia, Loca_nombre)
    SELECT DISTINCT
        pr.Prov_id,
        src.Localidad
    FROM (
        SELECT m.Agencia_Provincia AS Provincia, m.Agencia_Localidad AS Localidad
        FROM gd_esquema.Maestra m
        WHERE m.Agencia_Localidad IS NOT NULL
          AND m.Agencia_Provincia IS NOT NULL
        UNION
        SELECT m.Agente_Provincia, m.Agente_Localidad
        FROM gd_esquema.Maestra m
        WHERE m.Agente_Localidad IS NOT NULL
          AND m.Agente_Provincia IS NOT NULL
        UNION
        SELECT m.Cliente_Provincia, m.Cliente_Localidad
        FROM gd_esquema.Maestra m
        WHERE m.Cliente_Localidad IS NOT NULL
          AND m.Cliente_Provincia IS NOT NULL
    ) src
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_nombre = src.Provincia;

    INSERT INTO [PROYECTO_S.E.L.F].Localidad (Loca_id_provincia, Loca_nombre)
    SELECT DISTINCT
        pr.Prov_id,
        src.Localidad
    FROM (
        SELECT m.Hospedaje_Pais AS Pais, m.Hospedaje_Ciudad AS Localidad
        FROM gd_esquema.Maestra m
        WHERE m.Hospedaje_Pais IS NOT NULL
          AND m.Hospedaje_Ciudad IS NOT NULL
        UNION
        SELECT m.Aeropuerto_Salida_Pais, m.Aeropuerto_Salida_Ciudad
        FROM gd_esquema.Maestra m
        WHERE m.Aeropuerto_Salida_Pais IS NOT NULL
          AND m.Aeropuerto_Salida_Ciudad IS NOT NULL
        UNION
        SELECT m.Aeropuerto_Llegada_Pais, m.Aeropuerto_Llegada_Ciudad
        FROM gd_esquema.Maestra m
        WHERE m.Aeropuerto_Llegada_Pais IS NOT NULL
          AND m.Aeropuerto_Llegada_Ciudad IS NOT NULL
    ) src
    INNER JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = src.Pais
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_id_pais = p.Pais_id
       AND pr.Prov_nombre = N'Sin provincia';
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Direcciones
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Direccion (Dire_id_localidad, Dire_calle, Dire_numero)
    SELECT DISTINCT
        l.Loca_id_localidad,
        src.Direccion,
        N'0'
    FROM (
        SELECT m.Agencia_Provincia AS Provincia, m.Agencia_Localidad AS Localidad, m.Agencia_Direccion AS Direccion
        FROM gd_esquema.Maestra m
        WHERE m.Agencia_Direccion IS NOT NULL
          AND m.Agencia_Localidad IS NOT NULL
          AND m.Agencia_Provincia IS NOT NULL
        UNION
        SELECT m.Agente_Provincia, m.Agente_Localidad, m.Agente_Direccion
        FROM gd_esquema.Maestra m
        WHERE m.Agente_Direccion IS NOT NULL
          AND m.Agente_Localidad IS NOT NULL
          AND m.Agente_Provincia IS NOT NULL
        UNION
        SELECT m.Cliente_Provincia, m.Cliente_Localidad, m.Cliente_Direccion
        FROM gd_esquema.Maestra m
        WHERE m.Cliente_Direccion IS NOT NULL
          AND m.Cliente_Localidad IS NOT NULL
          AND m.Cliente_Provincia IS NOT NULL
    ) src
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_nombre = src.Provincia
    INNER JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = src.Localidad;

    INSERT INTO [PROYECTO_S.E.L.F].Direccion (Dire_id_localidad, Dire_calle, Dire_numero)
    SELECT DISTINCT
        l.Loca_id_localidad,
        m.Hospedaje_Direccion,
        N'0'
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = m.Hospedaje_Pais
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_id_pais = p.Pais_id
       AND pr.Prov_nombre = N'Sin provincia'
    INNER JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = m.Hospedaje_Ciudad
    WHERE m.Hospedaje_Direccion IS NOT NULL
      AND m.Hospedaje_Pais IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [PROYECTO_S.E.L.F].Direccion d
          WHERE d.Dire_id_localidad = l.Loca_id_localidad
            AND d.Dire_calle = m.Hospedaje_Direccion
            AND d.Dire_numero = N'0'
      );

    INSERT INTO [PROYECTO_S.E.L.F].Direccion (Dire_id_localidad, Dire_calle, Dire_numero)
    SELECT DISTINCT
        l.Loca_id_localidad,
        m.Aeropuerto_Salida_Descripcion,
        N'0'
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = m.Aeropuerto_Salida_Pais
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_id_pais = p.Pais_id
       AND pr.Prov_nombre = N'Sin provincia'
    INNER JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = m.Aeropuerto_Salida_Ciudad
    WHERE m.Aeropuerto_Salida_Descripcion IS NOT NULL
      AND m.Aeropuerto_Salida_Pais IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [PROYECTO_S.E.L.F].Direccion d
          WHERE d.Dire_id_localidad = l.Loca_id_localidad
            AND d.Dire_calle = m.Aeropuerto_Salida_Descripcion
            AND d.Dire_numero = N'0'
      );

    INSERT INTO [PROYECTO_S.E.L.F].Direccion (Dire_id_localidad, Dire_calle, Dire_numero)
    SELECT DISTINCT
        l.Loca_id_localidad,
        m.Aeropuerto_Llegada_Descripcion,
        N'0'
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = m.Aeropuerto_Llegada_Pais
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_id_pais = p.Pais_id
       AND pr.Prov_nombre = N'Sin provincia'
    INNER JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = m.Aeropuerto_Llegada_Ciudad
    WHERE m.Aeropuerto_Llegada_Descripcion IS NOT NULL
      AND m.Aeropuerto_Llegada_Pais IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [PROYECTO_S.E.L.F].Direccion d
          WHERE d.Dire_id_localidad = l.Loca_id_localidad
            AND d.Dire_calle = m.Aeropuerto_Llegada_Descripcion
            AND d.Dire_numero = N'0'
      );

END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Agencias
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Agencia (Agen_id_agencia, Agen_id_direccion, Agen_telefono, Agen_mail)
    SELECT DISTINCT
        m.Agencia_Nro_Agencia,
        d.Dire_id_direccion,
        m.Agencia_Telefono,
        m.Agencia_Mail
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_nombre = m.Agencia_Provincia
    INNER JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = m.Agencia_Localidad
    INNER JOIN [PROYECTO_S.E.L.F].Direccion d
        ON d.Dire_id_localidad = l.Loca_id_localidad
       AND d.Dire_calle = m.Agencia_Direccion
       AND d.Dire_numero = N'0'
    WHERE m.Agencia_Nro_Agencia IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Agentes
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Agente (
        Agt_id_agencia,
        Agt_id_direccion,
        Agt_dni,
        Agt_nombre,
        Agt_apellido,
        Agt_fecha_nac,
        Agt_telefono,
        Agt_mail,
        Agt_legajo
    )
    SELECT
        MAX(a.Agen_id_agencia),
        MAX(d.Dire_id_direccion),
        MAX(m.Agente_Dni),
        MAX(m.Agente_Nombre),
        MAX(m.Agente_Apellido),
        MAX(m.Agente_Fecha_Nac),
        MAX(m.Agente_Telefono),
        MAX(m.Agente_Mail),
        m.Agente_Legajo
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Agencia a ON a.Agen_id_agencia = m.Agencia_Nro_Agencia
    LEFT JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_nombre = m.Agente_Localidad
    LEFT JOIN [PROYECTO_S.E.L.F].Direccion d
        ON d.Dire_id_localidad = l.Loca_id_localidad
       AND d.Dire_calle = m.Agente_Direccion
       AND d.Dire_numero = N'0'
    WHERE m.Agente_Legajo IS NOT NULL
    GROUP BY m.Agente_Legajo;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Clientes
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Cliente (
        Clie_id_direccion,
        Clie_nombre,
        Clie_apellido,
        Clie_dni,
        Clie_fecha_nac,
        Clie_telefono,
        Clie_mail
    )
    SELECT DISTINCT
        d.Dire_id_direccion,
        m.Cliente_Nombre,
        m.Cliente_Apellido,
        m.Cliente_Dni,
        m.Cliente_Fecha_Nac,
        m.Cliente_Tel,
        m.Cliente_Mail
    FROM gd_esquema.Maestra m
    LEFT JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_nombre = m.Cliente_Provincia
    LEFT JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = m.Cliente_Localidad
    LEFT JOIN [PROYECTO_S.E.L.F].Direccion d
        ON d.Dire_id_localidad = l.Loca_id_localidad
       AND d.Dire_calle = m.Cliente_Direccion
       AND d.Dire_numero = N'0'
    WHERE m.Cliente_Nombre IS NOT NULL
       OR m.Cliente_Apellido IS NOT NULL
       OR m.Cliente_Dni IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Ciudades
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Ciudad (Ciud_nombre)
    SELECT DISTINCT m.Detalle_Solicitud_Ciudad
    FROM gd_esquema.Maestra m
    WHERE m.Detalle_Solicitud_Ciudad IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Sol_Cotizaciones
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Sol_cotizacion (
        Sol_id_solicitud,
        Sol_id_cliente,
        Sol_id_agente,
        Sol_fecha,
        Sol_fecha_inicio,
        Sol_fecha_fin,
        Sol_cant_pasajeros,
        Sol_observaciones,
        Sol_presupuesto
    )
    SELECT DISTINCT
        m.Solicitud_Nro_Solicitud,
        c.Clie_id_cliente,
        a.Agt_id_agente,
        m.Solicitud_Fecha_Solicitud,
        m.Solicitud_Fecha_Inicio_Tentativa,
        m.Solicitud_Fecha_Fin_Tentativa,
        m.Solicitud_Cant_Pax,
        m.Solicitud_Observaciones,
        m.Solicitud_Presupuesto_Estimado
    FROM gd_esquema.Maestra m
    LEFT JOIN [PROYECTO_S.E.L.F].Provincia prc
        ON prc.Prov_nombre = m.Cliente_Provincia
    LEFT JOIN [PROYECTO_S.E.L.F].Localidad lc
        ON lc.Loca_id_provincia = prc.Prov_id
       AND lc.Loca_nombre = m.Cliente_Localidad
    LEFT JOIN [PROYECTO_S.E.L.F].Direccion dc
        ON dc.Dire_id_localidad = lc.Loca_id_localidad
       AND dc.Dire_calle = m.Cliente_Direccion
       AND dc.Dire_numero = N'0'
    INNER JOIN [PROYECTO_S.E.L.F].Cliente c
        ON ISNULL(c.Clie_nombre, N'') = ISNULL(m.Cliente_Nombre, N'')
       AND ISNULL(c.Clie_apellido, N'') = ISNULL(m.Cliente_Apellido, N'')
       AND ISNULL(c.Clie_dni, N'') = ISNULL(m.Cliente_Dni, N'')
       AND ISNULL(c.Clie_telefono, N'') = ISNULL(m.Cliente_Tel, N'')
       AND ISNULL(c.Clie_mail, N'') = ISNULL(m.Cliente_Mail, N'')
       AND ISNULL(c.Clie_fecha_nac, '1900-01-01') = ISNULL(m.Cliente_Fecha_Nac, '1900-01-01')
       AND ISNULL(c.Clie_id_direccion, -1) = ISNULL(dc.Dire_id_direccion, -1)
    INNER JOIN [PROYECTO_S.E.L.F].Agente a
        ON a.Agt_legajo = m.Agente_Legajo
    WHERE m.Solicitud_Nro_Solicitud IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Items_Ciudad
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Item_ciudad (
        I_Ciudad_id_ciudad,
        I_Ciudad_id_solicitud,
        I_Ciudad_cant_dias,
        I_Ciudad_item_observaciones
    )
    SELECT DISTINCT
        c.Ciud_id_ciudad,
        s.Sol_id_solicitud,
        m.Detalle_Solicitud_Cant_Dias_Aprox,
        m.Detalle_Solicitud_Observaciones
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Ciudad c
        ON c.Ciud_nombre = m.Detalle_Solicitud_Ciudad
    INNER JOIN [PROYECTO_S.E.L.F].Sol_cotizacion s
        ON s.Sol_id_solicitud = m.Solicitud_Nro_Solicitud
    WHERE m.Detalle_Solicitud_Ciudad IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Proveedores
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Proveedor (
        Prov_nombre,
        Prov_mail,
        Prov_telefono
    )
    SELECT DISTINCT
        m.Proveedor_Nombre,
        m.Proveedor_Mail,
        m.Proveedor_Telefono
    FROM gd_esquema.Maestra m
    WHERE m.Proveedor_Nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Excursiones
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Excursion (
        Excu_id_proveedor,
        Excu_nombre,
        Excu_horario,
        Excu_duracion
    )
    SELECT DISTINCT
        p.Prov_id,
        m.Excursion_Nombre,
        TRY_CAST(m.Excursion_Horario AS DATETIME),
        m.Excursion_Duracion
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Proveedor p
        ON p.Prov_nombre = m.Proveedor_Nombre
       AND ISNULL(p.Prov_mail, N'') = ISNULL(m.Proveedor_Mail, N'')
       AND ISNULL(p.Prov_telefono, N'') = ISNULL(m.Proveedor_Telefono, N'')
    WHERE m.Excursion_Nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Aerolineas
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Aerolinea (AeroL_nombre)
    SELECT DISTINCT m.Aerolinea_Nombre
    FROM gd_esquema.Maestra m
    WHERE m.Aerolinea_Nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Codigos_Pais
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Codigo_pais (Cod_pais_nombre)
    SELECT DISTINCT Codigo
    FROM (
        SELECT Aeropuerto_Salida_Pais AS Codigo FROM gd_esquema.Maestra
        UNION
        SELECT Aeropuerto_Llegada_Pais FROM gd_esquema.Maestra
    ) x
    WHERE x.Codigo IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Aeropuertos
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Aeropuerto (
        AeroP_id_pais,
        AeroP_id_cod_pais,
        AeroP_nombre
    )
    SELECT DISTINCT
        p.Pais_id,
        cp.Cod_pais_id,
        m.Aeropuerto_Salida_Descripcion
    FROM gd_esquema.Maestra m
    LEFT JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = m.Aeropuerto_Salida_Pais
    LEFT JOIN [PROYECTO_S.E.L.F].Codigo_pais cp
        ON cp.Cod_pais_nombre = m.Aeropuerto_Salida_Pais
    WHERE m.Aeropuerto_Salida_Descripcion IS NOT NULL

    UNION

    SELECT DISTINCT
        p.Pais_id,
        cp.Cod_pais_id,
        m.Aeropuerto_Llegada_Descripcion
    FROM gd_esquema.Maestra m
    LEFT JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = m.Aeropuerto_Llegada_Pais
    LEFT JOIN [PROYECTO_S.E.L.F].Codigo_pais cp
        ON cp.Cod_pais_nombre = m.Aeropuerto_Llegada_Pais
    WHERE m.Aeropuerto_Llegada_Descripcion IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Vuelos
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Vuelo (
        Vuel_id_aeropuerto_salida,
        Vuel_id_aeropuerto_llegada,
        Vuel_id_aerolinea,
        Vuel_fecha_salida,
        Vuel_fecha_llegada
    )
    SELECT DISTINCT
        aps.AeroP_id_aeropuerto,
        apl.AeroP_id_aeropuerto,
        al.AeroL_id_aerolinea,
        m.Vuelo_Fecha_Salida,
        m.Vuelo_Fecha_Llegada
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Aeropuerto aps
        ON aps.AeroP_nombre = m.Aeropuerto_Salida_Descripcion
    INNER JOIN [PROYECTO_S.E.L.F].Aeropuerto apl
        ON apl.AeroP_nombre = m.Aeropuerto_Llegada_Descripcion
    INNER JOIN [PROYECTO_S.E.L.F].Aerolinea al
        ON al.AeroL_nombre = m.Aerolinea_Nombre
    WHERE m.Vuelo_Fecha_Salida IS NOT NULL
      AND m.Vuelo_Fecha_Llegada IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Hospedajes
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Hospedaje (
        Hosp_id_direccion,
        Hosp_hora_checkin,
        Hosp_hora_checkout
    )
    SELECT DISTINCT
        d.Dire_id_direccion,
        m.Hospedaje_Check_In,
        m.Hospedaje_Check_Out
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = m.Hospedaje_Pais
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_id_pais = p.Pais_id
       AND pr.Prov_nombre = N'Sin provincia'
    INNER JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = m.Hospedaje_Ciudad
    INNER JOIN [PROYECTO_S.E.L.F].Direccion d
        ON d.Dire_id_localidad = l.Loca_id_localidad
       AND d.Dire_calle = m.Hospedaje_Direccion
       AND d.Dire_numero = N'0'
    WHERE m.Hospedaje_Direccion IS NOT NULL
      AND m.Hospedaje_Pais IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Habitaciones
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Habitacion (
        Habi_id_hospedaje,
        Habi_nombre,
        Habi_descripcion,
        Habi_precio
    )
    SELECT DISTINCT
        h.Hosp_id_hospedaje,
        m.Habitacion_Nombre,
        m.Habitacion_Descripcion,
        m.Habitacion_Precio_Noche
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = m.Hospedaje_Pais
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_id_pais = p.Pais_id
       AND pr.Prov_nombre = N'Sin provincia'
    INNER JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = m.Hospedaje_Ciudad
    INNER JOIN [PROYECTO_S.E.L.F].Direccion d
        ON d.Dire_id_localidad = l.Loca_id_localidad
       AND d.Dire_calle = m.Hospedaje_Direccion
       AND d.Dire_numero = N'0'
    INNER JOIN [PROYECTO_S.E.L.F].Hospedaje h
        ON h.Hosp_id_direccion = d.Dire_id_direccion
       AND ISNULL(h.Hosp_hora_checkin, '00:00:00') = ISNULL(m.Hospedaje_Check_In, '00:00:00')
       AND ISNULL(h.Hosp_hora_checkout, '00:00:00') = ISNULL(m.Hospedaje_Check_Out, '00:00:00')
    WHERE m.Habitacion_Nombre IS NOT NULL
      AND m.Habitacion_Precio_Noche IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Estados_Propuesta
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Prop_estado (P_Est_nombre)
    SELECT DISTINCT m.Propuesta_Estado
    FROM gd_esquema.Maestra m
    WHERE m.Propuesta_Estado IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Propuestas
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Propuesta (
        Prop_id_propuesta,
        Prop_id_solicitud,
        Prop_id_agente,
        Prop_id_estado,
        Prop_fecha,
        Prop_fecha_vigencia,
        Prop_fecha_inicio,
        Prop_fecha_hasta,
        Prop_subtotal,
        Prop_descuento,
        Prop_importe_total
    )
    SELECT DISTINCT
        m.Propuesta_Nro_Propuesta,
        m.Solicitud_Nro_Solicitud,
        a.Agt_id_agente,
        pe.P_Est_id_estado,
        m.Propuesta_Fecha_Emision,
        m.Propuesta_Vigencia_Hasta,
        m.Propuesta_Fecha_Desde,
        m.Propuesta_Fecha_Hasta,
        m.Propuesta_Subtotal,
        m.Propuesta_Descuento,
        m.Propuesta_Importe_Total
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Agente a
        ON a.Agt_legajo = m.Agente_Legajo
    INNER JOIN [PROYECTO_S.E.L.F].Prop_estado pe
        ON pe.P_Est_nombre = m.Propuesta_Estado
    INNER JOIN [PROYECTO_S.E.L.F].Sol_cotizacion s
        ON s.Sol_id_solicitud = m.Solicitud_Nro_Solicitud
    WHERE m.Propuesta_Nro_Propuesta IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Canales
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Canal_de_venta (Canal_tipo)
    SELECT DISTINCT m.Venta_Canal_Venta
    FROM gd_esquema.Maestra m
    WHERE m.Venta_Canal_Venta IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Medios_De_Pago
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Medio_de_pago (Medio_pago_nombre)
    SELECT DISTINCT m.Venta_Medio_Pago
    FROM gd_esquema.Maestra m
    WHERE m.Venta_Medio_Pago IS NOT NULL;
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
        Vent_id_agente,
        Vent_id_propuesta,
        Vent_fecha,
        Vent_subtotal,
        Vent_descuento,
        Vent_importe_total
    )
    SELECT
        m.Venta_Nro_Venta,
        MAX(ca.Canal_id_canal),
        MAX(mp.Medio_id),
        MAX(cl.Clie_id_cliente),
        MAX(ag.Agt_id_agente),
        MAX(p.Prop_id_propuesta),
        MAX(m.Venta_Fecha_Venta),
        MAX(m.Venta_Subtotal),
        MAX(m.Venta_Descuento),
        MAX(m.Venta_Importe_Total)
    FROM gd_esquema.Maestra m
    LEFT JOIN [PROYECTO_S.E.L.F].Provincia prc
        ON prc.Prov_nombre = m.Cliente_Provincia
    LEFT JOIN [PROYECTO_S.E.L.F].Localidad lc
        ON lc.Loca_id_provincia = prc.Prov_id
       AND lc.Loca_nombre = m.Cliente_Localidad
    LEFT JOIN [PROYECTO_S.E.L.F].Direccion dc
        ON dc.Dire_id_localidad = lc.Loca_id_localidad
       AND dc.Dire_calle = m.Cliente_Direccion
       AND dc.Dire_numero = N'0'
    INNER JOIN [PROYECTO_S.E.L.F].Cliente cl
        ON ISNULL(cl.Clie_nombre, N'') = ISNULL(m.Cliente_Nombre, N'')
       AND ISNULL(cl.Clie_apellido, N'') = ISNULL(m.Cliente_Apellido, N'')
       AND ISNULL(cl.Clie_dni, N'') = ISNULL(m.Cliente_Dni, N'')
       AND ISNULL(cl.Clie_telefono, N'') = ISNULL(m.Cliente_Tel, N'')
       AND ISNULL(cl.Clie_mail, N'') = ISNULL(m.Cliente_Mail, N'')
       AND ISNULL(cl.Clie_fecha_nac, '1900-01-01') = ISNULL(m.Cliente_Fecha_Nac, '1900-01-01')
       AND ISNULL(cl.Clie_id_direccion, -1) = ISNULL(dc.Dire_id_direccion, -1)
    LEFT JOIN [PROYECTO_S.E.L.F].Agente ag
        ON ag.Agt_legajo = m.Agente_Legajo
    LEFT JOIN [PROYECTO_S.E.L.F].Canal_de_venta ca
        ON ca.Canal_tipo = m.Venta_Canal_Venta
    LEFT JOIN [PROYECTO_S.E.L.F].Medio_de_pago mp
        ON mp.Medio_pago_nombre = m.Venta_Medio_Pago
    LEFT JOIN [PROYECTO_S.E.L.F].Propuesta p
        ON p.Prop_id_propuesta = m.Propuesta_Nro_Propuesta
    WHERE m.Venta_Nro_Venta IS NOT NULL
    GROUP BY m.Venta_Nro_Venta;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Items_Venta
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Item_venta (
        I_Venta_nro_de_venta,
        I_Venta_Tipo,
        I_Venta_codigo_reserva
    )
    SELECT DISTINCT
        m.Venta_Nro_Venta,
        N'vuelo',
        CAST(m.Detalle_Venta_Vuelo_Cod_Reserva AS NVARCHAR(255))
    FROM gd_esquema.Maestra m
    WHERE m.Venta_Nro_Venta IS NOT NULL
      AND m.Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL

    UNION

    SELECT DISTINCT
        m.Venta_Nro_Venta,
        N'hospedaje',
        CAST(m.Detalle_Venta_Hospedaje_Cod_Reserva AS NVARCHAR(255))
    FROM gd_esquema.Maestra m
    WHERE m.Venta_Nro_Venta IS NOT NULL
      AND m.Detalle_Venta_Hospedaje_Cod_Reserva IS NOT NULL

    UNION

    SELECT DISTINCT
        m.Venta_Nro_Venta,
        N'excursion',
        CAST(m.Detalle_Venta_Excursion_Cod_Reserva AS NVARCHAR(255))
    FROM gd_esquema.Maestra m
    WHERE m.Venta_Nro_Venta IS NOT NULL
      AND m.Detalle_Venta_Excursion_Cod_Reserva IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Items_Hospedaje_Propuesta
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
        h.Habi_id_habitacion,
        m.Detalle_Propuesta_Hospedaje_Fecha_Desde,
        m.Detalle_Propuesta_Hospedaje_Fecha_Hasta,
        m.Detalle_Propuesta_Hospedaje_Cant,
        m.Detalle_Propuesta_Hospedaje_Precio,
        m.Detalle_Propuesta_Hospedaje_Subtotal
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Pais p
        ON p.Pais_nombre = m.Hospedaje_Pais
    INNER JOIN [PROYECTO_S.E.L.F].Provincia pr
        ON pr.Prov_id_pais = p.Pais_id
       AND pr.Prov_nombre = N'Sin provincia'
    INNER JOIN [PROYECTO_S.E.L.F].Localidad l
        ON l.Loca_id_provincia = pr.Prov_id
       AND l.Loca_nombre = m.Hospedaje_Ciudad
    INNER JOIN [PROYECTO_S.E.L.F].Direccion d
        ON d.Dire_id_localidad = l.Loca_id_localidad
       AND d.Dire_calle = m.Hospedaje_Direccion
       AND d.Dire_numero = N'0'
    INNER JOIN [PROYECTO_S.E.L.F].Hospedaje ho
        ON ho.Hosp_id_direccion = d.Dire_id_direccion
    INNER JOIN [PROYECTO_S.E.L.F].Habitacion h
        ON h.Habi_id_hospedaje = ho.Hosp_id_hospedaje
       AND h.Habi_nombre = m.Habitacion_Nombre
    WHERE m.Detalle_Propuesta_Hospedaje_Fecha_Desde IS NOT NULL
      AND m.Detalle_Propuesta_Hospedaje_Fecha_Hasta IS NOT NULL
      AND m.Detalle_Propuesta_Hospedaje_Cant IS NOT NULL
      AND m.Detalle_Propuesta_Hospedaje_Precio IS NOT NULL
      AND m.Detalle_Propuesta_Hospedaje_Subtotal IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Item_Detalle_Propuesta
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Item_detalle(
        I_Detalle_id_propuesta,
        I_Detalle_tipo
    )
    SELECT DISTINCT
        p.Prop_id_propuesta,
        N'hospedaje'
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Propuesta p
        ON p.Prop_id_propuesta = m.Propuesta_Nro_Propuesta
    WHERE m.Propuesta_Nro_Propuesta IS NOT NULL
      AND (
          m.Detalle_Propuesta_Hospedaje_Fecha_Desde IS NOT NULL
          OR m.Detalle_Venta_Hospedaje_Cod_Reserva IS NOT NULL
      )

    UNION

    SELECT DISTINCT
        p.Prop_id_propuesta,
        N'vuelo'
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Propuesta p
        ON p.Prop_id_propuesta = m.Propuesta_Nro_Propuesta
    WHERE m.Propuesta_Nro_Propuesta IS NOT NULL
      AND m.Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL

END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Items_Excursion
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Item_excursion (
        I_Excursion_id_item,
        I_Excursion_id_excursion,
        I_Excursion_fecha,
        I_Excursion_cantidad,
        I_Excursion_precio_unit,
        I_Excursion_subtotal
    )
    SELECT DISTINCT
        iv.I_Venta_id_item_venta,
        e.Excu_id_excursion,
        m.Detalle_Venta_Excursion_Fecha_Reserva,
        m.Detalle_Venta_Excursion_Cant,
        m.Detalle_Venta_Excursion_Precio_Unitario,
        m.Detalle_Venta_Excursion_Subtotal
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Item_venta iv
        ON iv.I_Venta_nro_de_venta = m.Venta_Nro_Venta
       AND iv.I_Venta_Tipo = N'excursion'
       AND iv.I_Venta_codigo_reserva = CAST(m.Detalle_Venta_Excursion_Cod_Reserva AS NVARCHAR(255))
    INNER JOIN [PROYECTO_S.E.L.F].Proveedor p
        ON p.Prov_nombre = m.Proveedor_Nombre
       AND ISNULL(p.Prov_mail, N'') = ISNULL(m.Proveedor_Mail, N'')
       AND ISNULL(p.Prov_telefono, N'') = ISNULL(m.Proveedor_Telefono, N'')
    INNER JOIN [PROYECTO_S.E.L.F].Excursion e
        ON e.Excu_id_proveedor = p.Prov_id
       AND e.Excu_nombre = m.Excursion_Nombre
       AND ISNULL(e.Excu_horario, '1900-01-01') = ISNULL(TRY_CAST(m.Excursion_Horario AS DATETIME), '1900-01-01')
       AND ISNULL(e.Excu_duracion, -1) = ISNULL(m.Excursion_Duracion, -1)
    WHERE m.Detalle_Venta_Excursion_Cod_Reserva IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Items_Vuelo
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Item_vuelo (
        I_Vuelo_id_item,
        I_Vuelo_id_vuelo,
        I_Vuelo_cant_pasajes,
        I_Vuelo_precio_unit,
        I_Vuelo_subtotal
    )
    SELECT DISTINCT
        iv.I_Venta_id_item_venta,
        v.Vuel_id_vuelo,
        m.Detalle_Venta_Vuelo_Cantidad_Pasajes,
        m.Detalle_Venta_Vuelo_Precio_Unitario,
        m.Detalle_Venta_Vuelo_Subtotal
    FROM gd_esquema.Maestra m
    INNER JOIN [PROYECTO_S.E.L.F].Item_venta iv
        ON iv.I_Venta_nro_de_venta = m.Venta_Nro_Venta
       AND iv.I_Venta_Tipo = N'vuelo'
       AND iv.I_Venta_codigo_reserva = CAST(m.Detalle_Venta_Vuelo_Cod_Reserva AS NVARCHAR(255))
    INNER JOIN [PROYECTO_S.E.L.F].Aeropuerto aps
        ON aps.AeroP_nombre = m.Aeropuerto_Salida_Descripcion
    INNER JOIN [PROYECTO_S.E.L.F].Aeropuerto apl
        ON apl.AeroP_nombre = m.Aeropuerto_Llegada_Descripcion
    INNER JOIN [PROYECTO_S.E.L.F].Aerolinea al
        ON al.AeroL_nombre = m.Aerolinea_Nombre
    INNER JOIN [PROYECTO_S.E.L.F].Vuelo v
        ON v.Vuel_id_aeropuerto_salida = aps.AeroP_id_aeropuerto
       AND v.Vuel_id_aeropuerto_llegada = apl.AeroP_id_aeropuerto
       AND v.Vuel_id_aerolinea = al.AeroL_id_aerolinea
       AND ISNULL(v.Vuel_fecha_salida, '1900-01-01') = ISNULL(m.Vuelo_Fecha_Salida, '1900-01-01')
       AND ISNULL(v.Vuel_fecha_llegada, '1900-01-01') = ISNULL(m.Vuelo_Fecha_Llegada, '1900-01-01')
    WHERE m.Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_Encuestas
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].Encuesta (
        Encu_id_encuesta,
        Encu_id_cliente,
        Encu_id_agente,
        Encu_fecha,
        Encu_comentario
    )
    SELECT DISTINCT
        m.Encuesta_Codigo_Encuesta,
        cl.Clie_id_cliente,
        ag.Agt_id_agente,
        m.Encuesta_Fecha_Encuesta,
        CAST(m.Encuesta_Comentarios AS NVARCHAR(MAX))
    FROM gd_esquema.Maestra m
    LEFT JOIN [PROYECTO_S.E.L.F].Provincia prc
        ON prc.Prov_nombre = m.Cliente_Provincia
    LEFT JOIN [PROYECTO_S.E.L.F].Localidad lc
        ON lc.Loca_id_provincia = prc.Prov_id
       AND lc.Loca_nombre = m.Cliente_Localidad
    LEFT JOIN [PROYECTO_S.E.L.F].Direccion dc
        ON dc.Dire_id_localidad = lc.Loca_id_localidad
       AND dc.Dire_calle = m.Cliente_Direccion
       AND dc.Dire_numero = N'0'
    INNER JOIN [PROYECTO_S.E.L.F].Cliente cl
        ON ISNULL(cl.Clie_nombre, N'') = ISNULL(m.Cliente_Nombre, N'')
       AND ISNULL(cl.Clie_apellido, N'') = ISNULL(m.Cliente_Apellido, N'')
       AND ISNULL(cl.Clie_dni, N'') = ISNULL(m.Cliente_Dni, N'')
       AND ISNULL(cl.Clie_telefono, N'') = ISNULL(m.Cliente_Tel, N'')
       AND ISNULL(cl.Clie_mail, N'') = ISNULL(m.Cliente_Mail, N'')
       AND ISNULL(cl.Clie_fecha_nac, '1900-01-01') = ISNULL(m.Cliente_Fecha_Nac, '1900-01-01')
       AND ISNULL(cl.Clie_id_direccion, -1) = ISNULL(dc.Dire_id_direccion, -1)
    LEFT JOIN [PROYECTO_S.E.L.F].Agente ag
        ON ag.Agt_legajo = m.Agente_Legajo
    WHERE m.Encuesta_Codigo_Encuesta IS NOT NULL;
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

EXEC [PROYECTO_S.E.L.F].Migrar_Paises;
EXEC [PROYECTO_S.E.L.F].Migrar_Provincias;
EXEC [PROYECTO_S.E.L.F].Migrar_Localidades;
EXEC [PROYECTO_S.E.L.F].Migrar_Direcciones;
EXEC [PROYECTO_S.E.L.F].Migrar_Agencias;
EXEC [PROYECTO_S.E.L.F].Migrar_Agentes;
EXEC [PROYECTO_S.E.L.F].Migrar_Clientes;
EXEC [PROYECTO_S.E.L.F].Migrar_Ciudades;
EXEC [PROYECTO_S.E.L.F].Migrar_Sol_Cotizaciones;
EXEC [PROYECTO_S.E.L.F].Migrar_Items_Ciudad;
EXEC [PROYECTO_S.E.L.F].Migrar_Proveedores;
EXEC [PROYECTO_S.E.L.F].Migrar_Excursiones;
EXEC [PROYECTO_S.E.L.F].Migrar_Aerolineas;
EXEC [PROYECTO_S.E.L.F].Migrar_Codigos_Pais;
EXEC [PROYECTO_S.E.L.F].Migrar_Aeropuertos;
EXEC [PROYECTO_S.E.L.F].Migrar_Vuelos;
EXEC [PROYECTO_S.E.L.F].Migrar_Hospedajes;
EXEC [PROYECTO_S.E.L.F].Migrar_Habitaciones;
EXEC [PROYECTO_S.E.L.F].Migrar_Estados_Propuesta;
EXEC [PROYECTO_S.E.L.F].Migrar_Propuestas;
EXEC [PROYECTO_S.E.L.F].Migrar_Canales;
EXEC [PROYECTO_S.E.L.F].Migrar_Medios_De_Pago;
EXEC [PROYECTO_S.E.L.F].Migrar_Ventas;
EXEC [PROYECTO_S.E.L.F].Migrar_Items_Venta;
EXEC [PROYECTO_S.E.L.F].Migrar_Items_Hospedaje_Propuesta;
EXEC [PROYECTO_S.E.L.F].Migrar_Item_Detalle_Propuesta;
EXEC [PROYECTO_S.E.L.F].Migrar_Items_Excursion;
EXEC [PROYECTO_S.E.L.F].Migrar_Items_Vuelo;
EXEC [PROYECTO_S.E.L.F].Migrar_Encuestas;
EXEC [PROYECTO_S.E.L.F].Migrar_Aspectos;
GO