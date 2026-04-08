-- 1. CONFIGURACIÓN DE SESIÓN (PARA EVITAR BLOQUEOS)
SET SESSION wait_timeout = 28800;
SET SQL_SAFE_UPDATES = 0;

-- 2. LIMPIEZA TOTAL (BORRAR PARA CONSTRUIR CORRECTAMENTE)
DROP TABLE IF EXISTS fact_fuel_prices;
DROP TABLE IF EXISTS dim_geography;
DROP TABLE IF EXISTS dim_subsidy_status;
DROP TABLE IF EXISTS dim_events;
DROP TABLE IF EXISTS dim_risk_rating;

-- 3. CREACIÓN DE DIMENSIONES
CREATE TABLE dim_geography (
    geography_key INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(100),
    region VARCHAR(100),
    INDEX idx_geo_lookup (country, region)
);

CREATE TABLE dim_subsidy_status (
    subsidy_key INT AUTO_INCREMENT PRIMARY KEY,
    subsidy_level VARCHAR(50),
    INDEX idx_sub_lookup (subsidy_level)
);

CREATE TABLE dim_events (
    event_key INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(255),
    is_crisis_period TINYINT(1) DEFAULT 0,
    INDEX idx_event_lookup (event_name)
);

CREATE TABLE dim_risk_rating (
    risk_key INT PRIMARY KEY,
    risk_label VARCHAR(20),
    min_score DECIMAL(5,2),
    max_score DECIMAL(5,2)
);

-- 4. CREACIÓN DE TABLA DE HECHOS (STAR SCHEMA)
CREATE TABLE fact_fuel_prices (
    fact_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    calendar_key DATE NOT NULL,
    geography_key INT NOT NULL,
    subsidy_key INT NOT NULL,
    event_key INT NOT NULL,
    risk_key INT NOT NULL,
    -- Métricas
    petrol_price_usd DECIMAL(10,4),
    diesel_price_usd DECIMAL(10,4),
    natural_gas_price_usd DECIMAL(10,4),
    crude_oil_price_usd DECIMAL(10,4),
    inflation_rate_pct DECIMAL(8,4),
    exchange_rate_vs_usd DECIMAL(12,6),
    gdp_growth_pct DECIMAL(8,4),
    supply_index DECIMAL(8,2),
    demand_index DECIMAL(8,2),
    geopolitical_risk_index DECIMAL(8,2),
    event_flag TINYINT(1),
    currency_devaluation_pct DECIMAL(8,4),
    tax_rate_on_fuel_pct DECIMAL(8,4),
    -- Relaciones
    CONSTRAINT fk_geo FOREIGN KEY (geography_key) REFERENCES dim_geography(geography_key),
    CONSTRAINT fk_subsidy FOREIGN KEY (subsidy_key) REFERENCES dim_subsidy_status(subsidy_key),
    CONSTRAINT fk_event FOREIGN KEY (event_key) REFERENCES dim_events(event_key),
    CONSTRAINT fk_risk FOREIGN KEY (risk_key) REFERENCES dim_risk_rating(risk_key)
);

-- 5. POBLAR DIMENSIONES
INSERT INTO dim_geography (country, region)
SELECT DISTINCT country, region FROM stg_petrol_prices;

INSERT INTO dim_subsidy_status (subsidy_level)
SELECT DISTINCT subsidy_level FROM stg_petrol_prices;

INSERT INTO dim_events (event_name, is_crisis_period)
SELECT DISTINCT 
    COALESCE(NULLIF(event_description, ''), 'Normal/Sin Evento'),
    CASE WHEN event_flag = 1 THEN 1 ELSE 0 END
FROM stg_petrol_prices;

INSERT INTO dim_risk_rating VALUES 
(1, 'Estable', 0.00, 30.00),
(2, 'Moderado', 30.01, 60.00),
(3, 'Alto Riesgo', 60.01, 100.00);

-- 6. CARGA MAESTRA DE LA TABLA DE HECHOS (TRANSFORMACIÓN Y CARGA)
INSERT INTO fact_fuel_prices (
    calendar_key, geography_key, subsidy_key, event_key, risk_key,
    petrol_price_usd, diesel_price_usd, natural_gas_price_usd, crude_oil_price_usd,
    inflation_rate_pct, exchange_rate_vs_usd, gdp_growth_pct, 
    supply_index, demand_index, geopolitical_risk_index, 
    event_flag, currency_devaluation_pct, tax_rate_on_fuel_pct
)
SELECT 
    s.record_date, 
    g.geography_key, 
    sub.subsidy_key,
    e.event_key,
    CASE 
        WHEN s.geopolitical_risk_index <= 30 THEN 1
        WHEN s.geopolitical_risk_index <= 60 THEN 2
        ELSE 3 
    END as risk_key,
    s.petrol_price_usd, s.diesel_price_usd, s.natural_gas_price_usd, s.crude_oil_price_usd,
    s.inflation_rate_pct, s.exchange_rate_vs_usd, s.gdp_growth_pct,
    s.supply_index, s.demand_index, s.geopolitical_risk_index,
    s.event_flag, s.currency_devaluation_pct, s.tax_rate_on_fuel_pct
FROM stg_petrol_prices s
JOIN dim_geography g ON s.country = g.country AND s.region = g.region
JOIN dim_subsidy_status sub ON s.subsidy_level = sub.subsidy_level
JOIN dim_events e ON COALESCE(NULLIF(s.event_description, ''), 'Normal/Sin Evento') = e.event_name;

-- 7. VALIDACIÓN FINAL DE CUADRE
SELECT 'Staging' as origen, COUNT(*) as registros, SUM(petrol_price_usd) as total_petrol FROM stg_petrol_prices
UNION ALL
SELECT 'Fact Table' as origen, COUNT(*) as registros, SUM(petrol_price_usd) as total_petrol FROM fact_fuel_prices;