/*
job_ClearJobHistory
10/30/2008 JMJ

Clear all the job and test results history
*/
CREATE proc [job].[job_ClearJobHistory]
as

delete job.jobtest; --will also clear out jobTestResults
truncate table dbo.tsuTestResults;
truncate table dbo.tsuFailures;
truncate table dbo.tsuErrors;
truncate table dbo.tsuLastTestResult;
truncate table job.JobTestFailures;


