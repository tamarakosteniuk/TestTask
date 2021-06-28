SET LANGUAGE ENGLISH
SELECT u.UserName [User Name], c.Country, s.LoginTS [Login TS] FROM [aschema].[Sessions] as s 
JOIN [aschema].[Countries] as c ON s.CountryID=c.CountryID JOIN [aschema].[Users] as u ON s.UserID=u.UserID
WHERE CAST(s.LoginTS as date) = CAST(GETDATE() as date) AND s.CountryID NOT IN
(SELECT n.CountryID FROM [aschema].[Sessions] as n 
WHERE n.UserID=s.UserID AND FORMAT(n.LoginTS, 'yyyy-MM') >= FORMAT(DATEADD(month, -5, GETDATE()), 'yyyy-MM')
AND CAST(n.LoginTS as date) < CAST(GETDATE() as date)) 





