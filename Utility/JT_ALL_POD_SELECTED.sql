
-- James Tuttle		
-- 11/19/2014
-- 
-- Gett all records in POD [ctdetl]

ALTER PROC JT_ALL_POD_SELECTED AS

SELECT *

FROM OPENQUERY(GSFL2K,'
	SELECT inu.iupgm
		   ,ctd.*

	FROM ctdetl ctd
	LEFT JOIN ooinuse inu ON ( ctd.ctlco = inu.iuco
						     AND ctd.ctlloc = inu.iuloc
							 AND ctd.ctlord# = inu.iuord#
							 AND ctd.ctlrel# = inu.iurel# )
')