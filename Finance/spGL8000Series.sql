USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[GL8000Series]    Script Date: 11/20/2014 1:46:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
--
--	TODO: ALTER this PROC to be an OPENQUERY instead of a linked server direct
--
--  Causes the Pivot table link in Excel to crash and the linked Server needs
--   its properties refreshed to work again. Article in SysAid KB - James Tuttle 11/21/14
--
================================================================================================*/


ALTER proc [dbo].[spGL8000Series] 

@GLYear as int 

as

select gdco as Company,gdgl# as GLAcct,glmast.gldesc as GLDesc,gdacyr as GLYear,gdacpr as GLPeriod,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5) as DerrivedVendor, 
vmvend as VendorNum, CAST(vmvend as varchar(10)) + ' - ' + vmname as Vendor,
sum(gdamt) as Amount

from gsfl2k.b107fd6e.gsfl2k.gldetl
left join gsfl2k.b107fd6e.gsfl2k.vendmast V on 
	cast(V.vmvend as varchar(6)) = REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5)
	
left join gsfl2k.b107fd6e.gsfl2k.glmast on (gldetl.gdco = glmast.glco
	and gldetl.gdgl# = glmast.glgl#)

where gdgl# between 800000 and 899999
and gdacyr = @GLYear
and substring(ltrim(rtrim(gdno2)),1,1) <> '0'

group by gdco,gdgl#,gldesc,gdacyr,gdacpr,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5), 
vmvend,vmname, CAST(vmvend as varchar(10)) + ' - ' + vmname 


union all

select gdco as Company,gdgl# as GLAcct,glmast.gldesc as GLDesc,gdacyr as GLYear,gdacpr as GLPeriod,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5) as DerrivedVendor, 
vmvend as VendorNum, CAST(vmvend as varchar(10)) + ' - ' + vmname as Vendor,
sum(gdamt) as Amount

from gsfl2k.b107fd6e.gsfl2k.gldetl
left join gsfl2k.b107fd6e.gsfl2k.vendmast V on 
	cast(V.vmvend as varchar(6)) = REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5)
left join gsfl2k.b107fd6e.gsfl2k.glmast on (gldetl.gdco = glmast.glco
	and gldetl.gdgl# = glmast.glgl#)


where gdgl# between 800000 and 899999
and gdacyr = @GLYear
and substring(ltrim(rtrim(gdno2)),1,1) = '0'
and substring(ltrim(rtrim(gdno2)),2,1) <> '0'

group by gdco,gdgl#,gldesc,gdacyr,gdacpr,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5), 
vmvend,vmname, CAST(vmvend as varchar(10)) + ' - ' + vmname 

union all

select gdco as Company,gdgl# as GLAcct,glmast.gldesc as GLDesc,gdacyr as GLYear,gdacpr as GLPeriod,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5) as DerrivedVendor, 
vmvend as VendorNum, CAST(vmvend as varchar(10)) + ' - ' + vmname as Vendor,
sum(gdamt) as Amount

from gsfl2k.b107fd6e.gsfl2k.gldetl
left join gsfl2k.b107fd6e.gsfl2k.vendmast V on 
	cast(V.vmvend as varchar(6)) = REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),3,4)
left join gsfl2k.b107fd6e.gsfl2k.glmast on (gldetl.gdco = glmast.glco
	and gldetl.gdgl# = glmast.glgl#)


where gdgl# between 800000 and 899999
and gdacyr = @GLYear
and substring(ltrim(rtrim(gdno2)),1,2) = '00'

group by gdco,gdgl#,gldesc,gdacyr,gdacpr,
REPLACE(substring(ltrim(rtrim(gdno2)),1,1),0,'')+SUBSTRING(ltrim(rtrim(gdno2)),2,5), 
vmvend,vmname, CAST(vmvend as varchar(10)) + ' - ' + vmname 


/*
	[GL8000Series] 2014
*/

GO


