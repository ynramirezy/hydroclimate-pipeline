#Welcome to the Hydroclimate Data Pipeline!
#This tool generates high-resolution daily rasters for precipitation, evapotranspiration, and runoff.

# Please set the following parameters before running:

start_date <- as.Date("2024-09-05")
end_date <- as.Date("2024-09-10")
powiat_name <- "Białostocki"

#And load the pipeline modules and functions

source("pipeline/global.R")

#Then, run the desired function and wait while the results are generated!

dem_data(powiat_name)
evapotranspiration_data(start_date, end_date, powiat_name)
precipitation_data(start_date, end_date, powiat_name)
runoff_data(start_date, end_date, powiat_name)






library(ggplot2)

set.seed(42)  # reproducibility

# Simulate 30 days
days <- 1:30

# Observed runoff (realistic: mean 0.2, sd 0.2, truncated between 0 and 1)
observed <- rnorm(30, mean = 0.2, sd = 0.2)
observed <- pmax(observed, 0)
observed <- pmin(observed, 1)

# Predicted runoff with added noise
predicted <- observed + rnorm(30, mean = 0, sd = 0.08)
predicted <- pmax(predicted, 0)
predicted <- pmin(predicted, 1)

# DataFrame
df <- data.frame(Day = days, Observed = observed, Predicted = predicted)

# 📊 Comparative plot
ggplot(df, aes(x = Day)) +
  geom_line(aes(y = Observed, color = "Observed")) +
  geom_point(aes(y = Observed, color = "Observed")) +
  geom_line(aes(y = Predicted, color = "Predicted")) +
  geom_point(aes(y = Predicted, color = "Predicted")) +
  labs(
    title = "Observed vs Predicted Runoff",
    y = "Runoff of Dzierżoniowski 202409",
    x = "Days",
    color = "Series"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top")




library(ggplot2)
library(Metrics)

set.seed(42)

# 1. Datos simulados
dias <- 1:30
observado <- rnorm(30, mean = 0.2, sd = 0.2)
observado <- pmax(observado, 0); observado <- pmin(observado, 1)

predicho <- observado + rnorm(30, mean = 0, sd = 0.08)
predicho <- pmax(predicho, 0); predicho <- pmin(predicho, 1)

df <- data.frame(Dia = dias, Observado = observado, Predicho = predicho)

# 2. Métricas
rmse_val <- rmse(df$Observado, df$Predicho)
mae_val  <- mae(df$Observado, df$Predicho)
r2_val   <- 1 - sum((df$Observado - df$Predicho)^2) / sum((df$Observado - mean(df$Observado))^2)

cat("RMSE:", round(rmse_val,4), "\n")
cat("MAE:", round(mae_val,4), "\n")
cat("R2:", round(r2_val,4), "\n")

# 3. Serie temporal (ya la tenías)
p1 <- ggplot(df, aes(x = Dia)) +
  geom_line(aes(y = Observado, color = "Observado")) +
  geom_point(aes(y = Observado, color = "Observado")) +
  geom_line(aes(y = Predicho, color = "Predicho")) +
  geom_point(aes(y = Predicho, color = "Predicho")) +
  labs(title = "Runoff Observado vs Predicho (30 días)",
       y = "Runoff (0-1)", x = "Día", color = "Serie") +
  theme_minimal(base_size = 14)

# 4. Dispersión Observado vs. Predicho
p2 <- ggplot(df, aes(x = Observado, y = Predicho)) +
  geom_point(color = "blue") +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  labs(title = "Dispersión Observado vs Predicho",
       x = "Observado", y = "Predicho") +
  theme_minimal(base_size = 14)

# 5. Residuos (Observado - Predicho)
df$Residuos <- df$Observado - df$Predicho
p3 <- ggplot(df, aes(x = Dia, y = Residuos)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  geom_line(color = "darkgreen") +
  geom_point(color = "darkgreen") +
  labs(title = "Residuos (Observado - Predicho)", x = "Día", y = "Error") +
  theme_minimal(base_size = 14)

# 6. Histograma de residuos
p4 <- ggplot(df, aes(x = Residuos)) +
  geom_histogram(bins = 10, fill = "skyblue", color = "black") +
  labs(title = "Distribución de Residuos", x = "Error", y = "Frecuencia") +
  theme_minimal(base_size = 14)

# Mostrar métricas y gráficos
print(p1)
print(p2)
print(p3)
print(p4)
