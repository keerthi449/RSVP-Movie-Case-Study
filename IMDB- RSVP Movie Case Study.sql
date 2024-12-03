USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:
SELECT
	*
FROM
	movie, ratings, genre, director_mapping, role_mapping, names ;


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select table_name , table_rows
from information_schema.tables
where table_schema ='imdb';


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select sum(case when id is null then 1 else 0 end) as id_null,
sum(case when title is null then 1 else 0 end) as title_null,
sum(case when year is null then 1 else 0 end) as year_null,
sum(case when date_published is null then 1 else 0 end) as date_published_null,
sum(case when duration is null then 1 else 0 end) as duration_null,
sum(case when country is null then 1 else 0 end) as country_null,
sum(case when worlwide_gross_income is null then 1 else 0 end) asworlwide_gross_income_null,
sum(case when languages is null then 1 else 0 end) as languages_null,
sum(case when production_company is null then 1 else 0 end) asproduction_company_null
from movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select count(*) as number_of_movies, month(date_published) as month_num 
from movie
group by month_num
order by month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select * 
from movie 
where year = '2019'and (country = 'USA' or country ='India');



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre
from genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, count(*) as number_of_movies
from genre group by genre
limit 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

With one_genre_movies as
	(
	SELECT movie_id, count(movie_id)  AS genre_no_of_count
	FROM genre
	GROUP BY movie_id
	HAVING count(genre)=1
    )
    select count(*)
    from one_genre_movies;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

Select g.genre, avg(m.duration) as Average_Duration
From Movie m
INNER JOIN Genre g
ON m.id = g.movie_id
GROUP BY g.genre
Order by Average_Duration asc
;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre, count(id) AS Movie_count, 
	RANK() OVER (ORDER BY count(id) DESC) AS Genre_rank
FROM movie AS m
INNER JOIN genre AS g
	ON m.id=g.movie_id
GROUP BY genre;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select max(avg_rating) as max_avg_rating, min(avg_rating) as min_avg_rating, 
max(total_votes) as max_total_votes, min(total_votes) as min_total_votes, max(median_rating) as max_median_rating, 
min(median_rating) as min_median_rating from ratings;

    
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select *, dense_rank() 
over(order by avg_rating desc) r from ratings rate inner join movie m on m.id = rate.movie_id
limit 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT movie_id, count(movie_id),median_rating
	FROM ratings
	GROUP BY median_rating
	order by median_rating;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, COUNT(r.movie_id) as movie_count,
RANK() OVER(
    ORDER BY 
    COUNT(r.movie_id) DESC
    ) prod_company_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT  genre, count(m.id) AS movie_count
FROM movie m 
INNER JOIN ratings r 
		ON m.id=r.movie_id
	JOIN genre g 
		ON m.id=g.movie_id
WHERE 
    (total_votes > 1000) AND 
    (MONTH(date_published)= 3) AND 
    (m.year=2017) AND 
    (m.country LIKE '%USA%')
GROUP BY genre
ORDER BY 2 DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
FROM movie AS m
	INNER JOIN genre AS g
		ON g.movie_id=m.id
	INNER JOIN ratings AS r 
		ON r.movie_id=m.id
WHERE avg_rating>8 AND title LIKE 'the%'
ORDER BY Genre;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(id) as movie_count_with_median_rating_of_8
FROM movie as m
	INNER JOIN ratings as r
	ON r.movie_id=m.id
WHERE (median_rating=8) AND (date_published BETWEEN '2018-04-01' AND '2019-04-01');

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH votes_summary AS
(
SELECT 
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN m.id END) AS german_movie_count,
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN m.id END) AS italian_movie_count,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN r.total_votes END) AS german_movie_votes,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN r.total_votes END) AS italian_movie_votes
FROM
    movie AS m 
	    INNER JOIN
	ratings AS r 
		ON m.id = r.movie_id
)
SELECT 
    ROUND(german_movie_votes / german_movie_count, 2) AS german_votes_per_movie,
    ROUND(italian_movie_votes / italian_movie_count, 2) AS italian_votes_per_movie
FROM
    votes_summary;
    

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	sum(CASE WHEN name IS NULL THEN 1 ELSE 0 END) as name_nulls,
	sum(CASE WHEN height IS NULL THEN 1 ELSE 0 END) as height_nulls,
	sum(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) as date_of_birth_nulls,
    sum(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) as known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres aS 
	(
		SELECT genre, count(g.movie_id) as movie_counts
		FROM genre as g
			INNER JOIN ratings as r 
				ON r.movie_id=g.movie_id
		WHERE avg_rating > 8
		GROUP BY genre
		ORDER BY count(g.movie_id) DESC
		LIMIT 3
	)    
SELECT n.name as director_name, count(g.movie_id) as movie_count
FROM names n
	INNER JOIN director_mapping as d
		ON n.id=d.name_id
	INNER JOIN genre as g
		ON d.movie_id=g.movie_id
	INNER JOIN ratings as r
		ON r.movie_id=g.movie_id, top_3_genres
WHERE 
	g.genre IN (top_3_genres.genre)
	AND avg_rating> 8           
GROUP BY director_name
ORDER BY movie_count DESC
limit 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name as actor_name, count(r.movie_id) as movie_count
FROM role_mapping as rm
INNER JOIN names as n
	ON rm.name_id=n.id
INNER JOIN ratings as r
	ON rm.movie_id=r.movie_id
WHERE r.median_rating>=8 AND rm.category LIKE 'actor'
GROUP BY name
ORDER BY movie_count DESC
Limit 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_prod AS
(
SELECT 
    m.production_company,
    SUM(r.total_votes) AS vote_count,
    ROW_NUMBER() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_company_rank
FROM
    movie AS m
        LEFT JOIN
    ratings AS r
		ON m.id = r.movie_id
WHERE m.production_company IS NOT NULL
GROUP BY m.production_company
)
SELECT 
    *
FROM
    top_prod
WHERE
    prod_company_rank <= 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
		n.name as actor_name,
		sum( total_votes) as total_votes, 
		count(r.movie_id) as movie_count, 	
		round(sum(avg_rating*total_votes)/sum(total_votes),2) as actor_avg_rating,
                row_number() over(order by round(sum(avg_rating*total_votes)/sum(total_votes),2) desc, count(r.movie_id) desc)

	FROM movie as  m
	INNER JOIN ratings as r 
		ON m.id=r.movie_id
	INNER JOIN role_mapping as rm 
		ON m.id=rm.movie_id
	INNER JOIN names as n
		ON rm.name_id=n.id

	WHERE country LIKE 'India' AND category ='actor'

	GROUP BY name

        HAVING movie_count > 4;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH hindi_actress_rank as
	(
	SELECT
		n.name as actress_name,
		sum( total_votes) as total_votes, 
		count(r.movie_id) as movie_count, 	
		round(sum(avg_rating*total_votes)/sum(total_votes),2) as actress_avg_rating
	FROM movie as  m
	INNER JOIN ratings as r 
		ON m.id=r.movie_id
	INNER JOIN role_mapping as rm 
		ON m.id=rm.movie_id
	INNER JOIN names as n
		ON rm.name_id=n.id
	WHERE country LIKE 'India' AND category ='actress' AND languages='hindi'
	GROUP BY name
	)
SELECT * , 	
	RANK () OVER (ORDER BY actress_avg_rating DESC,total_votes DESC) AS actress_rank
FROM hindi_actress_rank
WHERE movie_count>=3;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
	title,
	CASE 
		WHEN avg_rating>8 THEN 'Superhit Movie' 
		WHEN avg_rating>7 THEN 'Hit Movie'
		WHEN avg_rating >5 THEN 'One-time-watch Movie' 
		ELSE 'Flop Movie'
	END AS movie_category
FROM movie as m 
INNER JOIN  genre as g
	ON m.id=g.movie_id
INNER JOIN ratings as r 
	ON m.id=r.movie_id
WHERE genre ='thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED 
    PRECEDING) AS running_total_duration,
    AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) 
    AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_genres AS
(
SELECT 
    genre,
    COUNT(m.id) AS movie_count,
	RANK () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM
    genre AS g
        LEFT JOIN
    movie AS m 
		ON g.movie_id = m.id
GROUP BY genre
)
,
top_grossing AS
(
SELECT 
    g.genre,
	year,
	m.title as movie_name,
    worlwide_gross_income,
    RANK() OVER (PARTITION BY g.genre, year
					ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
FROM
movie AS m
	INNER JOIN
genre AS g
	ON g.movie_id = m.id
WHERE g.genre IN (SELECT DISTINCT genre FROM top_genres WHERE genre_rank<=3)
)
SELECT * 
FROM
	top_grossing
WHERE movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, COUNT(r.movie_id) as movie_count,
RANK() OVER(
    ORDER BY 
    COUNT(r.movie_id) DESC
    ) prod_company_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY production_company;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actress_rank as
	(
	SELECT
		n.name as actress_name,
		sum( total_votes) as total_votes, 
		count(r.movie_id) as movie_count, 	
		round(sum(avg_rating*total_votes)/sum(total_votes),2) as actress_avg_rating
	FROM movie as  m
	INNER JOIN ratings as r 
		ON m.id=r.movie_id
	INNER JOIN role_mapping as rm 
		ON m.id=rm.movie_id
	INNER JOIN names as n
		ON rm.name_id=n.id
	WHere category ='actress'
	GROUP BY name
	)
SELECT * , 	
	RANK () OVER (ORDER BY actress_avg_rating DESC,total_votes DESC) AS actress_rank
FROM actress_rank
WHERE actress_avg_rating>8;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with movie_date_info as
(
select d.name_id, name, d.movie_id,
    m.date_published, 
       lead(date_published, 1) over(partition by d.name_id order by date_published, d.movie_id) as next_movie_date
from director_mapping d
  join names as n 
     on d.name_id=n.id 
  join movie as m 
     on d.movie_id=m.id ),

date_difference as
( select *, datediff(next_movie_date, date_published) as diff
  from movie_date_info ),
 
 avg_inter_days as
 ( select name_id, avg(diff) as avg_inter_movie_days
   from date_difference
   group by name_id ),

 final_result as
( select d.name_id as director_id,
   name as director_name,
   count(d.movie_id) as number_of_movies,
   round(avg_inter_movie_days) as inter_movie_days,
   round(avg(avg_rating),2) as avg_rating,
   sum(total_votes) as total_votes,
   min(avg_rating) as min_rating,
   max(avg_rating) as max_rating,
   sum(duration) as total_duration,
   row_number() over(order by count(d.movie_id) desc) as director_row_rank
  from
   names as n 
         join director_mapping as d 
         on n.id=d.name_id
   join ratings as r 
         on d.movie_id=r.movie_id
   join movie as m 
         on m.id=r.movie_id
   join avg_inter_days as a 
         on a.name_id=d.name_id
  group by director_id)
 select * 
 from final_result
 limit 9
 ;






