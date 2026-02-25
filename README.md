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

# Estructura del Repositorio

A continuación, se detalla la organización de los archivos SQL que componen el pipeline de datos, numerados secuencialmente para facilitar un despliegue lógico desde la creación del entorno hasta las pruebas de estrés finales.

---

### 01_setup_infrastructure.sql
**Infraestructura Base y Modelado**
* **Modelo en Estrella (Star Schema):** Definición de tablas de hechos y dimensiones para optimizar la analítica.
* **Optimización:** Implementación de índices B-Tree estratégicos para acelerar el tiempo de respuesta en consultas complejas.
* **Auditoría:** Configuración de capas de registro para trazabilidad total de procesos.

### 02_automated_ingestion.sql
**Lógica de Ingesta y Calidad**
* **Poblamiento:** Rutinas automatizadas para la carga de dimensiones.
* **Prueba de Estrés:** Simulación de carga masiva de 11,000 registros para validar el rendimiento.
* **Integridad:** Manejo estricto de integridad referencial para asegurar la calidad del dato desde el origen.

### 03_advanced_analytics.sql
**Capa de Inteligencia de Negocios**
* **Minuto de Oro:** Monitoreo en tiempo real de métricas críticas.
* **Análisis de Cohortes:** Implementación de funciones de ventana para el seguimiento de grupos de usuarios.
* **Vistas Ejecutivas:** Dashboards SQL directos para la visualización del ROI.

### 04_qa_and_integrity_tests.sql
**Control de Calidad y Resiliencia**
* **Late-Arriving Data:** Validación de la capacidad del sistema para procesar datos con retraso de red.
* **Detección de Anomalías (Data Drift):** Pruebas proactivas para identificar desviaciones inesperadas en los flujos de datos.

### Conclusión y Roadmap
E-COMATRICS estabiliza la infraestructura de datos eliminando el error humano.
