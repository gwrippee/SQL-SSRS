

/*****************************************************
** Programmer:James Tuttle	Date: 2015-03-04  		**
** SR#: 29636										**
** -----------------------------------------------	**
**													**
** Purpose:	Need to be able to go to SSRS and		** 
**	select the billing code description (bcdesc)	** 
**	from a drop down list instead of the specific	** 
**	codes that are shown in the where clause of		**
**	the SQL below.									**
**													**
******************************************************/

ALTER PROC uspArmstrongDisplaysByCustomer
	@BillCodes	varchar(2)
AS
SELECT *
FROM OPENQUERY (GSFL2K,'
	SELECT     cbcust					AS CustNum
			   ,cmname					AS CustName
			   ,SUBSTRING(cmadr3,0,24)	AS City
			   ,SUBSTRING(cmadr3,24,2)	AS State
			   ,smname					AS Salesman			
			   ,cbblcd					AS BillCD
			   ,bcdesc					AS BillCDDesc

	FROM custbill
		  LEFT JOIN blcdmast ON cbblcd = bcblcd
		  LEFT JOIN custmast ON cbcust = cmcust
		  LEFT JOIN salesman ON smno = cmslmn

	/* WHERE cbblcd = ''  + @BillCodes  +''	*/

	ORDER BY smname ASC
			,cbcust ASC
')


--	uspBillingCodes 'AU'