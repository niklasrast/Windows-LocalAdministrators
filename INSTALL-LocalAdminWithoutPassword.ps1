<#
    .SYNOPSIS 
    Windows 10 Standalone Admin

    .DESCRIPTION
    Install:   C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminWithoutPassword.ps1 -install
    Uninstall: C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminWithoutPassword.ps1 -uninstall

    .ENVIRONMENT
    PowerShell 5.0

    .AUTHOR
    Niklas Rast
#>

[CmdletBinding()]
param(
	[Parameter(Mandatory = $true, ParameterSetName = 'install')]
	[switch]$install,
	[Parameter(Mandatory = $true, ParameterSetName = 'uninstall')]
	[switch]$uninstall
)

$ErrorActionPreference = 'Stop'
$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))

#Test if registry folder exists
if ($true -ne (test-Path -Path "HKLM:\SOFTWARE\COMPANY")) {
    New-Item -Path "HKLM:\SOFTWARE\" -Name "COMPANY" -Force
}

$Username = "ladmin"
$group = (Get-WmiObject win32_group -filter "LocalAccount = $TRUE And SID = 'S-1-5-32-544'" | Select-Object -expand name)

if ($install)
{
    Start-Transcript -path $logFile 

	try
	{          
        New-LocalUser -Name $Username -NoPassword | Add-LocalGroupMember -Group $group
        $Test = Get-LocalGroupMember -Group $group | Where-Object Name -Match $Username

        if ($Test) {
            Write-Output "User created."
            
            #Register package in registry
            New-Item -Path "HKLM:\SOFTWARE\COMPANY\" -Name "LocalAdminWithoutPassword"
            New-ItemProperty -Path "HKLM:\SOFTWARE\COMPANY\LocalAdminWithoutPassword" -Name "Version" -PropertyType "String" -Value "1.0.0" -Force    
        }
        else {
            Write-Output "$Username created."
        }      
    }
	catch
	{
		$PSCmdlet.WriteError($_)
	}
    Stop-Transcript
}

if ($uninstall)
{
    Start-Transcript -path $logFile
	try
	{
        $Test = Get-LocalGroupMember -Group $group | Where-Object Name -Match $Username

        if ($Test) {
            Remove-LocalUser -Name $Username
            #Remove package registration in registry
            Remove-Item -Path "HKLM:\SOFTWARE\COMPANY\LocalAdminWithoutPassword" -Recurse -Force    
        }
        else {
            Write-Output "$Username does not exists."
        }      
	}
	catch
	{
		$PSCmdlet.WriteError($_)
	}
    Stop-Transcript
}
