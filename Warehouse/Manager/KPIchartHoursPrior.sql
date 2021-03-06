
ALTER PROC KPIchartHoursPrior AS 
--
--
-- When looking at the details most warehouser user will com up
-- with the WCC user ID. That is because the Query in the Job Schedular
-- for "WarehouseProductivity_V2" Step "Load Hours into Metric Table"
-- uses MAX(RFUser), so W ends up being the MAX Character in the query.
--
BEGIN
/*-----------
SELECT  SUM(CAST(Value  AS decimal)) AS TotalHours
    
  FROM [GartmanReport].[dbo].[WarehouseProductivity]
  WHERE Metric LIKE 'Hour%'
	AND Location IS NOT NULL
	AND (RFUser LIKE '[WC]%'
		OR RFUser LIKE	'[_1]%'
		OR RFUser LIKE '[_2]%')
	AND Location = 50 
	AND CONVERT(varchar(10),RFDate) BETWEEN '01/01/2014' AND '01/31/2014'


---------------------------------------------------------------------------------------*/
--
-- DETAILS
--

SELECT  
[Company]
      ,[Location]
      ,[RFDate]
      ,[Dept]
      ,[RFUser]
      ,[Metric]
	  ,[Value]
      --,[Daily]
    -- , ROUND(SUM(CONVERT(float,[Value])),2) AS TotalTime
  FROM [GartmanReport].[dbo].[WarehouseProductivity]
  WHERE Metric LIKE 'Hour%'
	AND Location IS NOT NULL
	AND (RFUser LIKE '[WC]%'
		OR RFUser LIKE	'_1%'
		OR RFUser LIKE '_2%')
	AND Location = 50 
	AND CONVERT(date,RFDate) BETWEEN '01/01/2013' AND '01/31/2013'

--GROUP BY  [Company]
--      ,[Location]
--      ,[RFDate]
--      ,[Dept]
--      ,[RFUser]
--      ,[Metric]
--      ,[Daily]
	-------------------------------------------------------------------------*/
	END
	

/*------------------------
	SELECT  [Company]
      ,[Location]
      ,[RFDate]
      ,[Dept]
      ,[RFUser]
      ,[Metric]
      ,[Daily]
	  ,[Value]
  FROM [GartmanReport].[dbo].[WarehouseProductivity]
  WHERE Metric LIKE 'Hour%'
	AND Location IS NOT NULL
	AND Location = 50 
	AND (RFUser LIKE '_1%'
		OR RFUser LIKE 'WC%'
		OR RFUser LIKE '_2%')
	
	ORDER BY RFDate
		, RFUser
	----------------------------------------------------------*/

