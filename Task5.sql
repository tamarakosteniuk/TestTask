SET LANGUAGE ENGLISH
DECLARE @StartDate DATETIME, @EndDate DATETIME
SET @StartDate = FORMAT(DATEADD(day, -2, GETDATE()), 'yyyy-MM-dd 00:00:00')
SET @EndDate = GETDATE();
CREATE TABLE #Tempo(   
DateHour DATETIME,
Total int)
INSERT INTO #Tempo (DateHour)  
SELECT DATEADD(hour,number,@StartDate)FROM master..spt_values
WHERE type = 'P' AND DATEADD(hour,number,@StartDate) <= @EndDate;

WITH cteTable (DateHour, Total)
AS (
	SELECT t.DateHour, ISNULL(kk.Total,0) FROM
	(SELECT  c.DateHour [Date], SUM(CASE 
	WHEN c.DateHour = FORMAT((s.LoginTS), 'yyyy-MM-dd HH:00:00') THEN 
	CONVERT(int,DATEDIFF(minute, s.LoginTS, FORMAT(DATEADD(hour, 1, s.LoginTS), 'yyyy-MM-dd HH:00:00')))
	WHEN c.DateHour = FORMAT((s.LogoutTS), 'yyyy-MM-dd HH:00:00') THEN 
	CONVERT(int,DATEDIFF(minute, c.DateHour, LogoutTS)) 
	ELSE 60 END) [Total] 
	FROM #Tempo as c CROSS JOIN [aschema].[Sessions] as s 
	WHERE c.DateHour >= FORMAT((s.LoginTS), 'yyyy-MM-dd HH:00:00')  AND c.DateHour <= FORMAT((s.LogoutTS), 'yyyy-MM-dd HH:00:00')
	GROUP BY c.DateHour) as kk RIGHT JOIN #Tempo as t ON t.DateHour = kk.[Date])
SELECT CAST(c.DateHour as date) as 'Date', DATEPART(hour,c.DateHour) as 'Hour', 
c.Total as 'Total session duration for hour (in minutes)', 
SUM(c.Total) OVER (PARTITION BY CAST(c.DateHour as date) ORDER BY c.DateHour) 
AS 'Total session duration (accumulated)' FROM cteTable as c



