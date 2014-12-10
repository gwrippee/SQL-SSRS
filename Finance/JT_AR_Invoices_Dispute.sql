
/*****************************************************************************************************************************
** Programmer:James Tuttle	Date: 2014-11-24      																			**
** SR#: 27294																												**
** ------------------------------------------------------------------------------------------------------------------------ **
**																															**
** Purpose:	There is a Gartman report titled “Invoices That Are Coded in Dispute” report #: AR780CC.   I ran it yesterday	**
** and it’s 112 pages long.  One of the reasons the report is this large is it “stacks” the information.  I would like to	**
** get a current report I can begin working on (in excel) and then I would like to get a  monthly Query report (in excel)	**
** on this information where 1 row represents 1 disputed open AR invoice open balance.  The column definitions should be:	**
**																															**
**			-	  Company Number																							**
**          -     Branch Number																								**        
**			-	  Customer Number																							**
**          -     Customer Name																								**
**          -     Invoice Number																							**		
**          -     Invoice Date																								**
**          -     Type (see attached list of disputed codes I received from George)											**
**          -     Net (balance between total invoice amount less any applied payments										**
**          -     Sales Rep																									**
**																															**
** This would be for all companies (T&A, PM & SAF).  In the event the “Net” amount is $0 … I don’t want it on this report.	**
**																															**
**																															**
**																															**
**																															**
**																															**
******************************************************************************************************************************/


ALTER PROC JT_AR_Invoices_Dispute	AS
BEGIN
	SELECT qry.*
	,DATEDIFF(d,qry.aidate,GETDATE()) AS DaysOld
	
	 FROM OPENQUERY(GSFL2K,'
		SELECT 	oico		AS Company
			,oiloc			AS Branch_Number
			,oicust			AS Customer_Number
			,m.cmname		AS Customer_Name
			,a.oiinv#		AS Invoice_Number

			,MONTH(a.oidate) ||''/'' || DAY(a.oidate)	/* Format Date *USA */
				|| ''/'' || YEAR(a.oidate)				AS Invoice_Date

			,a.oicrcd		AS CreditCode	
			,c.ACDESC		AS CreditCodeDesc
			,b.aiamt		AS Amount_Due
			,a.oicomt		AS Comment
			,a.oislmn		AS Sales_Rep
			,s.smname		AS Salesman_Name
			,b.aidate
		
		FROM openitem a
		LEFT JOIN ARCRCODE c ON a.oicrcd = c.ACCODE
		LEFT JOIN custmast m ON a.oicust = m.cmcust
		LEFT JOIN ARIVBAL b ON (a.oicust = b.aicust 
							AND a.oiinv# = b.aipurg
							AND a.oidate = b.aidate)
		LEFT JOIN salesman s ON s.smno = a.oislmn

		WHERE oicrcd !='' ''	/*-- old codes from SSRS “Open Disputed Invoices”  (''FC'',''MC'',''MX'',''VC'') --*/
			AND b.aiamt != 0.00000	
		/*  	and a.oiinv# = ''177778''	  */

		/* --   and oicust = ''1020148''	-- */	
		

			') AS qry
		ORDER BY DaysOld DESC
END 




