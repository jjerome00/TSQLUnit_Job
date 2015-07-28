/*
[dbo].[ut_Tests_TestSuccess]

THIS IS AN EXAMPLE SCRIPT
Read more about testing options here:
http://www.sqlservercentral.com/articles/TSQLUnit/64357/


*/
create proc [dbo].[ut_Tests_TestSuccess]
as

set nocount on;

-------------------------------------------------------
-- Setup
-------------------------------------------------------
declare @item	varchar(25);


-------------------------------------------------------
-- Exercise the test
-------------------------------------------------------
set @item = 'HI08-19';


-------------------------------------------------------
-- Assert Expectations
-------------------------------------------------------

--THIS WILL FAIL!
if ( @item != 'HI08-19' )
begin
	exec dbo.tsu_Failure 'TestFailure failed (as expected).'
end
--else print 'success';

-------------------------------------------------------
--Teardown
-------------------------------------------------------
-- Implicity done via ROLLBACK TRAN in UT



