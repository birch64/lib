function Write-XXLog {
	[CmdletBinding()]
    param (
       $message,
	   $color
    )
	
	$d = get-variable -scope 2 -name MyInvocation
	
	$commandLine = $d.Value.MyCommand.ToString().Split(" ")[0]
	
	try {
		$gg = get-variable -name _logfile -ErrorAction Stop
	} 
	catch [System.Management.Automation.ActionPreferenceStopException] {
	# If it was launched from the Command Line...
		if($d.Value.CommandOrigin -eq "Runspace") {
		# set $_logfile to the name of the calling function + date
			
		$path = "C:\Windows\KTN_Sources\" + $commandLine + "_" +  (get-date -format MMddyyyy-HHmmss) + ".txt"
		Set-Variable -Name _logfile -Scope 2 -Value $path
		}
	}
	
	# Log to $_logfile
	Add-content $_logfile -value $message

	# Print message to console
	if ($color) {
		Write-Host $message -ForegroundColor $color
	}
	else {
		Write-Host $message	
	}
}

