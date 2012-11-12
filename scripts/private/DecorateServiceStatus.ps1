function DecorateServiceStatus()
{
  param(
		  [parameter(Mandatory=$true)][AllowEmptyString()][string] $status,
		  [parameter(Mandatory=$true)][AllowEmptyString()][string] $startmode

    )
  	if($status -eq 'Running'){
		$ret = 'UP'+"("+$startmode.substring(0,1)+")"
	}elseif ($status -eq ''){
		$ret = '-'
	}else{
		$ret = 'DOWN'+"("+$startmode.substring(0,1)+")"
	}
	$ret;
}
