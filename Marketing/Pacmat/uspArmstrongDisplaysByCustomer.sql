

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
-- UPDATE by James Tuttle 03/04/2015				--
--													--
--    Need to add customer's Armstrong ID.  That is --
-- in field=vncvcust in the table vendcust where the-- 
-- vncvend=16037									--
--=====================================================

ALTER PROC uspArmstrongDisplaysByCustomer
	@BillCodes	varchar(2)
AS
BEGIN
	 SET @BillCodes = UPPER(@BillCodes)

	DECLARE @sql varchar(MAX) 
	SET @sql = 'SELECT *
	FROM OPENQUERY (GSFL2K,''
		SELECT     cbcust					AS CustNum
				   ,cmname					AS CustName
				   ,SUBSTRING(cmadr3,0,24)	AS City
				   ,SUBSTRING(cmadr3,24,2)	AS State
				   ,smname					AS Salesman			
				   ,cbblcd					AS BillCD
				   ,bcdesc					AS BillCDDesc
				   ,vncvcust				AS Armstrong_ID

		FROM custbill cb
			  LEFT JOIN blcdmast bcm ON cb.cbblcd = bcm.bcblcd
			  LEFT JOIN custmast cm ON cbcust = cm.cmcust
			  LEFT JOIN salesman sm ON sm.smno = cm.cmslmn
			  LEFT JOIN vendcust vc ON vc.vnccust = cm.cmcust

		 WHERE cbblcd =  ' + '''' + '''' + @BillCodes + '''' + ''''	+ '
			AND vncvend = ''''16037''''
			
		ORDER BY smname 
				,cbcust  
	'')'

	EXEC (@sql)
END

--	uspArmstrongDisplaysByCustomer 'av'

-- AU, AH, A0, lc
--> 32 codes based on the 16037 vendor <--

-- BillCodesDescList