/*************************************************
** Programmer:Name	Date: 2015-04-17      		**
** SR#: SR#										**
** -------------------------------------------- **
**												**
** Purpose:	GL Report for Adrienne Lowber		**
**												**
**												**
**************************************************/

CREATE PROC JT_GL_CODE_BY_Adjustment AS 
BEGIN

SELECT *
FROM OPENQUERY(GSFL2K,'
	SELECT irco
		  ,irloc
		  ,iritem
		  ,irsrc
		  ,irreason
		  ,glgl#
		  ,gldesc

	FROM itemrech ir
	LEFT JOIN iareason ia ON ia.iareas = ir.irreason
	LEFT JOIN glmastgl glm ON glm.glgl# = ia.iargl#

	WHERE ir.irdate = CURRENT_DATE
		AND glgl# IS NOT NULL
')


-- iareason
-- itemrech
-- glmastgl

END