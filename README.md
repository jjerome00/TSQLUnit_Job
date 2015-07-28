# TSQLUnit_Job

Wrapper for [TSQLUnit](http://sourceforge.net/projects/tsqlunit/) that allows unit tests to be run as a database job (SQL Agent), with the results that can be sent as a html-formatted email.

This project is the result of a need to look for common issues in a legacy system that the client didn't have the resources to fix immediately.  Anytime I've mentioned it to colleagues they've expressed interest in seeing more, so I finally got around to providing some code.

The scripts are targeted at SQL Server 2005 or greater, but it could be modified to work with 2000 fairly easily.  It uses a few nvarchar(max) variables, a [job] schema, and some XML processing for the email procedure.


## Setup

1. Install [TSQLUnit](http://sourceforge.net/projects/tsqlunit/) (i.e. setup database)
2. Modify TSQLUnit (details below, or use scripts provided)
3. Create [job] database objects (be sure to create the job schema first!)
4. Create a SQL Agent job that calls **job.job_runTests** (see code below)

Note: the number of db objects is small enough that I just decided to provide one object per file in this repository.  There is no install script, you'll have to run each individually. (Sorry!)


## Usage

To run, call the stored procedure: **job.job_RunTests** 

	exec job.job_RunTests

This is the exact script I use in the SQL Agent job:

	DECLARE @jobid int, @success bit;
	
	EXEC job.job_RunTests 
		@jobid = @jobid OUTPUT;

	SELECT @success=success FROM job.jobtest WHERE jobid=@jobid;
	
	--send email with error list
	if (@success = 0)
		EXEC job.job_SendResultEmail @jobid=@jobid, @debug=0
	;

## Explanation

In TSQLUnit:

1. Tests are run via stored procedure: tsu_runTests
	- Summary of results stored in table: dbo.tsuLastTestResult
	- dbo.tsuTestRsults has a row for failures found, organized by *testResultID*
	- dbo.tsuFailures and dbo.tsuErrors have details of each failure, linked by *testResultID*


In tsqlunit_job:

1. Tests are run via stored procedure: job.job_RunTests
	- Wraps entire TSQLUnit process under a @jobID
	- Uses the resulting @jobID to send notifications


## TSQLUnit Modifications
I had to change the *[message]* that was passed around in the application from nvarchar(255) to nvarchar(max).  This required modifying a few objects in the tsqlunit database.  The changes are summarized below, or you can download the scripts in the folder.

Tables

- dbo.tsuActiveTest: column [message]
- dbo.tsuErrors: column [message]
- dbo.tsuFailures: column [message]

Stored Procedures

- dbo.tsu__private_addError: @errorMessage 
- dbo.tsu__private_addFailure: @errorMessage 
- dbo.tsu_error: @msg 
- dbo.tsu_failure: @message  
- dbo.tsu_runTestSuite: @message 


