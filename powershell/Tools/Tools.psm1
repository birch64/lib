function get-XXExpiringCertificates {
<#
	.SYNOPSIS
    Lists all certificates that expire given a certain template and date range. 
    .DESCRIPTION
    Lists all certificates that expire given a certain template and date range
    .PARAMETER days	
    Nr of days till expiring
    .PARAMETER template
    the certificate template to look for (default: webserver)
    .PARAMETER email
	alert via Email 
	.PARAMETER emailaddress
	who to email. 
	.PARAMETER certconfig 
	which server\CA to check - defaults to S-BE-KI-CTA.ktn.group\S-BE-KI-CA
    .EXAMPLE
	get-XXExpiringCertificates -days 10 -template webserver -email dennis.dehouwer@katoennatie.com
	find all webserver certs that will expire in the next 10 days and notify dennis
    .NOTES
#>
    
	[CmdletBinding()]
            param 
			(
            	[parameter(Mandatory=$false)]
          		[string]$days = 10,
				[parameter(Mandatory=$false)]
          		[string]$template = "webserver",
				[parameter(Mandatory=$false)]
          		[switch]$mail,
				[parameter(Mandatory=$false)]
          		[string[]]$emailaddress,
				[parameter(Mandatory=$false)]
				[string]$certconfig = "S-BE-KI-CTA.ktn.group\S-BE-KI-CA"
			)
				$username = $env:USERNAME
				$displayname = Get-ADUser $username | select name
				if (!($emailaddress)) {
					$emailaddress = "dennis.dehouwer@katoennatie.com","it_notification@katoennatie.com"
				}
				#if (!(Get-ADGroupMember "Domain Admins" | select Name |? {$_.Name -eq "$displayname"})) {Write-Host "you need to be a domain admin, quiting";break}
				if (!(Test-Path c:\certs)) { mkdir c:\certs }
				$arglist = '-config "{0}" -view csv' -f $certconfig
				start-process -FilePath "c:\Windows\System32\certutil.exe"  -ArgumentList "$arglist" -RedirectStandardOutput "c:\certs\certs.csv" -Wait
				$culturename = (Get-Culture).name
				$certinfo = import-csv "c:\certs\certs.csv"
				$fields = "Issued Distinguished Name","Issued Common Name","Certificate Expiration Date","Certificate Hash","Certificate Template","Serial Number"
				$now = Get-Date
				foreach ($cert in $certinfo) 
					{
						#Write-Host "bla"
						$certdate = ""
						$certdateStr= ""
						$certdate =""
						$diffdate =""
						$body =""
						$servername = ""
						$certhash = ""
						$certserial = ""
						$certvalid = ""
						$subject = ""
						#IF ($cert."Certificate Template" -eq "$template")
						#	{
							#write-host "-" $cert."Certificate Expiration Date" "-" -ForegroundColor Green
							if (($cert."Certificate Expiration Date") -and ($cert."Certificate Expiration Date" -ne "EMPTY"))
								{
								#check if cert is valid before doing anything else
								$certhash = $cert."Certificate Hash"
								$certvalid = & "c:\Windows\System32\certutil.exe" -config "$certconfig" -isvalid "$certhash"
								if ($certvalid -match "is valid")
									{
										#Write-Host "Test-Connection " $cert."Issued Common Name" "-Quiet -Count 1"
										$certdateStr= ($cert."Certificate Expiration Date").split(" ")[0]
										#should fix this properly but life is too short and we only support en-GB and en-US language settings on our domain :) 
										if ($culturename -eq "nl-BE")
											{
												$certd,$certm,$certy = $certdateStr.split("/")
											}
										elseif ($culturename -eq "en-US")
											{
												$certm,$certd,$certy = $certdateStr.split("/")
											}
										else {
												Write-Host "only nl-BE and en-US language/date formatting supported, Quiting"
												break
											}
										$certdate = New-Object system.datetime($certy,$certm,$certd)
										$diffdate = $certdate - $now
										if (($diffdate.days -gt 0) -AND ($diffdate.days -lt $days)) 
											{
												
												Write-Host "Cert almost expiring" -ForegroundColor Yellow
												foreach ($field in $fields) 
													{
														
														if ($field -eq "Issued Common Name") {$servername = $cert."$field"}
														#Write-Host $field -ForegroundColor gray; Write-Host $servername -ForegroundColor blue}
														$msg = "{0} : {1}" -f $field, $cert."$field"
														$body += "`n" + $msg + "`n"
														write-host $msg
													}
												if ($mail) 
													{	
														$subject = "{0}: {1} Certificate about to Expire" -f $servername, $template
														Send-MailMessage -From "CertificateDrone@katoennatie.com" -To $emailaddress -Body $body -SmtpServer "s-be-ki-smtp.ktn.group" -Subject $subject #-Encoding ([System.Text.Encoding]::UTF8)
													}
												write-host ""
											#end if $diffdate.days .... 
											}
									#end if $cervalid -match "is valid"
									}
								#end if cert expirtation date -ne EMPTY
								}
							#end IF Certification Template -eq $template
							#}
					#end foreach $certinfo
					}
			
	#end function 
	}