SET LANGUAGE ENGLISH
DECLARE @StartDate DATETIME, @EndDate DATETIME
SET @StartDate =  CONVERT(Char(16), FORMAT(DATEADD(month, -11, GETDATE()), 'yyyyMMdd'), 112)
SET @EndDate = GETDATE();

WITH cteTable1(DateHour, DeviceID, DeviceType)
AS (
	SELECT MIN(s.LoginTS) as MinLoginTS, s.DeviceID, ds.DeviceType [Device type] FROM [aschema].[Sessions] as s 
	JOIN [aschema].[Devices] as d 
	ON s.DeviceID =d.DeviceID JOIN [aschema].[DeviceTypes] as ds ON d.DeviceTypeID=ds.DeviceTypeID
	GROUP BY s.DeviceID, ds.DeviceType
	HAVING FORMAT( MIN(s.LoginTS), 'yyyy-MM') >=  FORMAT(@StartDate, 'yyyy-MM')),
cteTable2 (DateHour)
AS (
	SELECT DATEADD (month, number, @StartDate)
	FROM master..spt_values
	WHERE type = 'P' AND DATEADD(month,number,@StartDate) <= @EndDate)

SELECT FORMAT(c2.DateHour, 'yyyy') [Year],  DATENAME(month,CONVERT(Char(16), FORMAT(c2.DateHour, 'yyyyMMdd'),112)) [Month], ISNULL(c1.DeviceType, 'No new devices') [Device type],
COUNT(c1.DeviceType) [Number of users] FROM cteTable1 as c1 RIGHT JOIN cteTable2 as c2 ON  DATEPART(year,c1.DateHour) =  DATEPART(year,c2.DateHour) AND DATEPART(month,c1.DateHour) = DATEPART(month,c2.DateHour)
GROUP BY FORMAT(c2.DateHour, 'yyyy'), CONVERT(Char(16), FORMAT(c2.DateHour, 'yyyyMMdd'),112), c1.DeviceType
ORDER BY  CONVERT(Char(16), FORMAT(c2.DateHour, 'yyyyMMdd'),112), c1.DeviceType
GO