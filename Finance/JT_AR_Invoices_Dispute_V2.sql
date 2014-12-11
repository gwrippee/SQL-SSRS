
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

--ALTER PROC JT_AR_Invoices_Dispute_V2	AS
BEGIN
	SELECT *

	FROM OPENQUERY(GSFL2K,'
		SELECT  arh.cstype							AS Type
			,arh.cscrcd								AS Code
			,ac.acdesc								AS Description
			,arh.csco								AS Company
			,arh.csloc								AS Location
			,arh.cscust								AS Cust#
			,cm.cmname								AS Customer_Name
			,arh.csinv#								AS Invoice
			,MONTH(arh.csdate) || ''/'' ||
				DAY(arh.csdate) || ''/'' ||
				YEAR(arh.csdate)					AS Date
			,arh.cscash								AS Net
			,arh.csamt								AS Amount
			,arh.cscomt								AS Comment
			,arh.csslmn								AS Saleman
			,sm.smname								AS Name
			


		FROM ARCSHIST arh									/* -- AR Cash Hisotry (after closed cash)	-- */
		LEFT JOIN custmast cm ON cm.cmcust = arh.cscust		/* -- Customer master						-- */
		LEFT JOIN ARCRCODE ac ON ac.ACCODE = arh.cscrcd		/* -- AR Code descritpions					-- */
		LEFT JOIN salesman sm ON sm.smno = arh.csslmn		/* -- Salesman info							-- */
	
		WHERE arh.csdate >= ''01/01/2014''
			AND arh.csdate <= ''11/30/2014''
			AND arh.cscrcd != '' ''							/* -- credit code NOT blank (a reason why)	-- */
			AND arh.cstype = 2								/* -- payment type [1 = invoice | 2 = payment | 3 = credit adj | 4 = debit adj | 5 = finance chg | 6 = claim] -- */

			

		ORDER BY arh.cscrcd
				
	')
END
