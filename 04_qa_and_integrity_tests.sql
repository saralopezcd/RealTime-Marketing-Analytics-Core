/* =============================================================================
   1. AUDITORÍA DE INGESTA (LATE-ARRIVING DATA)
   ============================================================================= */

-- Simulación de evento con retraso de red (3 horas)
INSERT INTO fact_interacciones (cliente_id, campania_id, costo_clic, valor_conversion, timestamp_evento)
VALUES (1, 3, 0.50, 25.00, NOW() - INTERVAL '3 hours');

-- Consulta para detectar Lag de Datos (Auditoría para Laura Sánchez)
SELECT 
    id, 
    timestamp_evento AS ocurrido_el, 
    timestamp_ingesta AS procesado_el,
    (timestamp_ingesta - timestamp_evento) AS lag_tiempo
FROM fact_interacciones
ORDER BY lag_tiempo DESC
LIMIT 5;

/* =============================================================================
   2. MONITOREO DE SALUD DEL SISTEMA (DATA DRIFT)
   ============================================================================= */

-- Detector de anomalías de costo (Alerta automática)
WITH metricas_costo AS (
    SELECT 
        AVG(costo_clic) FILTER (WHERE timestamp_evento >= NOW() - INTERVAL '1 hour' AND timestamp_evento < NOW() - INTERVAL '10 minutes') AS promedio_hora_pasada,
        AVG(costo_clic) FILTER (WHERE timestamp_evento >= NOW() - INTERVAL '10 minutes') AS promedio_ultimos_10min
    FROM fact_interacciones
)
SELECT 
    ROUND(promedio_hora_pasada, 4) AS ref_costo,
    ROUND(promedio_ultimos_10min, 4) AS actual_costo,
    CASE 
        WHEN promedio_ultimos_10min > (promedio_hora_pasada * 1.5) THEN '🚨 ALERTA: Data Drift detectado (Costo +50%)'
        ELSE '✅ Costos bajo control'
    END AS estado_sistema
FROM metricas_costo;

/* =============================================================================
   3. REPORTE DE DISTRIBUCIÓN (ROI POR HORA)
   ============================================================================= */
SELECT 
    EXTRACT(HOUR FROM timestamp_evento) AS hora,
    COUNT(*) AS volumen_clics,
    ROUND(SUM(valor_conversion), 2) AS ingresos,
    ROUND((SUM(valor_conversion) / NULLIF(SUM(costo_clic), 0)), 2) AS roi_horario
FROM fact_interacciones
GROUP BY 1 ORDER BY 1;