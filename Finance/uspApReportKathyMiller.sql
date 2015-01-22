

SELECT * FROM OPENQUERY (GSFL2K,'

SELECT      ,vmvend AS VendorNum
            ,vmname AS VendorName
            ,vmterm AS TermsCode
            ,pudesc AS TermsDesc
            
            
FROM vendmast vm
LEFT JOIN poterms pot ON pot.puterm = vm.vmterm
      
      
ORDER BY POT.pudesc asc
')
