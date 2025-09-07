-- Netflix Project
drop TABLE if exists netflix;

create table netflix
(
	show_id	varchar(10),
	type varchar(10),	
	title varchar(150),	
	director varchar(250),	
	casts varchar(1000),
	country	varchar(150),
	date_added	varchar(50),
	release_year int,	
	rating varchar(50),
	duration varchar(50),
	listed_in varchar(150),	
	description varchar(250)
);	

SELECT * from netflix;

SELECT
count(*) 
from netflix;

-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	count(show_id) as total_count
from netflix
GROUP by type;
	


-- 2. Find the most common rating for movies and TV shows

SELECT
	type,
	rating 
FROM
(SELECT 
	type,
	rating,
	count(show_id),
	Rank() over(PARTITION by type order by count(show_id) DESC) as Rank
from netflix
group by 1, 2)as t1
where rank = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * from netflix
where
	type = 'Movie'
	and
	release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

select
	trim(unnest(string_to_array(country, ','))) as new_country,
	count(show_id)
from netflix
group by 1
order by 2 DESC
limit 5;


-- 5. Identify the longest movie

select title, 
substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflix
where type = 'Movie' and duration is not null
order by 2 desc
limit 1;

-- 6. Find content added in the last 5 years

select *from netflix
where 
	to_date(date_added, 'Month dd, yyyy') >= current_date - interval '5 years';



-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select 
	type,
	title, 
	director	
from netflix 
where  director like '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons

select 	*  from netflix
WHERE	
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::int > 5;

-- 9. Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as Total_count
from netflix
group by 1;	

	
-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

select 
	release_year,
	count(*),
	round(count(*)::numeric/(select count(*) from netflix
	where country = 'India'):: numeric* 100, 2) as average_content
from netflix
where country = 'India'
group by 1
order by  3 desc
limit 5;
	
	



-- 11. List all movies that are documentaries

select * from netflix
where 	
	listed_in like '%Documentaries%';

-- 12. Find all content without a director

	select * from netflix
	where 	
		director is null;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where 	
	casts Ilike '%Salman Khan%'
	and
	release_year > extract(year from current_date) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
	unnest(string_to_array(casts, ',')) as Actors,
	count(*) as Total_movie
from netflix
where 
	type = 'Movie'
	and 
	country ILIKE '%India%'
group by 1
ORDER by 2 desc
limit 10;


-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

with new_table
AS
(
select *,
		case	
		when description ilike '%kill%'
		or 
		description ilike '%violence%' THEN 'Bad_content'
		else 'Good_content'
		END Category
from netflix
)
SELECT
	category,
	count(*)
from new_table
group by 1;
	

