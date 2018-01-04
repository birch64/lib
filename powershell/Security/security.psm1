function Get-XXUserToSID {
<#
	.SYNOPSIS
		Gets the SID from a given username and domain (default = ktn.group)
	.DESCRIPTION
	.NOTES
	.LINK
	.PARAMETER Username
		The Username of which the SID is to be shown
	.PARAMETER Domain
		The domain to which the accompanying username is a member of. If not supplied, this will default to ktn.group
	.EXAMPLE
		Get-XXUserToSID -Username dehouwer
	.NOTES
#>

	[CmdletBinding()]
	param (
		[parameter(Mandatory=$true)]
		[String]$Username,
		[parameter(Mandatory=$false)]
		[String]$Domain="ktn.group"
	)
	
	try {
		$secprin = New-Object System.Security.Principal.NTAccount($domain, $username) 
		$userSID = $secprin.Translate([System.Security.Principal.SecurityIdentifier]) 
		return $userSID.Value
	}
	
	catch {
		Write-Host "Error generated, please investigate..."
		Write-Host $_
	}
}

function Get-XXSIDToUser {
<#
	.SYNOPSIS
		Gets the username from a given SID and domain (default = ktn.group)
	.DESCRIPTION
	.NOTES
	.LINK
	.PARAMETER SID
		The SID of which the username is to be shown
	.PARAMETER Domain
		The domain to which the accompanying SID is a member of. If not supplied, this will default to ktn.group
	.EXAMPLE
		Get-XXSIDToUser -SID S-1-5-21-1398500224-1831025052-1136263860-125123
	.NOTES
#>

	[CmdletBinding()]
	param (
		[parameter(Mandatory=$true)]
		[String]$SID,
		[parameter(Mandatory=$false)]
		[String]$Domain="ktn.group"
	)
	
	try {
		$secprin = New-Object System.Security.Principal.SecurityIdentifier ($SID) 
		$userSID = $secprin.Translate( [System.Security.Principal.NTAccount]) 
		return $userSID.Value
	}
	
	catch {
		Write-Host "Error generated, please investigate..."
		Write-Host $_
	}
}		