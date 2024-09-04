USE DATABASE ASSIGNMENT_1;

-- Task 1

SELECT
    COUNTRY,
    TITLE,
    CHANNEL_TITLE AS CHANNELTITLE ,
    VIEW_COUNT,
    ROW_NUMBER() OVER (PARTITION BY COUNTRY ORDER BY VIEW_COUNT DESC) AS RK
FROM table_youtube_final
WHERE TRENDING_DATE = '2024-04-01'
AND CATEGORY_TITLE = 'Gaming'
QUALIFY RANK() OVER (PARTITION BY country ORDER BY view_count DESC) <= 3
ORDER BY COUNTRY, RK;

-- Task 2
SELECT
    country,
    COUNT(DISTINCT video_id) AS CT
FROM table_youtube_final
WHERE UPPER(title) LIKE '%BTS%'
GROUP BY country
ORDER BY CT DESC;


-- Task 3
SELECT
    country,
    TO_CHAR(trending_date, 'YYYY-MM') AS year_month,
    title,
    channel_title,
    category_title,
    view_count,
    TRUNC(likes / NULLIF(view_count, 0) * 100, 2) AS likes_ratio
FROM (
    SELECT
        country,
        trending_date,
        title,
        channel_title,
        category_title,
        view_count,
        likes,
        ROW_NUMBER() OVER (PARTITION BY country, TO_CHAR(trending_date, 'YYYY-MM') ORDER BY view_count DESC) AS rn
    FROM table_youtube_final
    WHERE EXTRACT(YEAR FROM trending_date) = 2024
)
WHERE rn = 1
ORDER BY year_month, country;


-- Task 4 

WITH video_counts AS (
    SELECT
        country,
        CATEGORY_TITLE,
        COUNT(DISTINCT video_id) AS total_category_video
    FROM table_youtube_final
    WHERE trending_date > '2022-01-01'
    GROUP BY country, CATEGORY_TITLE
),
total_counts AS (
    SELECT
        country,
        COUNT(DISTINCT video_id) AS total_country_video
    FROM table_youtube_final
    WHERE trending_date > '2022-01-01'
    GROUP BY country
),
category_percentages AS (
    SELECT
        v.country,
        v.CATEGORY_TITLE,
        v.total_category_video,
        t.total_country_video,
        (v.total_category_video / NULLIF(t.total_country_video, 0)) * 100 AS percentage
    FROM video_counts v
    JOIN total_counts t
    ON v.country = t.country
),
max_category AS (
    SELECT
        country,
        CATEGORY_TITLE,
        total_category_video,
        total_country_video,
        percentage,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY total_category_video DESC) AS rn
    FROM category_percentages
)
SELECT
    country,
    CATEGORY_TITLE,
    total_category_video AS TOTAL_CATEGORY_VIDEO,
    total_country_video AS TOTAL_COUNTRY_VIDEO,
    TRUNC(percentage, 2) AS PERCENTAGE
FROM max_category
WHERE rn = 1
ORDER BY CATEGORY_TITLE, country;


-- Task 5
SELECT
    channel_title,
    COUNT(DISTINCT video_id) AS video_count_times
FROM table_youtube_final
GROUP BY channel_title
ORDER BY video_count_times DESC
LIMIT 1;