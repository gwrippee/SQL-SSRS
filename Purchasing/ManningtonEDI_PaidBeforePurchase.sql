USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[ManningtonEDI_PaidBeforePurchase]    Script Date: 3/3/2015 9:51:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************
**																				**
** SR# XXXXX																	**
** Programmer: Thomas Van Nuys													**
** ---------------------------------------------------------------------------- **
** Purpose:																		**
**	==========================================================================	**
**	SR#16085	Date: 11/22/2013		James Tuttle							**
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC [dbo].[ManningtonEDI_PaidBeforePurchase] AS
BEGIN
 SELECT OQ.*,MT.MTSTATUS
 FROM OPENQUERY(GSFL2K,'

	Select PHDELT
			,PHDOI AS IssueDate
			,Poline.PLDDAT AS DueDate
			,Poline.PLCO AS Company
			,Poline.PLLOC AS Location
			,Poline.plpo# AS PONum
			,PHREF# AS RefNum
			,Family.FMDESC AS Family 
			,Vendmast.VMNAME AS VendorName
			,Poline.PLITEM AS SKU
			,Poline.PLDESC AS Description
			,Itemmast.IMCOLR AS Color 
			,Poline.PLQORD AS UnitsOrdered
			,pdtype
		/*	,Itemfact.IFFACA AS UnitsPerPallet				*/
		/*	,Itemfact.IFUMC									*/
		/*	,Poline.PLQORD/Itemfact.IFFACA AS TotalPallets	*/
			,(SELECT MAX(mnman#) FROM manifest WHERE mnpo# = poline.plpo#
									AND mnpolo = poline.plloc
									AND mnitem = poline.plitem
									AND mnpoco = poline.plco) AS Manifest,
			(SELECT SUM(ibqoh) FROM itembal WHERE ibitem = itemmast.imitem) AS OnHand
			,irdate AS RecvDate
		/*	,irinv# AS APinvoice							*/
			,pdinv#

	FROM Poline

	LEFT JOIN Itemmast ON Itemmast.IMITEM = Poline.PLITEM
	LEFT JOIN Pohead ON (Poline.PLco = Pohead.PHco
		AND Poline.PLloc = Pohead.PHloc
		AND poline.plvend = pohead.phvend
		AND Poline.PLPO# = Pohead.PHPO#) 
/*	LEFT JOIN Itemfact ON Poline.PLITEM = Itemfact.IFITEM	*/
	LEFT JOIN Vendmast ON Poline.PLVEND = Vendmast.VMVEND 
	LEFT JOIN Family ON Poline.PLFMCD = Family.FMFMCD 
	LEFT JOIN itemrech ir ON ( ir.iritem = Poline.plitem
							AND ir.irpoco = Poline.plco
							AND ir.irpolo = Poline.plloc
							AND ir.irpo# = Poline.plpo# 
							AND ir.irvend = Poline.plvend
							AND ir.IRPOSQ = Poline.plseq#						
							 )
	LEFT JOIN POLHISTDTL pod On ( pod.pdco = Poline.plco
							AND pod.pdloc = Poline.plloc
							AND pod.pdpo# = Poline.plpo# 
							AND pod.pdvend = Poline.plvend
							AND pod.pdseq# = Poline.plseq#
							)  
							
	WHERE imvend = ''10131''
		AND Poline.PLDDAT = ''2039-12-31''
		AND Poline.plqrec != Poline.plqord 
		AND Poline.plcode != ''C''
	 	AND (( pod.pdtype =  ''M'' ) OR ( pod.pdtype IS NULL ))	 
	
	
	ORDER BY Poline.PLDDAT
			,Vendmast.VMNAME
			,Poline.PLPO#
			,Poline.PLITEM 
	') OQ

 LEFT JOIN GSFL2K.B107Fd6E.GSFL2K.MANTRACK MT ON Manifest = MT.MTMAN#
END
GO


