USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_inv_adjustments_PE]    Script Date: 4/22/2015 11:21:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER PROC [dbo].[JT_inv_adjustments_PE] AS

/* -----------------------------------------------------*
** James Tuttle 04/22/2015								*
** -----------------------------------------------------*
** PR (Purchasing Errors for Steve U and Denise C		*
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
WHERE irreason =''PE''
	AND irdate = (CURRENT_DATE - 1 DAY)
')

ORDER BY irloc, irreason ASC ;

-- END Query



GO


