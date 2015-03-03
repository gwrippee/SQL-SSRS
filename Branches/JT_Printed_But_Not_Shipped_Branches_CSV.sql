USE [GartmanReport]
GO

-- James Tuttle		Date: 03/02/2015	SR# 18691
--
-- Branches version for Printed Will Calls not Shipped
-- 

ALTER PROC [dbo].[JT_Printed_But_Not_Shipped_Branches_CSV] 
	@CSV varchar(100)	-- CSV udf to take in multiple PARMS seperated by a comma (,)
	,@PTR varchar(5)	-- Printer PARM by location for the subscription
	AS
SELECT DISTINCT *
	FROM OPENQUERY (GSFL2K, 'SELECT cmname AS CustName
									,ohprco AS CO
									,ohprlo AS Loc
									,ohord# AS Order
									,ohrel# AS Release
									,MONTH(ohdtp) || ''/'' || DAY(ohdtp) || ''/'' || YEAR(ohdtp) AS Date_Printed
									,ohviac AS Via_Code
									,ohvia AS Via_Description
									,olinvu AS Status
									,ohprlo
									,ohprtr

							FROM oohead oh JOIN ooline ol ON (oh.ohco = ol.olco
								AND oh.ohloc = ol.olloc
								AND oh.ohord# = ol.olord#
								AND oh.ohrel# = ol.olrel#)
								Join custmast cm ON cm.cmcust = oh.ohcust

							WHERE ohdtp = CURRENT_DATE
								AND ohviac IN (''1'', ''6'')
								AND ohticp = ''Y''
							/*	AND ohprlo IN (12, 22, 69)	*/
								AND ohotyp NOT IN (''SA'', ''DP'')
								AND (olinvu = '' '' OR olinvu = ''S'' OR olinvu = ''X'' OR olinvu = ''M'') 
								
					')

		WHERE ohprlo IN (SELECT * FROM dbo.udfCSVToList(@CSV))
			AND ohprtr =  '' + @PTR + ''

ORDER BY co
		,loc
		,[Status] DESC

-- JT_Printed_But_Not_Shipped_Branches_CSV '3,43,61', 'YAKL1'

