gci $psscriptroot\*.ps1 | % { . $_.FullName }
gci "$(poshpath -tag private)\*.ps1"| % { . $_.FullName }
gci "$(poshpath -tag public)\*.ps1"| % { . $_.FullName }
export-modulemember -alias * -function Get-* 

