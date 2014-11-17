USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[InboundFrieghtTA]    Script Date: 11/17/2014 12:22:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




  
  
/*----------------------------------------------------------  
--  
-- Jame Tuttle 09/25/2012  
--  
-- Added not to include reverse POs  
-- PHRETURN != 'Y'  
  
  
-- Thomas  10/15/2013  
--  
-- Changed item criteria to use IM clas indicator  

-- Thomas 7/15/2014
-- Changed to add 'Not Attached Qty' - SR 23280
  
------------------------------------------------------------*/  
  
  
  
ALTER Proc [dbo].[InboundFrieghtTA] as  
  
select OQ.*
		,MT.MTSTATUS 
		,MT.mttrak# AS Tracking_Number

from openquery(GSFL2K,'  
  
Select Poline.PLDDAT As DueDate,   
Poline.PLDDAT - 7 DAYS as ActualArrivalDueDate,   
Poline.PLCO as Company,  
Poline.PLLOC As Location,   
Family.FMDESC as Family,   
Vendmast.VMNAME As VendorName,   
Poline.PLPO# As PO,   
Poline.PLITEM As SKU,   
Poline.PLDESC As Description,   
Itemmast.IMCOLR As Color,   
Poline.PLQORD As UnitsOrdered,  


Poline.plqord - ifnull((select sum(pboqty) from poboline
	where pbco = poline.plco
	and pbloc = poline.plloc
	and pbpo# = poline.plpo#
	and PBREL# = poline.plrel#
	and pbitem = poline.plitem),0) as NotAttachedQty,

Itemfact.IFFACA as UnitsPerPallet,   
Itemfact.IFUMC,   
Poline.PLQORD/Itemfact.IFFACA As TotalPallets,  
(select max(mnman#) from manifest where mnpo# = poline.plpo#  
      and mnpolo = poline.plloc  
      and mnitem = poline.plitem  
      and mnpoco = poline.plco) as Manifest,  
(select sum(ibqoh) from itembal where ibitem = itemmast.imitem) as OnHand  
  
FROM Poline  
  
left join Itemmast on Itemmast.IMITEM = Poline.PLITEM  
Left Join Pohead On (Poline.PLco = Pohead.PHco  
 and Poline.PLloc = Pohead.PHloc  
 and poline.plvend = pohead.phvend  
 and Poline.PLPO# = Pohead.PHPO#)   
Left Join Itemfact On Poline.PLITEM = Itemfact.IFITEM   
Left Join Vendmast On Poline.PLVEND = Vendmast.VMVEND   
Left Join Family On Poline.PLFMCD = Family.FMFMCD   
  
Where Itemfact.IFUMC = ''P''   
AND Poline.PLITEM <> ''GENPROMO''   
AND Poline.PLITEM <> ''COBROKENPALLET''   
AND Poline.PLQORD/Itemfact.IFFACA > 0.999   
AND Pohead.PHDOI > ''12/31/2005''  
AND Poline.PLCO = 1   
and poline.plloc not in (41,42,60)  
AND Poline.PLDELT <> ''C''  
AND Poline.PLDIRS <> ''Y''   
and itemmast.imclas = ''IM''  
/*  
and ((poline.plvend in (22666,16088,22816,22887,22204,22949,22686,22674,22731,22859,23306)) or  
  (poline.plvend = 21861 and imprcd in (34057,34058)))  
    
*/  
and Poline.PLDDAT <> ''0001-01-01''  
AND POhead.phreturn != ''Y''  
  
Order By Poline.PLDDAT, Vendmast.VMNAME, Poline.PLPO#, Poline.PLITEM   
') OQ  
  
LEFT join (select * from openquery(GSFL2K,'select * from MANTRACK')) MT on OQ.Manifest = MT.MTMAN#  

  

GO


