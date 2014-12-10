
SELECT *
FROM OPENQUERY(GSFL2K,'
	SELECT gdco
			,gdgl#
			,gldesc
			,gdacyr
			,gdacpr
			,gdno2
		/*	,vmvend	*/
		/*	,vmname	*/
			,gdamt

	FROM gldetl gld
	LEFT JOIN glmast glm ON (gld.gdco = glm.glco
						AND gld.gdgl# = glm.glgl# )	

	LEFT JOIN CAST (

	WHERE YEAR(gddate) >= 2014
		AND gld.gdloc = 89
		AND gld.gdgl# >= 800000
		AND gld.gdgl# <= 899999
')
