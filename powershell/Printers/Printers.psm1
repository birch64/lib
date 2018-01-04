function Get-XXFreePrinterPort {
<#
	.SYNOPSIS
		Looks up a custom amount of free IP-addresses spread over all print servers (currently only BE-KI).
	.DESCRIPTION
	.NOTES
	.LINK
	.PARAMETER Amount
		Optional parameter to specify only the top amount results of the query
	.EXAMPLE
		Get-XXFreePrinterPort -amount 5
	.NOTES
#>	
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$false)]
		[string]$Amount,
		[parameter(Mandatory=$false)]
		[string]$Site = "BE-KI"
	)
		
	$DBServer = "s-be-ki-sql42.ktn.group\sql42"
	$DBName = "sql_o_ict_logging"
	
	try {
		$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
		$sqlConnection.ConnectionString = "Server=$DBServer;Database=$DBName;Integrated Security=SSPI;"
		$sqlConnection.Open()					
	}
	
	catch {}
	
	$sqlcmd = $sqlConnection.CreateCommand()
	if ($amount) {
		$sqlcmd.CommandText = "select top " + $amount + " freeprinterport from dbo.freeprinterports where site = '" + $site + "' order by counter"
		}
		else {
		$sqlcmd.CommandText = "select freeprinterport from dbo.freeprinterports where site = '" + $site + "' order by counter"
	}
	
	try { 
		$result = $sqlcmd.ExecuteReader()
		
		$table = new-object “System.Data.DataTable”
		$table.Load($result)
		
		$table |% { Write-Host $_.freeprinterport }		
	}
	
	catch {}
	
	$sqlConnection.Close()	
}

function Get-XXFreePrinterName {
<#
	.SYNOPSIS
	Looks up a custom amount of printernames spread over all print servers (currently only BE-KI).
	.DESCRIPTION
	.NOTES
	.LINK
	.PARAMETER Amount
		Optional parameter to specify only the top amount results of the query
	.EXAMPLE
		Get-XXFreePrinterName -amount 5
	.NOTES
#>	
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$false)]
		[string]$Amount,
		[parameter(Mandatory=$false)]
		[string]$Site = "BE-KI"
	)
		
	$DBServer = "s-be-ki-sql42.ktn.group\sql42"
	$DBName = "sql_o_ict_logging"
	
	try {
		$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
		$sqlConnection.ConnectionString = "Server=$DBServer;Database=$DBName;Integrated Security=SSPI;"
		$sqlConnection.Open()					
	}
	
	catch {}
	
	$sqlcmd = $sqlConnection.CreateCommand()
	if ($amount) {
		$sqlcmd.CommandText = "select top " + $amount + " freeprintername from dbo.freeprinternames where freeprintername like 'P-" + $site + "-%' order by counter"
		}
		else {
		$sqlcmd.CommandText = "select freeprintername from dbo.freeprinternames where freeprintername like 'P-" + $site + "-%' order by counter"
	}
	
	try { 
		$result = $sqlcmd.ExecuteReader()
		
		$table = new-object "System.Data.DataTable"
		$table.Load($result)
		
		$table |% { Write-Host $_.freeprintername }		
	}
	
	catch {}
	
	$sqlConnection.Close()	
}

function Get-XXPrinterDriver  {
<#
	.SYNOPSIS
	Looks up the drivers installed on printservers
	.DESCRIPTION
	.NOTES
	.LINK
	.PARAMETER Server
		Optional parameter to filter on server
	.EXAMPLE
		Get-XXPrinterDriver -Server s-be-ki-print1, s-be-ki-print2
	TBD
	.NOTES
#>	
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$false)]
		[string[]]$Servers
	)
		
	$DBServer = "s-be-ki-sql42.ktn.group\sql42"
	$DBName = "sql_o_ict_logging"
	
	try {
		$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
		$sqlConnection.ConnectionString = "Server=$DBServer;Database=$DBName;Integrated Security=SSPI;"
		$sqlConnection.Open()					
	}
	
	catch {}
	
	$sqlcmd = $sqlConnection.CreateCommand()
	if ($servers) {
		$sqlserver = ""
		foreach ($server in $servers)
		{
			$sqlserver += "'" + $server + "',"
		}
		$sqlserver = $sqlserver -replace ".$"
		$sqlcmd.CommandText = "select * from dbo.installedprintdrivers where server IN (" + $sqlserver + ")"
	}
		else {
		$sqlcmd.CommandText = "select * from dbo.installedprintdrivers"
	}
	
	try { 
		$result = $sqlcmd.ExecuteReader()
		
		$table = new-object “System.Data.DataTable”
		$table.Load($result)
		
		$format = @{expression={$_.server};Label="Server"},@{expression={$_.driver};Label="Driver"},@{expression={$_.architecture};Label="BitSize"},@{expression={$_.Version};Label="Version"},@{expression={$_.manufacturer};Label="Manufacturer"}
		$table | ft	$format -AutoSize
	}
	
	catch {}
	
	$sqlConnection.Close()	
}