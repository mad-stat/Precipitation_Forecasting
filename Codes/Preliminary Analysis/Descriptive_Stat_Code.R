library(tidyverse)
library(xlsx)
library(readr)
library(forecast)
library(imputeTS)
library(parameters)
library(pracma)
library(tsutils)
library(tseries)
library(nonlinearTseries)
library(feasts)
library(seastests)
library(VGAM)
library(readr)
library(extRemes)
library(evmix)

library(readr)
library(writexl)

data = read_csv("weekly_summary_1991-2021.csv")
horizon = c(53, 40, 27, 14)
i = 1
hor = horizon[i]
train_data <- data[1:(nrow(data) - hor), ]

sum_fn <- function(dat, var_name){
  sum = summary(dat)
  stan_dev = sd(dat)
  coeff_var = stan_dev/sum[4]
  skew = skewness(dat)$Skewness
  kurt = kurtosis(dat)$Kurtosis
  hst = data.frame(hurstexp(dat))$Hs
  kpss_p = kpss.test(dat)$p.value
  nlt_p_value = nonlinearityTest(dat, verbose = TRUE)$Terasvirta$p.value
  seas_month = isSeasonal(dat, freq = 12)
  seas_quart = isSeasonal(dat, freq = 4)
  seas_week = isSeasonal(dat, freq = 52)
  new_df <- c("Variable" = var_name, "Mean" = sum[4], "Min" = sum[1], "1st quartile" = sum[2], "3rd quartile" = sum[5],
              "Max" = sum[6], "Median" = sum[3], "Sd" = stan_dev, "CV" = coeff_var, "Skewness" = skew,
              "Kurtosis" = kurt, "Hurst_Exponent" = hst, "KPSS" = kpss_p, 
              "Terasvirta" = nlt_p_value, "Seas Month" = seas_month, "Seas Quart" = seas_quart, 
              "Seas Week" = seas_week)
  return(new_df)
}

sum_stat = data.frame(matrix(0, nrow = 1, ncol = 17))

colnames(sum_stat) <- c("Variable", "Mean", "Min", "1st quartile", "3rd quartile", "Max", "Median", "Sd", "CV", "Skewness",
                        "Kurtosis","Hurst_Exponent", "KPSS", "Terasvirta","Seas Month","Seas Quart", 
                        "Seas Annual")
sum_stat = rbind(sum_stat, sum_fn(train_data$Precipitation, var_name = "Precipitation"))
sum_stat = rbind(sum_stat, sum_fn(train_data$Mean_air_temperature, var_name = "Mean_air_temperature"))
sum_stat = rbind(sum_stat, sum_fn(train_data$Mean_relative_humidity, var_name = "Mean_relative_humidity"))
sum_stat = rbind(sum_stat, sum_fn(train_data$Mean_cloud_cover, var_name = "Mean_cloud_cover"))
sum_stat = rbind(sum_stat, sum_fn(train_data$Average_air_pressure, var_name = "Average_air_pressure"))
write.csv(sum_stat, "Descriptive_Stat_53week.csv")

library(tseriesChaos)
output <- lyap_k(train_data$Precipitation, m=3, d=2, s=20, t=40, ref=170, k=2, eps=4)
plot(output)

ad.test(train_data$Precipitation)

lyap(output, 0.73, 2.47)

ad.test(rnorm(100, mean = 5, sd = 3))

ggplot
ggAcf(ts(train_data$Precipitation), ylab = "ACF", xlab = "Time", main = "ACF of Precipitation Data")
ggPacf(ts(train_data$Precipitation), ylab = "PACF", xlab = "Time", main = "PACF of Precipitation Data")
autoplot(ts(train_data$Precipitation), ylab = "Precipitation Level", xlab = "Time", main = "Training Data")


autoplot(ts(train_data$Precipitation)) +
  ggtitle("Training Data") +
  ylab("Precipitation Level") +
  xlab("Time (Weeks)") +
  theme_classic() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 15, face = "bold"),
    axis.text = element_text(size = 13, face = "bold")
  ) +
  geom_line(color = "blue")

library(forecast)
library(ggplot2)

# Extract ACF data
acf_obj <- Pacf(ts(train_data$Precipitation), plot = FALSE)
acf_df <- data.frame(
  lag = acf_obj$lag[, 1, 1],
  acf = acf_obj$acf[, 1, 1]
)

acf_df <- tail(acf_df, 31)

# 95% confidence interval
n <- length(train_data$Precipitation)
conf_limit <- qnorm((1 + 0.95) / 2) / sqrt(n)

# Custom ACF plot
ggplot(acf_df, aes(x = lag, y = acf)) +
  geom_hline(yintercept = c(-conf_limit, conf_limit), color = "red", linetype = "dashed", 
             linewidth = 1) +
  geom_segment(aes(xend = lag, yend = 0), color = "blue", linewidth = 1.5) +
  geom_point(color = "blue", size = 3) +
  geom_hline(yintercept = 0, color = "black") +
  labs(title = "PACF of Precipitation Data", x = "Lag", y = "PACF") +
  theme_classic() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 15, face = "bold"),
    axis.text = element_text(size = 13, face = "bold")
  )

