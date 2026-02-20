/* =============================================================================
   1. MONITOREO EN TIEMPO REAL (OPERACIONES)
   Objetivo: Detección de picos de tráfico para decisiones inmediatas.
   ============================================================================= */

-- Consulta: El "Minuto de Oro"
SELECT 
    c.nombre AS campania,
    COUNT(f.id) AS clics_ultimo_minuto,
    SUM(f.costo_clic) AS gasto_instante,
    ROUND(SUM(f.valor_conversion), 2) AS retorno_instante,
    CASE 
        WHEN COUNT(f.id) > 50 THEN '🔥 TRÁFICO ALTO'
        ELSE '🟢 NORMAL'
    END AS estado_trafico
FROM dim_campania c
JOIN fact_interacciones f ON c.id = f.campania_id
WHERE f.timestamp_evento >= NOW() - INTERVAL '1 minute'
GROUP BY c.nombre
ORDER BY clics_ultimo_minuto DESC;

/* =============================================================================
   2. CAPA DE VISUALIZACIÓN (REPORTING)
   ============================================================================= */

-- Vista para métricas generales de ROI (Uso ejecutivo)
CREATE OR REPLACE VIEW vista_monitoreo_ejecutivo AS
SELECT 
    c.nombre AS campania,
    COUNT(f.id) AS total_clics,
    ROUND(SUM(f.costo_clic), 2) AS inversion,
    ROUND(SUM(f.valor_conversion), 2) AS retorno,
    ROUND((SUM(f.valor_conversion) / NULLIF(SUM(f.costo_clic), 0)), 2) AS roi
FROM dim_campania c
JOIN fact_interacciones f ON c.id = f.campania_id
GROUP BY c.nombre;

-- Análisis Comparativo Diario (Variación Hoy vs Ayer)
WITH metricas_por_dia AS (
    SELECT 
        c.nombre AS campania,
        CAST(f.timestamp_evento AS DATE) AS fecha,
        SUM(f.valor_conversion) AS ingresos_dia
    FROM dim_campania c
    JOIN fact_interacciones f ON c.id = f.campania_id
    WHERE f.timestamp_evento >= CURRENT_DATE - INTERVAL '1 day'
    GROUP BY c.nombre, CAST(f.timestamp_evento AS DATE)
)
SELECT 
    hoy.campania,
    ROUND(hoy.ingresos_dia, 2) AS ingresos_hoy,
    ROUND(COALESCE(ayer.ingresos_dia, 0), 2) AS ingresos_ayer,
    ROUND(
        CASE 
            WHEN COALESCE(ayer.ingresos_dia, 0) = 0 THEN 100.00
            ELSE ((hoy.ingresos_dia - ayer.ingresos_dia) / ayer.ingresos_dia) * 100 
        END, 2
    ) AS variacion_pct
FROM metricas_por_dia hoy
LEFT JOIN metricas_por_dia ayer 
    ON hoy.campania = ayer.campania 
    AND hoy.fecha = (ayer.fecha + INTERVAL '1 day')::DATE
WHERE hoy.fecha = CURRENT_DATE;

/* =============================================================================
   3. ANÁLISIS DE COMPORTAMIENTO (COHORTES)
   ============================================================================= */

-- Identificar clientes que saltaron de una campaña a otra en menos de 7 días
WITH historial_cliente AS (
    SELECT 
        cliente_id,
        campania_id,
        timestamp_evento,
        LAG(campania_id) OVER(PARTITION BY cliente_id ORDER BY timestamp_evento) AS campania_anterior,
        LAG(timestamp_evento) OVER(PARTITION BY cliente_id ORDER BY timestamp_evento) AS fecha_anterior
    FROM fact_interacciones
)
SELECT 
    cliente_id,
    campania_anterior,
    campania_id AS campania_actual,
    (timestamp_evento - fecha_anterior) AS tiempo_entre_interacciones
FROM historial_cliente
WHERE campania_anterior IS NOT NULL 
  AND timestamp_evento - fecha_anterior <= INTERVAL '7 days';