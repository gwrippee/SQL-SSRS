-- ===================================================================================
-- Author:      TASUPPLY\jamest
-- Create date: 2014-12-18 09:38:38
-- Database:    GartmanReport
--
-- Description: Annual PROC for gl80000series.xls for CFO datasource in GL 800000
--	from the Gartman systems.
--
--
-- ================================================================================


USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[GL8000Series]    Script Date: 10/11/2011 04:20:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter proc [dbo].[GL8000Series_] 

@GLYear as int 

as

select gdco as Company
,gdgl# as GLAcct
,gdacyr as GLYear
,gdacpr as GLPeriod
,REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5) as DerrivedVendor
,vmvend as VendorNum, CAST(vmvend as varchar(10)) + ' - ' + vmname as Vendor
,sum(gdamt) as Amount
,glmast.gldesc AS GLDesc


from gsfl2k.b107fd6e.gsfl2k.gldetl
left join gsfl2k.b107fd6e.gsfl2k.vendmast V on 
	cast(V.vmvend as varchar(6)) = REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5)
LEFT JOIN gsfl2k.b107fd6e.gsfl2k.glmast ON (gldetl.gdco = glmast.glco
	AND gldetl.gdgl# = glmast.glgl#)

where gdgl# between 800000 and 899999
and gdacyr = @GLYear
and substring(ltrim(rtrim(gdno2)),1,1) <> '0'

group by gdco,gdgl#,gdacyr,gdacpr,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5), 
vmvend,vmname, CAST(vmvend as varchar(10)) + ' - ' + vmname 
,GLDesc
,gddesc

----------------------------------------------------------------------------------------------------------------------------------------------

union all

select gdco as Company
,gdgl# as GLAcct
,gdacyr as GLYear
,gdacpr as GLPeriod
,REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5) as DerrivedVendor
,vmvend as VendorNum, CAST(vmvend as varchar(10)) + ' - ' + vmname as Vendor
,sum(gdamt) as Amount
,glmast.gldesc AS GLDesc



from gsfl2k.b107fd6e.gsfl2k.gldetl
left join gsfl2k.b107fd6e.gsfl2k.vendmast V on 
	cast(V.vmvend as varchar(6)) = REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5)
LEFT JOIN gsfl2k.b107fd6e.gsfl2k.glmast ON (gldetl.gdco = glmast.glco
	AND gldetl.gdgl# = glmast.glgl#)

where gdgl# between 800000 and 899999
and gdacyr = @GLYear
and substring(ltrim(rtrim(gdno2)),1,1) = '0'
and substring(ltrim(rtrim(gdno2)),2,1) <> '0'

group by gdco,gdgl#,gdacyr,gdacpr,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5), 
vmvend,vmname, CAST(vmvend as varchar(10)) + ' - ' + vmname 
,GLDesc
,gddesc

----------------------------------------------------------------------------------------------------------------------------------------------

union all

select gdco as Company
,gdgl# as GLAcct
,gdacyr as GLYear
,gdacpr as GLPeriod
,REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5) as DerrivedVendor
,vmvend as VendorNum, CAST(vmvend as varchar(10)) + ' - ' + vmname as Vendor
,sum(gdamt) as Amount
,glmast.gldesc AS GLDesc



from gsfl2k.b107fd6e.gsfl2k.gldetl
left join gsfl2k.b107fd6e.gsfl2k.vendmast V on 
	cast(V.vmvend as varchar(6)) = REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),3,4)
LEFT JOIN gsfl2k.b107fd6e.gsfl2k.glmast ON (gldetl.gdco = glmast.glco
	AND gldetl.gdgl# = glmast.glgl#)

where gdgl# between 800000 and 899999
and gdacyr = @GLYear
and substring(ltrim(rtrim(gdno2)),1,2) = '00'

group by gdco,gdgl#,gdacyr,gdacpr,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5), 
vmvend,vmname, CAST(vmvend as varchar(10)) + ' - ' + vmname 
,GLDesc
,gddesc


GO


-- GL8000Series_ 2013
