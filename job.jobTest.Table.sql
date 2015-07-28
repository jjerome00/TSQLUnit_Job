/*
PURPOSE: List of test and some statistics
*/
CREATE TABLE [job].[jobTest](
	[JobID] [int] IDENTITY(1,1) NOT NULL,
	[suite] [nvarchar](255) NULL,
	[success] [bit] NULL,
	[testCount] [int] NULL,
	[failureCount] [int] NULL,
	[errorCount] [int] NULL,
	[startTime] [datetime] NULL,
	[stopTime] [datetime] NULL,
 CONSTRAINT [PK_jobTest] PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
