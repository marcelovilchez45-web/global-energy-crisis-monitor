-- 1. VISTA MAESTRA (DETALLE TOTAL)

-- Propósito: Desnormalizar el modelo para análisis de series de tiempo y tablas de detalle.
CREATE OR REPLACE VIEW vw_master_fuel_prices AS
SELECT 
    f.calendar_key AS Fecha,
    g.country AS Pais,
    g.region AS Region,
    e.event_name AS Evento,
    CASE WHEN e.is_crisis_period = 1 THEN 'Crisis/Turbulencia' ELSE 'Estabilidad' END AS Estado_Mercado,
    r.risk_label AS Nivel_Riesgo,
    s.subsidy_level AS Politica_Subsidio,
    f.petrol_price_usd AS Precio_Gasolina,
    f.diesel_price_usd AS Precio_Diesel,
    f.natural_gas_price_usd AS Precio_Gas_Natural,
    f.crude_oil_price_usd AS Precio_Crudo,
    f.inflation_rate_pct AS Tasa_Inflacion,
    f.gdp_growth_pct AS Crecimiento_PIB,
    f.exchange_rate_vs_usd AS Tipo_Cambio,
    f.supply_index AS Indice_Suministro,
    f.demand_index AS Indice_Demanda,
    f.geopolitical_risk_index AS Score_Riesgo_Geopolitico
FROM fact_fuel_prices f
JOIN dim_geography g ON f.geography_key = g.geography_key
JOIN dim_events e ON f.event_key = e.event_key
JOIN dim_risk_rating r ON f.risk_key = r.risk_key
JOIN dim_subsidy_status s ON f.subsidy_key = s.subsidy_key;

-- 2. VISTA DE IMPACTO ECONÓMICO (AGREGADA)
-- Propósito: Comparar el impacto de eventos específicos en las métricas macroeconómicas globales.
CREATE OR REPLACE VIEW vw_resumen_impacto_eventos AS
SELECT 
    e.event_name AS Evento,
    COUNT(f.fact_key) AS Total_Semanas_Observadas,
    ROUND(AVG(f.petrol_price_usd), 4) AS Precio_Promedio_Gasolina,
    ROUND(AVG(f.crude_oil_price_usd), 4) AS Precio_Promedio_Crudo,
    ROUND(AVG(f.inflation_rate_pct), 2) AS Inflacion_Media,
    ROUND(AVG(f.gdp_growth_pct), 2) AS PIB_Medio,
    ROUND(AVG(f.geopolitical_risk_index), 2) AS Riesgo_Promedio
FROM fact_fuel_prices f
JOIN dim_events e ON f.event_key = e.event_key
GROUP BY e.event_name;

-- 3. VISTA DE ANÁLISIS REGIONAL Y SUBSIDIOS
-- Propósito: Analizar cómo los subsidios mitigan (o no) el precio final por región.
CREATE OR REPLACE VIEW vw_analisis_subsidios_region AS
SELECT 
    g.region AS Region,
    s.subsidy_level AS Nivel_Subsidio,
    ROUND(AVG(f.petrol_price_usd), 4) AS Precio_Promedio_Gasolina,
    ROUND(AVG(f.tax_rate_on_fuel_pct), 2) AS Tasa_Impuestos_Promedio,
    ROUND(AVG(f.currency_devaluation_pct), 2) AS Devaluacion_Media
FROM fact_fuel_prices f
JOIN dim_geography g ON f.geography_key = g.geography_key
JOIN dim_subsidy_status s ON f.subsidy_key = s.subsidy_key
GROUP BY g.region, s.subsidy_level;