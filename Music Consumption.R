# Load required libraries
library(dplyr)
library(DataExplorer)
library(ggplot2)
library(timetk)
library(prophet)

# Set options
options(scipen = 999)

# Data Preprocessing ------------------------------------------------------

# Mutate and clean data
study_data <- final_data %>% 
  mutate(Date = as.Date(Date),
         Position = as.numeric(Position),
         Peak = as.numeric(Peak),
         Prev = as.numeric(Prev),
         Streak = as.numeric(Streak),
         Streams = as.numeric(gsub(",", "", Streams)),
         album_type = as.factor(album_type),
         release_date = as.Date(release_date),
         duration = duration_ms / 1000,  # Convert milliseconds to seconds
         mode = as.factor(mode))

# Data Summary
summary(study_data)

# Select numeric columns for standard deviation analysis
numeric_data <- study_data %>% select(where(is.numeric))
apply(numeric_data, 2, sd, na.rm = TRUE)


# Exploratory Data Analysis (EDA) ------------------------------------------

# Define a helper function to generate histograms for each feature
plot_histogram <- function(data, feature, title, binwidth = NULL, x_label = feature, y_label = "Count") {
  ggplot(data, aes_string(x = feature)) +
    geom_histogram(binwidth = binwidth, color = 'black', fill = 'skyblue') +
    labs(title = title, x = x_label, y = y_label) +
    theme_minimal()
}

# Generate histograms for key features
plot_histogram(study_data, "release_date", "Release Date Distribution", binwidth = 365)
plot_histogram(study_data, "acousticness", "Acousticness Distribution", binwidth = 0.10)
plot_histogram(study_data, "danceability", "Danceability Distribution", binwidth = 0.1)
plot_histogram(study_data, "duration", "Duration Distribution (Seconds)", binwidth = 30)
plot_histogram(study_data, "energy", "Energy Distribution", binwidth = 0.1)
plot_histogram(study_data, "instrumentalness", "Instrumentalness Distribution", binwidth = 0.1)
plot_histogram(study_data, "key", "Key Distribution", binwidth = 1)
plot_histogram(study_data, "liveness", "Liveness Distribution", binwidth = 0.1)
plot_histogram(study_data, "loudness", "Loudness Distribution", binwidth = 3)
plot_histogram(study_data, "speechiness", "Speechiness Distribution", binwidth = 0.1)
plot_histogram(study_data, "tempo", "Tempo Distribution", binwidth = 30)
plot_histogram(study_data, "time_signature", "Time Signature Distribution", binwidth = 1)
plot_histogram(study_data, "valence", "Valence Distribution", binwidth = 0.1)
plot_histogram(study_data, "Streams", "Streams Distribution", binwidth = 100000)

# Bar plots for categorical variables
ggplot(study_data, aes(x = album_type)) +
  geom_bar(aes(y = (..count..)/sum(..count..)), fill = "purple") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Album Type Proportion", x = "Album Type", y = "Percentage") +
  theme_minimal()

ggplot(study_data, aes(x = explicit)) +
  geom_bar(aes(y = (..count..)/sum(..count..)), fill = "purple") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Explicitness Proportion", x = "Explicit", y = "Percentage") +
  theme_minimal()

ggplot(study_data, aes(x = mode)) +
  geom_bar(aes(y = (..count..)/sum(..count..)), fill = "purple") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Mode Proportion", x = "Mode", y = "Percentage") +
  scale_x_discrete(labels = c("0" = "Minor", "1" = "Major")) +
  theme_minimal()


# Weighted Averages and Time-Series ---------------------------------------

# Summarize daily data with weighted averages for each feature
daily_data <- study_data %>% 
  group_by(Date) %>%
  summarise(
    count = n(),
    Total_Streams = sum(Streams, na.rm = TRUE),
    Avg_Streams = mean(Streams, na.rm = TRUE),
    explicit = sum(explicit * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_danceability = sum(danceability * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_acousticness = sum(acousticness * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_duration = sum(duration * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_energy = sum(energy * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_instrumentalness = sum(instrumentalness * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_key = sum(key * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_liveness = sum(liveness * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_loudness = sum(loudness * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_mode = sum(as.numeric(mode) * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_speechiness = sum(speechiness * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_tempo = sum(tempo * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_time_signature = sum(time_signature * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE),
    avg_valence = sum(valence * Streams, na.rm = TRUE) / sum(Streams, na.rm = TRUE)
  )

# Plot weighted time-series data
plot_time_series <- function(data, feature, title, x_label = "Date", y_label = feature) {
  ggplot(data, aes(x = Date, y = .data[[feature]])) + 
    geom_line() +
    labs(title = title, x = x_label, y = y_label) +
    theme_minimal()
}

# Visualizing key features over time
plot_time_series(daily_data, "Avg_Streams", "Total Streams per Day")
plot_time_series(daily_data, "avg_danceability", "Avg Danceability per Day (Weighted)")
plot_time_series(daily_data, "avg_acousticness", "Avg Acousticness per Day (Weighted)")
plot_time_series(daily_data, "avg_duration", "Avg Duration per Day (Weighted)")
plot_time_series(daily_data, "avg_energy", "Avg Energy per Day (Weighted)")
plot_time_series(daily_data, "avg_instrumentalness", "Avg Instrumentalness per Day (Weighted)")
plot_time_series(daily_data, "avg_key", "Avg Key per Day (Weighted)")
plot_time_series(daily_data, "avg_loudness", "Avg Loudness per Day (Weighted)")
plot_time_series(daily_data, "avg_mode", "Avg Mode per Day (Weighted)")
plot_time_series(daily_data, "avg_speechiness", "Avg Speechiness per Day (Weighted)")
plot_time_series(daily_data, "avg_tempo", "Avg Tempo per Day (Weighted)")
plot_time_series(daily_data, "avg_time_signature", "Avg Time Signature per Day (Weighted)")
plot_time_series(daily_data, "avg_valence", "Avg Valence per Day (Weighted)")
plot_time_series(daily_data, "explicit", "Avg Explicitness per Day (Weighted)")


# Forecasting with Prophet ------------------------------------------------

# Function to apply Prophet and forecast
forecast_feature <- function(data, feature, title) {
  df <- data %>%
    rename(ds = Date, y = .data[[feature]])
  
  model <- prophet(seasonality.mode = 'additive')
  model <- fit.prophet(model, df)
  
  forecast <- predict(model)
  prophet_plot_components(model, forecast) +
    ggtitle(title)
}

# Forecast key features using Prophet
forecast_feature(daily_data, "avg_danceability", "Danceability Forecast")
forecast_feature(daily_data, "avg_acousticness", "Acousticness Forecast")
forecast_feature(daily_data, "avg_duration", "Duration Forecast")
forecast_feature(daily_data, "avg_energy", "Energy Forecast")
forecast_feature(daily_data, "avg_instrumentalness", "Instrumentalness Forecast")
forecast_feature(daily_data, "avg_key", "Key Forecast")
forecast_feature(daily_data, "avg_loudness", "Loudness Forecast")
forecast_feature(daily_data, "avg_mode", "Mode Forecast")
forecast_feature(daily_data, "avg_speechiness", "Speechiness Forecast")
forecast_feature(daily_data, "avg_tempo", "Tempo Forecast")
forecast_feature(daily_data, "avg_time_signature", "Time Signature Forecast")
forecast_feature(daily_data, "avg_valence", "Valence Forecast")
forecast_feature(daily_data, "explicit", "Explicitness Forecast")