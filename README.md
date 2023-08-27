# Netflix Project
Matthew Balderrama 2023-08-26

## Introduction
Netflix is an America subscription based streaming service that offers a wide variety of movies and TV shows. Netflix, along with similar platforms, have revolutionized how we consume movies and TV shows. Using the [Netflix TV Shows and Movies Dataset](https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies?select=titles.csv) from Kaggle, we can reveal patterns and trends in order to gain valuable insights through the utilization of SQL and Tableau. Acquired in July 2022, the data contains around 5k+ rows with 15 columns (genre, ratings, duration, seasons, etc) about the TV show and movie information and 77k+ rows for the credits of actors and directors on Netflix with 5 columns (id, name, role, etc). 


## Project Objective
Through the strategic utilization of SQL and Tableau, we aim to orchestrate the transformation and manipulation of data, complemented by the delivery of insightful visualizations. This synthesis of analytical tools facilitates the extraction of profound insights, culminating in an enhanced comprehension of the intricate interplay between content dynamics and audience preferences.


## Data Exploration & Analysis
These 3 variables were imported as floats, but we are going to round to the tenth for simplication purposes.
```sql
-- imported imdb_score, tmdb_popularity, tmdb_score
-- we will round imdb_score, tmdb_popularity, tmdb_score by 1 decimal place
UPDATE Netflix
SET imdb_score = ROUND(imdb_score, 1),
	tmdb_popularity = ROUND(tmdb_popularity, 1),
	tmdb_score = ROUND(tmdb_score, 1)
```


### Top/Bottom 10 Shows Ranked by IMDB Score
```sql
-- top 10 shows
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'SHOW'
ORDER BY imdb_score DESC

--bottom 10 shows
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL
ORDER BY imdb_score 
```
![Screenshot (268)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/4ae6e897-32ac-437f-aba3-553cc043800c) ![Screenshot (269)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/fa4a517c-1d08-4468-83b5-e506d5bc8d2c)

The highest rated TV show is *#ABtalks* with an IMDB score of 9.6, while the lowest rated shows are *Thomas & Friends: All Engines Go!* and *He's Expecting*, both with an IMDB score of 2.

### Top/Bottom 10 Movies Ranked by IMDB Score
```sql
-- top 10 movies
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'MOVIE' 
ORDER BY imdb_score DESC

--bottom 10 movies
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'MOVIE' AND imdb_score IS NOT NULL
ORDER BY imdb_score 
```
![Screenshot (270)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/8e95d4ad-86f9-427c-b2e3-d125736defd8) ![Screenshot (271)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/86d34444-0487-4b02-bb5e-82cecfa8b851)

The highest rated movies are *Chhota Bheem & Krishna vs Zimbara* and *Major* with an IMDB score of 9.6, while the lowest rated show is *Aerials* with an IMDB score of 1.5.




### Number of Age Category Ratings for Movies/Shows with Associated Ratings
```sql
--movies
SELECT age_certification, COUNT(*) AS movie_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE type = 'MOVIE' AND age_certification <> 'N/A'
GROUP BY age_certification
ORDER BY movie_count DESC

--shows
SELECT age_certification, COUNT(*) AS show_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score 
FROM Netflix
WHERE type = 'SHOW' AND age_certification <> 'N/A'
GROUP BY age_certification
ORDER BY show_count DESC
```
![Screenshot (272)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/5946e693-5772-466e-acbb-c228ab2ccec0) ![Screenshot (273)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/ddc9a9bf-01b0-4f57-94cd-02fca6eb8920)

Netflix has 556 movies that are rated R, and 883 TV shows that are rated TV-MA. However, the highest rated in the movie age category are PG-13 and G, while the highest rated in the TV show category is TV-14.



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
![Screenshot (274)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/fe74e3d7-ae43-4175-86e7-2cedece77cbb)

Most of Netflix's movies & TV shows released from 2010-2019. However, the 2020-2022 is second with only 3 years opposed to 10 and will likely surpass the 2010's time period at this rate. Also, Netflix only has 1 television show that released in the 1940's.


### Frequency of Genres with Associated Ratings
```sql
--- replacing genres with empty list to N/A
UPDATE Netflix
SET genres = 'N/A'
WHERE genres = '[]'

SELECT TOP(10) genres, COUNT(*) AS total_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE genres <> 'N/A'
GROUP BY genres
ORDER BY total_count DESC
```
![Screenshot (275)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/4697ff60-7b9c-42cc-b004-bf087ba63a55)

The most common genre in Netflix is comedy. However, documentation is the second most common, but the highest rated genre.


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
![Screenshot (276)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/f6801df7-d33c-41d8-b5e5-51243d19a72d) ![Screenshot (277)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/49f5ca90-4769-49ae-a748-f49a09665286)

From this query, we can see that higher rated movies have a longer average duration with a 5 minute differential from lower rated movies.



### Average Duration of Highest & Lowest Rated Shows
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
![Screenshot (278)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/41c941a5-3c5f-4ed0-9759-ea55a2f855d7) ![Screenshot (279)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/4875c4e0-0b1f-4dbe-a4e2-71aef82813c6)

From this query, we can see that higher rated TV shows have a longer average duration with a 5 minute differential from lower rated TV shows.


### Top 10 Countries by Production with Associated Ratings
```sql
SELECT TOP(10) SUBSTRING(production_countries,3,2) AS Countries, COUNT(*) AS country_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE LEN(production_countries) = 6 AND imdb_score IS NOT NULL
GROUP BY production_countries
ORDER BY country_count DESC
```
![Screenshot (280)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/dce754ab-74e5-4cd1-a59c-67b29fbda1bd)

The United States produce the most movies & TV shows, over 3x the amount of the second most in India. The country with the highest average IMDB score within the top 10 most production count is Korea.


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
![Screenshot (281)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/5f825591-e43f-4851-ab31-b9156ba45600) ![Screenshot (282)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/c897dd52-d7b4-412d-aba5-f70588f3e698)

Out of the directors who have directed 5 or more movies, Raul Campos directed the most movies, while Martin Scorsese has the highest average rating out of the movies he has directed.


### Individual Average IMDB Score of Actors who have Acted 15+ Movies
```sql
SELECT cred.name, COUNT(*) AS num_of_movies_acted, ROUND(AVG(net.imdb_score),1) AS avg_score
FROM Netflix net
JOIN credits cred 
ON net.id = cred.id
WHERE cred.role = 'ACTOR' AND net.imdb_score IS NOT NULL AND net.type = 'MOVIE'
GROUP BY cred.name
HAVING COUNT(*) >= 15
ORDER BY num_of_movies_acted DESC, avg_score DESC
```
![Screenshot (287)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/20ff7624-e8b7-4fd6-8534-78a07d1b9b0f)

Out of the actors who have acted in 15 or more movies, Boman Irani has acted in the most movies, while Aamir Khan has the highest rating.



### Average IMDB Score of Shows with Single vs Multiple Seasons
```sql
-- single season
SELECT AVG(imdb_score) AS avg_imdb_score_sing
FROM(
SELECT seasons, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL AND seasons = 1
) subquery

-- multiple seasons
SELECT AVG(imdb_score) AS avg_imdb_score_mult
FROM(
SELECT seasons, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL AND seasons > 1
) subquery
```
![Screenshot (285)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/69c148d3-ff6d-4d07-ae84-c7cb0329101e) ![Screenshot (286)](https://github.com/mbalderrama23/NetflixProject/assets/110944925/7b8bdca8-963d-4b9d-9f6a-aeed1364164f)

TV shows with multiple seasons, on average, have a higher IMDB score than shows with only one season on Netflix.



## Conclusion






















