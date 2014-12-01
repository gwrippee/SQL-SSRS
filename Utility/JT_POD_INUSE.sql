USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_POD_INUSE]    Script Date: 11/19/2014 9:03:07 AM ******/
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
	SELECT iu.*
		,oh.ohotyp

	FROM ooinuse iu
	LEFT JOIN oohead oh ON (oh.ohco = iu.iuco
						AND oh.ohloc = iu.iuloc
						AND oh.ohord# = iu.iuord#
						AND oh.ohrel# = iu.iurel# )
	
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


