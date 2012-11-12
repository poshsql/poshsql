function ReplaceParameters()
{
	$query = $args[0]| out-string;
	for($i=1;$i -lt $args.Length;$i++){
			$Query = $query.Replace("@parameter$i", $args[$i]);
	}
	$query;
}
