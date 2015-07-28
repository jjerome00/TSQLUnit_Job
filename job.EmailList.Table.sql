/*
PURPOSE: List of notification emails
*/
CREATE TABLE [job].[EmailList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[test] [varchar](255) NULL,
	[name] [varchar](100) NULL,
	[email] [varchar](1000) NULL,
	[notes] [varchar](max) NULL,
	[inactive] [int] NOT NULL CONSTRAINT [DF_EmailList_inactive]  DEFAULT ((0))
) ON [PRIMARY]
GO

