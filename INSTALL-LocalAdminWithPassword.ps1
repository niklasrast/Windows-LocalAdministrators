<#
    .SYNOPSIS 
    Windows 10 Standalone Admin

    .DESCRIPTION
    Install:   C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminWithPassword.ps1 -install
    Uninstall: C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminWithPassword.ps1 -uninstall

    .ENVIRONMENT
    PowerShell 5.0

    .AUTHOR
    Niklas Rast
#>

$ErrorActionPreference = 'Stop'
$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))

#Test if registry folder exists
if ($true -ne (test-Path -Path "HKLM:\SOFTWARE\OS")) {
    New-Item -Path "HKLM:\SOFTWARE\" -Name "OS" -Force
}

Start-Transcript -path $logFile

$Username = "ladmin"
$Password = "P444w0rd1234."

$group = (Get-WmiObject win32_group -filter "LocalAccount = $TRUE And SID = 'S-1-5-32-544'" | Select-Object -expand name)

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | Where-Object {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($null -eq $existing) {

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

#Register package in registry
New-Item -Path "HKLM:\SOFTWARE\OS\" -Name "LocalAdminWithPassword"
New-ItemProperty -Path "HKLM:\SOFTWARE\OS\LocalAdminWithPassword" -Name "Version" -PropertyType "String" -Value "1.0.0" -Force 

Stop-Transcript