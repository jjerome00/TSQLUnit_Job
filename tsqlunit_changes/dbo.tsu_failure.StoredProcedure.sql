SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[tsu_failure] 
	@message NVARCHAR(max)
-- GENERAL INFO:    This stored procedure is a part of the tsqlunit
--                  unit testing framework. It is open source software
--                  available at http://tsqlunit.sourceforge.net
--
-- DESCRIPTION:     This procedure should be called by a unit test when a
--                  test fails. 
-- PARAMETERS:      @message        A description of the failure
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
--	*	Changed @message parameter from nvarchar(255) to NVARCHAR(max)
--
------------------------------------------------------------------------------------
        
AS
BEGIN
	SET NOCOUNT ON
	UPDATE tsuActiveTest 	
		SET 
            isFailure=1, 
			isError=0,
			message=ISNULL(@message,'(no description)')
END
GO
