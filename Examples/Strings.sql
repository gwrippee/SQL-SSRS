--==========================================
--
--	STRINGS
--
--==========================================
DECLARE @name VARCHAR = 'JAMESxxxx'

SELECT SUBSTRING(LTRIM(RTRIM(@name)),2,1)	-- Trim
	,SUBSTRING(LTRIM(RTRIM(@name)),1,1)		-- Trim 

-----------------------	

	SELECT LEFT('HELLO WORLD',CHARINDEX('e','HELLO WORLD')-1)


	-------------------

	SELECT *
    FROM OPENQUERY(GSFL2K,'
    	SELECT * 
    	FROM gldetl

    ')
    
SELECT * SUBSTRING(LTRIM(RTRIM('hi ')),2,1)