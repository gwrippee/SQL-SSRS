USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_inv_adjustments]    Script Date: 4/22/2015 9:53:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER PROC [dbo].[JT_inv_adjustments] AS

/* -----------------------------------------------------*
** James Tuttle 5/10/2011		Created: 10/09/2008		*
** -----------------------------------------------------*
** 	Report is looking at adjustments by reason codes	*
**														*
**	Changed 4/29/13 to add 04 adjustment code per       *
**	request from Kathy Miller and Will Crites  SR 10331 *
**														*
**------------------------------------------------------*
*/
--SET STATISTICS TIME ON

-- Query
SELECT irloc 'Location',
	irreason 'Adj Code',
	irdate 'Date',
	iritem 'item',
	irdesc 'Description',
	irbin 'Bin',
	ircomt 'Comments',
	irqty 'QTY',
	ircost 'Cost',
	iruser 'User',
	CAST((irqty * ircost)AS DECIMAL(18,3)) 'Total Cost' 	
-- Select Adjustmenr reason codes
FROM OPENQUERY (GSFL2K, '
SELECT *
FROM itemrech
WHERE irreason IN(''02'', ''25'', ''16'', ''38'', ''39'', ''PI'', ''52'',''04'',''PE'')
	AND irdate = (CURRENT_DATE - 1 DAY)
')

ORDER BY irloc, irreason ASC ;

-- END Query



GO


