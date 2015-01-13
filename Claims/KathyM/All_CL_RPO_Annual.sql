---------------------------------------------
-- Kathy Miller 2014 Claim data dumps
--
-- James Tuttle 01/12/2015
---------------------------------------------
-- Purpose: All CL RPOs Annual
---------------------------------------------
SELECT *
FROM OPENQUERY(GSFL2K,'
	SELECT plactn						AS Action
		  ,phco							AS Co
		  ,phloc						AS Loc
		  ,phpo#						AS PO
		  ,phvend						AS Vend
		  ,vmname						AS Name
		  ,MONTH(phcdat) || ''/'' ||
			 DAY(phcdat) || ''/'' ||
			 YEAR(phcdat)				AS Created
		  ,phcusr						AS Author
		  ,plseq#
		  ,plitem						AS Item
		  ,plqrec						AS Qty
		  ,plum1						AS Qty_UM
		  ,plcost						AS Unit_Cost

		  ,plblur						AS Bill_Units
		  ,plum2						AS Bill_UM
		
		  ,plapam						AS Amt_to_AP
		  ,plapfam						AS Freight

	
		    
	FROM pohhist ph
	LEFT JOIN polhist pl ON (ph.phco = pl.plco
						 AND ph.phloc = pl.plloc
						 AND ph.phpo# = pl.plpo#
					 	 AND ph.phrel# = pl.plrel#	 
						 AND ph.phvend = pl.plvend	  )
	LEFT JOIN vendmast vm ON vm.vmvend = ph.phvend

	WHERE YEAR(ph.phcdat) = ''2014''
		AND ph.photyp = ''CL''
		AND pl.plactn = ''R''

	ORDER BY phco
			,phloc
			,phpo#
')
