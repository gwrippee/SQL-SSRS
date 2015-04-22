USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_inv_adjustments]    Script Date: 05/30/2013 09:50:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- ALTER PROC [dbo].[JT_inv_adjustments] AS

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
SELECT irloc 
	,irreason 

--	,CAST((irqty * ircost)AS DECIMAL(18,3)) 	

-- Select Adjustmenr reason codes
FROM OPENQUERY (GSFL2K, '
SELECT irloc
		,irreason
		,case
			when (im.IMMD = ''M'' and im.IMMD2 = '' '') 
				then (ir.irqty * im.IMFACT)
			when (im.IMMD = ''M'' and im.IMMD2 = ''D'') 
				then ((ir.irqty * im.IMFACT) / im.IMFAC2)
		else 0
	END AS Cost
	,im.immd
	,im.immd2
	,im.imfact
	,imfac2

FROM itemrech ir
LEFT JOIN itemmast im ON im.imitem = ir.iritem

WHERE irreason IN(''02'', ''25'', ''16'', ''38'', ''39'', ''PI'', ''52'',''04'',''PE'')
	AND irdate <= ''12/31/2014''
	AND irdate >= ''01/01/2014''



')

GROUP BY  irloc 
		,irreason  

ORDER BY irloc

-- END Query


GO


