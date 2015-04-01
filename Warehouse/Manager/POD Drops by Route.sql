/**************************************************
**	James Tuttle	Date: 04/01/2015
**
**  User go to SSRS and key in multiple routes
**  and see how the orders are ordred by DROP
**	and with the Customer "Ship To" name.
**
**************************************************/
ALTER PROC JT_POD_Drop 
	@CSV varchar(100)	-- Add mutiple routes seperated by 
AS						-- a comma (,).
BEGIN 
 --DECLARE @sql varchar(max)	-- Not needed
 -- SET @sql = '				-- Not needed
	SELECT *
	FROM OPENQUERY(GSFL2K,'
	SELECT OLROUTCON
		  ,OLCUSTCON
		  ,OLDROP
		  ,OLXPAL
		  ,OLROUT
		  ,CMNAME
		  ,OLCO
		  ,OLLOC
		  ,OLORD#
		  ,OLREL#
		  ,OLSEQ#
		  ,OLCUST
		  ,OLITEM
		  ,OLLINE
		  ,OLDESC
		  ,OLVEND
		  ,OLICO
		  ,OLILOC
		  ,OLQORD
		   
		FROM OOLINEPOD olp
		LEFT JOIN CUSTMAST cm ON olp.OLCUSTCON = cm.cmcust

		ORDER BY OLDROP
	')
	WHERE olrout IN (SELECT * FROM dbo.udfCSVToList(@CSV) )
	--EXEC (@sql)				-- Not needed
END
GO

-- JT_POD_Drop '296,296P,296S'


