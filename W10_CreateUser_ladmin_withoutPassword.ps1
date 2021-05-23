<#
    .SYNOPSIS 
    Windows 10 Standalone Benutzer
    Dieses Script legt einen Lokalen Admin Account 
    für Windows 10 an.

    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_CreateUser_ladmin_withoutPassword.ps1

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
$Username = "ladmin"
$group = "Administratoren"

if ($install)
{
    Start-Transcript -path $logFile 

	try
	{          
        $installDate = Get-Date -Format dd.MM.yyyy

        New-LocalUser -Name $Username -NoPassword | Add-LocalGroupMember -Group $group

        $Test = Get-LocalGroupMember -Group $group | ? Name -Match $Username

        if ($Test) {
            Write-Output "Benutzer wurde angelegt."
            New-Item "HKLM:\SOFTWARE\LokalAdmins\ladmin" -Force
            New-ItemProperty "HKLM:\SOFTWARE\LokalAdmins\ladmin" -Name "InstallDate" -PropertyType "String" -Value $installDate -Force
            
        }
        else {
            Write-Output "$Username wurde nicht angelegt."
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
        $Test = Get-LocalGroupMember -Group $group | ? Name -Match $Username

        if ($Test) {
            Remove-LocalUser -Name $Username
            Remove-Item "HKLM:\SOFTWARE\LokalAdmins\ladmin" -Force
            
        }
        else {
            Write-Output "$Username existiert nicht."
        }
              
	}
	catch
	{
		$PSCmdlet.WriteError($_)
	}

    Stop-Transcript
}

