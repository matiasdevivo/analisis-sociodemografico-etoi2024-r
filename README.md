# analisis-sociodemografico-etoi2024-r

# Análisis Sociodemográfico y Laboral — ETOI 2024 (Argentina) 🇦🇷

Trabajo práctico desarrollado en R que analiza los microdatos de la **Encuesta de Trabajo, Ocupación e Ingresos (ETOI) — segundo semestre 2024**, publicada por el INDEC. El script procesa datos a nivel de individuo y hogar para construir indicadores de población, empleo, educación y pobreza, con visualizaciones en `ggplot2`.

---

## 📁 Estructura del proyecto

```
├── TP_R_-_MATIAS_DE_VIVO_vfinal.R   # Script principal de análisis
├── etoi242_usu_ind.txt               # Microdatos individuos (fuente: INDEC)
├── etoi242_usu_hog.txt               # Microdatos hogares  (fuente: INDEC)
├── README.md
└── requirements.R
```

> **Nota:** los archivos de datos no están incluidos en el repositorio. Descargalos desde el sitio oficial del INDEC (ver sección [Datos](#-datos)).

---

## 🔍 Análisis realizados

| N° | Análisis |
|----|----------|
| 1 | Importación y exploración estructural de los microdatos |
| 2 | Población total y cantidad de hogares (expandidos y muestrales) |
| 3 | Distribución por género (ponderada) |
| 4 | Distribución por grupos de edad y edad promedio ponderada |
| 5 | Nivel educativo alcanzado |
| 6 | Tasa de actividad (población ≥ 18 años) |
| 7 | Tasa de empleo y tasa de desempleo |
| 8 | Ingreso laboral promedio de los ocupados |
| 9 | Distribución de pobreza: personas y hogares por estrato |
| 10 | Pobreza por grupos de edad |
| 11 | Distribución de ocupados según zona geográfica |
| 12 | Cruce género × grupo etario |
| 13 | Cruce nivel educativo × condición de actividad |
| 14 | Visualización con `ggplot2` |

---

## 📊 Principales hallazgos

- **Población expandida total:** 3.083.813 personas.
- **Hogares:** 1.352.744 (expandidos).
- **Distribución por género:** 52,90% mujeres — 47,10% varones.
- **Grupo etario más numeroso:** 15–29 años (19,61% de la población).
- **Edad promedio ponderada:** 38,80 años.
- **Tasa de actividad** (18+): **70,74%**.
- **Tasa de empleo:** 92,72% | **Tasa de desempleo:** 7,28%.
- **Ingreso laboral promedio** de ocupados: $734.061,80.
- **Pobreza:** 32,07% de las personas y 26,40% de los hogares son pobres.
- Los grupos más afectados por la pobreza son los **menores de 29 años**.
- A mayor nivel educativo, mayor probabilidad de estar ocupado/a.

---

## 📦 Requisitos

Ver el archivo [`requirements.R`](requirements.R) para la lista de paquetes necesarios e instrucciones de instalación.

**Versión de R recomendada:** ≥ 4.2.0

---

## 🗂 Datos

Los microdatos utilizados son de acceso público y pueden descargarse desde:

🔗 [INDEC — Encuesta de Trabajo, Ocupación e Ingresos (ETOI)](https://www.indec.gob.ar/)

Una vez descargados, colocar los archivos `etoi242_usu_ind.txt` y `etoi242_usu_hog.txt` en el directorio de trabajo antes de ejecutar el script, o bien usar el selector interactivo `setwd(choose.dir())` que está incluido al inicio del script.

---

## ▶️ Cómo ejecutar

```r
# 1. Instalar dependencias (solo la primera vez)
source("requirements.R")

# 2. Abrir y ejecutar el script principal
source("TP_R_-_MATIAS_DE_VIVO_vfinal.R")
```

---

## 👤 Autor

**Matías De Vivo**  
Trabajo Práctico Final — Análisis de Datos con R
