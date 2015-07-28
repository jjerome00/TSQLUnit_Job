SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[tsu__private_addFailure] @test NVARCHAR(255), @errorMessage NVARCHAR(max)
-- GENERAL INFO:    This stored procedure is a part of the tsqlunit
--                  unit testing framework. It is open source software
--                  available at http://tsqlunit.sourceforge.net
--
-- DESCRIPTION:     This procedure makes an internal notice when a failure has occurred. 
-- PARAMETERS:      @test               The name of the test
--                  @errorMessage       A description of the failure
--
-- RETURNS:         Nothing
-- 
-- VERSION:         tsqlunit-0.91
-- COPYRIGHT:
--    Copyright (C) 2002-2009  Henrik Ekelund 
--    Email: <http://sourceforge.net/sendmessage.php?touser=618411>
--
--    This library is free software; you can redistribute it and/or
--    modify it under the terms of the GNU Lesser General Public
--    License as published by the Free Software Foundation; either
--    version 2.1 of the License, or (at your option) any later version.
--
--    This library is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--    Lesser General Public License for more details.
--
--    You should have received a copy of the GNU Lesser General Public
--    License along with this library; if not, write to the Free Software
--    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

------------------------------------------------------------------------------------
-- Modifications:
--
--	12/09/2010 JMJ: 
--	*	Change failure message variable from nvarchar(255) to NVARCHAR(max) for entire app
--	*	Changed @errorMessage parameter from nvarchar(255) to NVARCHAR(max)
--
------------------------------------------------------------------------------------

AS
SET NOCOUNT ON
DECLARE @id INTEGER
SET @id=(SELECT MAX(testResultID) FROM tsuTestResults)

INSERT INTO tsuFailures( test, message, testResultID) VALUES(@test, @errorMessage, @id)
GO
