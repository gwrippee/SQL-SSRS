SELECT C.Name, S.LastRunTime

FROM ReportServer..Subscriptions AS S
LEFT OUTER JOIN ReportServer..[Catalog] AS C
ON C.ItemID = S.Report_OID

left join ReportServer..reportschedule as Sched on Sched.subscriptionid = s.subscriptionid

WHERE s.ExtensionSettings like '%willc@tasupply.com%'

-- adriennel@tasupply.com