select 
	auth_scheme authmode,
	@@servername as servername
		from 
			sys.dm_exec_connections 
				where 
					session_id=@@spid 
