function LoadQuery($tag="fixeddrives") {
	[xml]$queryxml = Get-Content "$(poshpath -tag config)\query.xml"
	$querypath = ($queryxml.queries.query | where {$_.tag -match $tag} | select path -first 1).path
	if ($querypath) { $querypath = $querypath.replace('$psscriptroot',"$(poshpath -tag sql)")}
	if ($querypath) {get-content $querypath} else {"select @@servername ServerName"}
}
