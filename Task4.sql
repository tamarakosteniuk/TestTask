WITH cteTable (UserID, CountP)
AS (SELECT u.UserID,  COUNT(s.SessionID) as CountP FROM [aschema].[Sessions] as s 
JOIN [aschema].[Users] as u ON s.UserID=u.UserID
		WHERE s.LoginTS > (SELECT DATEADD(hour, -1, GETDATE()))  
		GROUP BY u.UserID
		HAVING COUNT(s.SessionID)>1)

SELECT u.UserName as 'User Name', d.DeviceName as 'Device Name', s.LoginTS as 'Login TS' FROM cteTable as c 
JOIN [aschema].[Sessions] as s 
ON c.UserID=s.UserID JOIN [aschema].[Users] as u ON s.UserID=u.UserID 
JOIN [aschema].[Devices] as d ON d.DeviceID=s.DeviceID
WHERE s.LoginTS > (SELECT DATEADD(hour, -1, GETDATE())) 
ORDER BY u.UserName, s.LoginTS
GO