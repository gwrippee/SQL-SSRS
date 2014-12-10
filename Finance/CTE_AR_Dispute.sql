
select *
from OPENQUERY(GSFL2K,'
/* ================================================================= */		
		WITH inv AS	(select * 
					FROM openitem oi
					WHERE oitype = 2
						AND oicrcd != '' ''
						AND oiinv# = ''177778'' )
/* ================================================================= */	

		WITH pay AS (select *
		FROM openitem oi
		WHERE oitype = 1
			AND oicrcd = '' ''
			AND oiinv# = ''177778'' )


			select pay.oicode
				,pay.oicust
				.pay.oico
				,pay.oiloc
				,pay.oidate
				,pay.oitype
				,pay.oiinv#
				,pay.oiref#
				,pay.g
	')