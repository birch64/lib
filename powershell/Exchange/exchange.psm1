if ((Get-PSSession | where {$_.configurationname -eq "Microsoft.Exchange"}) -eq $null) {
	Write-Host "Loading Exchange Shell"
	. 'c:\Program Files\Microsoft\Exchange Server\V15\Bin\RemoteExchange.ps1'
	Connect-ExchangeServer -auto
}
