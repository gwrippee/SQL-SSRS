USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_Printed_But_Not_Shipped_Loc50]    Script Date: 10/21/2014 10:46:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*------------------------------------------------------*
** James Tuttle											*	
** Date: 11/3/2011										*
**														*
** report for loc50 on orders printed and not all		*
** lines are shipped									*
**														*
** ADDED: Ship VIA Code 6								*
**------------------------------------------------------*/



ALTER PROC [dbo].[JT_Printed_But_Not_Shipped_Loc50] AS


/* Query to look at orders printed but not shipped for Will Call */

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
							FROM oohead oh JOIN ooline ol ON (oh.ohco = ol.olco
								AND oh.ohloc = ol.olloc
								AND oh.ohord# = ol.olord#
								AND oh.ohrel# = ol.olrel#)
								Join custmast cm ON cm.cmcust = oh.ohcust
							WHERE ohdtp = CURRENT_DATE
								AND ohviac IN (''1'', ''6'')
								AND ohticp = ''Y''
								AND ohprlo = 50
								AND ohotyp NOT IN (''SA'', ''DP'',''MM'')
								AND (olinvu = '' '' OR olinvu = ''S'' OR olinvu = ''X'' OR olinvu = ''M'' OR olinvu != ''T'') 
						/*	 	AND ohprtr IN (''KCL1'',''KCL2'')  /* --- added printer IDs fo Will Call to ONLY look at those print jobs --- */	*/
					')
ORDER BY [Status] DESC

-- JT_Printed_But_Not_Shipped_Loc50


GO


