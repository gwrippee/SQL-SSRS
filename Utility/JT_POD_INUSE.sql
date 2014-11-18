USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_POD_INUSE]    Script Date: 11/13/2014 8:47:24 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- James Tuttle
-- 10/28/2014
--
-- Look for orders that are in POD CTDETL File
-- and in the Invoicing Batch

ALTER PROC [dbo].[JT_POD_INUSE] AS

BEGIN
SELECT * 
FROM OPENQUERY(GSFL2K,'
	SELECT *
	FROM ooinuse iu
	
	WHERE EXISTS

	( 
		SELECT * FROM ctdetl
		WHERE ctlco = iuco
			AND ctlloc = iuloc
			AND ctlord# = iuord#
			AND ctlrel# = iurel#
			AND iupgm != ''OE910''
	)

')
END	

GO


