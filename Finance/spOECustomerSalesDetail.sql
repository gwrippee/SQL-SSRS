


ALTER PROC spOECustomerSalesDetail AS
BEGIN 
	select shco as Company,
	shloc as Loc,
	vmname as VendorName,
	dvdesc as DivisionDesc,
	fmdesc as FamilyCodeDesc,
	pcdesc as ProductCodeDesc ,
	BillToAcct as BillToCustID,
	BillToCustName as BillToCustName, 
	BillTocity as BillTocity,
	BillToState as BillToState,
	ShipToCustName as ShipToCustName,
	ShipToCity as ShipToCity,
	ShipToState as ShipToState,
	smname as SalesName,
	InvoiceMonth as [Month],
	InvoiceYear as [Year],   
	Sales as [Sales], 
	Profit as Profit

	from openquery(gsfl2k,'
	select shco,
	shloc,
	vmname,
	dvdesc,
	fmdesc,
	pcdesc,
	billto.cmcust as BillToAcct,
	billto.CMNAME as BillToCustName, 
	left(billto.CMADR3,23) as BillTocity,
	right(billto.CMADR3,2) as BillToState,
	SHSTNM as ShipToCustName,
	left(SHSTA3,23) as ShipToCity,
	right(SHSTA3,2) as ShipToState,
	smname,
	month(shidat) as InvoiceMonth,
	year(shidat) as InvoiceYear,   

	sum(sleprc) as Sales, 
	sum(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) as Profit

	from shline
		
			left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
										AND SHLINE.SLLOC = SHHEAD.SHLOC 
										AND SHLINE.SLORD# = SHHEAD.SHORD# 
										AND SHLINE.SLREL# = SHHEAD.SHREL# 
										AND SHLINE.SLINV# = SHHEAD.SHINV#) 
			left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST
			LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
			LEFT JOIN DIVISION ON SHLINE.SLDIV = DIVISION.DVDIV 
			LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
			left join vendmast on slvend = vmvend
			LEFT JOIN FAMILY ON SHLINE.SLFMCD = FAMILY.FMFMCD 
			left join salesman on shline.SLSLMN = salesman.smno

	where SHCO = 1
	and YEAR(shidat) >= YEAR(current_date) 

	group by  shco,
	shloc,
	vmname,
	dvdesc,
	fmdesc,
	pcdesc,
	billto.cmcust,
	billto.CMNAME, 
	left(billto.CMADR3,23),
	right(billto.CMADR3,2),
	SHSTNM,
	left(SHSTA3,23),
	right(SHSTA3,2),
	smname,
	month(shidat),
	year(shidat) 

	')
END
