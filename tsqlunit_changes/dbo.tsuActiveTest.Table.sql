------------------------------------------------------------------------------------
-- Modifications:
--
--	12/09/2010 JMJ: 
--	*	Change [message] column from nvarchar(255) to NVARCHAR(max) for entire app
--
------------------------------------------------------------------------------------
CREATE TABLE [dbo].[tsuActiveTest](
	[isError] [bit] NOT NULL,
	[isFailure] [bit] NOT NULL,
	[procedureName] [nvarchar](255) NULL,
	[message] [nvarchar](max) NOT NULL
) ON [PRIMARY]
GO
