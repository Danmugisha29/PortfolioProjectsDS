
/*
 Author : Dan Mugisha
 Project : Trending Youtube videos Exploratory data analysis
 Skills used: CTE's, Temp Tables, Aggregate functions, Duplicate data removal
*/


/*
   QUERY TO SELECT THE DATASET
*/
--	Query to select all Trending youtube videos dataset

SELECT * 
FROM youtube_videos_data;

/*
  IDENTIFY DUPLICATES & REMOVE THEM FROM THE DATASET
*/


-- Identify for duplicate rows
-- Through the use of CTE, rows with duplicate data can be located and removed from the dataset

WITH Row_Number_CTE
AS (SELECT
       videoId, 
	   videoTitle, 
	   channelTitle, 
	   ROW_NUMBER() OVER(PARTITION BY videoId, 
	                                  videoTitle, 
									  channelTitle
           ORDER BY id) DuplicateCount
    FROM youtube_videos_data)

SELECT*
FROM Row_Number_CTE
where DuplicateCount > 1;

-- Remove duplicate with count greater than 1

WITH Row_Number_CTE
AS (SELECT
       videoId, 
	   videoTitle, 
	   channelTitle, 
	   ROW_NUMBER() OVER(PARTITION BY videoId, 
	                                  videoTitle, 
									  channelTitle
           ORDER BY id) DuplicateCount
    FROM youtube_videos_data)

DELETE
FROM Row_Number_CTE
where DuplicateCount > 1;

/*
  ANALYZE THE DATA - AGGREGATION AND CTE
*/

--- Identify the videos with highest number of views count according a specific genre

SELECT *
FROM
youtube_videos_data
WHERE videoCategoryLabel = 'People & Blogs'
ORDER BY viewCount DESC


-- Number of vids for each category label
-- Identify the category label with the most youtube videos
-- People & Blogs is the videoCategoryLabel with the highest number of youtube videos

SELECT videoCategoryLabel, Count(*) as Number_of_vids
FROM
youtube_videos_data
GROUP BY videoCategoryLabel
ORDER BY Number_of_vids DESC

-- Total number of videos per youtube channels
-- Determine youtube channel that has the most content
-- ICRISAT Co is the channel with the highest number of youtube videos

SELECT channelTitle, Count(*) as Total_num_vids_per_channel
FROM
youtube_videos_data
GROUP BY channelTitle
ORDER BY Total_num_vids_per_channel DESC

-- Youtube vids with over a 1000 views
-- Highest viewCount - Microdosing LSD or any Psychedelic

SELECT *
FROM
youtube_videos_data
WHERE viewCount >= 1000
ORDER BY viewCount DESC

-- Longest youtube video
-- Determine the youtube videos with the longest duration(seconds)

 SELECT videoId, channelTitle,videoDescription, durationSec
FROM
youtube_videos_data
ORDER BY durationSec DESC

-- Youtube videos with the most like counts
-- Most liked youtube video - Microdosing LSD or any Psychedelic

SELECT videoId, videoTitle, channelTitle,videoCategoryLabel, likeCount
FROM
youtube_videos_data
WHERE likeCount >= 100
ORDER BY likeCount DESC

-- Total views count by genre
-- Determine the youtube genre with the highest number of total views
-- Science & Technology is the genre with the highest number of total views

SELECT videoCategoryLabel, SUM(viewCount) as Total_Views_Count
FROM
youtube_videos_data
GROUP BY videoCategoryLabel
ORDER BY Total_Views_Count DESC

-- Total likes by genre
-- Determine the youtube genre with the highest number of total likes
-- Science & Technology is the genre with the highest Total likes count

SELECT videoCategoryLabel, SUM(likeCount) as Total_likes_Count
FROM
youtube_videos_data
GROUP BY videoCategoryLabel
ORDER BY Total_likes_Count DESC

-- Total views count per youtube channels
-- Determine the youtube channel with the highest number of total views
-- PyschedSubstance channel is the channel with the highest total views count

SELECT channelTitle, SUM(viewCount) as Total_Views_Count
FROM
youtube_videos_data
GROUP BY channelTitle
ORDER BY Total_Views_Count DESC

-- Total likes count per youtube channels
-- Determine the youtube channel with the highest number of total likes 
-- Psyched Substance is the channel with the highest Total likes count

SELECT channelTitle, SUM(likeCount) as Total_likes_count
FROM
youtube_videos_data
GROUP BY channelTitle
ORDER BY Total_likes_Count DESC

-- Total dislikes count per genre
-- Genre with the most dislikes - News & Politics

SELECT videoCategoryLabel, SUM(dislikeCount) as Total_dislike_count
FROM
youtube_videos_data
GROUP BY videoCategoryLabel
ORDER BY Total_dislike_count DESC

-- Number of hd vids for each genre
-- Determine the genre with the highest number of hd videos across all genres
-- Most hd vids - People & Blogs

SELECT videoCategoryLabel, Count(definition) as hd_vids_by_genre
FROM
youtube_videos_data
WHERE definition = 'hd'
GROUP BY videoCategoryLabel
ORDER BY hd_vids_by_genre DESC

-- Number of sd vids for each genre
-- Determine the genre with the highest number of sd videos accross all genres
-- Most sd vids - People & Blogs

 SELECT videoCategoryLabel, Count(definition) as sd_vids_by_genre
FROM
youtube_videos_data
WHERE definition = 'sd'
GROUP BY videoCategoryLabel
ORDER BY sd_vids_by_genre DESC

-- Total duration in seconds per genre
-- Determine which genre has the longest duration accross all genres
-- longest duration vid accross all genres - Nonprofits & Activism

SELECT videoCategoryLabel, MAX(durationSec) as Longest_duration_sec
FROM
youtube_videos_data
GROUP BY videoCategoryLabel
ORDER BY Longest_duration_sec DESC

/*
  Transforming data in different columns to get more insights
*/

-- Add new column

ALTER TABLE youtube_videos_data
Add Published_date_new_format Date;

Update youtube_videos_data
SET Published_date_new_format = CONVERT(date,publishedAt);

-- Add new column

ALTER TABLE youtube_videos_data
Add Published_year SMALLINT;

Update youtube_videos_data
SET Published_year = YEAR(Published_date_new_format)

--- Determine the total number of videos that were released each year

SELECT Published_year as year, Count(*) as Total_vids_each_year
FROM
youtube_videos_data
GROUP BY Published_year
ORDER BY Total_vids_each_year DESC

--- Total number of vids by genre 

SELECT videoCategoryLabel,Published_year as year, Count(*) as Total_vids_each_year
FROM
youtube_videos_data
GROUP BY Published_year , videoCategoryLabel
ORDER BY Total_vids_each_year DESC

-- Determine the youtube channels with the highest number of youtube videos each year
-- Temporary table to store the number of vids each year
-- The channel with the highest number of vids by year - ICRISAT Co

DROP TABLE if exists Total_num_vids
Create Table Total_num_vids
(
   channelTitle nvarchar (255),
   Published_year SMALLINT,
   num_vids numeric,
)

-- Insert into the temporary table

Insert into Total_num_vids
SELECT channelTitle, Published_year,
Count(*) AS num_vids
FROM
youtube_videos_data
GROUP BY Published_year , channelTitle
ORDER BY num_vids DESC ;

-- Query the temporary table

SELECT * 
FROM Total_num_vids;

-- Use CTE to partition the data by year

WITH ROW_NUMBER_CTE
AS (
  SELECT
    channelTitle, Published_year, num_vids
    ,ROW_NUMBER() OVER(PARTITION BY Published_year ORDER BY num_vids DESC) AS row_number
  FROM Total_num_vids
)
SELECT
  channelTitle, Published_year, MAX(num_vids) AS most_num_vids
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY channelTitle,Published_year
ORDER BY most_num_vids DESC;

-- Verify with this query
SELECT *
FROM
youtube_videos_data
WHERE Published_year = '2015' AND channelTitle = 'ICRISAT Co'


--- Total views count per year

WITH ROW_NUMBER_CTE AS (
  SELECT
    channelTitle, Published_year , viewCount
    ,ROW_NUMBER() OVER(PARTITION BY Published_year ORDER BY viewCount DESC) AS row_number
  FROM youtube_videos_data
)
SELECT
  channelTitle,Published_year, SUM(viewCount) as Most_views
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY channelTitle, Published_year
ORDER BY Most_views DESC;

--- Channel with the most likes every year
-- Determine the youtube videos with the highest number of likes


WITH ROW_NUMBER_CTE AS (
  SELECT
    channelTitle, Published_year , likeCount
    ,ROW_NUMBER() OVER(PARTITION BY Published_year ORDER BY likeCount DESC) AS row_number 
  FROM youtube_videos_data
)
SELECT
  channelTitle,Published_year, MAX(likeCount) as Most_likes
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY channelTitle, Published_year
ORDER BY Most_likes DESC;

-- Total comments per vids each year
-- Determine the youtube videos with the highest number of comments 
-- Most comments - Black Pigeon Speaks

WITH ROW_NUMBER_CTE AS (
  SELECT
    channelTitle, Published_year , commentCount
    ,ROW_NUMBER() OVER(PARTITION BY Published_year ORDER BY commentCount DESC) AS row_number
  FROM youtube_videos_data
)
SELECT
  channelTitle,Published_year, MAX(commentCount) as Most_comments
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY channelTitle, Published_year
ORDER BY Most_comments DESC;

