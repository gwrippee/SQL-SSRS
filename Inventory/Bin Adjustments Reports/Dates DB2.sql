


--	SELECT *
--FROM OPENQUERY(GSFL2K,'
--	SELECT CURRENT DATE - (DAY(CURRENT_DATE)) DAYS
--	,CURRENT DATE - (DAY(CURRENT DATE) - 1) DAYS 
--	FROM sysibm.sysdummy1

--')

--	SELECT *
--FROM OPENQUERY(GSFL2K,'

--SELECT LAST_DAY(CURRENT_DATE - 1 MONTH) AS End_date, /* last months last day */

--LAST_DAY(CURRENT_DATE - 4 MONTH) + 1 DAY AS start_date /* three months back first day */

--FROM SYSIBM.SYSDUMMY1')




	SELECT *
FROM OPENQUERY(GSFL2K,'

SELECT  LAST_DAY(CURRENT_DATE - 4 MONTH) + 1 DAY AS Start_Date
		,LAST_DAY(CURRENT_DATE - 1 MONTH)		 AS End_Date

FROM SYSIBM.SYSDUMMY1')

