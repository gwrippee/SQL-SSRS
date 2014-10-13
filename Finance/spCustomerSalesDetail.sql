
-- insert CustomerSalesDetail

--drop table CustomerSalesDetail

/* --- ======================================================== --- */
/* --- James Tuttle  Date: 10/13/2014							--- */
/* --- ======================================================== --- */
/* --- Changed to a Pass Through Query for the Excel			--- */
/* --- Datasource.												--- */
/* ---  I will point the current datasource spreadsheets		--- */
/* --- for Will C and Deborah H as a Stored Procedure			--- */
/* --- being called from their datasource on their spreadsheet. --- */
/* ---															--- */
/* --- This code is from the SQL Agent Job "Sales Detail"		--- */
/* --- which feed the original table "CustomerSalesDetail"      --- */
/* --- before it all was stopped and dome deleted back in		--- */
/* --- September of 2014 on SR# 25042- James Tuttle				--- */
/* --- ======================================================== --- */

ALTER PROC spCusotmerSalesDetail AS
BEGIN
	select InvoiceNbr, 
	CONVERT(varchar(10),convert(datetime,shidat),101) AS InvoiceDate, 
	CreditMemo, 
	CustPO, 
	Company, 
	Loc, 
	OrderNbr, 
	SalesID,
	SalesName,
	BillToCustID,
	BillToCustName, 
	BillToCity,
	BillToState,
	SoldToCustID,
	SoldToCustName,
	SoldToCity,
	SoldToState,

	ShipToCustName,
	ShipToCity,
	ShipToState,
	ShipToZip,

	ItemNum, 
	ItemDesc, 
	VendorNum, 
	VendorName,
	ProductCode, 
	ProductCodeDesc, 
	FamilyCode, 
	FamilyCodeDesc, 
	ClassCode, 
	ClassCodeDesc, 
	Division, 
	DivisionDesc, 
	ExtendedPrice, 
	ExtendedCost,
	Profit

	--into CustomerSalesDetail

			from openquery(gsfl2k,'

			SELECT SHLINE.SLINV# AS InvoiceNbr, 
			SHIDAT, 
			SHHEAD.SHCM AS CreditMemo, 
			SHHEAD.SHPO# AS CustPO, 
			SHLINE.SLCO AS Company, 
			SHLINE.SLLOC AS Loc, 
			SHLINE.SLORD# AS OrderNbr, 
			salesman.smno as SalesID,
			salesman.smname as SalesName,
			billto.CMCust AS BillToCustID, 
			billto.CMNAME AS BillToCustName, 
			Left(billto.CMADR3,23) AS BillToCity,
			Right(billto.CMADR3,2) AS BillToState,
			Soldto.cmname as SoldToCustName,
			Soldto.CMcust AS SoldToCustID, 
			Left(Soldto.CMADR3,23) AS SoldToCity,
			Right(Soldto.CMADR3,2) AS SoldToState,

			SHSTNM as ShipToCustName,
			Left(SHSTA3,23) AS ShipToCity,
			Right(SHSTA3,2) AS ShipToState,
			SHZIP as ShipToZip,
		
 			SHLINE.SLITEM AS ItemNum, 
			SHLINE.SLDESC AS ItemDesc, 
			SHLINE.SLVEND AS VendorNum, 
			vmname as VendorName,
			SHLINE.SLPRCD AS ProductCode, 
			PRODCODE.PCDESC AS ProductCodeDesc, 
			SHLINE.SLFMCD AS FamilyCode, 
			FAMILY.FMDESC AS FamilyCodeDesc, 
			SHLINE.SLCLS# AS ClassCode, 
			CLASCODE.CCDESC AS ClassCodeDesc, 
			SHLINE.SLDIV AS Division, 
			DIVISION.DVDESC AS DivisionDesc, 
			SLEPRC AS ExtendedPrice, 
			SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 as ExtendedCost,
			sleprc-(SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5) AS Profit,
			case
				when sleprc <> 0 then (sleprc-SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5)/sleprc 
				else 0
			end as ProfitPerc

			FROM SHLINE 
		
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

			WHERE vmvend <> 40000
		/* ----	AND SHHEAD.SHIDAT >= ''01/01/2011''	----	Changed to a dynamic two year for Will C -------*/
		/* ----	And SHHEAD.SHIDAT < current_date --- */
			AND YEAR(shidat) >= YEAR(CURRENT_DATE) - 2 /* ----- Go back two years	---- */
			')
END




