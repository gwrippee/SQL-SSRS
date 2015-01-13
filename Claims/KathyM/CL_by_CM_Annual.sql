---------------------------------------------
-- Kathy Miller 2014 Claim data dumps
--
-- James Tuttle 01/12/2015
---------------------------------------------
-- Purpose: All of "CL" Credits by CM# Annual
---------------------------------------------
SELECT *
FROM OPENQUERY(GSFL2K,'
	SELECT shco								AS Co
		   ,shloc							AS Loc
		   ,shord#							AS Order
		   ,shinv#							AS Invoice
		   ,shuser							AS Author
		   ,MONTH(shodat) || ''/'' ||
				DAY(shodat) || ''/'' ||
				YEAR(shodat)				AS Create_Date			 			
		   ,shemds							AS Sell
		   ,shcost							AS Cost
		   ,shspc1							AS Delv_Charge
		   ,shspc2							AS Restock
		   ,shspc3							AS Discount
		   ,shspc4							AS Frt_Handlng
		   ,shspc5							AS Fuel_Surchg				
		   ,shref#							AS Orig_Inv	
		   ,shcust							AS Customer
		   ,cmname							AS Name

		    
	FROM shhead sh
	LEFT JOIN custmast cm ON cm.cmcust = sh.shcust

	WHERE shpeyr = ''2014''
		AND sh.shotyp = ''CL''

	ORDER BY shco
			,shloc
			,shord#
')
