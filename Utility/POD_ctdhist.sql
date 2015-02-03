

SELECT *
FROM OPENQUERY(GSFL2K,'
	SELECT cdh.*, cm.cmname
	FROM CTDHIST cdh

	LEFT JOIN custmast cm ON cm.cmcust = cdh.ctcust

	WHERE cdh.ctdloc = 50
		AND cdh.ctdman = 5015

	ORDER BY ctcust
')
