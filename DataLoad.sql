CREATE TABLE #StagingData
( SessionID int,
  LoginTS datetime NOT NULL,
  LogoutTS datetime NOT NULL,
  UserName nvarchar(50) NOT NULL,
  DeviceName nvarchar(50) NOT NULL,
  DeviceType nvarchar(50) NOT NULL,
  Country nvarchar(50) NOT NULL
)
GO
BULK INSERT #StagingData
FROM 'C:\\Users\tamar\Desktop\Data_test\DataAnalytics2.csv'
WITH (
    FIRSTROW = 2,
	FIELDTERMINATOR = ';',  
	ROWTERMINATOR = '\n',   
	TABLOCK,
	CODEPAGE = 'ACP')
GO
INSERT INTO [aschema].[Countries] (Country)
SELECT DISTINCT Country FROM #StagingData
GO
INSERT INTO [aschema].[Users] (UserName)
SELECT DISTINCT UserName FROM #StagingData
GO
INSERT INTO [aschema].[DeviceTypes] (DeviceType)
SELECT DISTINCT DeviceType FROM #StagingData
GO
INSERT INTO [aschema].[Devices] (UserID, DevicetypeID, DeviceName)
SELECT DISTINCT u.UserID, dt.DeviceTypeID, s.DeviceName FROM #StagingData as s JOIN [aschema].[Users] as u
ON s.UserName=u.UserName JOIN [aschema].[DeviceTypes] as dt ON dt.DeviceType=s.DeviceType 
GO
INSERT INTO [aschema].[Sessions] (UserID, LoginTS, LogoutTS, CountryID, DeviceID)
SELECT DISTINCT u.UserID, s.LoginTS, s.LogoutTS, c.CountryID, d.DeviceID
FROM #StagingData as s 
JOIN [aschema].[Users] as u ON s.UserName=u.UserName 
JOIN [aschema].[Countries] as c ON s.Country=c.Country
JOIN [aschema].[DeviceTypes] as dt ON dt.DeviceType=s.DeviceType 
JOIN [aschema].[Devices] as d ON s.DeviceName=d.DeviceName AND d.DeviceTypeID=dt.DeviceTypeID AND d.UserID=u.UserID
GO

