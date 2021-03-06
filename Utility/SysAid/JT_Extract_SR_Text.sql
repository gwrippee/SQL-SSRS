/****** Script for SelectTopNRows command from SSMS  ******/

CREATE PROC JT_Extract_SR_Text AS
BEGIN
	SELECT  [id]			AS SR_Num
		  ,[title]			AS Subject
		  ,[description]	AS Text1
		  ,[description]	AS Text2
		  ,[notes]			AS Added_Notes
		  ,[resolution]		AS Resolution

	   /*   ,SUBSTRING( (SELECT', ' + D1 + ', ' + D2 FROM  [sysaid].[dbo].[service_req] sr2 WHERE sr2.id = sr1.id	FOR XML PATH ('')),2,999) AS Comments */

	  FROM [sysaid].[dbo].[service_req] sr1

	  WHERE [project_id] = 64
		AND [responsibility] = 'jamest'
END
