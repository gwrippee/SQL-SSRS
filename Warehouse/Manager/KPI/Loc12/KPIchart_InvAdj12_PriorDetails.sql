


CREATE PROC [KPIchart_InvAdj12_PriorDetails] AS
SELECT *
	FROM InventoryAdjustmentsWH_KPI
	WHERE CONVERT(date,[Date]) BETWEEN '01/01/2013' AND '01/31/2013' 
		AND Loc IN (12,22,69)