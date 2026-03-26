# requirements.R
# Dependencias del proyecto: Análisis Sociodemográfico y Laboral — ETOI 2024
# Ejecutar este script una sola vez para instalar todos los paquetes necesarios.

# ── Paquetes requeridos ────────────────────────────────────────────────────────

paquetes <- c(
  "tidyverse",   # Manipulación y transformación de datos (incluye dplyr, tidyr, readr, purrr, stringr, forcats)
  "ggplot2",     # Visualización de datos (incluido en tidyverse, se lista por claridad)
  "scales"       # Formato de ejes en ggplot2 (percent_format, comma, etc.)
)

# ── Instalación automática de los que faltan ───────────────────────────────────

instalar_si_falta <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

invisible(lapply(paquetes, instalar_si_falta))

message("✔ Todos los paquetes están disponibles.")

# ── Versiones verificadas ──────────────────────────────────────────────────────
# R          >= 4.2.0
# tidyverse  >= 2.0.0
# ggplot2    >= 3.4.0
# scales     >= 1.3.0
