
DECLARE @LastRan AS VARCHAR(20)		-- Timestamp from local table JT_JobLog_v2
DECLARE @Query AS VARCHAR(600)		-- Pass query to AS400

-- Get LastTime timestamp
SELECT @LastRan = JAMEST.dbo.JT_JobLog_v2.LastRan
FROM JAMEST.dbo.JT_JobLog_v2 --> Table to store job log of time report last ran
WHERE JT_JobLog_v2.JobName = 'JT_ri_report';

-- Create the conversion in time stamp as 
-- a Common Table Expression
WITH cte AS 
(
	SELECT ohco,
		  ohloc,
		  ohotyp,
		  ohord#,
		  ohodat,
		  ohtime,
		  ohuser, 
		  CONVERT(VARCHAR(10), ohodat, 126) as [Date],
		  testtime = case len(ohtime) 
				when 5 then '0' + substring(CONVERT(VARCHAR(7), ohtime),1,1) + ':' + substring(CONVERT(VARCHAR(7), ohtime),2,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),4,2)
				else substring(CONVERT(VARCHAR(7), ohtime),1,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),3,2) + ':' + substring(CONVERT(VARCHAR(7), ohtime),5,2) 
		  end
	FROM OPENQUERY (GSFL2K, '
	SELECT *
	FROM OOHEAD
	WHERE ohotyp IN(''IR'', ''RI'')
	ORDER BY ohodat DESC
')
)
--##############################################
select ohco as Company,
	ohloc as Location,
	ohotyp as Order_Type,
	ohord# as [order],
	ohuser as [user], 
	[DATE] + ' ' + testtime as Time_Stamp
FROM cte
WHERE testtime >= ' + @LastRan + '
--##############################################



-- Update the table with current time for LastTime
UPDATE JAMEST.dbo.JT_JobLog_v2
SET JAMEST.dbo.JT_JobLog_v2.LastRan =  CONVERT(VARCHAR(10),GETDATE(),120) + ' ' +REPLACE(CONVERT(VARCHAR(8), GETDATE(), 8), ':', ':') 
WHERE JAMEST.dbo.JT_JobLog_v2.JobName = 'JT_ri_report'

--   

-- SELECT * FROM JT_JobLog_v2

EXEC(@Query)


/* ---- TEST DATA ------------------------|
INSERT INTO JT_JobLog_v2 (JobName, LastRan)
VALUES ('JT_ri_report', '2011-07-12 07:25:22')
SELECT * FROM JT_JobLog_v2
DELETE FROM JT_JobLog
*/

