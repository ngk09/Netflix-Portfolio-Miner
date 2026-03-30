Markdown
# Netflix Portfolio Miner: SQL Content Analysis 🎬

![Netflix Analysis Logo](https://github.com/user-attachments/assets/3b5bdf74-d92e-44b5-aaa2-0a4d43306c88)

## Project Overview
This repository presents a data-driven exploration of Netflix’s global content library using **MySQL**. The objective is to audit the catalog, identify streaming patterns, and solve 15 critical business problems related to content distribution, genre trends, and regional production hubs.

## Objectives
- **Inventory Audit:** Contrast the volume of Movies vs. TV Shows.
- **Trend Spotting:** Identify the most common ratings and content release velocities.
- **Regional Deep-Dive:** Analyze production hotspots with a focus on Indian cinema.
- **Content Profiling:** Categorize the library based on duration, talent, and descriptive sentiment.

---

## Business Problems and Solutions

### 📊 Segment 1: Library Composition & Content Strategy

#### 1. Inventory Distribution
Analyze the current balance of content types available on the platform.
```sql
SELECT type, COUNT(*) 
FROM netflix 
GROUP BY type;
2. Popularity Profiling
Identify the most frequent rating for both Movies and TV Shows.

SQL
SELECT type, rating 
FROM (
    SELECT type, rating, COUNT(*) as count,
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as rnk
    FROM netflix 
    GROUP BY type, rating
) AS ranked_table
WHERE rnk = 1;
3. Historical Retrieval (2020)
List all content released during the 2020 fiscal year.

SQL
SELECT * FROM netflix WHERE release_year = 2020;
4. Recency Analysis
Filter for all titles added to the platform within the last 5 years.

SQL
SELECT * FROM netflix 
WHERE STR_TO_DATE(date_added, '%M %e, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
🌍 Segment 2: Regional & Talent Analytics
5. Market Concentration
Identify the top 5 countries driving global content volume.

SQL
SELECT country, COUNT(*) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;
6. Talent Portfolio Audit (Director)
Isolate the complete work history of director 'Rajiv Chilaka'.

SQL
SELECT * FROM netflix 
WHERE director LIKE '%Rajiv Chilaka%';
7. Indian Cinema Throughput
Calculate the top 5 years with the highest percentage of content releases from India.

SQL
SELECT release_year, COUNT(*) as total_release,
       (COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country LIKE '%India%') * 100) as avg_release
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY avg_release DESC
LIMIT 5;
8. Star-Power Influence (India)
Identify the top 10 most frequent actors appearing in Indian productions.

SQL
SELECT casts, COUNT(*) 
FROM netflix 
WHERE country LIKE '%India%' 
GROUP BY casts 
ORDER BY COUNT(*) DESC 
LIMIT 10;
9. Actor Portfolio Audit (Last 10 Years)
Track the volume of films featuring 'Salman Khan' in the last decade.

SQL
SELECT * FROM netflix 
WHERE casts LIKE '%Salman Khan%' 
AND release_year > YEAR(CURDATE()) - 10;
📈 Segment 3: Performance & Metadata Mining
10. Outlier Detection (Movies)
Identify the feature film with the longest runtime.

SQL
SELECT * FROM netflix 
WHERE type = 'Movie' 
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC 
LIMIT 1;
11. Longevity Assessment (TV Shows)
Filter for TV franchises that have successfully run for more than 5 seasons.

SQL
SELECT * FROM netflix 
WHERE type = 'TV Show' 
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
12. Genre Volumetrics
Count the total number of content items categorized under each genre.

SQL
SELECT listed_in as genre, COUNT(*) 
FROM netflix 
GROUP BY listed_in;
13. Niche Filtering (Documentaries)
Retrieve a comprehensive list of all documentaries.

SQL
SELECT * FROM netflix WHERE listed_in LIKE '%Documentaries%';
14. Safety & Sentiment Tagging
Label content based on the presence of high-intensity keywords ('Kill' or 'Violence').

SQL
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
🛠️ Segment 4: Data Quality & Governance
15. Metadata Gap Analysis
Locate records where director information is missing to ensure data integrity.

SQL
