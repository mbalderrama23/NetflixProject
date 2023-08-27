-- looking at data
SELECT TOP(20) *
FROM Netflix

-- imported imdb_score, tmdb_popularity, tmdb_score
-- we will round imdb_score, tmdb_popularity, tmdb_score by 1 decimal place
UPDATE Netflix
SET imdb_score = ROUND(imdb_score, 1),
	tmdb_popularity = ROUND(tmdb_popularity, 1),
	tmdb_score = ROUND(tmdb_score, 1)

-- check to see if successful
SELECT *
FROM Netflix



-- QUESTION 1: WHAT ARE THE TOP AND BOTTOM SHOWS/MOVIES RANKED BY IMDB SCORE
-- top 10 shows ranked by imdb_score
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'SHOW'
ORDER BY imdb_score DESC

-- find bottom 10 shows ranked by imdb_score
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL
ORDER BY imdb_score 

-- find top 10 movies ranked by imdb_score
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'MOVIE' 
ORDER BY imdb_score DESC

-- find bottom 10 movies ranked by imdb_score
SELECT TOP(10) title, imdb_score
FROM Netflix
WHERE type = 'MOVIE' AND imdb_score IS NOT NULL
ORDER BY imdb_score 


-- QUESTION 2: WHAT IS THE AGE RATING RANKING
SELECT age_certification, ROUND(AVG(imdb_score),1) as avg_imdb_score
FROM Netflix
GROUP BY age_certification
ORDER BY avg_imdb_score DESC


-- count of ratings for movies and shows, total as well
SELECT age_certification, COUNT(*) AS movie_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE type = 'MOVIE' AND age_certification <> 'N/A'
GROUP BY age_certification
ORDER BY movie_count DESC

SELECT age_certification, COUNT(*) AS show_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score 
FROM Netflix
WHERE type = 'SHOW' AND age_certification <> 'N/A'
GROUP BY age_certification
ORDER BY show_count DESC
--

-- top 10 shows ranked by tmdb_score
SELECT title, tmdb_score, age_certification, genres
FROM Netflix
WHERE type = 'SHOW' AND tmdb_score = 10


-- Seeing the movie and show count of each time period
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

-- UPDATING GENRES WITH EMPTY LIST
UPDATE Netflix
SET genres = 'N/A'
WHERE genres = '[]'

-- POPULAR GENRES AND ITS RATINGS
SELECT TOP(10) genres, COUNT(*) AS total_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE genres <> 'N/A'
GROUP BY genres
ORDER BY total_count DESC

-- movies specific
SELECT TOP(10) genres, COUNT(*) AS movie_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE TYPE = 'MOVIE' AND genres <> 'N/A'
GROUP BY genres
ORDER BY movie_count DESC


-- Countries associated with highest rating count

SELECT TOP(10) SUBSTRING(production_countries,3,2) AS Countries, COUNT(*) AS country_count, ROUND(AVG(imdb_score),1) AS avg_imdb_score
FROM Netflix
WHERE LEN(production_countries) = 6 AND imdb_score IS NOT NULL
GROUP BY production_countries
ORDER BY country_count DESC

-- MOVIE RUNTIME AND RATINGS
SELECT imdb_score, AVG(runtime) as avg_duration, min(runtime) as min_duration, max(runtime) as max_duration
FROM Netflix
WHERE runtime <> 0 AND type='MOVIE' AND imdb_score IS NOT NULL
GROUP BY imdb_score
order by imdb_score desc


SELECT TOP(50) imdb_score, AVG(runtime) AS avg_movie_duration
FROM Netflix
WHERE runtime <> 0 AND type='MOVIE' AND imdb_score IS NOT NULL
GROUP BY imdb_score
order by imdb_score asc

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

-- finding directors who have directed 5 of more movies and the avg score of the all their movies directed
SELECT cred.name, COUNT(*) AS num_of_movies_directed, ROUND(AVG(net.imdb_score),1) AS avg_score
FROM Netflix net
JOIN credits cred 
ON net.id = cred.id
WHERE cred.role = 'DIRECTOR' AND net.imdb_score IS NOT NULL AND net.type = 'MOVIE'
GROUP BY cred.name
HAVING COUNT(*) >= 5
ORDER BY num_of_movies_directed DESC, avg_score DESC


SELECT cred.name, COUNT(*) AS num_of_movies_acted, ROUND(AVG(net.imdb_score),1) AS avg_score
FROM Netflix net
JOIN credits cred 
ON net.id = cred.id
WHERE cred.role = 'ACTOR' AND net.imdb_score IS NOT NULL AND net.type = 'MOVIE'
GROUP BY cred.name
HAVING COUNT(*) >= 15
ORDER BY num_of_movies_acted DESC, avg_score DESC



select COUNT(*)
from credits
WHERE name LIKE 'Ra_l Campos'


-- seasons 
SELECT ROUND(AVG(imdb_score),2) AS avg_imdb_score_sing
FROM(
SELECT seasons, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL AND seasons = 1
) subquery

SELECT ROUND(AVG(imdb_score),2) AS avg_imdb_score_mult
FROM(
SELECT seasons, imdb_score
FROM Netflix
WHERE type = 'SHOW' AND imdb_score IS NOT NULL AND seasons > 1
) subquery


