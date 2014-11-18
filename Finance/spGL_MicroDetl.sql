

/* ---------------------------------------------------------------------------------------------
  Here is some SQL to start. Need subtotal by GL by customer. Need to bring in customer name 
 also and GL name from custmast and glmast respectively.

 James Tuttle 11/13/2014 - per George R for Kathy Miller
--------------------------------------------------------------------------------------------- */
ALTER PROC spGL_MicroDetl AS
BEGIN
	SELECT *
	 
	FROM OPENQUERY (GSFL2K,'
	
		SELECT Month(gmddate) || ''/'' ||	/* Format date in DB2 to USA */
				DAY(gmddate) || ''/'' ||
				YEAR(gmddate)				AS Date

			 ,glmd.gmdco					AS Co
			 ,glmd.gmdgl#					AS GL#
			 ,gl.gldesc
			 ,glmd.gmdkey1					AS Cust_Num
			 ,cm.cmname						AS Cust_name
			 ,glmd.gmdno	
			 ,glmd.gmdfile	
			 ,glmd.gmdapp
			 ,glmd.gmdbatch
			 ,glmd.gmdkey2					AS Order_Num
			 ,glmd.gmdkey3	
			 ,glmd.gmdkey4
			 ,glmd.gmdpgm
			 ,glmd.gmdfldnm
			 ,glmd.gmdamt

		FROM glmicrodtl glmd
		LEFT JOIN custmast cm ON glmd.gmdkey1 = cm.cmcust
		LEFT JOIN glmast gl ON ( gl.glgl# =  glmd.gmdgl#
							AND gl.glco = glmd.gmdco )

		WHERE gmddate BETWEEN ''10/01/2014'' AND ''10/31/2014''
			  AND gmdapp IN (''AC'')
			  AND gmdgl# NOT IN (103000,103100,107000,135300
					,200000,328000,355000,356500,610000,700000,610500)

		ORDER BY glmd.gmdgl#
				,glmd.gmdkey1
		')
END
