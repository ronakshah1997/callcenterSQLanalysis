USE portfolioproject;

-- before importing our data, we will create an empty table for the csv file to be imported in
CREATE TABLE calls (
ID CHAR(50),
cust_name CHAR(50),
sentiment CHAR(20),
csat_score INT,
call_timestamp CHAR(10),
reason CHAR(20),
city CHAR(20),
state CHAR(20),
callchannel CHAR(20),
response_time CHAR(20),
call_duration_minutes INT,
call_center CHAR(20)
);

-- here we want to convert call_timestamp into a date format
SELECT * FROM calls;
UPDATE calls SET call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y"); 
SELECT * FROM calls;

-- lets see the shape of our data, ie the total number of columns and rows
SELECT COUNT(*) AS rows_num FROM calls;
SELECT COUNT(*) AS cols_num FROM information_schema.columns WHERE table_name = 'calls';

-- checking the distinct values of some columns from our table
SELECT DISTINCT sentiment FROM calls;
SELECT DISTINCT reason FROM calls;
SELECT DISTINCT channel FROM calls;
SELECT DISTINCT response_time FROM calls;
SELECT DISTINCT call_center FROM calls;

-- The count and percentage from total of each of the distinct values we have 
SELECT sentiment, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT channel, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT response_time, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT call_center, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT state, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100,1) AS pct 
FROM calls GROUP BY 1 ORDER BY 3 DESC;
-- for instance, Billing Questions amount to 71.3% of all calls with Service Outage and Payments making up 14.3% each

-- now lets look at which day has the most calls
SELECT DAYNAME(call_timestamp) as Day_of_call, COUNT(*) num_of_calls FROM calls GROUP BY 1 ORDER BY 2 DESC;
-- it looks like Friday has the most calls and Sunday has the least

-- lets perform some aggregations on this dataset
SELECT MIN(csat_score) AS min_score, MAX(csat_score) AS max_score, ROUND(AVG(csat_score),1) AS avg_score
FROM calls WHERE csat_score != 0; 

SELECT MIN(call_timestamp) AS earliest_date, MAX(call_timestamp) AS most_recent FROM calls;

SELECT MIN(call_duration_minutes) AS min_call_duration, MAX(call_duration_minutes) AS max_call_duration, AVG(call_duration_minutes) AS avg_call_duration FROM calls;

-- checking how many calls are within, below or above the Service-Level -Agreement time
SELECT call_center, response_time, COUNT(*) AS count
FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

SELECT call_center, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT channel, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT state, reason, COUNT(*) FROM calls GROUP BY 1,2 ORDER BY 1,2,3 DESC;

SELECT state, sentiment, COUNT(*) FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

SELECT state, AVG(csat_score) as avg_csat_score FROM calls WHERE csat_score != 0 GROUP BY 1 ORDER BY 2 DESC;

SELECT sentiment, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- function to query the maximum call duration each day and then sort by it
SELECT call_timestamp, MAX(call_duration_minutes) OVER(PARTITION BY call_timestamp) AS max_call_duration 
FROM calls GROUP BY 1 ORDER BY 2 DESC;













