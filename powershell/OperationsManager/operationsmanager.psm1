if ((Get-SCOMManagementGroupConnection | where {$_.ManagementGroupName -eq "KTN_SCOM" -and $_.IsActive -eq $true}) -eq $null) {
	New-SCOMManagementGroupConnection s-be-ki-scom2
}
