
1. Count Movies vs TV Shows

SELECT type, COUNT(*) 
FROM netflix 
GROUP BY type;
2. Most Common Rating

SELECT type, rating 
FROM (
    SELECT type, rating, COUNT(*) as count,
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as rnk
    FROM netflix 
    GROUP BY type, rating
) AS ranked_table
WHERE rnk = 1;
3. Released in 2020

SELECT * FROM netflix WHERE release_year = 2020;
4. Top 5 Countries
Note: MySQL lacks a direct UNNEST function. For simple queries, we use LIKE or basic grouping.


SELECT country, COUNT(*) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;
5. Longest Movie

SELECT * FROM netflix 
WHERE type = 'Movie' 
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC 
LIMIT 1;
6. Added in Last 5 Years

SELECT * FROM netflix 
WHERE STR_TO_DATE(date_added, '%M %e, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
7. Content by Director 'Rajiv Chilaka'

SELECT * FROM netflix 
WHERE director LIKE '%Rajiv Chilaka%';
8. TV Shows with > 5 Seasons

SELECT * FROM netflix 
WHERE type = 'TV Show' 
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
9. Count by Genre

SELECT listed_in as genre, COUNT(*) 
FROM netflix 
GROUP BY listed_in;
10. Average Content Release by India

SELECT release_year, COUNT(*) as total_release,
       (COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country LIKE '%India%') * 100) as avg_release
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY avg_release DESC
LIMIT 5;
11. Documentaries

SELECT * FROM netflix WHERE listed_in LIKE '%Documentaries%';
12. No Director
SQL
SELECT * FROM netflix WHERE director IS NULL OR director = '';
13. Salman Khan Movies (Last 10 Years)

SELECT * FROM netflix 
WHERE casts LIKE '%Salman Khan%' 
AND release_year > YEAR(CURDATE()) - 10;
14. Top 10 Indian Actors


SELECT casts, COUNT(*) 
FROM netflix 
WHERE country LIKE '%India%' 
GROUP BY casts 
ORDER BY COUNT(*) DESC 
LIMIT 10;
15. Content Categorization ('Kill'/'Violence')

SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    type,
    COUNT(*) as content_count
FROM netflix
GROUP BY category, type
ORDER BY type;