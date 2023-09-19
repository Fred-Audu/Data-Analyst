SELECT *
FROM project .dbo.data1;

SELECT *
FROM project.dbo.data2;

--number of rows in the dataset

SELECT count(*)
FROM project ..data1;
SELECT count(*)
FROM project ..data2;

--dataset for Jhakarn and Bihar

SELECT * 
FROM project..data1
WHERE state in ('Jharkhand','Bihar');

--population of india

SELECT sum(population)
AS Population
FROM project..data2;

--avg growth

SELECT AVG(growth)*100
AS avg_growth
FROM project..data1;

--Multiplied growth by 100 to get it in percentage which is more clearer

--avg growth by state

SELECT state,
AVG(growth)*100
AS avg_growth
FROM project..data1
GROUP BY state;

--avg sex ratio

SELECT state,
ROUND(AVG(sex_ratio),0)
AS sex_ratio
FROM project..data1
GROUP BY state;

--using the order by function to order the rows in descending order to get the highest sex ratio

SELECT state,
ROUND(AVG(sex_ratio),0)
AS avg_sex_ratio
FROM project..data1
GROUP BY state
ORDER BY avg_sex_ratio DESC;

--avg literacy rate

SELECT state,
ROUND(AVG(literacy),0)
AS avg_literacy_ratio
FROM project..data1
GROUP BY state
ORDER BY avg_literacy_ratio DESC

--get the avg literacy rate greater than 90

SELECT state,
ROUND(AVG(literacy),0)
AS avg_literacy_ratio
FROM project..data1
GROUP BY state
HAVING ROUND(AVG(literacy),0)>90
ORDER BY avg_literacy_ratio DESC;

--top 3 states showing highest growth ratio

SELECT top 3 state,
AVG(growth)*100
AS avg_growth
FROM project..data1
GROUP BY state
ORDER BY avg_growth DESC;

----bottom 3 states showing lowest sex ratio

SELECT top 3 state,
ROUND(AVG(sex_ratio),0)
AS avg_sex_ratio
FROM project..data1
GROUP BY state
ORDER BY avg_sex_ratio ASC;

--Top and bottom 3 states in literacy rate
DROP TABLE IF exists #topstates;
CREATE TABLE #topstates
( state nvarchar(255),
  topstates float

  )

INSERT INTO #topstates
SELECT state,
ROUND(AVG(literacy),0)
AS literacy_ratio
FROM project..data1
GROUP BY state
ORDER BY literacy_ratio DESC;

SELECT TOP 3 *
FROM #topstates
ORDER BY #topstates.
topstates DESC;



DROP TABLE IF exists #bottomstates;
CREATE TABLE #bottomstates
( state nvarchar(255),
  bottomstates float

  )

INSERT INTO #bottomstates
SELECT state,
ROUND(AVG(literacy),0)
AS literacy_ratio
FROM project..data1
GROUP BY state
ORDER BY literacy_ratio ASC;

SELECT TOP 3 *
FROM #bottomstates
ORDER BY #bottomstates.
bottomstates ASC;

--Joining the two tables using union operator
SELECT * FROM (
SELECT TOP 3 *
FROM #topstates
ORDER BY #topstates.
topstates DESC) a

UNION

SELECT * FROM (
SELECT TOP 3 *
FROM #bottomstates
ORDER BY #bottomstates.
bottomstates ASC) b;

--States starting with letter a or b

SELECT DISTINCT STATE FROM 
project..data1
WHERE lower(STATE) LIKE 'a%'

OR

lower(STATE) LIKE 'b%';

--sates starting with the letter a and ending with the letter m

SELECT DISTINCT STATE FROM 
project..data1
WHERE lower(STATE) LIKE 'a%'

AND

lower(STATE) LIKE '%m';

--joining tables

SELECT a.district, a.state, a.sex_ratio, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district;


--calculating the total number of male population and total number of female population using mathematical formulas in each district
--divide by 1000 which is the formula given by indian census

SELECT c.district, c.state, ROUND(c.population/(c.sex_ratio+1),0) males, ROUND((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females FROM
( SELECT a.district, a.state, a.sex_ratio/1000 sex_ratio, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district ) c


--get the state level data (population of both males and females in each state)

SELECT d.state, SUM(d.males) total_males, sum(d.females) total_females FROM
(SELECT c.district, c.state, ROUND(c.population/(c.sex_ratio+1),0) males, ROUND((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females FROM
( SELECT a.district, a.state, a.sex_ratio/1000 sex_ratio, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district ) c) d
GROUP BY d.state;


--total literacy rate (divide by 100 which is the formula given by indian census)

SELECT a.district, a.state, a.literacy/100 literacy_ratio, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district

--total number of literate and illiterate pple in the districts

SELECT c.district, c.state, ROUND(c.literacy_ratio*c.population,0) literate_people, ROUND((1-c.literacy_ratio)*c.population,0) illiterate_people FROM
(SELECT a.district, a.state, a.literacy/100 literacy_ratio, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district) c

--total number of literate and illiterate pple in the states

SELECT d.state, SUM(d.literate_people) total_literate_population, sum(d.illiterate_people) total_illiterate_population FROM
(SELECT c.district, c.state, ROUND(c.literacy_ratio*c.population,0) literate_people, ROUND((1-c.literacy_ratio)*c.population,0) illiterate_people FROM
(SELECT a.district, a.state, a.literacy/100 literacy_ratio, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district) c) d
GROUP BY d.state

--I want to get the population in previous census ( whether you put the AS function or not its still thesame)

SELECT c.district, c.state, ROUND(c.population/(1+c.growth),0) AS previous_population, c.population AS current_population FROM
(SELECT a.district, a.state, a.growth AS growth, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district) c

--GROUP BY STATE

SELECT d.state,SUM(d.previous_census_population) AS previous_census_population,SUM(d.current_census_population) AS current_census_population FROM
(SELECT c.district, c.state, ROUND(c.population/(1+c.growth),0) AS previous_census_population, c.population AS current_census_population FROM
(SELECT a.district, a.state, a.growth AS growth, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district) c) d
GROUP BY d.state

--total population of India into the prvevious and current census

SELECT SUM(e.previous_census_population) AS previous_census_population , SUM(e.current_census_population) AS current_census_population FROM
(SELECT d.state,SUM(d.previous_census_population) AS previous_census_population,SUM(d.current_census_population) AS current_census_population FROM
(SELECT c.district, c.state, ROUND(c.population/(1+c.growth),0) AS previous_census_population, c.population AS current_census_population FROM
(SELECT a.district, a.state, a.growth AS growth, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district) c) d
GROUP BY d.state) e

--population vs area

SELECT q.*, r.* FROM
(SELECT '1' as keyy, n.* FROM
(SELECT SUM(e.previous_census_population) AS previous_census_population , SUM(e.current_census_population) AS current_census_population FROM
(SELECT d.state,SUM(d.previous_census_population) AS previous_census_population,SUM(d.current_census_population) AS current_census_population FROM
(SELECT c.district, c.state, ROUND(c.population/(1+c.growth),0) AS previous_census_population, c.population AS current_census_population FROM
(SELECT a.district, a.state, a.growth AS growth, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district) c) d
GROUP BY d.state) e) n) q INNER JOIN(

SELECT '1' as keyy, z.* FROM
(SELECT SUM(area_km2) AS total_area FROM project..data2)z) r ON q.keyy= r.keyy

--to get how much has been decreased from the previous population

SELECT (g.total_area/g.previous_census_population) AS previous_census_population_vs_area, (g.total_area/g.current_census_population) AS current_census_population_vs_area FROM
(SELECT q.*, r.total_area FROM
(SELECT '1' as keyy, n.* FROM
(SELECT SUM(e.previous_census_population) AS previous_census_population , SUM(e.current_census_population) AS current_census_population FROM
(SELECT d.state,SUM(d.previous_census_population) AS previous_census_population,SUM(d.current_census_population) AS current_census_population FROM
(SELECT c.district, c.state, ROUND(c.population/(1+c.growth),0) AS previous_census_population, c.population AS current_census_population FROM
(SELECT a.district, a.state, a.growth AS growth, b.population
FROM  project..data1 a
INNER JOIN project..data2 b 
ON a.district=b.district) c) d
GROUP BY d.state) e) n) q INNER JOIN(

SELECT '1' as keyy, z.* FROM
(SELECT SUM(area_km2) AS total_area FROM project..data2)z) r ON q.keyy= r.keyy) g

--window functions
--to give output of top 3 districts from each state with highest literacy rate using the window function

SELECT a.* FROM
(SELECT district, state, literacy, RANK() OVER(PARTITION BY STATE ORDER BY literacy DESC) RANK FROM project..data1) a
WHERE a.RANK IN (1,2,3)
ORDER BY STATE