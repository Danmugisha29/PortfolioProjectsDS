/*
 Author : Dan Mugisha
 Project : NFL offense data Week 3 2022
 Skills used: CTE's, Temp Tables, Duplicate removal, aggregation 
*/


-- Query to select all NFL offense dataset

SELECT
* 
FROM
nfl_offense_week_5

-- Number of teams in the NFL
-- Determine the number of NFL teams

SELECT count(*) as number_of_teams
FROM
nfl_offense_week_5;


/*
 Remove duplicates in the NFL dataset
*/

-- Identify duplicate rows using CTE
-- No duplicates so no need to remove them

WITH Row_Number_CTE
AS (SELECT
       rank, 
	   team, 
	   games,
	   points_scored,
	   total_yards,
	   ROW_NUMBER() OVER(PARTITION BY rank, 
	                                  team, 
									  games,
									  points_scored,
									  total_yards
           ORDER BY rank) DuplicateCount
    FROM nfl_offense_week_4)

SELECT*
FROM Row_Number_CTE
where DuplicateCount > 1;

/*
  Create nfl_conference column and group teams according to their respective conference
*/

-- Add column 

ALTER TABLE nfl_offense_week_5
ADD nfl_conference nvarchar(255);

-- afc_north
/*Baltimore Ravens", "Cincinnati Bengals", "Cleveland Browns", "Pittsburgh Steelers*/

UPDATE nfl_offense_week_5 set nfl_conference = 'afc_north' where team = 'Baltimore Ravens';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_north' where team = 'Cleveland Browns';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_north' where team = 'Cincinnati Bengals';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_north' where team = 'Pittsburgh Steelers';

-- afc_east
/*
"Miami Dolphins", "Buffalo Bills", "New England Patriots", "New York Jets" 
*/
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_east' where team = 'Miami Dolphins';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_east' where team = 'Buffalo Bills';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_east' where team = 'New England Patriots';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_east' where team = 'New York Jets';


-- afc_west
/*
 "Denver Broncos", "Kansas City Chiefs", "Las Vegas Raiders", "Los Angeles Chargers"
*/
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_west' where team = 'Denver Broncos';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_west' where team = 'Kansas City Chiefs';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_west' where team = 'Las Vegas Raiders';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_west' where team = 'Los Angeles Chargers';

-- afc_south
/*
 "Houston Texans", "Indianapolis Colts", "Jacksonville Jaguars", "Tennessee Titans"
*/
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_south' where team = 'Houston Texans';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_south' where team = 'Indianapolis Colts';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_south' where team = 'Jacksonville Jaguars';
UPDATE nfl_offense_week_5 set nfl_conference = 'afc_south' where team = 'Tennessee Titans';


-- nfc_north
/*
 "Chicago Bears", "Detroit Lions", "Green Bay Packers", "Minnesota Vikings"
*/
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_north' where team = 'Chicago Bears';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_north' where team = 'Detroit Lions';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_north' where team = 'Green Bay Packers';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_north' where team = 'Minnesota Vikings';

-- nfc_east
/*
 "Dallas Cowboys", "New York Giants", "Philadelphia Eagles", "Washington Commanders"
*/
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_east' where team = 'Dallas Cowboys';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_east' where team = 'New York Giants';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_east' where team = 'Philadelphia Eagles';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_east' where team = 'Washington Commanders';

-- nfc_west
/*
 "Arizona Cardinals", "Los Angeles Rams", "San Francisco 49ers", "Seattle Seahawks"
*/
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_west' where team = 'Arizona Cardinals';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_west' where team = 'Los Angeles Rams';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_west' where team = 'San Francisco 49ers';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_west' where team = 'Seattle Seahawks';


-- nfc_south
/*
 "Atlanta Falcons", "Carolina Panthers", "New Orleans Saints", "Tampa Bay Buccaneers"
*/
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_south' where team = 'Atlanta Falcons';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_south' where team = 'Carolina Panthers';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_south' where team = 'New Orleans Saints';
UPDATE nfl_offense_week_5 set nfl_conference = 'nfc_south' where team = 'Tampa Bay Buccaneers';


------------------

/*
  Analyze NFL dataset
*/

-- Determine the team with the highest number of total yards among all the NFL teams
-- Most_total_yards - Detroit Lions 

SELECT team, total_yards
FROM
nfl_offense_week_5
ORDER BY total_yards DESC

-- Determine the team with the most 1st down completions among all the NFL teams
-- Most_1st_down_completions - Kansas City Chiefs

SELECT 
team, [1st_downs]
FROM
nfl_offense_week_5
ORDER BY [1st_downs]DESC

-- Determine the team with the most yards per play among all the NFL teams
-- Most yards_per_play -- Buffalo Bills

SELECT 
team, yards_per_play
FROM
nfl_offense_week_5
ORDER BY yards_per_play DESC

-- Determine the number of teams in each of the NFL conference
-- Each nfl_conference has 4 teams

SELECT 
nfl_conference, 
count(*) as number_of_teams_in_each_conference
FROM
nfl_offense_week_5
GROUP BY nfl_conference
ORDER BY  number_of_teams_in_each_conference DESC

-- Determine the NFL conference with the highest number of total points scored 
-- Total_points_scored - afc_north

SELECT 
nfl_conference, 
SUM(points_scored) as total_points_scored
FROM
nfl_offense_week_5
GROUP BY nfl_conference
ORDER BY total_points_scored DESC

-- Determine the NFL conference with the most total yards
-- nfl_conference with most total yards - afc_east

SELECT 
nfl_conference, 
SUM(total_yards) as total_yards_in_each_conference
FROM
nfl_offense_week_5
GROUP BY nfl_conference 
ORDER BY total_yards_in_each_conference DESC


-- Determine the team with the highest yards per play in a specific conference
-- nfl_conference used - nfc_west
-- Max_yards_per_play - Seattle Seahawks

SELECT 
team, nfl_conference, 
yards_per_play
FROM
nfl_offense_week_5
WHERE nfl_conference ='nfc_west'
ORDER BY yards_per_play DESC

-- Determine the team with the highest number of points scored in a specific conference
-- nfl_conference used - nfc_west
-- Max_points_scored - Seattle Seahawks

SELECT 
team, nfl_conference, 
points_scored
FROM
nfl_offense_week_5
WHERE nfl_conference ='nfc_west'
ORDER BY points_scored DESC


-- Determine the team with the highest number of passing touchdowns in a specific conference
-- nfl_conference used - nfc_west
-- max_passing_touchdowns - Seattle Seahawks

SELECT 
team, nfl_conference, 
passing_touchdowns
FROM
nfl_offense_week_5
WHERE nfl_conference ='nfc_west'
ORDER BY passing_touchdowns DESC;


-- CTE
-- Used CTE to be able to partition data according to the NFL conference and avoiding tie 
-- present between some of the NFL teams

-- Determine the team with the most passing touchdowns within each conference
-- Max passing touchdowns NFL conference and team
-- afc_north, Baltimore Ravens

WITH ROW_NUMBER_CTE AS (
  SELECT
    team,nfl_conference, passing_touchdowns
    ,ROW_NUMBER() OVER(PARTITION BY nfl_conference ORDER BY passing_touchdowns DESC) AS row_number
  FROM nfl_offense_week_5
)
SELECT
  team,nfl_conference,MAX(passing_touchdowns) as max_passing_touchdowns
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY nfl_conference, team
ORDER BY max_passing_touchdowns DESC;


-- Determine the team with the highest number of passing yards within each conference
-- Most passing yards NFL conference and team
-- afc_east, Buffalo Bills

WITH ROW_NUMBER_CTE AS (
  SELECT
    team,nfl_conference, passing_yards
    ,ROW_NUMBER() OVER(PARTITION BY nfl_conference ORDER BY passing_yards DESC) AS row_number
  FROM nfl_offense_week_5
)
SELECT
  team,nfl_conference,MAX(passing_yards) as max_passing_yards
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY nfl_conference, team
ORDER BY max_passing_yards DESC;

-- Determine the team with the highest number of rushing yards within each conference
-- Most rushing yards NFL conference and team
-- afc_north, Cleveland Browns

WITH ROW_NUMBER_CTE AS (
  SELECT
    team,nfl_conference,rushing_yards
    ,ROW_NUMBER() OVER(PARTITION BY nfl_conference ORDER BY rushing_yards DESC) AS row_number
  FROM nfl_offense_week_5
)
SELECT
  team,nfl_conference,MAX(rushing_yards) as max_rushing_yards
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY nfl_conference, team
ORDER BY max_rushing_yards DESC;

-- Determine the team with the highest number of rushing touchdowns within each conference
-- Most rushing touchdowns NFL conference and team
-- nfc_east, Philadelphia Eagles

WITH ROW_NUMBER_CTE AS (
  SELECT
    team,nfl_conference,rushing_touchdowns
    ,ROW_NUMBER() OVER(PARTITION BY nfl_conference ORDER BY rushing_touchdowns DESC) AS row_number
  FROM nfl_offense_week_5
)
SELECT
  team,nfl_conference,MAX(rushing_touchdowns) as max_rush_touchdowns
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY nfl_conference, team
ORDER BY max_rush_touchdowns DESC;

-- Determine the team with the highest number of points scored within each conference
-- Most points scored NFL conference and team
-- afc_west, Kansas City Chiefs

WITH ROW_NUMBER_CTE AS (
  SELECT
    team,nfl_conference,points_scored
    ,ROW_NUMBER() OVER(PARTITION BY nfl_conference ORDER BY points_scored DESC) AS row_number
  FROM nfl_offense_week_5
)
SELECT
  team,nfl_conference,MAX(points_scored) as max_points_scored
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY nfl_conference, team
ORDER BY max_points_scored DESC;

-- Determine the team with the highest number of total yards within each conference
-- Most total yards NFL conference and team
-- afc_east, Buffalo Bills

WITH ROW_NUMBER_CTE AS (
  SELECT
    team,nfl_conference, total_yards
    ,ROW_NUMBER() OVER(PARTITION BY nfl_conference ORDER BY total_yards DESC) AS row_number
  FROM nfl_offense_week_5
)
SELECT
  team,nfl_conference,MAX(total_yards) as max_total_yards
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY nfl_conference, team
ORDER BY max_total_yards DESC;

-- Determine the team with most pass completion percentage within each conference
-- Most pass completion percentage NFL conference and team
-- nfc_west, Seattle Seahawks

--- Temporary table for Pass Completion percentage

DROP TABLE if exists PassCompletionPercentage_Week_5
Create Table PassCompletionPercentage_Week_5
(
   team nvarchar (255),
   nfl_conference nvarchar(255),
   passes_attempted numeric,
   passes_completed numeric,
   pass_completion_percentage float
)
Insert into PassCompletionPercentage_Week_5

SELECT team, nfl_conference, passes_attempted,
passes_completed,(passes_completed/passes_attempted)*100 AS pass_completion_percentage
FROM
nfl_offense_week_5;


WITH ROW_NUMBER_CTE
AS (
  SELECT
    team, nfl_conference, pass_completion_percentage
    ,ROW_NUMBER() OVER(PARTITION BY nfl_conference ORDER BY pass_completion_percentage DESC) AS row_number
  FROM PassCompletionPercentage_Week_5
)
SELECT
  team,nfl_conference,MAX(pass_completion_percentage) as max_pass_completion_percentage
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY nfl_conference, team
ORDER BY max_pass_completion_percentage DESC;


-- Determine the team with the highest number of touchdowns within each NFL conference
-- Most total number of touchdowns NFL conference and team
-- afc_north, Kansas City Chiefs

DROP TABLE if exists Total_number_of_touchdowns_Week_5
Create Table Total_number_of_touchdowns_Week_5
(
   team nvarchar (255),
   nfl_conference nvarchar(255),
   passing_touchdownns numeric,
   rushing_touchdowns numeric,
   total_num_of_touchdowns numeric
)

Insert into Total_number_of_touchdowns_Week_5

SELECT team, nfl_conference, 
passing_touchdowns, rushing_touchdowns,
(passing_touchdowns + rushing_touchdowns) AS total_num_of_touchdowns
FROM
nfl_offense_week_5;

WITH ROW_NUMBER_CTE
AS (
  SELECT
    team, nfl_conference, total_num_of_touchdowns
    ,ROW_NUMBER() OVER(PARTITION BY nfl_conference ORDER BY total_num_of_touchdowns DESC) AS row_number
  FROM Total_number_of_touchdowns_Week_5
)
SELECT
  team,nfl_conference,MAX(total_num_of_touchdowns) as Most_total_number_of_touchdowns
FROM ROW_NUMBER_CTE
WHERE row_number = 1
GROUP BY nfl_conference, team
ORDER BY Most_total_number_of_touchdowns DESC;


--ALTER DATABASE Nfl_offense_week_3_2022_dataset MODIFY NAME = Nfl_offense_2022_database;