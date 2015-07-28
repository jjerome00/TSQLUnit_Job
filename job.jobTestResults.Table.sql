/*
PURPOSE: Links the testResultID and the JobTestResultID (intersection table)
*/
CREATE TABLE [job].[jobTestResults](
	[JobID] [int] NOT NULL,
	[testResultID] [int] NOT NULL,
	[JobTestResultID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [job].[jobTestResults]  WITH CHECK ADD  CONSTRAINT [FK_jobTestResults_jobTest] FOREIGN KEY([JobID])
REFERENCES [job].[jobTest] ([JobID])
ON DELETE CASCADE
GO
ALTER TABLE [job].[jobTestResults] CHECK CONSTRAINT [FK_jobTestResults_jobTest]
GO
