# Music-Insights-Segmentation

## Overview
This project analyzes streaming trends based on key track features such as danceability, energy, and duration, with an emphasis on seasonality and user behavior. By exploring patterns in streaming data, the analysis aims to provide insights for the music industry to optimize track release strategies, marketing campaigns, and audience engagement.

## Objective
The objective of this analysis is to uncover patterns in streaming performance using track features and seasonality analysis to aid music streaming platforms, record labels, and artists in optimizing their content strategies.

## Key Areas of Focus

### 1. Track Feature Trends:
Analyze how features like danceability, energy, and tempo affect track popularity over time, using streaming data from Spotify's Top 200 charts.

### 2. Seasonality Analysis:
Identify seasonality in track performance, predicting high or low streaming periods to better plan music releases and marketing efforts.

## Data Sources
This project uses dummy data based on real Spotify track features and streaming counts, providing a representation of the Top 200 songs over a set period.

## Tools and Technologies Used
- **Programming Language**: R
- **Development Environment**: RStudio

### Data Analysis and Manipulation:
- `dplyr`, `DataExplorer`, `timetk`

### Machine Learning/Forecasting:
- `Prophet` for time-series forecasting

### Data Visualization:
- `ggplot2` for visualizing trends

### Upcoming Feature:
- **K-means clustering** to group tracks by features.

## Skills Demonstrated
- **Data Collection**: Simulated track data and streaming counts.
- **Data Wrangling**: Cleaned and processed track features for analysis.
- **Visualization**: Created visualizations to highlight trends in track features and streaming behavior.
- **Seasonality Forecasting**: Used Prophet to analyze seasonal components in streaming data and predict future patterns.

## Project Structure

### 1. Track Feature Analysis
**Question**: How do features like danceability, energy, and duration impact the streaming performance of tracks?

**Code Snippet**:
```r
ggplot(study_data, aes(x = energy)) +
  geom_histogram(binwidth = 0.1, color = 'black', fill = 'skyblue') +
  labs(title = "Energy Distribution", x = 'Energy', y = 'Count') +
  theme_minimal()
```

## 2. Seasonality in Streaming Patterns

**Question**: What are the seasonal trends in track performance, and how can they be used to optimize release strategies?

**Code Snippet**:
```r
df <- daily_data %>% 
  rename(ds = Date, y = avg_danceability)
danceability_model <- prophet(seasonality.mode = 'additive')
danceability_model <- fit.prophet(danceability_model, df)
danceability_forecast <- predict(danceability_model)
prophet_plot_components(danceability_model, danceability_forecast)
```

## Insights: Music Streaming Trends Summary

This analysis of music streaming patterns based on track features and listener behavior reveals the following key insights:

- **Seasonal Listening Patterns**:
  - **Summer**: Listeners gravitate toward high-energy, danceable, and loud tracks, indicating a preference for more upbeat music.
  - **Winter**: Acoustic, reflective, and longer tracks are more popular, aligning with more introspective listening habits during colder months.

- **Weekly Listening Behavior**:
  - **Weekends**: Tracks with higher energy, explicit content, and faster tempos gain more streams on Fridays and Saturdays, reflecting more dynamic weekend activity.
  - **Weekdays**: Listeners prefer calmer, acoustic, and instrumental tracks at the beginning of the week (Monday-Wednesday), indicating a preference for relaxed, background music.

- **Track Feature Preferences**:
  - **Valence** (happiness): More positive, upbeat tracks are favored on weekends.
  - **Speechiness** (spoken word/rap): Increases on weekends, reflecting a stronger preference for rap and spoken-word tracks during this period.
  - **Explicit Content**: Higher on weekends but shows a dip during the year-end holiday season, reflecting shifts in listening preferences based on context.

### Conclusion:
While this analysis highlights patterns in how track features align with listener behavior throughout the week and year, it provides a clearer understanding of when listeners favor different types of music. These insights help inform streaming platforms and artists about what audiences are likely to engage with based on time and track characteristics, offering opportunities for better audience targeting and engagement strategies.
