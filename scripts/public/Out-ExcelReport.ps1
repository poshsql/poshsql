﻿function Out-Excel {
 param(
  $path = 	"$(poshpath -tag temp)\outexcel.csv"
 )
	$Input | Export-Csv $path -NoTypeInformation -UseCulture -Encoding UTF8
	& $path 
}
