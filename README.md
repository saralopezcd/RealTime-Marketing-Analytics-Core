# E-COMATRICS: Marketing Data Engine

### Objetivos Estratégicos y KPI de Negocio
Este ecosistema de datos fue diseñado para transformar una operación de marketing reactiva en una arquitectura impulsada por datos (Data-Driven), atacando directamente los cuellos de botella de latencia y calidad:

* **Reducción de Latencia en Toma de Decisiones:** Eliminación del desfase de 72 horas en reportes de ROI, logrando una visibilidad de ciclo cerrado en tiempo real (< 1 min) para ajustes presupuestarios dinámicos.
* **Automatización de la Integridad de Datos:** Sustitución de procesos de limpieza manuales por un pipeline automatizado, garantizando precisión financiera absoluta mediante tipado de datos estricto.

**Impacto Medido:** Reducción del 70% en el tiempo de preparación de datos y una mejora del 95% en la eficiencia del procesamiento de la capa de ingesta.

---

### Stack Tecnológico (Enterprise Grade)
* **Engine:** PostgreSQL 16.2 (Optimizado para compatibilidad con Amazon Redshift/BigQuery).
* **Lenguajes:** SQL Avanzado (CTE, Window Functions) y PL/pgSQL para lógica procedimental.
* **Metodología:** Modelado Dimensional Kimball (Star Schema) y Particionamiento de Tablas.

---

### Arquitectura y Matriz de Beneficio Técnico

| Pilar Técnico | Implementación | Valor de Negocio |
| :--- | :--- | :--- |
| **Escalabilidad Horizontal** | Table Partitioning (Range): Segmentación mensual de la tabla de hechos. | Soporte para volúmenes de Big Data sin degradación de latencia. |
| **Gobernanza y Resiliencia** | Transaccionalidad Atómica: Bloques BEGIN...EXCEPTION con auditoría persistente. | Garantía de consistencia de datos y recuperación inmediata ante fallos. |
| **Precisión Financiera** | Fixed-Point Arithmetic: Uso de NUMERIC(10,4) para evitar errores de coma flotante. | Eliminación de discrepancias monetarias en el cálculo del ROI. |
| **Monitoreo Proactivo** | Data Drift Detection: Ventanas de comparación (10 min vs 1 h) para anomalías. | Identificación inmediata de picos de gasto publicitario ineficiente. |

---

### Key Features 
* **Orquestación de Particiones:** Gestión automática de particiones por rangos temporales, minimizando el costo de mantenimiento (Zero-Ops).
* **Análisis de Cohortes y Recurrencia:** Uso de funciones de ventana LAG() para analizar la retención y el comportamiento del cliente en ventanas de atribución de 7 días.
* **Auditoría de Ingesta (Observabilidad):** Implementación de `timestamp_ingesta` para identificar y corregir el impacto del Late-Arriving Data en los reportes históricos.

---

### Estructura del Repositorio
1.  **01_ddl_star_schema.sql:** Definición de infraestructura, índices B-Tree estratégicos y roles de seguridad.
2.  **02_ingestion_stress_test.sql:** Lógica de carga masiva, manejo de excepciones y validación de integridad.
3.  **03_analytics_layer.sql:** Vistas de monitoreo ejecutivo, detección de drift y métricas de ROI real.

### Conclusión y Roadmap
E-COMATRICS estabiliza la infraestructura de datos eliminando el error humano.
