# 🛢️ Global Energy Crisis Monitor: End-to-End BI Solution

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-black?style=for-the-badge&logo=analytics&logoColor=white)

## 📌 Descripción del Proyecto
En un entorno de alta volatilidad geopolítica, entender la relación entre los mercados energéticos y la economía real es vital. Este proyecto es una solución integral de **Business Intelligence** que analiza cómo las crisis globales (Pandemia, Conflictos Bélicos) impactan en los precios minoristas de gasolina y la inflación regional, permitiendo identificar patrones de resiliencia y zonas de riesgo crítico.

---

## 📖 Storytelling: La Narrativa de los Datos
El mercado energético no se mueve solo por oferta y demanda, sino por **percepciones y eventos disruptivos**. 

1. **El Problema:** Las organizaciones carecen de una vista unificada para comparar el crudo con la gasolina local debido a la disparidad de escalas. Comparar precios de $50 USD con centavos de dólar genera ruido visual.
2. **El Enfoque:** Implementé una técnica de **Normalización (Base 100)** para nivelar el campo de juego. Esto nos permitió descubrir que, durante choques de oferta, la gasolina tiende a indexar su precio un **15% más rápido** que la materia prima.
3. **La Conclusión:** El dashboard no solo muestra datos; clasifica el mundo en **Cuadrantes de Riesgo**. Revelamos que regiones como Europa enfrentan una "Zona Crítica" donde la inflación y la volatilidad coinciden, exigiendo medidas de intervención urgentes.

---

## 📐 Arquitectura Técnica

1. **Data Foundation:** Limpieza, normalización y tratamiento de registros históricos en **MySQL**, asegurando la integridad referencial y eliminando redundancias en las series temporales.
2. **Modeling:** Diseño de un **Esquema en Estrella (Star Schema)** optimizado para analítica, vinculando tablas de hechos de precios con dimensiones de Geografía, Calendario y Eventos de Crisis.
3. **Analytics Layer:** Implementación de **Vistas SQL** y medidas **DAX Avanzadas** para el cálculo de volatilidad dinámica, promedios móviles y segmentación por cuadrantes.

---

## 📊 Dashboard & Insights Clave

### 1. Monitor de Volatilidad e Índice 100
Análisis de correlación técnica: Gracias a la normalización, se observa el "desacoplamiento" de precios. El evento **Russia-Ukraine War** registró una volatilidad del **26.14%**, superando el impacto de la Pandemia COVID-19.

![Monitor de Volatilidad](Imagenes/1_volatilidad_index.png)

---

### 2. Matriz de Eficiencia Económica (Scatter Analysis)
Uso de analítica avanzada para segmentar regiones. Dividí el mapa en 4 cuadrantes basados en promedios globales:
* **Zona Crítica (Rojo):** Alta Inflación + Alta Volatilidad (Liderado por Europa).
* **Zona Resiliente (Verde):** Estabilidad en ambos indicadores.

![Matriz de Eficiencia](Imagenes/2_scatter_cuadrantes.png)

---

## 🚀 Impacto y Valor de Negocio
* **Predicción de Riesgo:** Identificación temprana de regiones vulnerables a choques inflacionarios externos.
* **Transparencia en la Cadena de Costos:** Claridad sobre la rapidez de la transferencia de costos (Pass-through) del crudo al consumidor final.
* **Arquitectura Escalable:** El modelo permite añadir nuevos indicadores (PIB, Tasas de Interés) sin comprometer el rendimiento.

---

## 👤 Sobre mí
Soy **Marccell Alejandro Vilchez Calero**, profesional en Contabilidad Pública y Finanzas con una especialización técnica en **Data Analysis**. Mi enfoque es el "Zero-Footprint Personalization": utilizar datos con precisión mecánica para resolver problemas de negocio.

Mi metodología se basa en:
* **Asertividad Analítica:** No pregunto qué datos hay, propongo qué respuestas necesitamos encontrar para marcar territorio en el mercado.
* **UX Analítica:** Diseño dashboards intuitivos en "Dark Mode" donde la respuesta estratégica está a solo un clic de distancia.
* **Eficiencia Técnica:** Modelos de datos escalables, optimizados desde la query SQL hasta el visual final.

---

## 💼 Servicios & Colaboración
* **End-to-End BI:** Desarrollo de proyectos desde la base de datos hasta el storytelling visual.
* **Consultoría Financiera:** Automatización de reportes contables y análisis de volatilidad de costos.
* **Optimización de Modelos:** Diseño de arquitecturas de datos (Star Schema) y DAX avanzado.

---
_Proyecto finalizado en 2026 como parte de mi portafolio profesional de Business Intelligence._
