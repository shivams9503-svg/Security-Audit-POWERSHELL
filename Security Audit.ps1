 $repoPth = "$env:USERPROFILE\Desktop\SecurityAuditReport.txt"
 Start-Transcript -Path $repoPth -Force |Out-Null
 Write-Host "Security Audit Report" -ForegroundColor Cyan
 "Date: $(Get-Date)" 
 Write-Host "Computer: $env:COMPUTERNAME"
 Write-Host "n[1] Windows Version" -Foregroundcolor Blue
$os= Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
Write-Host "Product:$($os.ProductName)"
write-Host "Build:$($os.CurrentBuild)"
Write-Host "n[2] Local User Accounts" -Foregroundcolor DarkBlue
$users = Get-LocalUser | Where-object { $_.Enabled -eq $true}
foreach ($u in $users) {
    Write-Host "Enabled account: $[$u.Name]"
}
Write-Host "Total enabled accounts: $($users.Count)"
Write-Host "n [3]Antivirus Status" -Foregroundcolor DarkGreen
$av = Get-MpComputerStatus
if ($av.AntivirusEnabled -and $av. RealTimeProtectionEnabled){
    Write-Host "pass: Antivirus is enabled and real-time protection is active"
} else {
    Write-Host "fail: Antivirus is not enabled or real-time protection is not active" -ForegroundColor DarkMagenta
}
if ($av.AntivirusSignatureAge -gt 7) {
    Write-Host "Warning:Virus definitions $($av.AntivirusSignatureAge) dinpurani hain" -ForegroundColour Yellow

}else {
    Write-Host "PASS: Virus definitions up to date hain" -ForegroundColor Red
}
Write-Host "n[4] Exection Policy " -ForegroundColor DarkCyan
$policy = Get-ExecutionPolicy
Write-Host "Current policy: $policy"
if ($policy -eq " Unresticted " -or $policy -eq "Bypass") {
    Write-Host "Warning: Execution policy is set to $policy, which may pose a security risk." -ForegroundColor Yellow
} else {
    Write-Host "Execution policy is set to $policy, which is considered secure." -ForegroundColor Green
}
Write-Host "NReport saved to $repoPth" -ForegroundColor DarkYellow
Stop-Transcript | Out-Null