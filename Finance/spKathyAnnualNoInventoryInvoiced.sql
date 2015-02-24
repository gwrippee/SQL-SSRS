
SELECT *
FROM OPENQUERY(GSFL2K,'
	SELECT shotyp as order_type
				,shco as co
				,shloc as loc
				,shord# as order
				,shrel# as release
				,slitem as item
				,sldesc as description
				,slecst as extened_cost
				,shuser as user

	FROM shhead sh
	LEFT JOIN shline sl ON ( sh.shco = sl.slco
		    AND sh.shloc = sl.slloc
		    AND sh.shord# = sl.slord#
		    AND sh.shrel# = sl.slrel#
		    AND sh.shcust = sl.slcust 
		    AND sh.shinv# = sl.slinv# )
	LEFT JOIN itemmast im ON sl.slitem = im.imitem 

	WHERE sl.slbyp = ''N''
/* -------------------------------------------------------------------------*/
/*	Look at all invoiced dates for the YEAR()								*/
/* -------------------------------------------------------------------------*/
			AND  YEAR(sh.shidat) = ''2014''
/* -------------------------------------------------------------------------*/
/*	Added order type "FN" due to it being Finance Charges that happen		*/
/*  behind the scenes.	And "MM"											*/
/* -------------------------------------------------------------------------*/
			AND sh.shotyp NOT IN(''CL'', ''FC'',''FN'',''MM'',''SA'',''DP'',''IR'')
			AND im.imsi != ''O''
			AND sh.shcred NOT IN (''MP'',''AP'',''PE'')

	ORDER BY shco
			,shloc
')
