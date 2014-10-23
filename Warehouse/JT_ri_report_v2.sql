USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_ri_report_v2]    Script Date: 08/02/2013 08:51:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[JT_ri_report_v2] AS

/*==========================================*
** James Tuttle		Date: 7/13/2011			*
**											*
** Purpose: Hourly report for any orders    *
** that were created since the LastRan		*
** TimeStamp.								*
**===========================================*/ 
--
--James Tuttle		Date: 10/23/2014
-- 
--Added $ amount and reason code
---------------------------------------------

DECLARE @LastRan AS VARCHAR(20)		-- Timestamp from local table JT_JobLog_v2
DECLARE @Query AS VARCHAR(600)		-- Pass query to AS400

-- Get LastTime timestamp
SELECT @LastRan = dbo.JT_JobLog_v2.LastRan
FROM dbo.JT_JobLog_v2 --> Table to store job log of time report last ran
WHERE JT_JobLog_v2.JobName = 'JT_ri_report';



SELECT ohco		AS Company
      ,ohloc	AS Location
      ,ohotyp	AS Order_Type
      ,ohord#	AS [Order]
      ,ohodat	AS [Date]
      ,ohtime	AS [Time]
      ,ohuser	AS [User]
	  ,ohtotl	AS [Total_Amount]
	  ,ohcred	AS [Reason]
	  ,crrdes	AS [Description]
FROM OPENQUERY (GSFL2K, '
				SELECT *
				FROM OOHEAD oh
					LEFT JOIN crreason cr ON oh.ohcred = cr.crreas
				WHERE ohotyp IN(''IR'', ''RI'')
				ORDER BY ohodat DESC
				')
where CONVERT(VARCHAR(10), ohodat, 126) + ' ' +
		  case len(ohtime) 
				when 5 then '0' + substring(CONVERT(VARCHAR(7), ohtime),1,1) + ':' + substring(CONVERT(VARCHAR(7), ohtime),2,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),4,2)
				else substring(CONVERT(VARCHAR(7), ohtime),1,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),3,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),5,2) 
end > @LastRan

-- Update the table with current time for LastTime
UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan =  CONVERT(VARCHAR(10),GETDATE(),120) + ' ' +REPLACE(CONVERT(VARCHAR(8), GETDATE(), 8), ':', ':') 
WHERE dbo.JT_JobLog_v2.JobName = 'JT_ri_report'

--  
EXEC(@Query)


/* ---- TEST DATA ------------------------|

INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('JT_ri_report', '2011-07-13 11:00:00')

SELECT * FROM JT_JobLog_v2

DELETE FROM JT_JobLog_v2
WHERE JobName = 'JT_ri_report'

UPDATE dbo.JT_JobLog_v2
SET dbo.JT_JobLog_v2.LastRan = '2011-07-13 11:00:00'

------------------------------------------------------------------------------------------------------------------------------------------------   
--> used at the column level <------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
CONVERT(VARCHAR(10), ohodat, 126) + ' ' +
		  case len(ohtime) 
				when 5 then '0' + substring(CONVERT(VARCHAR(7), ohtime),1,1) + ':' + substring(CONVERT(VARCHAR(7), ohtime),2,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),4,2)
		else substring(CONVERT(VARCHAR(7), ohtime),1,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),3,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),5,2) 
	end
	*/

GO


