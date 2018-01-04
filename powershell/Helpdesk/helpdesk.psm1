function _generatePasswrd () {
<#
	.SYNOPSIS
		Create a random generated password
	.DESCRIPTION
	.NOTES
	.LINK
	.EXAMPLE
		_generatePasswrd -length 12
	.PARAMETER length
		The specified length of the password (default = 9)	
#>
	param ( [int]$Length = 9, [int]$NonAlphanumericChar = 1 )
	$Assembly = Add-Type -AssemblyName System.Web
	$RandomComplexPassword = [System.Web.Security.Membership]::GeneratePassword($Length,$NonAlphanumericChar)
	return $RandomComplexPassword
}

function New-XXEmptyFile {
<#
	.SYNOPSIS
		Create empty spacer files.
	.DESCRIPTION
	.NOTES
	.LINK
	.EXAMPLE
		new-XXemptyFile -filepath c:\temp\emptyFile.spacer -size 20MB
	.PARAMETER filepath
		The full file path to the spacer file (directory and file name) 
	.PARAMETER size
		The size of the file in MB
#>
	[CmdletBinding()]
		param (
			[parameter(Mandatory=$True)]
			$FilePath,
			[parameter(Mandatory=$true)]
			$Size
			)
    $file = [System.IO.File]::Create($FilePath)
   $file.SetLength($Size)
   $file.Close()
   Get-Item $file.Name
}

function Get-XXADUser {
<#
    .SYNOPSIS
    	Search for a user based on a part of the name
    .DESCRIPTION
    	Search for a user based on a part of his name or his username
	.NOTES
	.LINK
	.EXAMPLE
    	Get-XXADUser -manager dehouwed
		Get-XXADUser -manager houwer
		Get-XXADUser -manager nnis
	.PARAMETER user
      	A part of the username or part of the full name
#>
	
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$true)]
		[String[]]$User,
		[String]$Server
	)

	foreach ($item in $user) {
		$userString = "*" + $item + "*"
		if ($server){
			Get-ADUser -Server $server -Filter {Name -like $userString -or GivenName -like $userString -or Surname -like $userString} | select name, givenname, surname, SAMAccountName	
		}
		else {
			Get-ADUser -Filter {Name -like $userString -or GivenName -like $userString -or Surname -like $userString} | select name, givenname, surname, SAMAccountName
		}
		
	}
}

function Get-XXUserLastLoggedOn {
<#
    .SYNOPSIS
    	Search for machines a user or a set of users has last logged on to.
    .DESCRIPTION
	.NOTES
	.LINK
	.EXAMPLE
    	Get-XXUserLastLoggedOn -user dehouwer
	.PARAMETER user
      	The username to check onto which computers he is logged on to.
#>
	[CmdletBinding()]
	param (
		[parameter (Mandatory=$true)]
		[String[]]$User
	)
	
	foreach ($item in $user) {
		gwmi -Computername s-be-ki-sccm1 -Namespace "root\SMS\site_ITG" -Query "select sms_r_system.name,sms_r_system.lastlogonusername from sms_r_system where sms_r_system.LastLogonUserName = `'$item`'" | select lastlogonusername, name
	}
}

function Get-XXComputerLastLoggedOn {
<#
    .SYNOPSIS
    	Search for users that have logged onto a specific computer or set of computers
    .DESCRIPTION
	.NOTES
	.LINK
	.EXAMPLE
    	Get-XXComputerLastLoggedOn -computer l-be-ki-dehouwe
	.PARAMETER user
      	The computername to check for user logins
#>
	[CmdletBinding()]
	param (
		[parameter (Mandatory=$true)]
		[String[]]$Computer
	)
	
	
	foreach ($item in $computer) {
		gwmi -ComputerName s-be-ki-sccm1 -Namespace "root\SMS\site_ITG" -Query "select sms_r_system.name,SMS_R_System.LastLogonUserName, SMS_R_System.LastLogonTimestamp from  SMS_R_System where SMS_R_System.Name = `'$item`'" | select Name, LastLogonUserName, @{name="LastLogonTimestamp";expression={_convertDateSCCM($_.LastLogonTimestamp)}}	
	}
}

function Start-XXRemoteControl {
<#
    .SYNOPSIS
    	Starts a SCCM Remote Control session to a specified computer
    .DESCRIPTION
	.NOTES
	.LINK
	.EXAMPLE
		Start-XXRemoteControl -computer l-be-ki-dehouwe
	.PARAMETER computer
      	The computer to which a remote session is started
#>

	[CmdletBinding()]
	param (
		[parameter (Mandatory=$true)]
		$Computer
	)
	
	Start-Process -FilePath "${env:programfiles(x86)}\Microsoft Configuration Manager\AdminConsole\bin\i386\CmRcViewer.exe" -ArgumentList $computer
}

function Start-XXRadmin {
<#
    .SYNOPSIS
    	Starts a Radmin session to a specified computer
    .DESCRIPTION
	.NOTES
	.LINK
	.EXAMPLE
		Start-XXRadmin -computer l-be-ki-dehouwe
		Start-XXRadmin -computer l-be-ki-dehouwe -port 1234
	.PARAMETER computer
      	The computer to which a remote session is started
	.PARAMETER port
		Specify a different port than the default port (4899)
#>

	[CmdletBinding()]
	param (
		[parameter (Mandatory=$true)]
		$Computer,
		[parameter (Mandatory=$false)]
		$Port
	)
	
	if ($port) {
		Start-Process -FilePath "${env:programfiles(x86)}\Radmin Viewer 3\Radmin.exe" -ArgumentList ("/connect:" + $computer + ":" + $port) 
		}
		else {
		Start-Process -FilePath "${env:programfiles(x86)}\Radmin Viewer 3\Radmin.exe" -ArgumentList ("/connect:" + $computer)
	}
}

