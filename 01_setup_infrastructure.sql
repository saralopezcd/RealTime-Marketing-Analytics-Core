/* ESTRUCTURA DE DATOS E-COMATRICS
   Diseñada para alta escalabilidad y precisión financiera.
*/

-- 1. DIMENSIONES MAESTRAS
CREATE TABLE dim_cliente (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100) UNIQUE
);

CREATE TABLE dim_campania (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    presupuesto DECIMAL(15,2),
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP
);

-- 2. TABLA DE HECHOS (Particionada en producción)
CREATE TABLE fact_interacciones (
    id BIGSERIAL PRIMARY KEY,
    cliente_id INT REFERENCES dim_cliente(id),
    campania_id INT REFERENCES dim_campania(id),
    timestamp_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    timestamp_ingesta TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Auditoría de streaming
    costo_clic DECIMAL(10,4), -- Precisión técnica para micro-costos
    valor_conversion DECIMAL(12,2)
);

-- 3. ESTRATEGIA DE INDEXACIÓN B-TREE
CREATE INDEX idx_fact_campania_id ON fact_interacciones USING btree (campania_id);
CREATE INDEX idx_fact_timestamp ON fact_interacciones USING btree (timestamp_evento);
CREATE INDEX idx_perf_campania_tiempo ON fact_interacciones (campania_id, timestamp_evento);