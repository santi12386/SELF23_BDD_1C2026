USE GD1C2026;
GO

DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Paises;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Provincias;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Localidades;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Direcciones;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Agencias;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Agentes;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Ciudades;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Clientes;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Sol_Cotizaciones;
DROP PROCEDURE IF EXISTS S_E_L_F.Migrar_Items_Ciudad;
GO

DROP TABLE IF EXISTS S_E_L_F.Item_ciudad;
DROP TABLE IF EXISTS S_E_L_F.Sol_cotizacion;
DROP TABLE IF EXISTS S_E_L_F.Cliente;
DROP TABLE IF EXISTS S_E_L_F.Ciudad;
DROP TABLE IF EXISTS S_E_L_F.Agente;
DROP TABLE IF EXISTS S_E_L_F.Agencia;
DROP TABLE IF EXISTS S_E_L_F.Direccion;
DROP TABLE IF EXISTS S_E_L_F.Localidad;
DROP TABLE IF EXISTS S_E_L_F.Provincia;
DROP TABLE IF EXISTS S_E_L_F.Pais;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'S_E_L_F')
BEGIN
    EXEC ('CREATE SCHEMA S_E_L_F');
END
GO

--CREACION DE TABLAS

CREATE TABLE S_E_L_F.Pais (
    Pais_id      INT IDENTITY(1,1) NOT NULL,
    Pais_nombre  NVARCHAR(100)     NOT NULL
)

CREATE TABLE S_E_L_F.Provincia (
    Prov_id       INT IDENTITY(1,1) NOT NULL,
    Prov_id_pais  INT               NOT NULL,
    Prov_nombre   NVARCHAR(100)     NOT NULL
)

CREATE TABLE S_E_L_F.Localidad (
    Loca_id_localidad  INT IDENTITY(1,1) NOT NULL,
    Loca_id_provincia  INT               NOT NULL,
    Loca_nombre        NVARCHAR(100)     NOT NULL
)

CREATE TABLE S_E_L_F.Direccion (
    Dire_id_direccion  INT IDENTITY(1,1) NOT NULL,
    Dire_id_localidad  INT               NOT NULL,
    Dire_calle         NVARCHAR(200)     NOT NULL,
    Dire_numero        NVARCHAR(20)      NOT NULL
)

-- La Maestra no tiene nombre de agencia, pero si telefono y mail.
-- Decidimos reemplazar Agen_nombre por Agen_telefono y Agen_mail.
CREATE TABLE S_E_L_F.Agencia (
    Agen_id_agencia   BIGINT        NOT NULL,
    Agen_id_direccion INT           NOT NULL,
    Agen_telefono     NVARCHAR(50)  NULL,
    Agen_mail         NVARCHAR(100) NULL
)

-- Agregamos campos que tiene la Maestra pero que no estaban en el DER:
-- Agt_legajo, Agt_apellido, Agt_fecha_nac, Agt_telefono, Agt_mail
CREATE TABLE S_E_L_F.Agente (
    Agt_id_agente     INT IDENTITY(1,1) NOT NULL,
    Agt_id_agencia    BIGINT            NOT NULL,
    Agt_id_direccion  INT               NOT NULL,
    Agt_dni           NVARCHAR(20)      NULL,
    Agt_nombre        NVARCHAR(100)     NOT NULL,
    Agt_apellido      NVARCHAR(100)     NOT NULL,
    Agt_fecha_nac     DATE              NULL,
    Agt_telefono      NVARCHAR(50)      NULL,
    Agt_mail          NVARCHAR(100)     NULL,
    Agt_legajo        BIGINT            NOT NULL
)

CREATE TABLE S_E_L_F.Ciudad (
    Ciud_id_ciudad  INT IDENTITY(1,1) NOT NULL,
    Ciud_nombre     NVARCHAR(100)     NOT NULL
)

-- Cliente: tabla preparada para cuando se integre con las tablas de los companeros.
-- La FK de Sol_cotizacion se activa una vez que se junte todo.
CREATE TABLE S_E_L_F.Cliente (
    Clie_id_cliente   INT IDENTITY(1,1) NOT NULL,
    Clie_id_direccion INT               NULL,
    Clie_nombre       NVARCHAR(100)     NOT NULL,
    Clie_apellido     NVARCHAR(100)     NULL,
    Clie_dni          NVARCHAR(20)      NULL,
    Clie_fecha_nac    DATE              NULL,
    Clie_telefono     NVARCHAR(50)      NULL,
    Clie_mail         NVARCHAR(100)     NULL
)

CREATE TABLE S_E_L_F.Sol_cotizacion (
    Sol_id_solicitud    BIGINT         NOT NULL,
    Sol_id_cliente      INT            NOT NULL,
    Sol_id_agente       INT            NOT NULL,
    Sol_fecha           DATE           NOT NULL,
    Sol_fecha_inicio    DATE           NULL,
    Sol_fecha_fin       DATE           NULL,
    Sol_cant_pasajeros  INT            NOT NULL,
    Sol_observaciones   NVARCHAR(255)  NULL,
    Sol_presupuesto     DECIMAL(18,2)  NULL
)

-- PK compuesta: una misma ciudad no se repite dentro de la misma solicitud.
-- El DER no la incluye pero es necesaria para normalizar.
CREATE TABLE S_E_L_F.Item_ciudad (
    I_Ciudad_id_ciudad             INT            NOT NULL,
    I_Ciudad_id_solicitud          BIGINT         NOT NULL,
    I_Ciudad_cant_dias             INT            NOT NULL,
    I_Ciudad_item_observaciones    NVARCHAR(255)  NULL
)
GO

-- AGREGO LAS CONSTRAINTS
-- PRIMARY KEY

ALTER TABLE S_E_L_F.Pais
    ADD CONSTRAINT PK_Pais PRIMARY KEY (Pais_id)

ALTER TABLE S_E_L_F.Provincia
    ADD CONSTRAINT PK_Provincia PRIMARY KEY (Prov_id)

ALTER TABLE S_E_L_F.Localidad
    ADD CONSTRAINT PK_Localidad PRIMARY KEY (Loca_id_localidad)

ALTER TABLE S_E_L_F.Direccion
    ADD CONSTRAINT PK_Direccion PRIMARY KEY (Dire_id_direccion)

ALTER TABLE S_E_L_F.Agencia
    ADD CONSTRAINT PK_Agencia PRIMARY KEY (Agen_id_agencia)

ALTER TABLE S_E_L_F.Agente
    ADD CONSTRAINT PK_Agente PRIMARY KEY (Agt_id_agente)

ALTER TABLE S_E_L_F.Ciudad
    ADD CONSTRAINT PK_Ciudad PRIMARY KEY (Ciud_id_ciudad)

ALTER TABLE S_E_L_F.Cliente
    ADD CONSTRAINT PK_Cliente PRIMARY KEY (Clie_id_cliente)

ALTER TABLE S_E_L_F.Sol_cotizacion
    ADD CONSTRAINT PK_Sol_cotizacion PRIMARY KEY (Sol_id_solicitud)

ALTER TABLE S_E_L_F.Item_ciudad
    ADD CONSTRAINT PK_Item_ciudad PRIMARY KEY (I_Ciudad_id_ciudad, I_Ciudad_id_solicitud)

ALTER TABLE S_E_L_F.Agente
    ADD CONSTRAINT UQ_Agente_Legajo UNIQUE (Agt_legajo) -- UNIQUE

-- FOREIGN KEY

ALTER TABLE S_E_L_F.Provincia
    ADD CONSTRAINT FK_Provincia_Pais
    FOREIGN KEY (Prov_id_pais)
    REFERENCES S_E_L_F.Pais(Pais_id)

ALTER TABLE S_E_L_F.Localidad
    ADD CONSTRAINT FK_Localidad_Provincia
    FOREIGN KEY (Loca_id_provincia)
    REFERENCES S_E_L_F.Provincia(Prov_id)

ALTER TABLE S_E_L_F.Direccion
    ADD CONSTRAINT FK_Direccion_Localidad
    FOREIGN KEY (Dire_id_localidad)
    REFERENCES S_E_L_F.Localidad(Loca_id_localidad)

ALTER TABLE S_E_L_F.Agencia
    ADD CONSTRAINT FK_Agencia_Direccion
    FOREIGN KEY (Agen_id_direccion)
    REFERENCES S_E_L_F.Direccion(Dire_id_direccion)

ALTER TABLE S_E_L_F.Agente
    ADD CONSTRAINT FK_Agente_Agencia
    FOREIGN KEY (Agt_id_agencia)
    REFERENCES S_E_L_F.Agencia(Agen_id_agencia)

ALTER TABLE S_E_L_F.Agente
    ADD CONSTRAINT FK_Agente_Direccion
    FOREIGN KEY (Agt_id_direccion)
    REFERENCES S_E_L_F.Direccion(Dire_id_direccion)

ALTER TABLE S_E_L_F.Sol_cotizacion
    ADD CONSTRAINT FK_SolCotizacion_Agente
    FOREIGN KEY (Sol_id_agente)
    REFERENCES S_E_L_F.Agente(Agt_id_agente)

ALTER TABLE S_E_L_F.Sol_cotizacion
    ADD CONSTRAINT FK_SolCotizacion_Cliente
    FOREIGN KEY (Sol_id_cliente)
    REFERENCES S_E_L_F.Cliente(Clie_id_cliente)

ALTER TABLE S_E_L_F.Item_ciudad
    ADD CONSTRAINT FK_ItemCiudad_Ciudad
    FOREIGN KEY (I_Ciudad_id_ciudad)
    REFERENCES S_E_L_F.Ciudad(Ciud_id_ciudad)

ALTER TABLE S_E_L_F.Item_ciudad
    ADD CONSTRAINT FK_ItemCiudad_SolCotizacion
    FOREIGN KEY (I_Ciudad_id_solicitud)
    REFERENCES S_E_L_F.Sol_cotizacion(Sol_id_solicitud)
GO

-- MIGRACION DE DATOS

CREATE PROCEDURE S_E_L_F.Migrar_Paises
AS
BEGIN
    INSERT INTO S_E_L_F.Pais (Pais_nombre)
    SELECT DISTINCT Aeropuerto_Salida_Pais
    FROM gd_esquema.Maestra
    WHERE Aeropuerto_Salida_Pais IS NOT NULL

    UNION

    SELECT DISTINCT Aeropuerto_Llegada_Pais
    FROM gd_esquema.Maestra
    WHERE Aeropuerto_Llegada_Pais IS NOT NULL

    UNION

    SELECT DISTINCT Hospedaje_Pais
    FROM gd_esquema.Maestra
    WHERE Hospedaje_Pais IS NOT NULL

    UNION

    SELECT DISTINCT Aerolinea_Pais
    FROM gd_esquema.Maestra
    WHERE Aerolinea_Pais IS NOT NULL;
END;
GO

-- Las agencias son todas de Argentina, por eso filtramos el pais.
CREATE PROCEDURE S_E_L_F.Migrar_Provincias
AS
BEGIN
    INSERT INTO S_E_L_F.Provincia (Prov_id_pais, Prov_nombre)
    SELECT DISTINCT
        p.Pais_id,
        m.Agencia_Provincia
    FROM gd_esquema.Maestra m
    JOIN S_E_L_F.Pais p ON p.Pais_nombre = 'Argentina'
    WHERE m.Agencia_Provincia IS NOT NULL;
END;
GO

CREATE PROCEDURE S_E_L_F.Migrar_Localidades
AS
BEGIN
    INSERT INTO S_E_L_F.Localidad (Loca_id_provincia, Loca_nombre)
    SELECT DISTINCT
        p.Prov_id,
        m.Agencia_Localidad
    FROM gd_esquema.Maestra m
    JOIN S_E_L_F.Provincia p ON p.Prov_nombre = m.Agencia_Provincia
    WHERE m.Agencia_Localidad IS NOT NULL;
END;
GO

-- La Maestra trae la direccion en un solo campo, no separada en calle y numero.
-- Guardamos la direccion completa en Dire_calle y ponemos 0 en Dire_numero.
CREATE PROCEDURE S_E_L_F.Migrar_Direcciones
AS
BEGIN
    INSERT INTO S_E_L_F.Direccion (Dire_id_localidad, Dire_calle, Dire_numero)
    SELECT DISTINCT
        l.Loca_id_localidad,
        m.Agencia_Direccion,
        '0'
    FROM gd_esquema.Maestra m
    JOIN S_E_L_F.Localidad l ON l.Loca_nombre = m.Agencia_Localidad
    WHERE m.Agencia_Direccion IS NOT NULL

    UNION

    SELECT DISTINCT
        l.Loca_id_localidad,
        m.Agente_Direccion,
        '0'
    FROM gd_esquema.Maestra m
    JOIN S_E_L_F.Localidad l ON l.Loca_nombre = m.Agente_Localidad
    WHERE m.Agente_Direccion IS NOT NULL;
END;
GO

CREATE PROCEDURE S_E_L_F.Migrar_Agencias
AS
BEGIN
    INSERT INTO S_E_L_F.Agencia (Agen_id_agencia, Agen_id_direccion, Agen_telefono, Agen_mail)
    SELECT DISTINCT
        m.Agencia_Nro_Agencia,
        d.Dire_id_direccion,
        m.Agencia_Telefono,
        m.Agencia_Mail
    FROM gd_esquema.Maestra m
    JOIN S_E_L_F.Direccion d ON d.Dire_calle = m.Agencia_Direccion
    WHERE m.Agencia_Nro_Agencia IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM S_E_L_F.Agencia a
        WHERE a.Agen_id_agencia = m.Agencia_Nro_Agencia
    );
END;
GO

CREATE PROCEDURE S_E_L_F.Migrar_Agentes
AS
BEGIN
    INSERT INTO S_E_L_F.Agente (
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
    SELECT DISTINCT
        a.Agen_id_agencia,
        d.Dire_id_direccion,
        m.Agente_Dni,
        m.Agente_Nombre,
        m.Agente_Apellido,
        m.Agente_Fecha_Nac,
        m.Agente_Telefono,
        m.Agente_Mail,
        m.Agente_Legajo
    FROM gd_esquema.Maestra m
    JOIN S_E_L_F.Agencia a ON a.Agen_id_agencia = m.Agencia_Nro_Agencia
    JOIN S_E_L_F.Direccion d ON d.Dire_calle = m.Agente_Direccion
    WHERE m.Agente_Legajo IS NOT NULL;
END;
GO

CREATE PROCEDURE S_E_L_F.Migrar_Ciudades
AS
BEGIN
    INSERT INTO S_E_L_F.Ciudad (Ciud_nombre)
    SELECT DISTINCT Detalle_Solicitud_Ciudad
    FROM gd_esquema.Maestra
    WHERE Detalle_Solicitud_Ciudad IS NOT NULL;
END;
GO

CREATE PROCEDURE S_E_L_F.Migrar_Clientes
AS
BEGIN
    INSERT INTO S_E_L_F.Cliente (Clie_nombre, Clie_apellido, Clie_dni, Clie_fecha_nac, Clie_mail)
    SELECT DISTINCT
        m.Cliente_Nombre,
        m.Cliente_Apellido,
        m.Cliente_Dni,
        m.Cliente_Fecha_Nac,
        m.Cliente_Mail
    FROM gd_esquema.Maestra m
    WHERE m.Cliente_Dni IS NOT NULL
    AND m.Cliente_Nombre = (
        SELECT TOP 1 m2.Cliente_Nombre
        FROM gd_esquema.Maestra m2
        WHERE m2.Cliente_Dni = m.Cliente_Dni
        ORDER BY m2.Cliente_Nombre
    );
END;
GO

CREATE PROCEDURE S_E_L_F.Migrar_Sol_Cotizaciones
AS
BEGIN
    INSERT INTO S_E_L_F.Sol_cotizacion (
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
        (SELECT TOP 1 c.Clie_id_cliente FROM S_E_L_F.Cliente c WHERE c.Clie_dni = m.Cliente_Dni),
        a.Agt_id_agente,
        m.Solicitud_Fecha_Solicitud,
        m.Solicitud_Fecha_Inicio_Tentativa,
        m.Solicitud_Fecha_Fin_Tentativa,
        m.Solicitud_Cant_Pax,
        m.Solicitud_Observaciones,
        m.Solicitud_Presupuesto_Estimado
    FROM gd_esquema.Maestra m
    JOIN S_E_L_F.Agente a ON a.Agt_legajo = m.Agente_Legajo
    WHERE m.Solicitud_Nro_Solicitud IS NOT NULL
    AND m.Cliente_Dni IS NOT NULL;
END;
GO

CREATE PROCEDURE S_E_L_F.Migrar_Items_Ciudad
AS
BEGIN
    INSERT INTO S_E_L_F.Item_ciudad (
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
    JOIN S_E_L_F.Ciudad c ON c.Ciud_nombre = m.Detalle_Solicitud_Ciudad
    JOIN S_E_L_F.Sol_cotizacion s ON s.Sol_id_solicitud = m.Solicitud_Nro_Solicitud
    WHERE m.Detalle_Solicitud_Ciudad IS NOT NULL;
END;
GO

EXEC S_E_L_F.Migrar_Paises;
EXEC S_E_L_F.Migrar_Provincias;
EXEC S_E_L_F.Migrar_Localidades;
EXEC S_E_L_F.Migrar_Direcciones;
EXEC S_E_L_F.Migrar_Agencias;
EXEC S_E_L_F.Migrar_Agentes;
EXEC S_E_L_F.Migrar_Ciudades;
EXEC S_E_L_F.Migrar_Clientes;
EXEC S_E_L_F.Migrar_Sol_Cotizaciones;
EXEC S_E_L_F.Migrar_Items_Ciudad;
GO