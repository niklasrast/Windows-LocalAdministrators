<#
    .SYNOPSIS 
    Windows 10 Standalone Benutzer
    Dieses Script legt einen Lokalen Admin Account 
    für Windows 10 an.

    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_CreateUser_ladmin_withPassword.ps1

    .ENVIRONMENT
    PowerShell 5.0

    .AUTHOR
    Niklas Rast
#>

$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))
Start-Transcript -path $logFile

$Username = "ladmin"
$Password = "P0mm3s.2021!"

$group = "Administratoren"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never
    
    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add

}
else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE

New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Name "W10_CreateUser_ladmin" -Force
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_CreateUser_ladmin" -Name "Version" -PropertyType "String" -Value "1.0" -Force
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_CreateUser_ladmin" -Name "Revision" -PropertyType "String" -Value "001" -Force
New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_CreateUser_ladmin" -Name "LogFile" -PropertyType "String" -Value "${logFile}" -Force

Stop-Transcript