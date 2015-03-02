-------------------------------------------------------------------------------------------
-- DynamicSQL Pivot 
-- http://stackoverflow.com/questions/16946836/crosstab-query-with-count-of-values-in-sql-server-2008-r2
--
--	E N D	R E S U L T		B E L O W 
-- ''''''''''''''''''''''''''''''''''''
-------------------------------------------------------------------------------------------
--| APPROACHSTATUS | GI MED ONC | BREAST MED ONC |
--------------------------------------------------
--|     Approached |          2 |              1 |
--| Not Approached |          0 |              1 |
--|        Pending |          1 |              0 |

-------------------------------------------------------------------------------------------
-- #1
--
DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX)

select @cols = STUFF((SELECT distinct ',' + QUOTENAME(Clinic) 
                    from yt
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT ApproachStatus,' + @cols + ' 
            from yt
            pivot 
            (
                count(Clinic)
                for Clinic in (' + @cols + ')
            ) p '

execute(@query)
-- #2
--  Simple Pivot
-- 
select ApproachStatus, [GI Med Onc],[Breast Med Onc]
from yt
pivot
(
  count(Clinic)
  for Clinic in ([GI Med Onc],[Breast Med Onc])
) piv;
---------------------------------------------------------------------------------------------
-- #3
-- By Case Statement Cross Tab Query
--
SELECT olrloc [Location]
		,SUM(CASE WHEN imdiv = 3 THEN 1 ELSE 0 END) [Vinyl]
		,SUM(CASE WHEN imdiv = 11 THEN 1 ELSE 0 END) [Carpet]

 FROM tbl
 GROUP BY olrloc
 ---------------------------------------------------------------------------------------------	
 -- #4 Invoice table
 SELECT *
FROM (
    SELECT 
        year(invoiceDate) as [year],left(datename(month,invoicedate),3)as [month], 
        InvoiceAmount as Amount 
    FROM Invoice
) as s
PIVOT
(
    SUM(Amount)
    FOR [month] IN (jan, feb, mar, apr, 
    may, jun, jul, aug, sep, oct, nov, dec)
)AS pivot
---------------------------------------------------------------------------------------------