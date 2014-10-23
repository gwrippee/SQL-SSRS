USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[spCustomerSalesReview]    Script Date: 10/8/2014 12:22:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* 

Created By:  Thomas Van Nuys
Date Created: 

SR #25144


spCustomerSalesReview '1001786'
*/

ALTER proc [dbo].[spCustomerSalesReview] 
@BillToID varchar(10)
as

declare @sql as varchar(max)

set @sql = 'select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,''
select  shco,shloc,shord#,shrel#
shinv#,
shidat,
sldate,
soldto.cmcust as SoldToCustID,
soldto.cmname as SoldToCust,
substring(soldto.CMADR3,0,24) AS SoldToCity,
billto.cmcust as BillToCustID,
billto.cmname as BillToCust,
substring(billto.CMADR3,0,24) AS BillToCity,

imfmcd as FamilyCode,
fmdesc as Family,
dvdiv as DivisionCode,
dvdesc as Division,

case
	when dvdiv in (6,7,8,9,10,13,41) then ''''INSTALLATION ITEMS''''
	else dvdesc
end as ReportDivision,

pcname as ProductCode,
slitem,
imdesc,
SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 as ExtendedCost,
sleprc as ExtendedPrice

from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		left join custmast soldto on shhead.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		left join vendmast on slvend = vmvend
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
		LEFT JOIN CLASCODE ON SHLINE.SLCLS# = CLASCODE.CCCLAS 
		LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
		left join salesman on shline.SLSLMN = salesman.smno
		
where (
		(year(shline.sldate) = year(current_date - 1 month) or year(shline.sldate) = year(current_date - 1 month)-1)
				 and month(shline.sldate) <= month(current_date - 1 month))  /* last full month this year and last year */

and billto.cmcust in (''''' + @BillToID + ''''')


'')
'

exec(@sql)


GO


