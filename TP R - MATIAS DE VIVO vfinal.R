# RUTA DE LOS ARCHIVOS
setwd(choose.dir())

# Importación de librerias
library(tidyverse)
library(ggplot2)

# 1) Importación de datos
df_ind <- read_delim("etoi242_usu_ind.txt", delim = ";")
df_hog <- read_delim("etoi242_usu_hog.txt", delim = ";")


# 2) Exploración de estructura
glimpse(df_ind)
glimpse(df_hog)

# 3) Calcular POBLACION Y HOGARES

# 3a) Población total 
pobl_total <- df_ind %>%
  summarise(poblacion = sum(fexp, na.rm = TRUE))

pobl_total

# 3b) Cantidad de hogares

hogares_muestral  <- nrow(df_hog)
hogares_expandida <- df_hog %>% summarise(hogares = sum(fexp, na.rm = TRUE))

hogares_muestral
hogares_expandida


# 4) Distribución de género 
dist_genero <- df_ind %>%
  mutate(genero = case_when(
    sexo == 1 ~ "Varón",
    sexo == 2 ~ "Mujer",
    TRUE ~ "NS/NR"
  )) %>%
  count(genero, wt = fexp, name = "n") %>%
  mutate(prop = n / sum(n))

dist_genero


# 5) Distribución por grupos de edad 
df_ind <- df_ind %>%
mutate(grupo_edad = cut(
  edad,
  breaks = c(-Inf, 14, 29, 44, 64, Inf),
  labels = c("0-14", "15-29", "30-44", "45-64", "65+"),
  right = TRUE
))

dist_edad <- df_ind %>%
  count(grupo_edad, wt = fexp, name = "n") %>%
  mutate(prop = n / sum(n))

dist_edad
 
# 6) Edad promedio 

edad_prom <- df_ind %>%
  summarise(edad_promedio = weighted.mean(edad, fexp, na.rm = TRUE))

edad_prom

# 7) Nivel educativo 

count(df_ind, nivel_2, wt = fexp, name = "n") %>% arrange(nivel_2)

df_ind <- df_ind %>%
  mutate(nivel_lbl = case_when(
    nivel_2 == 1 ~ "Primario incompleto",
    nivel_2 == 2 ~ "Primario completo",
    nivel_2 == 3 ~ "Secundario",
    nivel_2 == 4 ~ "Superior/Univ.",
    TRUE ~ "NS/NR"
  ))

# Proporciones ponderadas
niv_educ <- df_ind %>%
  count(nivel_lbl, wt = fexp, name = "n") %>%
  mutate(prop = n / sum(n))

niv_educ

# 8) Tasa de actividad (PEA / población ≥ 18)
df_ind <- df_ind %>%
  mutate(mayor18 = edad >= 18,
         cond_act = case_when(
           estado == 1 ~ "Ocupado",
           estado == 2 ~ "Desocupado",
           estado == 3 ~ "Inactivo",
           TRUE ~ "NS/NR"
         ),
         pea = cond_act %in% c("Ocupado", "Desocupado"))

tasas_act <- df_ind %>%
  filter(mayor18) %>%
  summarise(
    PEA = sum(fexp[pea], na.rm = TRUE),
    Pobl_18p = sum(fexp, na.rm = TRUE),
    tasa_actividad = PEA / Pobl_18p
  )

tasas_act

# 9) Tasa de desempleo

tasas_pea <- df_ind %>%
  filter(mayor18, pea) %>%
  summarise(
    Ocupados   = sum(fexp[cond_act == "Ocupado"],   na.rm = TRUE),
    Desocupados= sum(fexp[cond_act == "Desocupado"],na.rm = TRUE),
    PEA        = sum(fexp, na.rm = TRUE)
  ) %>%
  mutate(
    tasa_empleo     = Ocupados / PEA,
    tasa_desempleo  = Desocupados / PEA
  )

tasas_pea

# 10) Ingreso laboral promedio tasa de ocupados

ingreso_prom_ocup <- df_ind %>%
  filter(cond_act == "Ocupado", !is.na(inglab_2)) %>%
  summarise(ingreso_prom = weighted.mean(inglab_2, fexp, na.rm = TRUE))

ingreso_prom_ocup


# 11) Pobreza (Unir hogares -> individuos)

# a) Unir propiedades del hogar a cada individuo
df_ind2 <- df_ind %>%
  left_join(df_hog %>%
              select(id, nhogar, i_estratos, i_pobreza, fexp_hog = fexp),
            by = c("id","nhogar"))

# a) Distribución de la población por estratos (ponderada por fexp individual)
dist_pers_estrato <- df_ind2 %>%
  count(i_estratos, wt = fexp, name = "n") %>%
  mutate(prop = n / sum(n))

# b) Distribución de hogares por estratos (ponderada por fexp de hogares)
dist_hog_estrato <- df_hog %>%
  count(i_estratos, wt = fexp, name = "n") %>%
  mutate(prop = n / sum(n))

# c) Variable binaria pobres / no pobres 
df_ind2 <- df_ind2 %>%
  mutate(pobre = case_when(
    i_pobreza %in% c(1, 2) ~ "Pobre",
    i_pobreza == 3         ~ "No pobre",
    TRUE                   ~ "NS/NR"
  ))

# Personas pobres vs no pobres 
pobreza_personas <- df_ind2 %>%
  count(pobre, wt = fexp, name = "n") %>%
  mutate(prop = n / sum(n))

# Hogares pobres vs no pobres (ponderado por fexp de hogares)
pobreza_hogares <- df_hog %>%
  mutate(pobre = case_when(
    i_pobreza %in% c(1, 2) ~ "Pobre",
    i_pobreza == 3         ~ "No pobre",
    TRUE                   ~ "NS/NR"
  )) %>%
  count(pobre, wt = fexp, name = "n") %>%
  mutate(prop = n / sum(n))

# d) Pobreza por grupos de edad 
pobreza_por_edad <- df_ind2 %>%
  count(grupo_edad, pobre, wt = fexp, name = "n") %>%
  group_by(grupo_edad) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

# Vistas rápidas
dist_pers_estrato
dist_hog_estrato
pobreza_personas
pobreza_hogares
pobreza_por_edad

# 12 Distribucion de ocupados segun zona geofrafica 

dist_ocup_zona <- df_ind %>%
  filter(cond_act == "Ocupado") %>%
  count(zona, wt = fexp, name = "n") %>%
  mutate(prop = n / sum(n))

dist_ocup_zona

# 13 cruce de genero x grupo etario 

df_ind <- df_ind %>%
  mutate(
    genero = case_when(
      sexo == 1 ~ "Varón",
      sexo == 2 ~ "Mujer",
      TRUE ~ "NS/NR"
    ),
    grupo_edad = cut(
      edad,
      breaks = c(-Inf, 14, 29, 44, 64, Inf),
      labels = c("0-14", "15-29", "30-44", "45-64", "65+"),
      right = TRUE
    )
  )

tabla_genero_edad <- df_ind %>%
  count(genero, grupo_edad, wt = fexp, name = "n") %>%
  group_by(grupo_edad) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

tabla_genero_edad


# 14 cruce nivel educativo por condicion de actividad 
tabla_educ_act <- df_ind %>%
  count(nivel_lbl, cond_act, wt = fexp, name = "n") %>%
  group_by(nivel_lbl) %>%
  mutate(prop = n / sum(n)) %>%
  ungroup()

tabla_educ_act

# 15 Visualizacion con ggplot2

ggplot(dist_genero, aes(x = genero, y = prop, fill = genero)) +
  geom_col() +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Distribución por género (ponderada)",
       x = "Género", y = "Proporción") +
  theme_minimal() +
  theme(legend.position = "none")



# 16) Principales hallazgos del TP
# - La población expandida total es de 3083813 millones de personas.
# - La cantidad de hogares es de 1352744 millones.
# - La distribución por género muestra una proporción equilibrada: 
# - 0.5289572x100 = 52,90% mujeres y 0.4710428x100 =  47,10% varones.
# - El grupo etario más numeroso es el de 15–29 años (0.1961429x100 = 19,61% de la población).
# - La edad promedio ponderada de la población es de 38.80 años.
# - La tasa de actividad (18+) es de 70,74%.
# - La tasa de empleo es de 92,72%, mientras que la de desempleo es de 7,28%.
# - El ingreso laboral promedio de los ocupados es de 734061.8 pesos.
# - En términos de pobreza, 32,07% de las personas y 26,40% de los hogares son pobres.
# - Los grupos de edad más afectados por la pobreza son los menores de 29 años.
# - La distribución de ocupados varía por zona: la zona 1 concentra la mayor proporción.
# - El cruce género x edad muestra que las mujeres son mayoría en los grupos 15–29 y 65+.
# - El cruce nivel educativo x condición de actividad evidencia que a mayor nivel educativo,
#   mayor probabilidad de estar ocupado/a y menor de estar desocupado/a.
# - Visualmente, los gráficos de barras refuerzan las brechas en género, edad y educación.




















