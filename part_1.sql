-- Task 3 a
CREATE DATABASE assignment_1;


USE DATABASE assignment_1;

-- Task 3 b
CREATE OR REPLACE STAGE stage_assignment
URL='azure://utshemang.blob.core.windows.net/assignment'
CREDENTIALS=(AZURE_SAS_TOKEN=' ');


-- Verifying 
SHOW STAGES LIKE 'stage_assignment';


-- Task 4 a
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_trending
(
    video_id STRING AS (value:c1::STRING),
    title STRING AS (value:c2::STRING),
    published_at TIMESTAMP_NTZ AS (value:c3::TIMESTAMP_NTZ),
    channel_id STRING AS (value:c4::STRING),
    channel_title STRING AS (value:c5::STRING),
    category_id STRING AS (value:c6::STRING),
    trending_date DATE AS (value:c7::DATE),
    view_count NUMBER AS (value:c8::NUMBER),
    likes NUMBER AS (value:c9::NUMBER),
    dislikes NUMBER AS (value:c10::NUMBER),
    comment_count NUMBER AS (value:c11::NUMBER),
    country STRING AS (regexp_substr(metadata$filename, '/([^/]+)_youtube_trending', 1, 1, 'e')::STRING)
)
WITH LOCATION=@stage_assignment/youtube_trending
FILE_FORMAT=(TYPE=CSV FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER= 1 );

-- Task 5 a
CREATE OR REPLACE TABLE table_youtube_trending AS
SELECT
    video_id,
    title,
    published_at,
    channel_id,
    channel_title,
    category_id,
    trending_date,
    view_count,
    likes,
    dislikes,
    comment_count,
    country
FROM ex_table_youtube_trending
WHERE video_id != 'video_id';

-- Verifying
SELECT *
FROM table_youtube_trending
LIMIT 10;

-- Task 4 b
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_category
WITH LOCATION = @stage_assignment/youtube-category
FILE_FORMAT = (TYPE = 'JSON')
PATTERN = '.*[.]json';

-- Verifying
SELECT *
FROM ex_table_youtube_category
LIMIT 10;

-- Task 5 b
CREATE OR REPLACE TABLE table_youtube_category AS
SELECT
    regexp_substr(metadata$filename, '/([^/]+)_category', 1, 1, 'e')::STRING AS COUNTRY,
    f.value:id::STRING AS CATEGORY_ID,
    f.value:snippet:title::STRING AS CATEGORY_TITLE
FROM ex_table_youtube_category,
LATERAL FLATTEN(input => parse_json($1):items) f;

-- Verifying content of internal category table
SELECT *
FROM table_youtube_category
LIMIT 10;

-- Task 6

CREATE OR REPLACE TABLE table_youtube_final AS
SELECT 
    t.video_id,
    t.title,
    t.published_at,
    t.channel_id,
    t.channel_title,
    t.category_id,
    t.trending_date,
    t.view_count,
    t.likes,
    t.dislikes,
    t.comment_count,
    t.country,
    c.CATEGORY_TITLE,
    UUID_STRING() AS ID
FROM 
    table_youtube_trending t
LEFT JOIN 
    table_youtube_category c
ON 
    t.country = c.COUNTRY AND t.category_id = c.CATEGORY_ID;

-- Verify
SELECT COUNT(*) FROM table_youtube_final;