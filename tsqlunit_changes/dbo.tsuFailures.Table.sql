------------------------------------------------------------------------------------
-- Modifications:
--
--	12/09/2010 JMJ: 
--	*	Change [message] column from nvarchar(255) to NVARCHAR(max) for entire app
--
------------------------------------------------------------------------------------
CREATE TABLE [dbo].[tsuFailures](
	[testResultID] [int] NOT NULL,
	[test] [nvarchar](255) NOT NULL,
	[message] [nvarchar](max) NOT NULL
) ON [PRIMARY]
GO
