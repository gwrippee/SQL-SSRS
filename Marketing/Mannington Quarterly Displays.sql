



CREATE PROC Mannington_Quarterly_Displays
		 @BeginDate varchar(10)
		,@EndDate varchar(10) 
AS

-- Beginning day of QTR
SET @BeginDate = CONVERT(VARCHAR(10),DATEADD(m,-3, Dateadd(d,1-DATEPART(d,getdate()),GETDATE())), 101)
-- Last day of the QTR
SET @EndDate = CONVERT(varchar(10), dateadd(mm,-1,DATEADD(dd,-DAY(getdate()),DATEADD(mm,1,getdate()))), 101)


BEGIN
DECLARE @sql varchar(MAX)
SET @sql = '

	select * from openquery(gsfl2k,'' 
	SELECT  
	 SHIDAT as Date, 
	 VNCVCUST AS MMIRTLNum, 
	 BillTo.CMNAME AS RetailerName, 
	 shline.slinv# as InvoiceNumber, 
	 shline.slitem as Product, 
	  slrecnbr as ReceiptNum, 
	 (select max(IRINV#) from itemrech RH where RH.IRRECNBR = slrecnbr and rh.IRITEM = slitem and IRSRC = ''''P'''') 
	 as ManningtonInvoice,
	 SHLINE.SLDESC as DisplayProvided, 
	 SHLINE.SLBLUS as BillableUnitsShipped,  
	 SHLINE.SLECST as LandedCost, 
	 itemmast.imrcst as NetCost, 
	 ''''50%'''' as PercentageOfDistSupport, 
	 itemmast.imrcst * .5 as AmountAllocatedToDiscretionaryFund, 
	 IMCOMMRES as CommResFlag 
 

	FROM SHLINE  
	INNER JOIN CUSTMAST ON SHLINE.SLCUST = CUSTMAST.CMCUST  
	INNER JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO  
							AND SHLINE.SLLOC = SHHEAD.SHLOC  
							AND SHLINE.SLORD# = SHHEAD.SHORD#  
							AND SHLINE.SLREL# = SHHEAD.SHREL#  
							AND SHLINE.SLINV# = SHHEAD.SHINV#) 
	LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
	left join ITEMXTRA on ITEMMAST.IMITEM = ITEMXTRA.IMXITM  
	left JOIN CUSTMAST BillTo ON SHHEAD.SHBIL# = BillTo.CMCUST 
	left join vendcust on (billto.cmcust=VNCCUST and vncvend = ''''10131'''')

	WHERE SHHEAD.SHIDAT between ' + '''' + '''' + @BeginDate + '''' + '''' + '
	 and ' + '''' + '''' + @EndDate + '''' + '''' + ' 

	AND shhead.shotyp = ''''DP'''' 
	and itemmast.imvend in (''''10131'''', ''''10133'''')  
	and IMCOMMRES <> ''''C'''' 

	'') 
	'