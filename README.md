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
UPDATE Netflix
SET genres = 'N/A'
WHERE genres = '[]'

SELECT TOP(10) genres, COUNT(*) AS total_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE genres <> 'N/A'
GROUP BY genres
ORDER BY total_count DESC
```

### Average Duration of Highest & Lowest Rated Movies
```sql
-- looking at average duration of top 50 highest rated movies
SELECT AVG(avg_movie_duration) AS avg_duration_highrated_movies
FROM (SELECT TOP(50) imdb_score, AVG(runtime) AS avg_movie_duration
FROM Netflix
WHERE runtime <> 0 AND type='MOVIE' AND imdb_score IS NOT NULL
GROUP BY imdb_score
ORDER BY imdb_score DESC) AS subquery

-- looking at average duration of top 50 lowest rated movies
SELECT AVG(avg_movie_duration) AS avg_duration_lowrated_movies
FROM (SELECT TOP(50) imdb_score, AVG(runtime) AS avg_movie_duration
FROM Netflix
WHERE runtime <> 0 AND type='MOVIE' AND imdb_score IS NOT NULL
GROUP BY imdb_score
ORDER BY imdb_score ASC) AS subquery
```

### Average Duration of Highest & Lowest Rated Movies
```sql
-- looking at average duration of top 50 highest rated shows
SELECT AVG(avg_movie_duration) AS avg_duration_highrated_shows
FROM (SELECT TOP(50) imdb_score, AVG(runtime) AS avg_movie_duration
FROM Netflix
WHERE runtime <> 0 AND type='SHOW' AND imdb_score IS NOT NULL
GROUP BY imdb_score
ORDER BY imdb_score DESC) AS subquery

-- looking at average duration of top 50 lowest rated shows
SELECT AVG(avg_movie_duration) AS avg_duration_lowrated_shows
FROM (SELECT TOP(50) imdb_score, AVG(runtime) AS avg_movie_duration
FROM Netflix
WHERE runtime <> 0 AND type='SHOW' AND imdb_score IS NOT NULL
GROUP BY imdb_score
ORDER BY imdb_score ASC) AS subquery
```

### Individual Average IMDB Score of Directors who have Directed 5+ Movies
```sql
SELECT cred.name, COUNT(*) AS num_of_movies_directed, ROUND(AVG(net.imdb_score),1) AS avg_score
FROM Netflix net
JOIN credits cred 
ON net.id = cred.id
WHERE cred.role = 'DIRECTOR' AND net.imdb_score IS NOT NULL AND net.type = 'MOVIE'
GROUP BY cred.name
HAVING COUNT(*) >= 5
ORDER BY num_of_movies_directed DESC, avg_score DESC
```

### Individual Average IMDB Score of Directors who have Directed 5+ Movies
```sql
SELECT cred.name, COUNT(*) AS num_of_movies_directed, ROUND(AVG(net.imdb_score),1) AS avg_score
FROM Netflix net
JOIN credits cred 
ON net.id = cred.id
WHERE cred.role = 'DIRECTOR' AND net.imdb_score IS NOT NULL AND net.type = 'MOVIE'
GROUP BY cred.name
HAVING COUNT(*) >= 5
ORDER BY num_of_movies_directed DESC, avg_score DESC
```

### Individual Average IMDB Score of Actors who have Acted 10+ Movies
```sql
SELECT cred.name, COUNT(*) AS num_of_movies_acted, ROUND(AVG(net.imdb_score),1) AS avg_score
FROM Netflix net
JOIN credits cred 
ON net.id = cred.id
WHERE cred.role = 'ACTOR' AND net.imdb_score IS NOT NULL
GROUP BY cred.name
HAVING COUNT(*) >= 10
ORDER BY num_of_movies_acted DESC, avg_score DESC
```

### Average IMDB Score of Shows with Single Season
```sql
SELECT AVG(imdb_score) AS avg_imdb_score
FROM(
SELECT seasons, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL AND seasons = 1
) subquery
```

### Average IMDB Score of Shows with Multiple Seasons
```sql
SELECT AVG(imdb_score) AS avg_imdb_score
FROM(
SELECT seasons, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL AND seasons > 1
) subquery
```
























