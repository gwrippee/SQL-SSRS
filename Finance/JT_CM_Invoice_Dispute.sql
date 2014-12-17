
-- CM for Credit Reasons
-- Omit Order Type [RA, CR, FR]
--
-- SHCRED - credit reason

--ALTER PROC JT_CM_Invoice_Dispute AS
BEGIN

	SELECT *
	FROM OPENQUERY(GSFL2K,'
		SELECT sh.shco						AS Co
			,sh.shloc						AS Loc
			,sh.shord#						AS Order#
			,sh.shrel#						AS Rel#
			,sh.shcust						AS Cust#
			,cm.cmname						AS Customer
			,sh.shinv#						AS Inv#
			,MONTH(sh.shidat) || ''/''	||
				DAY(sh.shidat) || ''/'' ||
				YEAR(sh.shidat)				AS Invoice_Date
			,sh.shcred						AS Code
			,arc.acdesc						AS Description
			,shtotl							AS Total_Price
			,shcost							AS Total_Cost
			,sh.shslsm						AS Sales#
			,sm.smname						AS Name

		FROM SHHEAD sh
	/*	LEFT JOIN SHLINE sl ON ( sl.slco = sh.shco
							AND sl.slloc = sh.shloc
							AND sl.slord# = sh.shord#
							AND sl.slrel# = sh.shrel#
							AND sl.slcust = sh.shcust
							AND sl.slinv# = sh.shinv# )		*/

		LEFT JOIN custmast cm ON cm.cmcust = sh.shcust
		LEFT JOIN arcrcode arc ON arc.accode = sh.shcred
		LEFT JOIN salesman sm ON sm.smno = sh.shslsm

		WHERE sh.shdate >= ''12/01/2014''
			AND sh.shotyp NOT IN (''RA'',''CL'',''FC'')
			AND sh.shcm	= ''Y''
	')
END

