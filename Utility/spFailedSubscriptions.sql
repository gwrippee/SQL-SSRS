

ALTER PROC	spFailedSubscriptions AS 
BEGIN

SELECT C.Name, S.LastRunTime, S.LastStatus, S.Description, sched.scheduleid

	FROM ReportServer..Subscriptions AS S
	LEFT OUTER JOIN ReportServer..[Catalog] AS C ON C.ItemID = S.Report_OID

	left join ReportServer..reportschedule as Sched on Sched.subscriptionid = s.subscriptionid


	WHERE LEFT (S.LastStatus, 12) != 'Mail sent to'	-- Mail Sent to default
	AND LEFT (S.LastStatus, 12) != 'New Subscrip'	-- New subscription
	AND s.LastStatus not like '%SuppressEmail%'		-- SuppressEmail for subscriptions not to email if no records
	AND LEFT(S.LastStatus,12) NOT LIKE ''			-- After clearing a status it is blank
	AND LEFT(S.LastStatus,12) != 'Pending'			-- Pending for this report itself shows up
END
