USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spCOGSForecast]    Script Date: 09/03/2014 13:08:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* 


where SLSDAT >= CURDATE() - 90 days

sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as SOCOGS,

-- want COGS for last 3 complete months
*/

/******************************************************************************************
James Tuttle   02/09/2015    SR# 28614

Column ONE UNITS SOLD  
Column two BO QTY
Column Three UNITS Sold + BO Qty..?

 eason.   My present forecast sheet is based on sales and I convert to units.  
 Now that the sheet can “auto Populate”  makes sense to pull units rather than dollars.  
 (this will keep me from having errors on the forecast sheet with cost changes.
********************************************************************************************/

ALTER proc [dbo].[spCOGSForecastUnits] 

@StartDate as varchar(15), 
@EndDate as varchar(15) 

as

declare @sql as varchar(max)

set @sql = 'select OQ.*,

case 
	when (OQ.IMMD = ''M'' and OQ.IMMD2 = '' '') then (BOQty*OQ.IMFACT*imcost)
	when (OQ.IMMD = ''M'' and OQ.IMMD2 = ''D'') then (((BOQty*imcost)*OQ.IMFACT)/OQ.IMFAC2)
	else 0
end as BOValue

from openquery(gsfl2k,''
select i1.imvend,
i1.imfmcd,
i1.imitem,
i1.imdesc,
i1.imcolr,
i1.IMMD,
i1.IMMD2,
i1.imfact,
i1.imfac2,
i1.imcost,
sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as SOCOGS

,ifnull((select sum(PBOQTY)
		from poboline 
		join itemmast i3 on i3.imitem = pbitem
		where PBITEM = i1.imitem),0) as BOQty
		
,ifnull((select sum(sleprc)
		from shline sl 
		where sl.slitem = i1.imitem
		and year(SLDATE) = year(current_date)),0) as YTDSales

/*--------------------------------------------------------------------------------------------------*/
/* Get the last three months QTY																	*/
/*SELECT LAST_DAY(CURRENT_DATE - 1 MONTH) AS End_date, --> last months last day						*/
/*																									*/
/*LAST_DAY(CURRENT_DATE - 4 MONTH) + 1 DAY AS start_date --> three months back first day			*/
/*------------------------------------------------------------------------------------------------- */

,ifnull((select sum(slqord)
		from shline sl 
		where sl.slitem = i1.imitem
			and sldate >= LAST_DAY(CURRENT_DATE - 4 MONTH) + 1 DAY 
			and sldate <= LAST_DAY(CURRENT_DATE - 1 MONTH)
			),0) AS Month_3_back


from shline
LEFT JOIN ITEMMAST i1 ON SHLINE.SLITEM = i1.IMITEM 
		
where SLDATE >= ''''' + @StartDate + '''''
 and SLDATE <= ''''' + @EndDate + '''''
 and i1.IMCLAS in (''''IM'''',''''NL'''')
 and i1.IMFCRG <> ''''S''''
 and i1.imsi = ''''Y''''
 and i1.imfmcd not in (''''L2'''',''''W2'''')
 and i1.imdrop <> ''''D''''

  /* AND i1.imitem = ''''WPVISION503''''	*/

group by i1.imvend,
i1.imfmcd,
i1.imitem,
i1.imdesc,
i1.imcolr,
i1.IMMD,
i1.IMMD2,
i1.imfact,
i1.imfac2,
i1.imcost


'') OQ;


'

--select (@sql)
exec(@sql)


GO

-- spCOGSForecastUnits '11/01/2014', '01/31/2015'


