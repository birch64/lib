function Start-XXRadmin {
<#
    .SYNOPSIS
    	Creates a user or batch of users based on a csv file.
    .DESCRIPTION
	.NOTES
	.LINK
	.EXAMPLE
		Add-XXUser -InputFile .\addusers.csv
	.PARAMETER TBD
#>

	[CmdletBinding()]
	param (
		[parameter (Mandatory=$true)]
		$InputFile
	)
	
	$file = Import-Csv $InputFile -Delimiter ";"
	$index = 0
	foreach ($item in $file) {
		$name = $file[$index]
		Write-Progress -Activity "Creating new user" -Status "Now creating $name" -PercentComplete ($index / $file.count*100)
		Start-Sleep 5
	}
}