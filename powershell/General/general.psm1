function Remove-XXRegistryValue {
<#
	.SYNOPSIS
	Remove a specific registry 
	.DESCRIPTION
	.NOTES
	.LINK
	.PARAMETER filepath
	The full file path to the spacer file (directory and file name) 
	.PARAMETER size
	The size of the file in MB
	.EXAMPLE
	new-XXemptyFile -filepath c:\temp\emptyFile.spacer -size 20MB
	.NOTES
#>	
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$true)]
		[string]$path,
		[parameter(Mandatory=$true)]
		[string]$value
	)
	
	Get-Item -Path $path | Select-Object -ExpandProperty property | % { 
		if ($_ -match $value) { 
			Remove-ItemProperty -Path $path -name $value
		} 
	}
}

function _convertDate {
<#
	.SYNOPSIS
	Converts a date in the timestamp format to something readable
	.DESCRIPTION
	.NOTES
	.LINK
	.PARAMETER timestamp
	The value of the timestamp notation
	.EXAMPLE
	_convertdate -timestamp 130947490771288457
	_converdate xxx
	.NOTES
#>

	[CmdletBinding()]
	param (
		[parameter(Mandatory=$true)]
		[System.Int64]$timestamp
	)
	
	return ([datetime]::FromFileTime($timestamp).toString('G'))
}

function _convertDateSCCM {
<#
	.SYNOPSIS
	Converts a date in the timestamp format that SCCM uses to something readable
	.DESCRIPTION
	.NOTES
	.LINK
	.PARAMETER timestamp
	The value of the timestamp notation
	.EXAMPLE
	_convertdateSCCM -timestamp 20160204081926.000000+***
	.NOTES
#>

	[CmdletBinding()]
	param (
		[parameter(Mandatory=$true)]
		[String]$timestamp
	)
	
	$dt = [datetime]::parseexact($timestamp.split('.')[0],"yyyyMMddHHmmss",[System.Globalization.CultureInfo]::InvariantCulture)
	return ($dt.tostring('dd/MM/yyyy HH:mm:ss'))
}