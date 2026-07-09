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

DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_DISTRIBUCION_FACTURACION;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_V_TICKET_PROMEDIO;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_SOLICITUDES_POR_TEMPORADA;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_SOLICITUDES_ANTICIPACION_PROMEDIO;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_TASA_ACEPTACION_PROPUESTAS;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_COTIZACION_PROMEDIO_TEMPORADA;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_TIEMPO_PROMEDIO_RESPUESTA;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_DESVIO_PRESUPUESTO;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_RANKING_ASPECTOS;
DROP VIEW IF EXISTS [PROYECTO_S.E.L.F].BI_SATISFACCION_PROMEDIO_AGENTE;
GO

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

/* Tabla de hechos*/

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA (
    fact_venta_tiempo_id INT NOT NULL,
    fact_venta_rango_etario_id INT NOT NULL,
    fact_venta_canal_id INT NOT NULL,
    fact_venta_tipo_servicio INT NOT NULL,

    fact_venta_cantidad INT NOT NULL,
    fact_venta_importe_total DECIMAL(18,2) NOT NULL,
    fact_venta_descuento DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_BI_FACT_VENTA PRIMARY KEY (
        fact_venta_tiempo_id,
        fact_venta_rango_etario_id,
        fact_venta_canal_id,
        fact_venta_tipo_servicio
    ),

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
    fact_solicitud_tiempo_id INT NOT NULL,
    fact_solicitud_rango_etario_id INT NOT NULL,

    fact_solicitud_cantidad INT NOT NULL,
    fact_solicitud_dias_anticipacion_total INT NOT NULL,

    CONSTRAINT PK_BI_FACT_SOLICITUD PRIMARY KEY (
        fact_solicitud_tiempo_id,
        fact_solicitud_rango_etario_id
    ),

    CONSTRAINT FK_BI_FACT_SOLICITUD_TIEMPO FOREIGN KEY (fact_solicitud_tiempo_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_TIEMPO(tiempo_id),

    CONSTRAINT FK_BI_FACT_SOLICITUD_RANGO FOREIGN KEY (fact_solicitud_rango_etario_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO(id_rango_etario)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA (
    fact_propuesta_tiempo_id INT NOT NULL,
    fact_propuesta_rango_etario_agente_id INT NOT NULL,
    fact_propuesta_estado INT NOT NULL,

    fact_propuesta_cantidad INT NOT NULL,
    fact_propuesta_importe DECIMAL(18,2) NOT NULL,
    fact_propuesta_presupuesto_estimado DECIMAL(18,2) NOT NULL,
    fact_propuesta_dias_estimados_total INT NOT NULL,

    CONSTRAINT PK_BI_FACT_PROPUESTA PRIMARY KEY (
        fact_propuesta_tiempo_id,
        fact_propuesta_rango_etario_agente_id,
        fact_propuesta_estado
    ),

    CONSTRAINT FK_BI_FACT_PROPUESTA_TIEMPO FOREIGN KEY (fact_propuesta_tiempo_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_TIEMPO(tiempo_id),

    CONSTRAINT FK_BI_FACT_PROPUESTA_RANGO_AGENTE FOREIGN KEY (fact_propuesta_rango_etario_agente_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO(id_rango_etario),

    CONSTRAINT FK_BI_FACT_PROPUESTA_ESTADO FOREIGN KEY (fact_propuesta_estado)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_ESTADO_PROPUESTA(estado_propuesta_id)
);
GO

CREATE TABLE [PROYECTO_S.E.L.F].BI_DIM_FACT_ENCUESTA (
    fact_encuesta_tiempo_id INT NOT NULL,
    fact_encuesta_rango_etario_id INT NOT NULL,
    fact_encuesta_aspecto_id INT NOT NULL,

    fact_encuesta_cantidad INT NOT NULL,
    fact_encuesta_puntaje_total INT NOT NULL,

    CONSTRAINT PK_BI_FACT_ENCUESTA PRIMARY KEY (
        fact_encuesta_tiempo_id,
        fact_encuesta_rango_etario_id,
        fact_encuesta_aspecto_id
    ),

    CONSTRAINT FK_BI_FACT_ENCUESTA_TIEMPO FOREIGN KEY (fact_encuesta_tiempo_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_TIEMPO(tiempo_id),

    CONSTRAINT FK_BI_FACT_ENCUESTA_RANGO FOREIGN KEY (fact_encuesta_rango_etario_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO(id_rango_etario),

    CONSTRAINT FK_BI_FACT_ENCUESTA_ASPECTO FOREIGN KEY (fact_encuesta_aspecto_id)
        REFERENCES [PROYECTO_S.E.L.F].BI_DIM_ASPECTO(aspecto_id)
);
GO

/* Migración de dimensiones */
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

CREATE OR ALTER PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_DIM_TIEMPO
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_TIEMPO
        (tiempo_anio, tiempo_cuatrimestre, tiempo_mes, tiempo_temporada)
    SELECT DISTINCT
        YEAR(v.Vent_fecha),
        CASE
            WHEN MONTH(v.Vent_fecha) BETWEEN 1 AND 4 THEN 1
            WHEN MONTH(v.Vent_fecha) BETWEEN 5 AND 8 THEN 2
            ELSE 3
        END,
        MONTH(v.Vent_fecha),
        CASE
            WHEN MONTH(v.Vent_fecha) BETWEEN 1 AND 3 THEN N'Verano'
            WHEN MONTH(v.Vent_fecha) BETWEEN 4 AND 6 THEN N'Otono'
            WHEN MONTH(v.Vent_fecha) BETWEEN 7 AND 9 THEN N'Invierno'
            ELSE N'Primavera'
        END
    FROM [PROYECTO_S.E.L.F].Venta v
    WHERE v.Vent_fecha IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
          WHERE t.tiempo_anio = YEAR(v.Vent_fecha)
            AND t.tiempo_mes = MONTH(v.Vent_fecha)
      );

    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_TIEMPO
        (tiempo_anio, tiempo_cuatrimestre, tiempo_mes, tiempo_temporada)
    SELECT DISTINCT
        YEAR(s.Sol_fecha),
        CASE
            WHEN MONTH(s.Sol_fecha) BETWEEN 1 AND 4 THEN 1
            WHEN MONTH(s.Sol_fecha) BETWEEN 5 AND 8 THEN 2
            ELSE 3
        END,
        MONTH(s.Sol_fecha),
        CASE
            WHEN MONTH(s.Sol_fecha) BETWEEN 1 AND 3 THEN N'Verano'
            WHEN MONTH(s.Sol_fecha) BETWEEN 4 AND 6 THEN N'Otono'
            WHEN MONTH(s.Sol_fecha) BETWEEN 7 AND 9 THEN N'Invierno'
            ELSE N'Primavera'
        END
    FROM [PROYECTO_S.E.L.F].Sol_cotizacion s
    WHERE s.Sol_fecha IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
          WHERE t.tiempo_anio = YEAR(s.Sol_fecha)
            AND t.tiempo_mes = MONTH(s.Sol_fecha)
      );

    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_TIEMPO
        (tiempo_anio, tiempo_cuatrimestre, tiempo_mes, tiempo_temporada)
    SELECT DISTINCT
        YEAR(p.Prop_fecha),
        CASE
            WHEN MONTH(p.Prop_fecha) BETWEEN 1 AND 4 THEN 1
            WHEN MONTH(p.Prop_fecha) BETWEEN 5 AND 8 THEN 2
            ELSE 3
        END,
        MONTH(p.Prop_fecha),
        CASE
            WHEN MONTH(p.Prop_fecha) BETWEEN 1 AND 3 THEN N'Verano'
            WHEN MONTH(p.Prop_fecha) BETWEEN 4 AND 6 THEN N'Otono'
            WHEN MONTH(p.Prop_fecha) BETWEEN 7 AND 9 THEN N'Invierno'
            ELSE N'Primavera'
        END
    FROM [PROYECTO_S.E.L.F].Propuesta p
    WHERE p.Prop_fecha IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
          WHERE t.tiempo_anio = YEAR(p.Prop_fecha)
            AND t.tiempo_mes = MONTH(p.Prop_fecha)
      );

    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_TIEMPO
        (tiempo_anio, tiempo_cuatrimestre, tiempo_mes, tiempo_temporada)
    SELECT DISTINCT
        YEAR(p.Prop_fecha_inicio),
        CASE
            WHEN MONTH(p.Prop_fecha_inicio) BETWEEN 1 AND 4 THEN 1
            WHEN MONTH(p.Prop_fecha_inicio) BETWEEN 5 AND 8 THEN 2
            ELSE 3
        END,
        MONTH(p.Prop_fecha_inicio),
        CASE
            WHEN MONTH(p.Prop_fecha_inicio) BETWEEN 1 AND 3 THEN N'Verano'
            WHEN MONTH(p.Prop_fecha_inicio) BETWEEN 4 AND 6 THEN N'Otono'
            WHEN MONTH(p.Prop_fecha_inicio) BETWEEN 7 AND 9 THEN N'Invierno'
            ELSE N'Primavera'
        END
    FROM [PROYECTO_S.E.L.F].Propuesta p
    WHERE p.Prop_fecha_inicio IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
          WHERE t.tiempo_anio = YEAR(p.Prop_fecha_inicio)
            AND t.tiempo_mes = MONTH(p.Prop_fecha_inicio)
      );

    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_TIEMPO
        (tiempo_anio, tiempo_cuatrimestre, tiempo_mes, tiempo_temporada)
    SELECT DISTINCT
        YEAR(e.Encu_fecha),
        CASE
            WHEN MONTH(e.Encu_fecha) BETWEEN 1 AND 4 THEN 1
            WHEN MONTH(e.Encu_fecha) BETWEEN 5 AND 8 THEN 2
            ELSE 3
        END,
        MONTH(e.Encu_fecha),
        CASE
            WHEN MONTH(e.Encu_fecha) BETWEEN 1 AND 3 THEN N'Verano'
            WHEN MONTH(e.Encu_fecha) BETWEEN 4 AND 6 THEN N'Otono'
            WHEN MONTH(e.Encu_fecha) BETWEEN 7 AND 9 THEN N'Invierno'
            ELSE N'Primavera'
        END
    FROM [PROYECTO_S.E.L.F].Encuesta e
    WHERE e.Encu_fecha IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
          WHERE t.tiempo_anio = YEAR(e.Encu_fecha)
            AND t.tiempo_mes = MONTH(e.Encu_fecha)
      );
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


CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_FACT_VENTA
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA (
        fact_venta_tiempo_id,
        fact_venta_rango_etario_id,
        fact_venta_canal_id,
        fact_venta_tipo_servicio,
        fact_venta_cantidad,
        fact_venta_importe_total,
        fact_venta_descuento
    )
    SELECT
        t.tiempo_id,
        r.id_rango_etario,
        v.Vent_id_canal,
        ts.tipo_servicio_id,
        COUNT(*) AS fact_venta_cantidad,
        SUM(ISNULL(v.Vent_importe_total, 0)) AS fact_venta_importe_total,
        SUM(ISNULL(v.Vent_descuento, 0)) AS fact_venta_descuento
    FROM [PROYECTO_S.E.L.F].Venta v
    JOIN [PROYECTO_S.E.L.F].Cliente c
        ON c.Clie_id_cliente = v.Vent_id_cliente
    JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
        ON t.tiempo_anio = YEAR(v.Vent_fecha)
       AND t.tiempo_mes = MONTH(v.Vent_fecha)
    JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
        ON (
            DATEDIFF(YEAR, c.Clie_fecha_nac, v.Vent_fecha)
            - CASE
                WHEN DATEADD(
                        YEAR,
                        DATEDIFF(YEAR, c.Clie_fecha_nac, v.Vent_fecha),
                        c.Clie_fecha_nac
                     ) > v.Vent_fecha
                THEN 1
                ELSE 0
              END
        ) BETWEEN r.rango_etario_desde
              AND ISNULL(r.rango_etario_hasta, 999) /* Este datediff se lo pedi a la ia para diferenciar los que cumplieron en el año o no a la hora de realizar la transaccion*/
    JOIN [PROYECTO_S.E.L.F].BI_DIM_TIPO_SERVICIO ts
        ON ts.tipo_servicio_descripcion =
           CASE
                WHEN v.Vent_id_propuesta IS NULL THEN N'Venta Directa'
                ELSE N'Propuesta a Medida'
           END
    WHERE v.Vent_fecha IS NOT NULL
      AND c.Clie_fecha_nac IS NOT NULL
      AND v.Vent_id_canal IS NOT NULL
    GROUP BY
        t.tiempo_id,
        r.id_rango_etario,
        v.Vent_id_canal,
        ts.tipo_servicio_id;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_FACT_SOLICITUD
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_FACT_SOLICITUD (
        fact_solicitud_tiempo_id,
        fact_solicitud_rango_etario_id,
        fact_solicitud_cantidad,
        fact_solicitud_dias_anticipacion_total
    )
    SELECT
        t.tiempo_id,
        r.id_rango_etario,
        COUNT(*) AS fact_solicitud_cantidad,
        SUM(DATEDIFF(DAY, s.Sol_fecha, s.Sol_fecha_inicio)) AS fact_solicitud_dias_anticipacion_total
    FROM [PROYECTO_S.E.L.F].Sol_cotizacion s
    JOIN [PROYECTO_S.E.L.F].Cliente c
        ON c.Clie_id_cliente = s.Sol_id_cliente
    JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
        ON t.tiempo_anio = YEAR(s.Sol_fecha)
       AND t.tiempo_mes = MONTH(s.Sol_fecha)
    JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
        ON (
            DATEDIFF(YEAR, c.Clie_fecha_nac, s.Sol_fecha)
            - CASE
                WHEN DATEADD(
                        YEAR,
                        DATEDIFF(YEAR, c.Clie_fecha_nac, s.Sol_fecha),
                        c.Clie_fecha_nac
                     ) > s.Sol_fecha
                THEN 1
                ELSE 0
              END
        ) BETWEEN r.rango_etario_desde
              AND ISNULL(r.rango_etario_hasta, 999)
    WHERE s.Sol_fecha IS NOT NULL
      AND s.Sol_fecha_inicio IS NOT NULL
      AND c.Clie_fecha_nac IS NOT NULL
    GROUP BY
        t.tiempo_id,
        r.id_rango_etario;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_FACT_PROPUESTA
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA (
        fact_propuesta_tiempo_id,
        fact_propuesta_rango_etario_agente_id,
        fact_propuesta_estado,
        fact_propuesta_cantidad,
        fact_propuesta_importe,
        fact_propuesta_presupuesto_estimado,
        fact_propuesta_dias_estimados_total
    )
    SELECT
        t.tiempo_id,
        r.id_rango_etario,
        p.Prop_id_estado,
        COUNT(*) AS fact_propuesta_cantidad,
        SUM(ISNULL(p.Prop_importe_total, 0)) AS fact_propuesta_importe,
        SUM(ISNULL(s.Sol_presupuesto, 0)) AS fact_propuesta_presupuesto_estimado,
        SUM(DATEDIFF(DAY, s.Sol_fecha, CAST(p.Prop_fecha AS DATE))) AS fact_propuesta_dias_estimados_total
    FROM [PROYECTO_S.E.L.F].Propuesta p
    JOIN [PROYECTO_S.E.L.F].Sol_cotizacion s
        ON s.Sol_id_solicitud = p.Prop_id_solicitud
    JOIN [PROYECTO_S.E.L.F].Agente a
        ON a.Agt_id_agente = p.Prop_id_agente
    JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
        ON t.tiempo_anio = YEAR(ISNULL(CAST(p.Prop_fecha_inicio AS DATE), CAST(p.Prop_fecha AS DATE)))
       AND t.tiempo_mes = MONTH(ISNULL(CAST(p.Prop_fecha_inicio AS DATE), CAST(p.Prop_fecha AS DATE)))
    JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
        ON (
            DATEDIFF(YEAR, a.Agt_fecha_nac, CAST(p.Prop_fecha AS DATE))
            - CASE
                WHEN DATEADD(
                        YEAR,
                        DATEDIFF(YEAR, a.Agt_fecha_nac, CAST(p.Prop_fecha AS DATE)),
                        a.Agt_fecha_nac
                     ) > CAST(p.Prop_fecha AS DATE)
                THEN 1
                ELSE 0
              END
        ) BETWEEN r.rango_etario_desde
              AND ISNULL(r.rango_etario_hasta, 999)
    WHERE p.Prop_fecha IS NOT NULL
      AND s.Sol_fecha IS NOT NULL
      AND a.Agt_fecha_nac IS NOT NULL
      AND p.Prop_id_estado IS NOT NULL
    GROUP BY
        t.tiempo_id,
        r.id_rango_etario,
        p.Prop_id_estado;
END;
GO

CREATE PROCEDURE [PROYECTO_S.E.L.F].Migrar_BI_FACT_ENCUESTA
AS
BEGIN
    INSERT INTO [PROYECTO_S.E.L.F].BI_DIM_FACT_ENCUESTA (
        fact_encuesta_tiempo_id,
        fact_encuesta_rango_etario_id,
        fact_encuesta_aspecto_id,
        fact_encuesta_cantidad,
        fact_encuesta_puntaje_total
    )
    SELECT
        t.tiempo_id,
        r.id_rango_etario,
        ba.aspecto_id,
        COUNT(*) AS fact_encuesta_cantidad,
        SUM(ISNULL(a.Aspe_puntaje, 0)) AS fact_encuesta_puntaje_total
    FROM [PROYECTO_S.E.L.F].Aspecto a
    JOIN [PROYECTO_S.E.L.F].Encuesta e
        ON e.Encu_id_encuesta = a.Aspe_id_encuesta
    JOIN [PROYECTO_S.E.L.F].Agente ag
        ON ag.Agt_id_agente = e.Encu_id_agente
    JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
        ON t.tiempo_anio = YEAR(e.Encu_fecha)
       AND t.tiempo_mes = MONTH(e.Encu_fecha)
    JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
        ON (
            DATEDIFF(YEAR, ag.Agt_fecha_nac, e.Encu_fecha)
            - CASE
                WHEN DATEADD(
                        YEAR,
                        DATEDIFF(YEAR, ag.Agt_fecha_nac, e.Encu_fecha),
                        ag.Agt_fecha_nac
                     ) > e.Encu_fecha
                THEN 1
                ELSE 0
              END
        ) BETWEEN r.rango_etario_desde
              AND ISNULL(r.rango_etario_hasta, 999)
    JOIN [PROYECTO_S.E.L.F].BI_DIM_ASPECTO ba
        ON ba.aspecto_descripcion = a.Aspe_nombre
    WHERE e.Encu_fecha IS NOT NULL
      AND ag.Agt_fecha_nac IS NOT NULL
      AND a.Aspe_nombre IS NOT NULL
    GROUP BY
        t.tiempo_id,
        r.id_rango_etario,
        ba.aspecto_id;
END;
GO

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

/* vistas */

CREATE VIEW [PROYECTO_S.E.L.F].BI_V_TICKET_PROMEDIO
AS
SELECT
    t.tiempo_anio,
    t.tiempo_mes,
    r.rango_etario_descripcion,
    c.canal_venta_tipo,
    CAST(SUM(v.fact_venta_importe_total) * 1.0
    / NULLIF(SUM(v.fact_venta_cantidad), 0)
AS DECIMAL(18,2)) AS ticket_promedio
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA v
JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = v.fact_venta_tiempo_id
JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
    ON r.id_rango_etario = v.fact_venta_rango_etario_id
JOIN [PROYECTO_S.E.L.F].BI_DIM_CANAL_VENTA c
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
    NULLIF((
        SELECT SUM(v2.fact_venta_importe_total)
        FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_VENTA v2
        JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t2
            ON t2.tiempo_id = v2.fact_venta_tiempo_id
        WHERE t2.tiempo_anio = t.tiempo_anio
          AND t2.tiempo_cuatrimestre = t.tiempo_cuatrimestre
    ), 0) AS porcentaje_facturacion
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

CREATE VIEW [PROYECTO_S.E.L.F].BI_SOLICITUDES_POR_TEMPORADA
AS
SELECT
    SUM(s.fact_solicitud_cantidad) AS cantidad_de_solicitudes,
    t.tiempo_anio,
    t.tiempo_temporada,
    r.rango_etario_descripcion
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_SOLICITUD s
JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
    ON r.id_rango_etario = s.fact_solicitud_rango_etario_id
JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = s.fact_solicitud_tiempo_id
GROUP BY
    t.tiempo_anio,
    t.tiempo_temporada,
    r.rango_etario_descripcion;
GO

CREATE VIEW [PROYECTO_S.E.L.F].BI_SOLICITUDES_ANTICIPACION_PROMEDIO
AS
SELECT
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    r.rango_etario_descripcion,
    SUM(s.fact_solicitud_dias_anticipacion_total) * 1.0 /
        NULLIF(SUM(s.fact_solicitud_cantidad), 0) AS promedio_dias_anticipacion
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_SOLICITUD s
JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
    ON r.id_rango_etario = s.fact_solicitud_rango_etario_id
JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = s.fact_solicitud_tiempo_id
GROUP BY
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    r.rango_etario_descripcion;
GO

CREATE VIEW [PROYECTO_S.E.L.F].BI_TASA_ACEPTACION_PROPUESTAS
AS
SELECT
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    SUM(p.fact_propuesta_cantidad) AS total_propuestas,
    SUM(CASE
            WHEN e.estado_propuesta_descripcion = N'Aceptada'
            THEN p.fact_propuesta_cantidad
            ELSE 0
        END) AS propuestas_aceptadas,
    SUM(CASE
            WHEN e.estado_propuesta_descripcion = N'Aceptada'
            THEN p.fact_propuesta_cantidad
            ELSE 0
        END) * 100.0 / NULLIF(SUM(p.fact_propuesta_cantidad), 0) AS porcentaje_aceptacion
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA p
JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = p.fact_propuesta_tiempo_id
JOIN [PROYECTO_S.E.L.F].BI_DIM_ESTADO_PROPUESTA e
    ON e.estado_propuesta_id = p.fact_propuesta_estado
GROUP BY
    t.tiempo_anio,
    t.tiempo_cuatrimestre;
GO

CREATE VIEW [PROYECTO_S.E.L.F].BI_COTIZACION_PROMEDIO_TEMPORADA
AS
SELECT
    t.tiempo_anio,
    t.tiempo_temporada,
    SUM(p.fact_propuesta_importe) * 1.0 /
        NULLIF(SUM(p.fact_propuesta_cantidad), 0) AS cotizacion_promedio
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA p
JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = p.fact_propuesta_tiempo_id
GROUP BY
    t.tiempo_anio,
    t.tiempo_temporada;
GO

CREATE VIEW [PROYECTO_S.E.L.F].BI_TIEMPO_PROMEDIO_RESPUESTA
AS
SELECT
    t.tiempo_anio,
    t.tiempo_mes,
    r.rango_etario_descripcion,
    SUM(p.fact_propuesta_dias_estimados_total) * 1.0 /
        NULLIF(SUM(p.fact_propuesta_cantidad), 0) AS tiempo_promedio_respuesta
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA p
JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = p.fact_propuesta_tiempo_id
JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
    ON r.id_rango_etario = p.fact_propuesta_rango_etario_agente_id
GROUP BY
    t.tiempo_anio,
    t.tiempo_mes,
    r.rango_etario_descripcion;
GO

CREATE VIEW [PROYECTO_S.E.L.F].BI_DESVIO_PRESUPUESTO
AS
SELECT
    SUM(p.fact_propuesta_importe - p.fact_propuesta_presupuesto_estimado) * 1.0 /
        NULLIF(SUM(p.fact_propuesta_cantidad), 0) AS desvio_promedio
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_PROPUESTA p;
GO

CREATE VIEW [PROYECTO_S.E.L.F].BI_RANKING_ASPECTOS
AS
SELECT
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    a.aspecto_descripcion,
    SUM(e.fact_encuesta_puntaje_total) * 1.0 /
        NULLIF(SUM(e.fact_encuesta_cantidad), 0) AS promedio_puntaje
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_ENCUESTA e
 JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = e.fact_encuesta_tiempo_id
JOIN [PROYECTO_S.E.L.F].BI_DIM_ASPECTO a
    ON a.aspecto_id = e.fact_encuesta_aspecto_id
GROUP BY
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    a.aspecto_descripcion;
GO

CREATE VIEW [PROYECTO_S.E.L.F].BI_SATISFACCION_PROMEDIO_AGENTE
AS
SELECT
    t.tiempo_anio,
    t.tiempo_mes,
    r.rango_etario_descripcion,
    SUM(e.fact_encuesta_puntaje_total) * 1.0 /
        NULLIF(SUM(e.fact_encuesta_cantidad), 0) AS satisfaccion_promedio
FROM [PROYECTO_S.E.L.F].BI_DIM_FACT_ENCUESTA e
JOIN [PROYECTO_S.E.L.F].BI_DIM_TIEMPO t
    ON t.tiempo_id = e.fact_encuesta_tiempo_id
JOIN [PROYECTO_S.E.L.F].BI_DIM_RANGO_ETARIO r
    ON r.id_rango_etario = e.fact_encuesta_rango_etario_id
GROUP BY
    t.tiempo_anio,
    t.tiempo_mes,
    r.rango_etario_descripcion;
GO