
-- Crear Base de Datos para el Estudio

CREATE DATABASE Caso_Petroleo_BD;

USE Caso_Petroleo_BD;

-- Creacion de Tabla en la Base de Datos

CREATE TABLE stg_petrol_prices (
    record_date DATE,
    country VARCHAR(100),
    region VARCHAR(100),
    petrol_price_usd DECIMAL(10, 4),
    diesel_price_usd DECIMAL(10, 4),
    natural_gas_price_usd DECIMAL(10, 4),
    crude_oil_price_usd DECIMAL(10, 4),
    inflation_rate_pct DECIMAL(8, 4),
    exchange_rate_vs_usd DECIMAL(12, 6),
    gdp_growth_pct DECIMAL(8, 4),
    supply_index DECIMAL(8, 2),
    demand_index DECIMAL(8, 2),
    geopolitical_risk_index DECIMAL(8, 2),
    event_flag TINYINT(1),
    event_description VARCHAR(255) NULL,
    currency_devaluation_pct DECIMAL(8, 4) NULL,
    subsidy_level VARCHAR(50),
    tax_rate_on_fuel_pct DECIMAL(8, 4),
    petrol_7d_ma DECIMAL(10, 4) NULL,
    petrol_28d_vol DECIMAL(12, 8) NULL,
    petrol_lag_1 DECIMAL(10, 4) NULL,
    crude_lag_1 DECIMAL(10, 4) NULL
);

-- Carga de los datos

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/petrol_gas_price_analysis_clean.csv' 
INTO TABLE stg_petrol_prices 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS 
(
    @Date, @Country, @Region, @Petrol, @Diesel, @NatGas, @Crude, @Inflation, @Exchange, @GDP, 
    @Supply, @Demand, @GeoRisk, @EventFlag, @EventDesc, @Devaluation, @Subsidy, @TaxRate, 
    @Petrol7d, @Petrol28d, @PetrolLag, @CrudeLag
) 
SET 
    record_date = @Date,
    country = @Country,
    region = @Region,
    petrol_price_usd = NULLIF(@Petrol, ''),
    diesel_price_usd = NULLIF(@Diesel, ''),
    natural_gas_price_usd = NULLIF(@NatGas, ''),
    crude_oil_price_usd = NULLIF(@Crude, ''),
    inflation_rate_pct = NULLIF(@Inflation, ''),
    exchange_rate_vs_usd = NULLIF(@Exchange, ''),
    gdp_growth_pct = NULLIF(@GDP, ''),
    supply_index = NULLIF(@Supply, ''),
    demand_index = NULLIF(@Demand, ''),
    geopolitical_risk_index = NULLIF(@GeoRisk, ''),
    event_flag = NULLIF(@EventFlag, ''),
    event_description = NULLIF(@EventDesc, ''),
    currency_devaluation_pct = NULLIF(@Devaluation, ''),
    subsidy_level = @Subsidy,
    tax_rate_on_fuel_pct = NULLIF(@TaxRate, ''),
    petrol_7d_ma = NULLIF(@Petrol7d, ''),
    petrol_28d_vol = NULLIF(@Petrol28d, ''),
    petrol_lag_1 = NULLIF(@PetrolLag, ''),
    crude_lag_1 = NULLIF(@CrudeLag, '');
    
    -- Verificación de los datos
    
   -- 1 Conteo de los registros 
    SELECT COUNT(*) AS Total_Registros 
FROM stg_petrol_prices;

-- 2 Deteccion de los duplicados
SELECT record_date, country, COUNT(*) as Frecuencia
FROM stg_petrol_prices
GROUP BY record_date, country
HAVING Frecuencia > 1;

-- 3 Verificación de integridad de campos clave (Detección de Nulos anómalos):
SELECT 
    SUM(CASE WHEN record_date IS NULL THEN 1 ELSE 0 END) AS Nulos_Fechas,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Nulos_Paises,
    SUM(CASE WHEN petrol_price_usd IS NULL THEN 1 ELSE 0 END) AS Nulos_Precio_Petrol
FROM stg_petrol_prices;

ALTER DATABASE Caso_Petroleo_BD  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    
    
    