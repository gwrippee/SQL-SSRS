

/*

SR Project
SR Status

Sub reports for calls and activities

*/

CREATE PROC uspSR_ASC_Status
AS
BEGIN
	select g.[ASC]

	,case g.[Type]
		when 'Q' then 'Quote'
		when 'S' then 'Support'
		else g.[Type]
	end as ASCType

	,case g.Priority
		when 0 then 'None'
		when 1 then 'High'
		when 2 then 'Medium'
		when 3 then 'Low'
		else 'Unknonwn'
	end as ASC_Priority

	,case g.[Status]
		when 'A' then 'Assigned'
		when 'C' then 'Closed'
		when 'H' then 'On Hold'
		when 'I' then 'In Progress'
		when 'O' then 'Open'
		when 'Q' then 'Quoated'
		when 'R' then 'Report to Cust'
			else 'Unknonwn'
	end as ASC_Status

	,g.[Date Reported]
	,g.[Description]
	,g.Comments
	,g.[CSR Name]
	,g.[Assigned To]
	,g.[Reported By]

	,pj.title as Project_Title
	,sr.[Id] as SR_ID
	,sr.title
	,st.[value_caption] as SR_Status
	,sr.responsibility as SR_Responsibility
	,sr.notes as SR_Notes
	,(select MAX(ActTime) from SRActivities where sr.[id] = ActId) as LastSRActivityDate
	--,(select ActBody from SRActivities where sr.[id] = ActId 
	--	and ActTime = (select MAX(ActTime) from SRActivities a1 where a1.ActId = sr.[id])) as LastActivityBody

	from GartmanASC g
	left join SYSaid.sysaid.dbo.service_req sr on sr.cust_text2 = cast(g.[ASC] as varchar(255))
	left join sysaid.[sysaid].[dbo].[cust_values] st on (sr.[status] = st.value_key and st.list_name = 'status')
	left join sysaid.sysaid.dbo.project pj on sr.project_id = pj.id
END
