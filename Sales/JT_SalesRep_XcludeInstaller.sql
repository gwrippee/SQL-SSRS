
-----------------------------------------------
-- James Tuttle
-- Date: 11/25/14
--
-- Query list for a sales rep
-- exclude: 999/Closed
--			201/Installer
--			202/Installer
------------------------------------------------

CREATE PROC JT_SalesRep_XcludeInstaller AS 


select * from openquery (gsfl2k,'

select      cmco   as Company,
			cmcust as CustNum,
            cmname as CustName,
            cmadr1 as Address1,
            cmadr2 as Address2,
            cmbill as BillToAcct,
            cxbprc as BillToPrice,
            left(cmadr3,23) as City,
            right(cmadr3,2) as State,
            cmslmn as RepNum,
            smname as RepName,
            cuclxclass as CustType,
            ccldesc as TypeDesc,
            cmdrt1 as Route1,
            cmdrt2 as Route2,
            cxe_mail as AcctgEmail
            
            
            
from  custmast cm 
      left join salesman sm on sm.smno = cm.cmslmn
      left join cucl2xref cucl on cucl.cuclxcust = cm.cmcust
      left join cuclmast ccl on ccl.cclclass = cucl.cuclxclass
      left join custxtra cx on cx.cxcust = cm.cmcust
      
      
where right(cmadr3,2) = ''AK''
	AND cm.cmco = 1
	AND cuclxclass NOT IN (201,202,999)

/* --   cmslmn = 11	-- */
            
order by cmname   

')
