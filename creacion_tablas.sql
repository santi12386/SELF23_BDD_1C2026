USE GD1C2026;
GO

-- Create de tablas

IF OBJECT_ID('PROYECTO_S.E.L.F.Item_vuelo', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Item_vuelo;
IF OBJECT_ID('PROYECTO_S.E.L.F.Vuelo', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Vuelo;
IF OBJECT_ID('PROYECTO_S.E.L.F.Aeropuerto', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Aeropuerto;
IF OBJECT_ID('PROYECTO_S.E.L.F.Aerolinea', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Aerolinea;
IF OBJECT_ID('PROYECTO_S.E.L.F.Codigo_pais', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Codigo_pais;
IF OBJECT_ID('PROYECTO_S.E.L.F.Item_excursion', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Item_excursion;
IF OBJECT_ID('PROYECTO_S.E.L.F.Excursion', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Excursion;
IF OBJECT_ID('PROYECTO_S.E.L.F.Proveedor', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Proveedor;
IF OBJECT_ID('PROYECTO_S.E.L.F.Item_venta', 'U') IS NOT NULL DROP TABLE PROYECTO_S.E.L.F.Item_venta;

CREATE TABLE PROYECTO_S.E.L.F.Proveedor (
    prov_id INT IDENTITY(1,1) PRIMARY KEY,
    prov_nombre VARCHAR(255),
    prov_mail VARCHAR(255),
    prov_telefono VARCHAR(255)
);

CREATE TABLE PROYECTO_S.E.L.F.Excursion (
    Excu_id_excursion INT IDENTITY(1,1) PRIMARY KEY,
    Excu_id_proovedor INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Proveedor(prov_id),
    Excu_horario DATETIME,
    Excu_duracion INT
);

CREATE TABLE PROYECTO_S.E.L.F.Item_venta (
    Item_id INT IDENTITY(1,1) PRIMARY KEY,
    Venta_id BIGINT,
    Item_tipo VARCHAR(50)
);

CREATE TABLE PROYECTO_S.E.L.F.Item_excursion (
    I_Excursion_id_item INT PRIMARY KEY
        FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Item_venta(Item_id),
    I_Excursion_id_excursion INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Excursion(Excu_id_excursion),
    I_Excursion_fecha DATETIME,
    I_Excursion_cantidad INT,
    I_Excursion_precio_unit INT,
    I_Excursion_subtotal INT
);

CREATE TABLE PROYECTO_S.E.L.F.Aerolinea (
    AeroL_id_aerolinea INT IDENTITY(1,1) PRIMARY KEY,
    AeroL_nombre VARCHAR(255)
);

CREATE TABLE PROYECTO_S.E.L.F.Codigo_pais (
    Cod_pais_id INT IDENTITY(1,1) PRIMARY KEY,
    Cod_Pais_nombre VARCHAR(255)
);

CREATE TABLE PROYECTO_S.E.L.F.Aeropuerto (
    AeroP_id_aeropuerto INT IDENTITY(1,1) PRIMARY KEY,
    AeroP_id_cod_pais_llegada INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Codigo_pais(Cod_pais_id),
    AeroP_id_cod_pais_salida INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Codigo_pais(Cod_pais_id),
    id_pais_salida INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.pais(pais_id),
    id_pais_llegada INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.pais(pais_id),
    AeroP_nombre VARCHAR(255)
);

CREATE TABLE PROYECTO_S.E.L.F.Vuelo (
    Vuel_id_vuelo INT IDENTITY(1,1) PRIMARY KEY,
    Vuel_id_aeropuerto INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Aeropuerto(AeroP_id_aeropuerto),
    Vuel_id_aerolinea INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Aerolinea(AeroL_id_aerolinea),
    Vuel_fecha_llegada DATETIME,
    Vuel_fecha_salida DATETIME
);

CREATE TABLE PROYECTO_S.E.L.F.Item_vuelo (
    I_Vuelo_id_item INT PRIMARY KEY
        FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Item_venta(Item_id),
    I_Vuelo_id_vuelo INT FOREIGN KEY REFERENCES PROYECTO_S.E.L.F.Vuelo(Vuel_id_vuelo),
    I_Vuelo_cant_pasajes INT,
    I_Vuelo_precio_unit INT,
    I_Vuelo_subtotal INT
);

GO

-- Migracion


CREATE PROCEDURE PROYECTO_S.E.L.F.InsertProveedor
AS
BEGIN
    INSERT INTO PROYECTO_S.E.L.F.Proveedor (
        prov_nombre,
        prov_mail,
        prov_telefono
    )
    SELECT DISTINCT
        m.Proveedor_Nombre,
        m.Proveedor_Mail,
        m.Proveedor_Telefono
    FROM gd_esquema.Maestra m
    WHERE m.Proveedor_Nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE PROYECTO_S.E.L.F.InsertExcursion
AS
BEGIN
    INSERT INTO PROYECTO_S.E.L.F.Excursion (
        Excu_id_proovedor,
        Excu_horario,
        Excu_duracion
    )
    SELECT DISTINCT
        p.prov_id,
        TRY_CAST(m.Excursion_Horario AS DATETIME),
        m.Excursion_Duracion
    FROM gd_esquema.Maestra m
    JOIN PROYECTO_S.E.L.F.Proveedor p
        ON p.prov_nombre = m.Proveedor_Nombre
    WHERE m.Excursion_Nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE PROYECTO_S.E.L.F.InsertAerolinea
AS
BEGIN
    INSERT INTO PROYECTO_S.E.L.F.Aerolinea (
        AeroL_nombre
    )
    SELECT DISTINCT
        m.Aerolinea_Nombre
    FROM gd_esquema.Maestra m
    WHERE m.Aerolinea_Nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE PROYECTO_S.E.L.F.InsertCodigoPais
AS
BEGIN
    INSERT INTO PROYECTO_S.E.L.F.Codigo_pais (
        Cod_Pais_nombre
    )
    SELECT DISTINCT
        m.Aeropuerto_Salida_Pais
    FROM gd_esquema.Maestra m
    WHERE m.Aeropuerto_Salida_Pais IS NOT NULL
    UNION
    SELECT DISTINCT
        m.Aeropuerto_Llegada_Pais
    FROM gd_esquema.Maestra m
    WHERE m.Aeropuerto_Llegada_Pais IS NOT NULL;
END;
GO

CREATE PROCEDURE PROYECTO_S.E.L.F.InsertAeropuerto
AS
BEGIN
    INSERT INTO PROYECTO_S.E.L.F.Aeropuerto (
        AeroP_id_cod_pais_llegada,
        AeroP_id_cod_pais_salida,
        id_pais_salida,
        id_pais_llegada,
        AeroP_nombre
    )
    SELECT DISTINCT
        cp_llegada.Cod_pais_id,
        cp_salida.Cod_pais_id,
        p_salida.pais_id,
        p_llegada.pais_id,
        m.Aeropuerto_Salida_Descripcion
    FROM gd_esquema.Maestra m
    LEFT JOIN PROYECTO_S.E.L.F.Codigo_pais cp_salida
        ON cp_salida.Cod_Pais_nombre = m.Aeropuerto_Salida_Pais
    LEFT JOIN PROYECTO_S.E.L.F.Codigo_pais cp_llegada
        ON cp_llegada.Cod_Pais_nombre = m.Aeropuerto_Llegada_Pais
    LEFT JOIN PROYECTO_S.E.L.F.pais p_salida
        ON p_salida.pais_nombre = m.Aeropuerto_Salida_Pais
    LEFT JOIN PROYECTO_S.E.L.F.pais p_llegada
        ON p_llegada.pais_nombre = m.Aeropuerto_Llegada_Pais;
END;
GO

CREATE PROCEDURE PROYECTO_S.E.L.F.InsertVuelo
AS
BEGIN
    INSERT INTO PROYECTO_S.E.L.F.Vuelo (
        Vuel_id_aeropuerto,
        Vuel_id_aerolinea,
        Vuel_fecha_llegada,
        Vuel_fecha_salida
    )
    SELECT DISTINCT
        a.AeroP_id_aeropuerto,
        al.AeroL_id_aerolinea,
        m.Vuelo_Fecha_Llegada,
        m.Vuelo_Fecha_Salida
    FROM gd_esquema.Maestra m
    JOIN PROYECTO_S.E.L.F.Aeropuerto a
        ON a.AeroP_nombre = m.Aeropuerto_Salida_Descripcion
    JOIN PROYECTO_S.E.L.F.Aerolinea al
        ON al.AeroL_nombre = m.Aerolinea_Nombre;
END;
GO

CREATE PROCEDURE PROYECTO_S.E.L.F.InsertItemExcursion
AS
BEGIN
    INSERT INTO PROYECTO_S.E.L.F.Item_venta (
        Venta_id,
        Item_tipo
    )
    SELECT DISTINCT
        m.Venta_Nro_Venta,
        'excursion'
    FROM gd_esquema.Maestra m
    WHERE m.Detalle_Venta_Excursion_Cod_Reserva IS NOT NULL;

    INSERT INTO PROYECTO_S.E.L.F.Item_excursion (
        I_Excursion_id_item,
        I_Excursion_id_excursion,
        I_Excursion_fecha,
        I_Excursion_cantidad,
        I_Excursion_precio_unit,
        I_Excursion_subtotal
    )
    SELECT DISTINCT
        iv.Item_id,
        e.Excu_id_excursion,
        m.Detalle_Venta_Excursion_Fecha_Reserva,
        m.Detalle_Venta_Excursion_Cant,
        m.Detalle_Venta_Excursion_Precio_Unitario,
        m.Detalle_Venta_Excursion_Subtotal
    FROM gd_esquema.Maestra m
    JOIN PROYECTO_S.E.L.F.Item_venta iv
        ON iv.Venta_id = m.Venta_Nro_Venta
       AND iv.Item_tipo = 'excursion'
    JOIN PROYECTO_S.E.L.F.Excursion e
        ON e.Excu_id_proovedor = (
            SELECT prov_id
            FROM PROYECTO_S.E.L.F.Proveedor
            WHERE prov_nombre = m.Proveedor_Nombre
        );
END;
GO

CREATE PROCEDURE PROYECTO_S.E.L.F.InsertItemVuelo
AS
BEGIN
    INSERT INTO PROYECTO_S.E.L.F.Item_venta (
        Venta_id,
        Item_tipo
    )
    SELECT DISTINCT
        m.Venta_Nro_Venta,
        'vuelo'
    FROM gd_esquema.Maestra m
    WHERE m.Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL;

    INSERT INTO PROYECTO_S.E.L.F.Item_vuelo (
        I_Vuelo_id_item,
        I_Vuelo_id_vuelo,
        I_Vuelo_cant_pasajes,
        I_Vuelo_precio_unit,
        I_Vuelo_subtotal
    )
    SELECT DISTINCT
        iv.Item_id,
        v.Vuel_id_vuelo,
        m.Detalle_Venta_Vuelo_Cantidad_Pasajes,
        m.Detalle_Venta_Vuelo_Precio_Unitario,
        m.Detalle_Venta_Vuelo_Subtotal
    FROM gd_esquema.Maestra m
    JOIN PROYECTO_S.E.L.F.Item_venta iv
        ON iv.Venta_id = m.Venta_Nro_Venta
       AND iv.Item_tipo = 'vuelo'
    JOIN PROYECTO_S.E.L.F.Vuelo v
        ON v.Vuel_id_aeropuerto = (
            SELECT a.AeroP_id_aeropuerto
            FROM PROYECTO_S.E.L.F.Aeropuerto a
            WHERE a.AeroP_nombre = m.Aeropuerto_Salida_Descripcion
        );
END;
GO
