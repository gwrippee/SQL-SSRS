USE [msdb]
GO

/****** Object:  Job [CycleCountReport]    Script Date: 2/5/2015 3:04:54 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/5/2015 3:04:54 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'CycleCountReport', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Cycle Count Report for Colleen
collects the lines countes
exceptions
calculates accuracy
net dollars 
for a set of co/loc

James Tuttle
1/15/2013', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TASUPPLY\jamest', 
		@notify_email_operator_name=N'James', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Exceptions]    Script Date: 2/5/2015 3:04:54 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Exceptions', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
/* Count the ITEMRECH irsrc ''I'' transactions as an exception */

-- Insert data into DB table on Server from AS400
 INSERT CycleCountReport (co,loc,[date],Measurement,Value)

-- Query the daily data from the AS400
SELECT irco				AS Co
	,irloc				AS Loc
	,irdate				AS [Date]
	,''Exceptions''		AS Measurement
	,ExceptionCountColumn
	
FROM OPENQUERY(GSFL2K,''
 
SELECT irco
	,irloc 
	,irdate
	,COUNT(iritem) AS ExceptionCountColumn

FROM itemrech ir

WHERE ir.irsrc = ''''I''''
	  AND ir.irdate <= CURRENT_DATE  
and ir.irdate >= ''''01/01/2014''''
	

GROUP BY irco
	,irloc
	,irdate
'')
-- AND ir.irloc IN (4,44,64,50,52,41,57,60,42,59,80,81,84,85,12,22,69)
-- AND ir.irco IN (1,2,3)
-- AND ir.irbin NOT LIKE ''''SHW%''''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [LinesCounted]    Script Date: 2/5/2015 3:04:54 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'LinesCounted', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/* Count the OOLRFUSR olrtyp ''I'' transactions as lines counted */

-- Insert data into DB table on Server from AS400
INSERT dbo.CycleCountReport (co,loc,[date],Measurement,Value)

-- Query the daily data from the AS400
SELECT olrico			AS Co
		,olrilo			AS Loc
		,olrdat			AS [Date] 
		,''LinesCounted'' AS Measurement
		,LinesCountedColumn
		
FROM OPENQUERY(GSFL2K,''

SELECT olrico
	,olrilo
	,olrdat
	,COUNT(olritm) AS LinesCountedColumn

 FROM oolrfuser hst

 WHERE hst.olrtyp = ''''I''''
	  AND hst.olrcyrc != ''''Y''''
	  AND hst.olrdat <= CURRENT_DATE
and hst.olrdat >= ''''01/01/2014''''
	

GROUP BY olrico
		,olrilo	 
		,olrdat 
'')
	--  AND hst.olrico IN (1,2,3)
	--  AND hst.olrilo IN (4,44,64,50,52,41,57,60,42,59,80,81,84,85,12,22,69)', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Branch Lines Counted]    Script Date: 2/5/2015 3:04:54 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Branch Lines Counted', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---------------------------------------------------------------
--	James Tuttle	DAte: 01/14/2014
--
--	Query all lines counted by the branch locations
--	only - do not count the RF Locations
--
--	 PICOUNTHST
--




-- Insert data into DB table on Server from AS400
INSERT dbo.CycleCountReport (co,loc,[date],Measurement,Value)

-- Query the daily data from the AS400
SELECT pchco				AS Co
	,pchloc					AS Loc
	,pchdate				AS [Date]
	,''LinesCounted''			AS Measurement
	,LinesCountedColumn
	
FROM OPENQUERY(GSFL2K,''
 
SELECT pchco
	,pchloc 
	,pchdate
	,COUNT(pchitem) AS LinesCountedColumn

FROM PICOUNTHST pi

WHERE  pi.pchdate <= CURRENT_DATE  
and pi.pchdate >= ''''01/01/2014''''
		
		

	AND pchloc NOT IN (50,60,52,4,12,80,81,83,84,85,41,42,22,44,53,64,69,57,59,54)
	 
GROUP BY pchco
	,pchloc
	,pchdate
'')
', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Net]    Script Date: 2/5/2015 3:04:54 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Net', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------\/* Count the ITEMRECH irsrc ''I'' transactions for total Net $ */

-- Insert data into DB table on Server from AS400
INSERT CycleCountReport (co,loc,[date],Measurement,Value)

-- Query the daily data from the AS400
SELECT irco				AS Co
	,irloc				AS Loc
	,irdate				AS [Date]
	,''Net''				AS Measurement
	,NetColumn
	
FROM OPENQUERY(GSFL2K,''
 
SELECT irco
	,irloc 
	,irdate
	,CASE
		WHEN (im.immd = ''''M'''' AND im.immd2 = '''' '''')
			THEN CAST(SUM(( irqty * imfact) * imcost) as decimal (18,2)) 

		WHEN (im.immd = ''''M'''' AND im.immd2 = ''''D'''')
			THEN CAST(SUM((( irqty * imfact) / imfac2) * imcost ) as decimal(18,2))
		END AS NetColumn

FROM itemrech ir
LEFT JOIN itemmast im ON im.imitem = ir.iritem

WHERE ir.irsrc = ''''I''''
	  AND ir.irdate <= CURRENT_DATE
and ir.irdate >= ''''01/01/2014''''
	
	

GROUP BY irco
	,irloc
	,irdate
	,immd
	,immd2
	,imfact
	,imfac2
'')
-- 	  AND ir.irco IN (1,2,3)
--	  AND ir.irloc IN (4,44,64,50,52,41,57,60,42,59,80,81,84,85,12,22,69)
--	  AND ir.irbin NOT LIKE ''''SHW%''''', 
		@database_name=N'GartmanReport', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DailyRun', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130123, 
		@active_end_date=99991231, 
		@active_start_time=80000, 
		@active_end_time=235959, 
		@schedule_uid=N'9af57f1d-5b22-4497-af92-5a21ecf52cb6'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


