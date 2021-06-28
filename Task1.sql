SET LANGUAGE ENGLISH
DECLARE @StartDate DATETIME, @EndDate DATETIME
SET @StartDate =  CONVERT(Char(16), FORMAT(DATEADD(month, -11, GETDATE()), 'yyyyMMdd'), 112)
SET @EndDate = GETDATE();
WITH cteTable1 (UserID, DateHour)
AS (
	SELECT s.UserID, MIN(s.LoginTS) FROM [aschema].[Sessions] as s
	GROUP BY s.UserID 
	HAVING FORMAT(MIN(s.LoginTS), 'yyyy-MM') >=  FORMAT(@StartDate, 'yyyy-MM')),
cteTable2 (DateHour)
AS (
	SELECT DATEADD (month, number, @StartDate)
	FROM master..spt_values
	WHERE type = 'P' AND DATEADD(month,number,@StartDate) <= @EndDate)
SELECT FORMAT(c2.DateHour, 'yyyy') [Year],  
DATENAME(month,CONVERT(Char(16), FORMAT(c2.DateHour, 'yyyyMMdd'),112)) [Month], 
COUNT(c1.UserID) as 'Number of users'  FROM cteTable1 as c1  
RIGHT JOIN cteTable2 as c2 ON DATEPART(year,c1.DateHour) =  DATEPART(year,c2.DateHour) 
AND DATEPART(month,c1.DateHour) = DATEPART(month,c2.DateHour)
GROUP BY FORMAT(c2.DateHour, 'yyyy'), CONVERT(Char(16), FORMAT(c2.DateHour, 'yyyyMMdd'),112)
ORDER BY  CONVERT(Char(16), FORMAT(c2.DateHour, 'yyyyMMdd'),112)
GO


