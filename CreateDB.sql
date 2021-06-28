CREATE SCHEMA aschema
GO
CREATE TABLE [aschema].[Users] (
UserID int PRIMARY KEY IDENTITY,
UserName nvarchar(50) NOT NULL)
GO
CREATE TABLE [aschema].[Countries] (
CountryID int PRIMARY KEY IDENTITY,
Country nvarchar(50) NOT NULL UNIQUE)
GO
CREATE TABLE [aschema].DeviceTypes (
DeviceTypeID int PRIMARY KEY IDENTITY,
DeviceType nvarchar(50) NOT NULL UNIQUE)
GO
CREATE TABLE [aschema].[Devices] (
DeviceID int PRIMARY KEY IDENTITY,
UserID int,
DeviceTypeID int,
DeviceName nvarchar(50) NOT NULL,
FOREIGN KEY (UserID) REFERENCES [aschema].Users(UserID),
FOREIGN KEY (DeviceTypeID) REFERENCES [aschema].DeviceTypes(DeviceTypeID))
GO
CREATE TABLE [aschema].[Sessions] (
SessionID int PRIMARY KEY IDENTITY,
UserID int,
LoginTS datetime NOT NULL,
LogoutTS datetime NOT NULL,
CountryID int,
DeviceID int,
FOREIGN KEY (UserID) REFERENCES [aschema].Users(UserID),
FOREIGN KEY (CountryID) REFERENCES [aschema].Countries(CountryID),
FOREIGN KEY (DeviceID) REFERENCES [aschema].Devices(DeviceID))
GO
