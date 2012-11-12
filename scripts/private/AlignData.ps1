Function AlignData {
	param(
			[string]$data, [int]$width, [switch]$Right, [switch]$Lastcolumn
    )
	$padspace = 0
	$ww = $data.Length
	if ($Lastcolumn -eq $false){
	#if this is not for a last column we need to reduce a width for column spacing 
		$width--;
	}
	if ($ww -le $width){
		$padspace = $width - $ww
	}else { #Trim the word 
		$data = $data.Substring(0,$width)
	}
	if ($Lastcolumn -eq $false)
	{
		$data = $data + " "	
	}
	if($right){
		" " * $padspace + $data
	}else{
		$data + " " * $padspace 

	}
}
