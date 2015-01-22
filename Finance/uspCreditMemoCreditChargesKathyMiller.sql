/*************************************************
** Programmer:James Tuttle	Date: 2015-01-22    **
** SR#: SR#	28529								**
** -------------------------------------------- **
**												**
** Purpose:										**
**												**
**												**
**												**
**												**
**************************************************/

-- ===============================================
--
--		tsGSFL2K <-------------------
--
-- ===============================================

SELECT *
FROM OPENQUERY(tsGSFL2K,'

	SELECT ohcust		AS Sold_To
		  ,cmname
		  ,ohcm
		  ,ohref#
		  ,olitem
		 /* ,ohpric */
		  ,ohemds		AS Sub_Total
		  ,ohsam1		AS Misc_Amount_Delv_Chg
		  ,ohsam2		AS Misc_Amount_Restock
		  ,ohsam3		AS Misc_Amount_Discount
		  ,ohsam4		AS Misc_Amount_Frt_Hndl
		  ,ohsam5		AS Misc_Amount_Fuel

		  ,ohspc1		AS Misc_Ext_Delv_Chg
		  ,ohspc2		AS Misc_Ext_Restock
		  ,ohspc3		AS Misc_Ext_Discount
		  ,ohspc4  		AS Misc_Ext_Frt_Hndl
		  ,ohspc5		AS Misc_Ext_Fuel

		  ,oleprc		AS Line_Ext_Price
		  ,olesp1		AS Line_Ext_Cut_Chg
		  ,olesp2
		  ,olesp3
		  ,olesp4
		  ,olesp5

		  ,''''		AS rebate

		  ,''''				AS tl_loads
		  ,''''			AS trip

		

	FROM oohead oh
	LEFT JOIN ooline ol ON ( oh.ohco = ol.olco
		    AND oh.ohloc = ol.olloc
		    AND oh.ohord# = ol.olord#
		    AND oh.ohrel# = ol.olrel#
		    AND oh.ohcust = ol.olcust )
	LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust

	/* ------------------ TEST LIBRARY ORDER ------------------ */

	WHERE oh.ohord# = 190486

	/* -------------------------------------------------------- */
')


