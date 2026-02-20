/* =============================================================================
   02_INGESTA_Y_STRESS_TEST: E-COMATRICS
   Lógica de autogestión de datos para validación de integridad y performance.
   ============================================================================= */

-- A. CARGA DE DIMENSIONES MAESTRAS (Requisito de Integridad)
-- Generamos 100 clientes para asegurar una distribución realista en los índices
INSERT INTO dim_cliente (id, nombre, correo)
SELECT 
    i, 
    'Mock_Customer_' || i, 
    'user_' || i || '@ecomatrics.test'
FROM generate_series(1, 100) i
ON CONFLICT (id) DO NOTHING;

-- Carga de campañas con presupuesto proyectado
INSERT INTO dim_campania (id, nombre, presupuesto, fecha_inicio) VALUES
(1, 'Cyber Monday', 10000, NOW()),
(2, 'Summer Sale', 5000, NOW()),
(3, 'Flash Promo', 2000, NOW()),
(4, 'Rebranding 2026', 3500, NOW()),
(5, 'Black Friday', 12000, NOW())
ON CONFLICT (id) DO NOTHING;

-- B. SIMULACIÓN DE CARGA MASIVA (Dinámica y Resiliente)
-- Implementamos subconsultas aleatorias para garantizar consistencia referencial absoluta.

-- Carga Hoy e Histórica (10,000 registros)
INSERT INTO fact_interacciones (cliente_id, campania_id, costo_clic, valor_conversion, timestamp_evento)
SELECT 
    (SELECT id FROM dim_cliente ORDER BY random() LIMIT 1), 
    (SELECT id FROM dim_campania ORDER BY random() LIMIT 1), 
    (random()*5)::numeric(10,4),
    CASE WHEN random() > 0.9 THEN (random()*100)::numeric(12,2) ELSE 0 END,
    NOW() - (random() * interval '1 hour')
FROM generate_series(1, 10000);

-- Carga Ayer para Análisis Comparativo de Deltas (1,000 registros)
INSERT INTO fact_interacciones (cliente_id, campania_id, costo_clic, valor_conversion, timestamp_evento)
SELECT 
    (SELECT id FROM dim_cliente ORDER BY random() LIMIT 1), 
    (SELECT id FROM dim_campania ORDER BY random() LIMIT 1), 
    (random()*2)::numeric(10,4), 
    (random()*30)::numeric(12,2),
    CURRENT_DATE - INTERVAL '1 day' + (random() * interval '23 hours')
FROM generate_series(1, 1000);

-- C. CASO DE USO: LATE-ARRIVING DATA
-- Evento que llega con retraso pero debe ser procesado por la ventana de tiempo correcta.
INSERT INTO fact_interacciones (cliente_id, campania_id, costo_clic, valor_conversion, timestamp_evento)
VALUES (
    (SELECT id FROM dim_cliente ORDER BY random() LIMIT 1), 
    3, 0.50, 25.00, NOW() - INTERVAL '3 hours'
);