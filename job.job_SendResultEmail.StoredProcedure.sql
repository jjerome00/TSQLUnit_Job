/*
job_SendResultEmail
10/30/2008 JMJ

Send a summary email of the given job id to all recipients given

Modifications:
12/01/2008 JMJ - Added Server Name to email
03/02/2010 JMJ 
- Removed database name (tsqlunit) from query strings,
	it's not needed and keeps the database from being deployed under
	a different name

12/09/2010 JMJ
-	Incorporated new job.EmailList table to determine where to send emails for different failures
-	Added @debug parameter, if = 1, then it will output as a select stmt instead of sending email

*/
CREATE proc [job].[job_SendResultEmail](
	@jobID int,
	@debug int = 0
)
as

----test data
--declare @jobID int
--delcare @debug int
--set @jobID = 5;
--set @debug = 1;

declare @default_email varchar(1000);
set @default_email = 'nothing@example.com'; --used only if not set in job.EmailList table


declare @email_query nvarchar(max);
declare @tableHTML nvarchar(max);
declare @tableHTML2 nvarchar(max);
declare @email varchar(max);

SET @tableHTML =
    N'<H1>SQL Unit Test Report</H1>' +
    N'<table border="1" cellpadding="2" cellspacing="0">' +
	N'<tr>' +
	N'<th>Server</th><th>Job ID</th><th>Suite</th>' +
    N'<th>Success</th><th>Test Count</th><th>Failure Count</th>' +
	N'<th>Error Count</th><th>Start Time</th><th>End Time</th>' +
	N'</tr>' +
    CAST ( ( SELECT td = @@servername, '',
                    td = jobID, '',
					td = suite, '',
                    td = success, '',
                    td = testCount, '',
                    td = failureCount, '',
                    td = errorcount, '',
                    td = CONVERT(varchar,starttime,113), '',
                    td = CONVERT(varchar,stoptime,113), ''
              FROM job.jobTest 
              WHERE jobid = @jobID
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;

-------------------------------------------------------------------------
-- Not quite ready for this functionality yet
-- Want to gather each user and determine which failures are associated
-------------------------------------------------------------------------
/*
----
-- Send emails to specific people if they exist in the job.emaillist table
----

-- Store the tests that have an email associated with them in a local table
declare @email_list table (
	[test] varchar(255),
	[name] varchar(100),
	[email] varchar(1000),
	[notes] varchar(max)
)
;

-- results of unittest, link [test] from tsufailures to job.emaillist
insert into @email_list
SELECT tf.[Test], em.name, em.email, em.notes
FROM dbo.tsufailures tf 

	inner join job.jobTestResults jTR on
		jtr.testresultid = tf.testresultid

	inner join job.emaillist em on
		em.inactive = 0
		and tf.test = em.test	
		
WHERE jTR.jobid = @jobID
;

-- For each test that has a specific user, email that person with their test results
declare @test_name varchar(255);
declare @name varchar(100);

while exists (select top 1 * from @email_list)
begin
	--load 1st row from loop
	select top 1 @test_name=[test], @name=[name], @email=[email] from @email_list;

	-- Format message from those failures associated with the user/test
	SET @tableHTML2 =
		N'<H1>Results for: ' + @name + '</H1>' +
		N'<table border="1" cellpadding="2" cellspacing="0">' +
		N'<tr><th>Test Name</th><th>Message</th></tr>' +
		CAST ( ( SELECT td = [Test],       '',
						td = [Message], ''
				  FROM dbo.tsufailures TF 
					inner join job.jobTestResults jTR on
						jtr.testresultid = tf.testresultid
				  WHERE 
						jTR.jobid = @jobID
						and tf.test = @test_name
				  FOR XML PATH('tr'), TYPE 
		) AS NVARCHAR(MAX) ) +
		N'</table>' 
	;

	-- build entire email html message for user
	set @email_query = @tableHTML + '<br><br>' +@tableHTML2;

	-- Cleanup any last minute html tags
	set @email_query =  REPLACE(@email_query, N'&lt;', N'<');
	set @email_query =  REPLACE(@email_query, N'&gt;', N'>');	

	-- send email (or select for debuggin)
	if (@debug = 1)
		select @email_query;
	else
	begin
		exec msdb.dbo.sp_send_dbmail
			@recipients = @email,
			@subject = 'SQL Unit Test Notification',
			@body_format = 'HTML',
			@body = @email_query
		;
	end	

	--remove current row from loop
	delete @email_list where [test] = @test_name and [name] = @name and [email] = @email;
end
*/

-- Setup Admin email (i.e. send ALL results to admin)

select @email=isnull(email, @default_email) 
from job.emaillist 
where [test] = '[ADMIN]' and inactive = 0
;

SET @tableHTML2 =
    N'<H1>Results for ADMIN:</H1>' +
    N'<table border="1" cellpadding="2" cellspacing="0">' +
    N'<tr><th>Test Name</th><th>Message</th></tr>' +
    CAST ( ( SELECT td = [Test],       '',
                    td = [Message], ''
              FROM dbo.tsufailures TF 
				inner join job.jobTestResults jTR on
					jtr.testresultid = tf.testresultid
              WHERE jTR.jobid = @jobID
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' 
	;

set @email_query = @tableHTML + '<br><br>' +@tableHTML2;

--select @email_query
--Cleanup any last minute html tags
set @email_query =  REPLACE(@email_query, N'&lt;', N'<');
set @email_query =  REPLACE(@email_query, N'&gt;', N'>');


declare @subject nvarchar(100);
set @subject = 'SQL Unit Test Notification (' + convert(nvarchar(12), getdate()) + ')';

if (@debug = 1)
	select @email_query;
else
begin
	exec msdb.dbo.sp_send_dbmail
		@recipients = @email,
		@subject = @subject, --'SQL Unit Test Notification',
		@body_format = 'HTML',
		@body = @email_query
	;
end


