USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) AS total_rows_movies FROM movie;
-- 7997
SELECT COUNT(*) AS total_rows_genre FROM genre;
-- 14662
SELECT COUNT(*) AS total_rows_ratings FROM ratings;
-- 7997
SELECT COUNT(*) AS total_rows_names FROM names;
-- 25735
SELECT COUNT(*) AS total_rows_director_mapping FROM director_mapping;
-- 3867
SELECT COUNT(*) AS total_rows_role_mapping FROM role_mapping;
-- 15615

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
(select count(*) from movie where id is NULL) AS id,
(select count(*) from movie where title is NULL) as title,
(select count(*) from movie where year is NULL) as year,
(select count(*) from movie where date_published is NULL) as date_published,
(select count(*) from movie where duration is null) as duration,
(select count(*) from movie where country is null) as country,
(select count(*) from movie where worlwide_gross_income is null) as worlwide_gross_income,
(select count(*) from movie where languages is null) as languages,
(select count(*) from movie where production_company is null) as production_company
;


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

SELECT year,
	count(title) as number_of_movies
    from movie
group by year;

select month(date_published) as month_num,
	count(*) 				as number_of_movies
from movie
group by month_num
order by month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(distinct ID) as number_of_movies, year
from movie
where (upper (country) LIKE '%INDIA%'
		or upper (country) like '%USA%')
	AND year = 2019 ;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre from genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre,
		count(mov.id) as number_of_movies
from	movie		as mov
INNER JOIN genre as gen
where gen.movie_id = mov.id
group by genre
order by number_of_movies DESC limit 1 ;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select genre_count,
	count(movie_id) movie_count
from (select movie_id, count(genre) genre_count
	from genre
    group by movie_id
    order by genre_count desc ) genre_counts
where genre_count =1
group by genre_count;


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

select genre,
	round(avg(duration),2) as avg_duration
from movie as mov
inner join genre as gen
on gen.movie_id = mov.id
group by genre
order by avg_duration desc;

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

with genre_summary as 
(
	SELECT
		genre,
		count(movie_id) 							AS movie_count ,
        Rank() OVER (ORDER BY count(movie_id) DESC ) as genre_rank
	from genre
    group by genre
)
select * 
from genre_summary
where genre= "THRILLER";	

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

SELECT 
	min(avg_rating) AS min_avg_rating,
    max(avg_rating) AS max_avg_rating,
    min(total_votes) as min_total_votes,
    max(total_votes) as max_total_votes,
    min(median_rating) as min_median_rating,
    max(median_rating) as max_median_rating
FROM ratings;

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

SELECT 
	title,
    avg_rating,
    DENSE_rank() OVER (order by avg_rating DESC) as movie_rank
from ratings as rat
inner join movie as mov
on mov.id = rat.movie_id limit 10;

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

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;


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

SELECT production_company,
	count (movie_id) as movie_count,
    RANK () over (order by count(movie_id) desc) as prod_company_rank
from ratings as rat
	inner join movies as mov
    on mov.id = rat.movie_id
where avg_rating >8 
	AND production_company is not null
GROUP By production_company;


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

select genre,
		count(mov.id) as movie_count
from movie as mov
	inner join genre as gen
		on gen.movie_id = mov.id
    inner join ratings as rat
		on rat.movie_id = mov.id
where year = 2017
	AND month(date_published) = 3
    AND country LIKE '%USA%'
    AND total_votes > 1000
GROUP by genre
order by movie_count DESC;


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
FROM movie as mov
	INNER JOIN genre as gen
		on gen.movie_id = mov.id
    INNER JOIN ratings as rat
			on rat.movie_id = mov.id
WHERE avg_rating > 8
	AND title LIKE 'THE%'	
ORDER BY avg_rating DESC;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select 
	median_rating,
count(*) as movie_count
from movie as mov
	inner join ratings as rat
		on rat.movie_id = mov.id
where median_rating = 8
	AND date_published between '2018-04-01' AND '2019-04-01'
group by median_rating;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select 
	country,
    sum(total_votes) as total_votes
from movie as mov
	inner join ratings as rat
			on mov.id = rat.movie_id
where lower (country) = 'germany' or lower (country) = 'italy'
group by country;

-- The answer is YES
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

select sum(case
			WHEN NAME IS NULL THEN 1
            ELSE 0
            END) as name_null,
		sum(case 
			when height is null then 1
            else 0
            END) as height_null,
		sum(case
			when date_of_birth is null then 1 
            else 0
            END) as date_of_bith_null,
		sum(case 
			when known_for_movies is null then 1
            else 0
            END) as known_for_movies_null
from names;


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

with top_3_genre
AS (
	SELECT genre,
		count(mov.id) AS movie_count,
        RANK () OVER (ORDER BY count(mov.id) DESC) as genre_rank
	FROM movie as mov
		INNER JOIN genre AS gen
			ON gen.movie_id = mov.id
		INNER JOIN ratings AS rat
			on rat.movie_id = mov.id
	WHERE avg_rating > 8
	GROUP BY genre limit 3
    )
select
	nam.NAME as director_name,
    count(dm.movie_id) as movie_count
from director_mapping as dm
	inner join genre gen using (movie_id)
    inner join names as nam
    on nam.id = dm.name_id
    inner join top_3_genre using (genre)
    inner join ratings using (movie_id)
where avg_rating > 8
group by name 
order by movie_count DESC limit 3;

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
select
	nam.name as actor_name,
		count(movie_id) as movie_count
from role_mapping as rm
	inner join movie as mov
		on mov.id = rm.movie_id
	inner join ratings as rat using (movie_id)
    inner join names as nam
		on nam.id =rm.name_id
where rat.median_rating >= 8
	and category = 'actor'
group by actor_name
order by movie_count DESC limit 2;
    

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

select
	production_company,
    sum(total_votes) as vote_count,
    rank() over (order by sum(total_votes) DESC) as prod_comp_rank
from movie as mov
inner join ratings as rat
	on rat.movie_id = mov.id
group by production_company limit 3;


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

WITH actor_summary
     AS (SELECT n.name AS actor_name, total_votes,
                Count(R.movie_id) AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
         FROM movie AS m
                INNER JOIN ratings AS r
                      ON m.id = r.movie_id
                INNER JOIN role_mapping AS rm
					  ON m.id = rm.movie_id
                INNER JOIN names AS n
                        ON rm.name_id = n.id
         WHERE category = 'actor'
                AND country = "india"
         GROUP BY name
         HAVING movie_count >= 5)
SELECT *,
       Rank() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM actor_summary;

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

WITH actress_detail
	 AS(
       SELECT 
          n.name AS actress_name, total_votes,
		  Count(r.movie_id) AS movie_count,
		  Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
        FROM movie AS m
             INNER JOIN ratings AS r
                   ON m.id=r.movie_id
			 INNER JOIN role_mapping AS rm
                   ON m.id = rm.movie_id
			 INNER JOIN names AS n
                   ON rm.name_id = n.id
	    WHERE Upper(category) = 'ACTRESS'
              AND Upper(country) = "INDIA"
              AND Upper(languages) LIKE '%HINDI%'
	   GROUP BY name
	   HAVING movie_count>=3 
       )
SELECT *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM actress_detail LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with thriller_movies as (
	select 
		distinct title,
        avg_rating
	from movie as mov inner join ratings as rat
		on mov.id = rat.movie_id
		inner join genre as gen on gen.movie_id = mov.id
	where genre like 'Thriller')
select *,
		case 
			when avg_rating > 8 then 'superhit movies'
            when avg_rating between 7 and 8 then 'hit movies'
            when avg_rating between 5 and 7 then 'one-time-watch movies'
            else 'Flop movies'
		end as avg_rating_category
from thriller_movies;


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

select genre,
		ROUND(AVG(duration),2) as avg_duration,
        sum(round(avg(duration),2)) over (order by genre ROWS unbounded preceding) as running_total_duration,
		round(avg(avg(duration)) over (order by genre rows 10 PRECEDING),2) as moving_avg_duration
from movie as m
inner join genre as g
on m.id = g.movie_id
group by genre
order by genre;

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

WITH top_3_genres 
     AS( SELECT genre,
                Count(m.id) AS movie_count ,
                Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
         FROM movie AS m
              INNER JOIN genre AS g
                     ON g.movie_id = m.id
              INNER JOIN ratings AS r
                     ON r.movie_id = m.id
         GROUP BY genre limit 3 ), movie_summary 
     AS( SELECT genre, year,
                title AS movie_name,
                CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
         FROM movie AS m
              INNER JOIN genre AS g
                    ON m.id = g.movie_id
         WHERE genre IN
         ( SELECT genre FROM top_3_genres)
         GROUP BY   movie_name
          )
SELECT * FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;
        

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

WITH production_company_detail
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM movie AS mov
                INNER JOIN ratings AS rat
		      ON rat.movie_id = mov.id
         WHERE median_rating >= 8
	       AND production_company IS NOT NULL
               AND Position(',' IN languages) > 0
         GROUP BY production_company
         ORDER BY movie_count DESC)
SELECT *,
       Rank() over( ORDER BY movie_count DESC) AS prod_comp_rank
FROM production_company_detail LIMIT 2;


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

WITH actress_summary 
     AS( SELECT n.name AS actress_name,
                SUM(total_votes) AS total_votes,
		Count(r.movie_id) AS movie_count,
                Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
	FROM movie AS m
             INNER JOIN ratings AS r
                   ON m.id=r.movie_id
             INNER JOIN role_mapping AS rm
                   ON m.id = rm.movie_id
             INNER JOIN names AS n
		   ON rm.name_id = n.id
             INNER JOIN GENRE AS g
                  ON g.movie_id = m.id
	WHERE lower(category) = 'actress'
              AND avg_rating>8
              AND lower(genre) = "drama"
	GROUP BY name )
SELECT *,
	   Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM actress_summary LIMIT 3;






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

WITH next_date_published_detail
     AS( SELECT d.name_id, name, d.movie_id, duration, r.avg_rating, total_votes, m.date_published,
                Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
          FROM director_mapping                                                                      AS d
               INNER JOIN names                                                                                 AS n
                     ON n.id = d.name_id
               INNER JOIN movie AS m
                     ON m.id = d.movie_id
               INNER JOIN ratings AS r
                     ON r.movie_id = m.id ), top_director_summary AS
( SELECT *,
         Datediff(next_date_published, date_published) AS date_difference
  FROM   next_date_published_detail )
SELECT   name_id AS director_id,
         name AS director_name,
         Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;





