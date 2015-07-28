/*
job.job_RunTests
10/30/2008 JMJ

Runs the tsqlunit test scripts through a "job" interface.

Summary of tsqlunit framework:
-	The tsqlunit framework runs its tests via the tsu_runTests stored proc and
	creates a summary in the dbo.tsuLastTestResult
-	The framework adds records to dbo.tsuTestResults as a summary to any failures/errors
-	Details of failures/errors are in dbo.tsuFailures and dbo.tsuErrors, 
	they are linked to dbo.tsuTestResults by the "testResultID" field.

The reason for this stored proc:
-	No functionality exists to link a single running of tsu_runTests to the
	dbo.tsuFailures and dbo.tsuErrors tables.  They are both linked to the
	dbo.tsuTestResults, which can have multiple rows after the stored proc is run.
-	This procedure uses a couple new tables to "wrap" the tsu_runTests stored proc
	under a JobID.  It also allows the results to be sent in an email
 
Parameters:
-	@JobID (export only) - returns the Job ID created by running this procedure (will ignore any input)

Returns:
-	resultset of jobTest table for the newly created Job ID

Results:
job.jobTest - table with the overview of the job
job.jobTestResults - All test results linked to the job
dbo.tsuTestResults - All test results, organized by testResultID column
dbo.tsuFailures - All failed tests, linked by jobTestResults to tsuTestResults
dbo.tsuErrors - All errors, linked by jobTestResults to tsuTestResults

Modifications:
12/08/2010 JMJ:
-	Moved to the [job] schema
-	Moved creation of record in job.jobTest to BEFORE the actual test is run.  This allows other scripts
	to gain access to the jobid used for the run.  The initial insert is just nulls, and after the tests
	are run, this script just updates the job.jobTest table

*/
CREATE proc [job].[job_RunTests](
	@JobID int = 0 OUTPUT
)
as

----Test data
--declare @JobID int;

set nocount on;

declare @startTestID int;

-- Results of [tsu_runTests] are stored in the dbo.tsuLastTestResult table, copy them into 
-- the job.jobTest table.  This will create a new job id for the app.
insert into job.jobTest (suite, success, testCount, failureCount, errorCount, startTime, stopTime)
select null, null, null, null, null, null, null
;

-- get the new job id
set @JobID = scope_identity();

--find last testID from last job run
SELECT @startTestID=isnull(MAX(testResultID),-1) FROM dbo.tsuTestResults;

--run tests via normal sproc 
exec dbo.[tsu_runTests];

-- Results of [tsu_runTests] are stored in the 
-- dbo.tsuLastTestResult table, copy them into 
-- the dbo.jobTest table.  
update job.jobTest
set
suite = t.suite, 
success = t.success, 
testCount = t.testCount, 
failureCount = t.failureCount, 
errorCount = t.errorCount, 
startTime = t.startTime,
stopTime = t.stopTime
from dbo.tsuLastTestResult t
where jobid = @JobID
;

-- Add all the new results to the job.jobTestResults table 
-- (intersection table between JobID and testResultID).  
insert into job.jobTestResults (
	JobID, testResultID
)
select @JobID, testResultID
from dbo.tsuTestResults
where testResultID > @startTestID
;

select * from job.jobTest where jobid = @jobID;


