/*
[dbo].[ut_Tests_TestFailure]

THIS IS AN EXAMPLE SCRIPT
Read more about testing options here:
http://www.sqlservercentral.com/articles/TSQLUnit/64357/

*/
CREATE proc [dbo].[ut_Tests_TestFailure]
as

set nocount on;

-------------------------------------------------------
-- Setup
-------------------------------------------------------
declare @item	varchar(25);


-------------------------------------------------------
-- Exercise the test
-------------------------------------------------------
set @item = 'HI08-19 --- fail';


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



