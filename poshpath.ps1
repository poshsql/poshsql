function PoshPath([string] $tag)
{
	switch ($tag)
	{
		"sql"     { return $psscriptroot+"\scripts\sql" }
		"private" { return $psscriptroot+"\scripts\private" }
		"public"  { return $psscriptroot+"\scripts\public" }
		"config"  { return $psscriptroot+"\config" }
		"temp"    { return $psscriptroot+"\temp" }
		default   { return $psscriptroot }
	}
}
