SET LANGUAGE ENGLISH
DECLARE @StartDate DATETIME, @EndDate DATETIME
SET @StartDate = FORMAT(DATEADD(hour,-5, GETDATE()), 'yyyy-MM-dd HH:00:00') 
SET @EndDate = GETDATE();

WITH cteTable1 (DateHour)
AS (
	SELECT DATEADD(hour,number, @StartDate ) FROM master..spt_values
	WHERE type = 'P' AND DATEADD(hour,number,@StartDate) <= @EndDate)

SELECT c1.DateHour, ISNULL(COUNT(s.SessionID), 0) as 'Maximum concurrent sessions' FROM
cteTable1 as c1 CROSS JOIN [aschema].[Sessions] as s
WHERE c1.DateHour BETWEEN FORMAT(s.LoginTS, 'yyyy-MM-dd HH:00:00') AND FORMAT(s.LogoutTS, 'yyyy-MM-dd HH:00:00')
GROUP BY c1.DateHour 
GO