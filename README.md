# Netflix Movies and TV Shows Data Analysis Using SQL 

![Netflix logo](https://github.com/sahil-sawal/Netflix_SQL_projrct/blob/main/logo.png)

## Objective
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
	type,
	count(show_id) as total_count
from netflix
GROUP by type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * from netflix
where
	type = 'Movie'
	and
	release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select
	trim(unnest(string_to_array(country, ','))) as new_country,
	count(show_id)
from netflix
group by 1
order by 2 DESC
limit 5;

```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select title, 
    substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflix
where
     type = 'Movie' and duration is not null
order by 2 desc
limit 1;

```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select *from netflix
where 
	to_date(date_added, 'Month dd, yyyy') >= current_date - interval '5 years';

```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select 
	type,
	title, 
	director	
from netflix 
where  director like '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select 	*  from netflix
WHERE	
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::int > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as Total_count
from netflix
group by 1;	
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
###  return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select * from netflix
where 	
	listed_in like '%Documentaries%'
	and 
	type = 'Movie';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select * from netflix
where 	
    director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
Select * from netflix
where 	
	casts Ilike '%Salman Khan%'
	and
	release_year > extract(year from current_date) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
with new_table
AS
(
select *,
		case	
			when description ilike '%kill%' or description ilike '%violence%' THEN 'Bad_content'
			else 'Good_content'
		END Category
from netflix
)
SELECT
	category,
	count(*)
from new_table
group by 1;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Sahil Sawal

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. 

