/*
job.RunAllTests
12/13/2010 JMJ

Description:
-	Run all unit tests in system through the [job] wrapper.
	The logic in this stored proc could be run as a SQL Server Agent job,
	or you can just call this procedure directly from an Agent job.

Modifications:
-	n/a

*/
CREATE proc [job].[RunAllTests]
as

declare @jobid int; 
declare @success bit;

-- Run all tests, @jobid will be returned
exec job.job_RunTests @jobid=@jobid output;

-- Double-check job.jobtest table to see if job was successful
select @success = success from job.jobtest where jobid = @jobid;

-- only send email if job wasn't a success (i.e. send email with list of unit test failures)
if (@success = 0)
begin
	--send email with error list
	exec job.job_SendResultEmail
		@jobid=@jobid, 
		@debug=0
	;
end


