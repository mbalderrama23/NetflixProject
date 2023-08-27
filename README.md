# Netflix Project
Matthew Balderrama 2023-08-26

## Introduction
Netflix is an America subscription based streaming service that offers a wide variety of movies and TV shows. Netflix, along with similar platforms, have revolutionized how we consume movies and TV shows. Using the [Netflix TV Shows and Movies Dataset](https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies?select=titles.csv) from Kaggle, we can reveal patterns and trends in order to gain valuable insights through the utilization of SQL and Tableau. Acquired in July 2022, the data contains around 5k+ rows with 15 columns (genre, ratings, duration, seasons, etc) about the TV show and movie information and 77k+ rows for the credits of actors and directors on Netflix with 5 columns (id, name, role, etc). 


## Project Objective
Through the strategic utilization of SQL and Tableau, we aim to orchestrate the transformation and manipulation of data, complemented by the delivery of insightful visualizations. This synthesis of analytical tools facilitates the extraction of profound insights, culminating in an enhanced comprehension of the intricate interplay between content dynamics and audience preferences.

```sql

```
## Data Exploration
These 3 variables were imported as floats, but we are going to round to the tenth for simplication purposes.
```sql
-- imported imdb_score, tmdb_popularity, tmdb_score
-- we will round imdb_score, tmdb_popularity, tmdb_score by 1 decimal place
UPDATE Netflix
SET imdb_score = ROUND(imdb_score, 1),
	tmdb_popularity = ROUND(tmdb_popularity, 1),
	tmdb_score = ROUND(tmdb_score, 1)
```

### Top 10 Shows Ranked by IMDB Score
```sql
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'SHOW'
ORDER BY imdb_score DESC
```

### Bottom 10 Shows Ranked by IMDB Score
```sql
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL
ORDER BY imdb_score 
```

### Top 10 Movies Ranked by IMDB Score
```sql
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'MOVIE' 
ORDER BY imdb_score DESC
```

### Bottom 10 Movies Ranked by IMDB Score
```sql
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'MOVIE' AND imdb_score IS NOT NULL
ORDER BY imdb_score 
```

### Number of Age Category Ratings for Movies with Associated Ratings
```sql
SELECT age_certification, COUNT(*) AS movie_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE type = 'MOVIE' AND age_certification <> 'N/A'
GROUP BY age_certification
ORDER BY movie_count DESC
```

### Number of Age Category Ratings for Shows with Associated Ratings
```sql
SELECT age_certification, COUNT(*) AS show_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score 
FROM Netflix
WHERE type = 'SHOW' AND age_certification <> 'N/A'
GROUP BY age_certification
ORDER BY show_count DESC
```

### Movies and Show Count by Time Period
```sql
SELECT CONCAT(era,'''s') AS time_period, 
SUM(CASE WHEN type='MOVIE' THEN 1 ELSE 0 END) AS movie_count,
SUM(CASE WHEN type='SHOW' THEN 1 ELSE 0 END) AS show_count,
SUM(CASE WHEN type IN ('MOVIE','SHOW') THEN 1 ELSE 0 END) AS total_count
FROM (
	SELECT release_year, (release_year - (release_year % 10)) AS era, TYPE
	FROM Netflix
) AS era_description
GROUP BY era
ORDER BY era
```

### Frequency of Genres with Associated Ratings
```sql
SELECT TOP(10) genres, COUNT(*) AS total_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE genres <> 'N/A'
GROUP BY genres
ORDER BY total_count DESC
```

### Individual Production Countries Count and Ratings
```sql
SELECT TOP(10) SUBSTRING(production_countries,3,2) AS Countries, COUNT(*) AS country_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE LEN(production_countries) = 6 AND imdb_score IS NOT NULL
GROUP BY production_countries
ORDER BY country_count DESC
```










