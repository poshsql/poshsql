﻿function Out-Text {
 param(
    $path = 	"$(poshpath -tag temp)\outtext.txt"
 )
	$Input | Format-Table -AutoSize | Out-File $Path -Width 99999
	& $Path
}
