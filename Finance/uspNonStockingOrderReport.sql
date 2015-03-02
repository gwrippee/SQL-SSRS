


/* Service Desk - Incident # 12174     */

CREATE PROC uspNonStockingOrderReport AS
BEGIN
	select *,CONVERT(datetime, CONVERT(VARCHAR(10), OHODAT)) as InvoiceDate
	from openquery(gsfl2k,'
	select  ohco,ohloc,ohord#,ohrel#,
	OHODAT,
	ohUSER,
	billto.cmcust,
	billto.cmname,
	imfmcd,
	fmdesc,
	dvdiv,
	dvdesc,
	olitem,
	imdesc,
	olECST+olESC1+olESC2+olESC3+olESC4+olESC5 as ExtendedCost,
	oleprc as ExtendedPrice

	from ooline
		
			left JOIN ooHEAD ON (ooLINE.olCO = oohead.ohCO 
										AND ooline.olLOC = oohead.ohLOC 
										AND ooline.olORD# = oohead.ohORD# 
										AND ooline.olREL# = oohead.ohREL#) 
									
			left JOIN CUSTMAST billto ON oohead.ohBIL# = billto.CMCUST 
			left join custmast soldto on oohead.ohcust = soldto.cmcust
			LEFT JOIN ITEMMAST ON ooline.olITEM = ITEMMAST.IMITEM 
			left join vendmast on olvend = vmvend
			LEFT JOIN PRODCODE ON ooline.olPRCD = PRODCODE.PCPRCD 
			LEFT JOIN FAMILY ON ooline.olFMCD = FAMILY.FMFMCD 
			LEFT JOIN CLASCODE ON ooline.olCLS# = CLASCODE.CCCLAS 
			LEFT JOIN DIVISION ON ooline.olDIV = DIVISION.DVDIV 
			left join salesman on ooline.olSLMN = salesman.smno
		
	where OHODAT >= current_date - 1 days
	and ITEMMAST.IMSI <> ''Y''
	and itemmast.IMFCRG <> ''S''
	and imfmcd <> ''IR''
	and billto.cmcust not like ''TRANSFER%'' 
	and dvdiv not in (9,13,6,5)
	and ohuser not in (''JOHNB'',
	''MONICAM'',
	''JOHNBP'',
	''BOBPRF'',
	''ROBERTP'',
	''TAMIM'',
	''JIMMYC'',
	''DAWNM'',
	''GWENB'',
	''GWENBP'',
	''STEPGP'',
	''STEPHENG'',
	''STEPHENGP'',
	''HOPER'',
	''KIMBERLYR'',
	''KIMR'',
	''K1RAM50'',
	''VICKIH'',
	''LANCEK'',
	''LANCEKTA'',
	''MICHELEG'',
	''MICHELEGP'',
	''M1GOL12'',
	''M1GOL22'',
	''KRISTIH'',
	''KRISTIHP'',
	''BRIDGETS'',
	''BRIDGETSP'',
	''B1SCH22'',
	''JOEF'',
	''JOEFRF'',
	''JOEF50'',
	''JENH'',
	''JENHRF'',
	''THELMAF'',
	''LATE'',
	''KELLIM'',
	''KELLIMT'',
	''PAMELAP'',
	''PAMP'',
	''SHANNONS'',
	''SHANNONST'',
	''S1SWE41'',
	''S1SWE50'',
	''JODIM'')

	')
END
