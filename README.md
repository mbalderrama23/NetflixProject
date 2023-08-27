# Netflix Project
Matthew Balderrama 2023-08-26

## Introduction
Netflix is an America subscription based streaming service that offers a wide variety of movies and TV shows. Netflix, along with similar platforms, have revolutionized how we consume movies and TV shows. Using the [Netflix TV Shows and Movies Dataset](https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies?select=titles.csv) from Kaggle, we can reveal patterns and trends in order to gain valuable insights through the utilization of SQL and Tableau. Acquired in July 2022, the data contains around 5k+ rows with 15 columns (genre, ratings, duration, seasons, etc) about the TV show and movie information and 77k+ rows for the credits of actors and directors on Netflix with 5 columns (id, name, role, etc). 


## Project Objective
Through the strategic utilization of SQL and Tableau, we aim to orchestrate the transformation and manipulation of data, complemented by the delivery of insightful visualizations. This synthesis of analytical tools facilitates the extraction of profound insights, culminating in an enhanced comprehension of the intricate interplay between content dynamics and audience preferences.


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



