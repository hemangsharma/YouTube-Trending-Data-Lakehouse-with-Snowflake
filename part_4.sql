USE DATABASE ASSIGNMENT_1;

-- Calculate video count and total views per category and country, excluding "Music" and "Entertainment"
SELECT
    country,
    CATEGORY_TITLE,
    COUNT(video_id) AS video_count,
    SUM(view_count) AS total_views
FROM table_youtube_final
WHERE CATEGORY_TITLE NOT IN ('Music', 'Entertainment')
GROUP BY country, CATEGORY_TITLE
ORDER BY country, video_count DESC;

-- Identify the most popular category in each country based on the max video count and include total views
SELECT
    ccs.country,
    ccs.CATEGORY_TITLE,
    ccs.video_count,
    ccs.total_views
FROM (
    SELECT
        country,
        CATEGORY_TITLE,
        COUNT(video_id) AS video_count,
        SUM(view_count) AS total_views
    FROM table_youtube_final
    WHERE CATEGORY_TITLE NOT IN ('Music', 'Entertainment')
    GROUP BY country, CATEGORY_TITLE
) AS ccs
JOIN (
    SELECT
        country,
        MAX(video_count) AS max_video_count
    FROM (
        SELECT
            country,
            CATEGORY_TITLE,
            COUNT(video_id) AS video_count
        FROM table_youtube_final
        WHERE CATEGORY_TITLE NOT IN ('Music', 'Entertainment')
        GROUP BY country, CATEGORY_TITLE
    ) AS country_category_stats
    GROUP BY country
) AS mvc
ON ccs.country = mvc.country AND ccs.video_count = mvc.max_video_count
ORDER BY ccs.country, ccs.video_count DESC;


-- Find the category with the highest total views among the most popular categories
WITH popular_categories AS (
    SELECT
        ccs.country,
        ccs.CATEGORY_TITLE,
        ccs.video_count,
        ccs.total_views
    FROM (
        SELECT
            country,
            CATEGORY_TITLE,
            COUNT(video_id) AS video_count,
            SUM(view_count) AS total_views
        FROM table_youtube_final
        WHERE CATEGORY_TITLE NOT IN ('Music', 'Entertainment')
        GROUP BY country, CATEGORY_TITLE
    ) AS ccs
    JOIN (
        SELECT
            country,
            MAX(video_count) AS max_video_count
        FROM (
            SELECT
                country,
                CATEGORY_TITLE,
                COUNT(video_id) AS video_count
            FROM table_youtube_final
            WHERE CATEGORY_TITLE NOT IN ('Music', 'Entertainment')
            GROUP BY country, CATEGORY_TITLE
        ) AS country_category_stats
        GROUP BY country
    ) AS mvc
    ON ccs.country = mvc.country AND ccs.video_count = mvc.max_video_count
)

SELECT 
    country,
    CATEGORY_TITLE,
    total_views
FROM popular_categories
ORDER BY total_views DESC
LIMIT 1;


-- Calculate total view count for the 'People & Blogs' category across all countries
SELECT
    country,
    COUNT(video_id) AS video_count,
    SUM(view_count) AS total_views
FROM table_youtube_final
WHERE CATEGORY_TITLE = 'People & Blogs'
GROUP BY country
ORDER BY total_views DESC;


--  Calculate the total views for the "People & Blogs" category in each country
WITH people_blogs_views AS (
    SELECT
        country,
        'People & Blogs' AS category_title,
        SUM(view_count) AS total_views
    FROM table_youtube_final
    WHERE CATEGORY_TITLE = 'People & Blogs'
    GROUP BY country
),

-- Identify the highest-viewed category (excluding 'People & Blogs', 'Music', and 'Entertainment') in each country
highest_viewed_category AS (
    SELECT
        country,
        CATEGORY_TITLE AS category_title,
        SUM(view_count) AS total_views
    FROM table_youtube_final
    WHERE CATEGORY_TITLE NOT IN ('People & Blogs', 'Music', 'Entertainment')
    GROUP BY country, CATEGORY_TITLE
    QUALIFY ROW_NUMBER() OVER (PARTITION BY country ORDER BY total_views DESC) = 1
)

-- Combine the results to compare the views and calculate the difference
SELECT
    pb.country,
    pb.category_title AS people_blogs_category,
    pb.total_views AS people_blogs_views,
    hv.category_title AS highest_viewed_category,
    hv.total_views AS highest_category_views,
    CASE
        WHEN pb.total_views > hv.total_views THEN 'People & Blogs'
        ELSE hv.category_title
    END AS more_views_category,
    ABS(pb.total_views - hv.total_views) AS view_difference
FROM people_blogs_views pb
JOIN highest_viewed_category hv
ON pb.country = hv.country
ORDER BY pb.country;


-- Calculate the total views for "People & Blogs" and "Gaming" categories
WITH category_totals AS (
    SELECT
        CATEGORY_TITLE,
        SUM(view_count) AS total_views
    FROM table_youtube_final
    WHERE CATEGORY_TITLE IN ('People & Blogs', 'Gaming')
    GROUP BY CATEGORY_TITLE
),

-- Determine which category has more views and calculate the difference
view_comparison AS (
    SELECT
        MAX(CASE WHEN CATEGORY_TITLE = 'People & Blogs' THEN total_views END) AS people_blogs_views,
        MAX(CASE WHEN CATEGORY_TITLE = 'Gaming' THEN total_views END) AS gaming_views
    FROM category_totals
)

-- Final output showing the total views for each category, the difference, and which category has more views
SELECT
    people_blogs_views,
    gaming_views,
    gaming_views - people_blogs_views AS view_difference,
    CASE
        WHEN gaming_views > people_blogs_views THEN 'Gaming'
        ELSE 'People & Blogs'
    END AS more_views_category
FROM view_comparison;