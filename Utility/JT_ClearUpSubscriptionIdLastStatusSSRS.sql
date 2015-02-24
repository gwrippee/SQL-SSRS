
/*
------>>>>>> This is to UPDATE the Subscription ID to ' ' [Blank] for the LastStatus Field <<<<<<---------

UPDATE ReportServer..Subscriptions 
SET  LastStatus = ''
WHERE SubscriptionID = '4ED7CD0C-537D-4A46-8209-E9EF8F1B428A'

*/
----------------------------------------------------------------------------------------------------------
------->>>>>>>> Check current report status as in the SSRS <<<<<<<<<--------------------------------------

SELECT S.SubscriptionID, C.Name, S.LastRunTime, S.LastStatus, S.Description, sched.scheduleid
FROM ReportServer..Subscriptions AS S
LEFT OUTER JOIN ReportServer..[Catalog] AS C ON C.ItemID = S.Report_OID
left join ReportServer..reportschedule as Sched on Sched.subscriptionid = s.subscriptionid

WHERE LEFT (S.LastStatus, 12) != 'Mail sent to'
AND LEFT (S.LastStatus, 12) != 'New Subscrip'
and s.LastStatus not like '%SuppressEmail%'
AND LEFT(S.LastStatus,12) NOT LIKE ''	
----------------------------------------------------------------------------------------------------------

