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

/* DROPS */
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_FACT_ENCUESTA;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_FACT_PROPUESTA;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_FACT_SOLICITUD;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_FACT_VENTA;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_DIM_ESTADO_PROPUESTA;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_DIM_ASPECTO;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_DIM_TIPO_SERVICIO;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_DIM_CANAL_VENTA;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_DIM_TIEMPO;
DROP PROCEDURE IF EXISTS [PROYECTO_S.E.L.F].Migrar_BI_DIM_RANGO_ETARIO;
GO

DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_FACT_ENCUESTA;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_FACT_SOLICITUD;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_ESTADO_PROPUESTA;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_ASPECTO;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_TIEMPO;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_TIPO_SERVICIO;
DROP TABLE IF EXISTS [PROYECTO_S.E.L.F].BI_DIM_CANAL_VENTA;
GO

/* DIMENSIONES */
CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_CANAL_VENTA (
    canal_venta_id INT PRIMARY KEY,
    canal_venta_tipo NVARCHAR(255) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_TIPO_SERVICIO (
    tipo_servicio_id INT IDENTITY(1,1) PRIMARY KEY,
    tipo_servicio_descripcion NVARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO (
    id_rango_etario INT IDENTITY(1,1) PRIMARY KEY,
    rango_etario_descripcion NVARCHAR(50) NOT NULL UNIQUE,
    rango_etario_desde INT NOT NULL,
    rango_etario_hasta INT NULL
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_TIEMPO (
    tiempo_id INT IDENTITY(1,1) PRIMARY KEY,
    tiempo_anio INT NOT NULL,
    tiempo_cuatrimestre INT NOT NULL,
    tiempo_mes INT NOT NULL,
    tiempo_temporada NVARCHAR(20) NOT NULL,
    CONSTRAINT UQ_BI_DIM_TIEMPO UNIQUE (tiempo_anio, tiempo_mes)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_ASPECTO (
    aspecto_id INT IDENTITY(1,1) PRIMARY KEY,
    aspecto_descripcion NVARCHAR(255) NOT NULL UNIQUE
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_ESTADO_PROPUESTA (
    estado_propuesta_id INT PRIMARY KEY,
    estado_propuesta_descripcion NVARCHAR(50) NOT NULL UNIQUE
);
GO

/* FACTS */
CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA (
    fact_venta_id INT IDENTITY(1,1) PRIMARY KEY,
    fact_venta_tiempo_id INT NOT NULL,
    fact_venta_rango_etario_id INT NOT NULL,
    fact_venta_canal_id INT NULL,
    fact_venta_tipo_servicio INT NOT NULL,
    fact_venta_nro_venta BIGINT NOT NULL,
    fact_venta_importe_total DECIMAL(18,2) NULL,
    fact_venta_descuento DECIMAL(18,2) NULL,
    CONSTRAINT FK_BI_FACT_VENTA_TIEMPO FOREIGN KEY (fact_venta_tiempo_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_TIEMPO(tiempo_id),
    CONSTRAINT FK_BI_FACT_VENTA_RANGO FOREIGN KEY (fact_venta_rango_etario_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO(id_rango_etario),
    CONSTRAINT FK_BI_FACT_VENTA_CANAL FOREIGN KEY (fact_venta_canal_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_CANAL_VENTA(canal_venta_id),
    CONSTRAINT FK_BI_FACT_VENTA_TIPO_SERVICIO FOREIGN KEY (fact_venta_tipo_servicio)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_TIPO_SERVICIO(tipo_servicio_id)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_FACT_SOLICITUD (
    fact_solicitud_id INT IDENTITY(1,1) PRIMARY KEY,
    fact_solicitud_tiempo_id INT NOT NULL,
    fact_solicitud_rango_etario_id INT NOT NULL,
    fact_solicitud_dias_anticipacion INT NULL,
    CONSTRAINT FK_BI_FACT_SOLICITUD_TIEMPO FOREIGN KEY (fact_solicitud_tiempo_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_TIEMPO(tiempo_id),
    CONSTRAINT FK_BI_FACT_SOLICITUD_RANGO FOREIGN KEY (fact_solicitud_rango_etario_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO(id_rango_etario)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA (
    fact_propuesta_id INT IDENTITY(1,1) PRIMARY KEY,
    fact_propuesta_tiempo_id INT NOT NULL,
    fact_propuesta_rango_etario_agente_id INT NOT NULL,
    fact_propuesta_estado INT NOT NULL,
    fact_propuesta_importe DECIMAL(18,2) NULL,
    fact_propuesta_presupuesto_estimado DECIMAL(18,2) NULL,
    fact_propuesta_dias_estimados INT NULL,
    CONSTRAINT FK_BI_FACT_PROPUESTA_TIEMPO FOREIGN KEY (fact_propuesta_tiempo_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_TIEMPO(tiempo_id),
    CONSTRAINT FK_BI_FACT_PROPUESTA_RANGO_AGENTE FOREIGN KEY (fact_propuesta_rango_etario_agente_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO(id_rango_etario),
    CONSTRAINT FK_BI_FACT_PROPUESTA_ESTADO FOREIGN KEY (fact_propuesta_estado)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_ESTADO_PROPUESTA(estado_propuesta_id)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_FACT_ENCUESTA (
    fact_encuesta_id INT IDENTITY(1,1) PRIMARY KEY,
    fact_encuesta_tiempo_id INT NOT NULL,
    fact_encuesta_rango_etario_id INT NOT NULL,
    fact_encuesta_aspecto_id INT NOT NULL,
    fact_encuesta_puntaje INT NULL,
    CONSTRAINT FK_BI_FACT_ENCUESTA_TIEMPO FOREIGN KEY (fact_encuesta_tiempo_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_TIEMPO(tiempo_id),
    CONSTRAINT FK_BI_FACT_ENCUESTA_RANGO FOREIGN KEY (fact_encuesta_rango_etario_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO(id_rango_etario),
    CONSTRAINT FK_BI_FACT_ENCUESTA_ASPECTO FOREIGN KEY (fact_encuesta_aspecto_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_ASPECTO(aspecto_id)
);
GO

/* MIGRACION DE DIMENSIONES */
CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_DIM_RANGO_ETARIO
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO
        (rango_etario_descripcion, rango_etario_desde, rango_etario_hasta)
    VALUES
        (N'Menores de 25', 0, 25),
        (N'Entre 25 y 35', 26, 35),
        (N'Entre 35 y 50', 36, 50),
        (N'Mayores de 50', 51, NULL);
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_DIM_TIEMPO
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_TIEMPO
        (tiempo_anio, tiempo_cuatrimestre, tiempo_mes, tiempo_temporada)
    SELECT DISTINCT
        YEAR(fecha),
        CASE WHEN MONTH(fecha) BETWEEN 1 AND 4 THEN 1
             WHEN MONTH(fecha) BETWEEN 5 AND 8 THEN 2
             ELSE 3 END,
        MONTH(fecha),
        CASE WHEN MONTH(fecha) BETWEEN 1 AND 3 THEN N'Verano'
             WHEN MONTH(fecha) BETWEEN 4 AND 6 THEN N'Otono'
             WHEN MONTH(fecha) BETWEEN 7 AND 9 THEN N'Invierno'
             ELSE N'Primavera' END
    FROM (
        SELECT Vent_fecha fecha FROM [PROYECTO_S.E.L.F].Venta WHERE Vent_fecha IS NOT NULL
        UNION
        SELECT Sol_fecha FROM [PROYECTO_S.E.L.F].Sol_cotizacion WHERE Sol_fecha IS NOT NULL
        UNION
        SELECT CAST(Prop_fecha AS DATE) FROM [PROYECTO_S.E.L.F].Propuesta WHERE Prop_fecha IS NOT NULL
        UNION
        SELECT CAST(Prop_fecha_inicio AS DATE) FROM [PROYECTO_S.E.L.F].Propuesta WHERE Prop_fecha_inicio IS NOT NULL
        UNION
        SELECT Encu_fecha FROM [PROYECTO_S.E.L.F].Encuesta WHERE Encu_fecha IS NOT NULL
    ) fechas;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_DIM_CANAL_VENTA
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_CANAL_VENTA
        (canal_venta_id, canal_venta_tipo)
    SELECT Canal_id_canal, Canal_tipo
    FROM [PROYECTO_S.E.L.F].Canal_de_venta;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_DIM_TIPO_SERVICIO
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_TIPO_SERVICIO
        (tipo_servicio_descripcion)
    VALUES (N'Venta Directa'), (N'Propuesta a Medida');
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_DIM_ASPECTO
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_ASPECTO (aspecto_descripcion)
    SELECT DISTINCT Aspe_nombre
    FROM [PROYECTO_S.E.L.F].Aspecto
    WHERE Aspe_nombre IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_DIM_ESTADO_PROPUESTA
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_ESTADO_PROPUESTA
        (estado_propuesta_id, estado_propuesta_descripcion)
    SELECT P_Est_id_estado, P_Est_nombre
    FROM [PROYECTO_S.E.L.F].Prop_estado;
END;
GO

/* MIGRACION DE FACTS */
CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_FACT_VENTA
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA (
        fact_venta_tiempo_id,
        fact_venta_rango_etario_id,
        fact_venta_canal_id,
        fact_venta_tipo_servicio,
        fact_venta_nro_venta,
        fact_venta_importe_total,
        fact_venta_descuento
    )
    SELECT
        t.tiempo_id,
        r.id_rango_etario,
        v.Vent_id_canal,
        ts.tipo_servicio_id,
        v.Vent_nro_de_venta,
        v.Vent_importe_total,
        v.Vent_descuento
    FROM [PROYECTO_S.E.L.F].Venta v
    INNER JOIN [PROYECTO_S.E.L.F].Cliente c
        ON c.Clie_id_cliente = v.Vent_id_cliente
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
        ON t.tiempo_anio = YEAR(v.Vent_fecha)
       AND t.tiempo_mes = MONTH(v.Vent_fecha)
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
        ON (
            DATEDIFF(YEAR, c.Clie_fecha_nac, v.Vent_fecha)
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.Clie_fecha_nac, v.Vent_fecha), c.Clie_fecha_nac) > v.Vent_fecha
                THEN 1 ELSE 0
              END
        ) BETWEEN r.rango_etario_desde AND ISNULL(r.rango_etario_hasta, 999)
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_TIPO_SERVICIO ts
        ON ts.tipo_servicio_descripcion =
           CASE WHEN v.Vent_id_propuesta IS NULL THEN N'Venta Directa'
                ELSE N'Propuesta a Medida' END
    WHERE v.Vent_fecha IS NOT NULL
      AND c.Clie_fecha_nac IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_FACT_SOLICITUD
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_FACT_SOLICITUD (
        fact_solicitud_tiempo_id,
        fact_solicitud_rango_etario_id,
        fact_solicitud_dias_anticipacion
    )
    SELECT
        t.tiempo_id,
        r.id_rango_etario,
        DATEDIFF(DAY, s.Sol_fecha, s.Sol_fecha_inicio)
    FROM [PROYECTO_S.E.L.F].Sol_cotizacion s
    INNER JOIN [PROYECTO_S.E.L.F].Cliente c
        ON c.Clie_id_cliente = s.Sol_id_cliente
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
        ON t.tiempo_anio = YEAR(s.Sol_fecha)
       AND t.tiempo_mes = MONTH(s.Sol_fecha)
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
        ON (
            DATEDIFF(YEAR, c.Clie_fecha_nac, s.Sol_fecha)
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.Clie_fecha_nac, s.Sol_fecha), c.Clie_fecha_nac) > s.Sol_fecha
                THEN 1 ELSE 0
              END
        ) BETWEEN r.rango_etario_desde AND ISNULL(r.rango_etario_hasta, 999)
    WHERE s.Sol_fecha IS NOT NULL
      AND s.Sol_fecha_inicio IS NOT NULL
      AND c.Clie_fecha_nac IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_FACT_PROPUESTA
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA (
        fact_propuesta_tiempo_id,
        fact_propuesta_rango_etario_agente_id,
        fact_propuesta_estado,
        fact_propuesta_importe,
        fact_propuesta_presupuesto_estimado,
        fact_propuesta_dias_estimados
    )
    SELECT
        t.tiempo_id,
        r.id_rango_etario,
        p.Prop_id_estado,
        p.Prop_importe_total,
        s.Sol_presupuesto,
        DATEDIFF(DAY, s.Sol_fecha, CAST(p.Prop_fecha AS DATE))
    FROM [PROYECTO_S.E.L.F].Propuesta p
    INNER JOIN [PROYECTO_S.E.L.F].Sol_cotizacion s
        ON s.Sol_id_solicitud = p.Prop_id_solicitud
    INNER JOIN [PROYECTO_S.E.L.F].Agente a
        ON a.Agt_id_agente = p.Prop_id_agente
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
        ON t.tiempo_anio = YEAR(ISNULL(CAST(p.Prop_fecha_inicio AS DATE), CAST(p.Prop_fecha AS DATE)))
       AND t.tiempo_mes = MONTH(ISNULL(CAST(p.Prop_fecha_inicio AS DATE), CAST(p.Prop_fecha AS DATE)))
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
        ON (
            DATEDIFF(YEAR, a.Agt_fecha_nac, CAST(p.Prop_fecha AS DATE))
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, a.Agt_fecha_nac, CAST(p.Prop_fecha AS DATE)), a.Agt_fecha_nac) > CAST(p.Prop_fecha AS DATE)
                THEN 1 ELSE 0
              END
        ) BETWEEN r.rango_etario_desde AND ISNULL(r.rango_etario_hasta, 999)
    WHERE p.Prop_fecha IS NOT NULL
      AND a.Agt_fecha_nac IS NOT NULL;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_FACT_ENCUESTA
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_FACT_ENCUESTA (
        fact_encuesta_tiempo_id,
        fact_encuesta_rango_etario_id,
        fact_encuesta_aspecto_id,
        fact_encuesta_puntaje
    )
    SELECT
        t.tiempo_id,
        r.id_rango_etario,
        ba.aspecto_id,
        a.Aspe_puntaje
    FROM [PROYECTO_S.E.L.F].Aspecto a
    INNER JOIN [PROYECTO_S.E.L.F].Encuesta e
        ON e.Encu_id_encuesta = a.Aspe_id_encuesta
    INNER JOIN [PROYECTO_S.E.L.F].Agente ag
        ON ag.Agt_id_agente = e.Encu_id_agente
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
        ON t.tiempo_anio = YEAR(e.Encu_fecha)
       AND t.tiempo_mes = MONTH(e.Encu_fecha)
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
        ON (
            DATEDIFF(YEAR, ag.Agt_fecha_nac, e.Encu_fecha)
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, ag.Agt_fecha_nac, e.Encu_fecha), ag.Agt_fecha_nac) > e.Encu_fecha
                THEN 1 ELSE 0
              END
        ) BETWEEN r.rango_etario_desde AND ISNULL(r.rango_etario_hasta, 999)
    INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_ASPECTO ba
        ON ba.aspecto_descripcion = a.Aspe_nombre
    WHERE e.Encu_fecha IS NOT NULL
      AND ag.Agt_fecha_nac IS NOT NULL
      AND a.Aspe_nombre IS NOT NULL;
END;
GO

/* EJECUCION */
EXEC [PROYECTO_S.E.L.F].Migrar_BI_DIM_RANGO_ETARIO;
EXEC [PROYECTO_S.E.L.F].Migrar_BI_DIM_TIEMPO;
EXEC [PROYECTO_S.E.L.F].Migrar_BI_DIM_CANAL_VENTA;
EXEC [PROYECTO_S.E.L.F].Migrar_BI_DIM_TIPO_SERVICIO;
EXEC [PROYECTO_S.E.L.F].Migrar_BI_DIM_ASPECTO;
EXEC [PROYECTO_S.E.L.F].Migrar_BI_DIM_ESTADO_PROPUESTA;

EXEC [PROYECTO_S.E.L.F].Migrar_BI_FACT_VENTA;
EXEC [PROYECTO_S.E.L.F].Migrar_BI_FACT_SOLICITUD;
EXEC [PROYECTO_S.E.L.F].Migrar_BI_FACT_PROPUESTA;
EXEC [PROYECTO_S.E.L.F].Migrar_BI_FACT_ENCUESTA;
GO

DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_DISTRIBUCION_FACTURACION
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_V_TICKET_PROMEDIO;
GO

/* ticket Promedio */
CREATE VIEW [PROYECTO_S.E.L.F].BI_V_TICKET_PROMEDIO
AS
SELECT
    t.tiempo_anio,
    t.tiempo_mes,
    r.rango_etario_descripcion,
    c.canal_venta_tipo,
    AVG(v.fact_venta_importe_total) AS ticket_promedio
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA v
INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = v.fact_venta_tiempo_id
INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
    ON r.id_rango_etario = v.fact_venta_rango_etario_id
INNER JOIN [PROYECTO_S.E.L.F].BI_DIM_CANAL_VENTA c
    ON c.canal_venta_id = v.fact_venta_canal_id
GROUP BY
    t.tiempo_anio,
    t.tiempo_mes,
    r.rango_etario_descripcion,
    c.canal_venta_tipo;
GO


CREATE VIEW [PROYECTO_S.E.L.F].BI_DISTRIBUCION_FACTURACION
AS
SELECT
    SUM(v.fact_venta_importe_total) AS facturacion_tipo_servicio,
    t.tiempo_cuatrimestre,
    t.tiempo_anio,
    s.tipo_servicio_descripcion,

    SUM(v.fact_venta_importe_total) * 100.0 /
    (
        SELECT SUM(v2.fact_venta_importe_total)
        FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA v2
        JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t2
            ON t2.tiempo_id = v2.fact_venta_tiempo_id
        WHERE t2.tiempo_anio = t.tiempo_anio
          AND t2.tiempo_cuatrimestre = t.tiempo_cuatrimestre
    ) AS porcentaje_facturacion

FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA v

JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = v.fact_venta_tiempo_id

JOIN [PROYECTO_S.E.L.F].BI_DIM_TIPO_SERVICIO s
    ON s.tipo_servicio_id = v.fact_venta_tipo_servicio

GROUP BY
    t.tiempo_cuatrimestre,
    t.tiempo_anio,
    s.tipo_servicio_descripcion;
GO