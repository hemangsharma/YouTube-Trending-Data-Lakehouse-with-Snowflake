USE DATABASE ASSIGNMENT_1;

-- Task 1
SELECT CATEGORY_TITLE
FROM TABLE_YOUTUBE_CATEGORY
GROUP BY CATEGORY_TITLE
HAVING COUNT(DISTINCT CATEGORY_ID) > 1;

-- Task 2
SELECT CATEGORY_TITLE
FROM table_youtube_category
GROUP BY CATEGORY_TITLE
HAVING COUNT(DISTINCT COUNTRY) = 1;


-- Task 3
SELECT DISTINCT c.category_id, c.CATEGORY_TITLE, c.COUNTRY
FROM table_youtube_final t
JOIN table_youtube_category c ON t.category_id = c.category_id
WHERE t.CATEGORY_TITLE IS NULL
AND c.CATEGORY_TITLE IS NOT NULL;

-- Task 3 (Verify)
SELECT category_id, COUNT(*)
FROM table_youtube_final
WHERE CATEGORY_TITLE IS NULL
GROUP BY category_id;


-- Task 4
UPDATE table_youtube_final t
SET CATEGORY_TITLE = c.CATEGORY_TITLE
FROM table_youtube_category c
WHERE t.category_id = c.CATEGORY_ID
AND t.CATEGORY_TITLE IS NULL
AND t.category_id IN (
    SELECT DISTINCT category_id
    FROM table_youtube_final
    WHERE CATEGORY_TITLE IS NULL
)
AND c.CATEGORY_TITLE IS NOT NULL;

-- Task 5
SELECT TITLE
FROM table_youtube_final
WHERE channel_title IS NULL;


-- Task 6
DELETE FROM table_youtube_final
WHERE video_id = '#NAME?';

-- Task 7
CREATE OR REPLACE TABLE table_youtube_duplicates AS
WITH ranked_duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY video_id, country, trending_date
               ORDER BY view_count DESC
           ) AS rn
    FROM table_youtube_final
)
SELECT *
FROM ranked_duplicates
WHERE rn > 1;

-- Task 8
DELETE FROM table_youtube_final
USING table_youtube_duplicates d
WHERE table_youtube_final.video_id = d.video_id
AND table_youtube_final.country = d.country
AND table_youtube_final.trending_date = d.trending_date
AND table_youtube_final.ID = d.ID;

-- Task 9
SELECT COUNT(*)
FROM table_youtube_final;