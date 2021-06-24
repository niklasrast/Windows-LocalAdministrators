<#
    .SYNOPSIS 
    Windows 10 Software packaging wrapper

    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminSolution.ps1 -install
    Uninstall: PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminSolution.ps1 -uninstall
    Detect:    PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminSolution.ps1 -detect

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
	[switch]$uninstall,
	[Parameter(Mandatory = $true, ParameterSetName = 'detect')]
	[switch]$detect
)

$ErrorActionPreference = "SilentlyContinue"
#Use "C:\Windows\Logs" for System Installs and "$env:TEMP" for User Installs
$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))
$HostSerial = ((gwmi win32_bios).SerialNumber)
$Username = "ADM#" + $HostSerial
$Password = "XXXXXXXXXX"

if ($install)
{
    Start-Transcript -path $logFile -Append
        try
        {         
            $group = (gwmi win32_group -filter "LocalAccount = $TRUE And SID = 'S-1-5-32-544'" | select -expand name)

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
        } 
        catch
        {
            $PSCmdlet.WriteError($_)
            return $false
        }
    Stop-Transcript
}

if ($uninstall)
{
    Start-Transcript -path $logFile -Append
        try
        {
            Write-Host "Removing $Username from System $ENV:COMPUTERNAME..."
            Remove-LocalUser -Name $Username -Confirm:$False -Verbose
        }
        catch
        {
            $PSCmdlet.WriteError($_)
            return $false
        }
    Stop-Transcript
}

if ($detect)
{
    Start-Transcript -path $logFile -Append
        try {
            Try {
                $ObjLocalUser = Get-LocalUser $Username
                Write-Verbose "User $($Username) was found"
            }

            Catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
                "User $($Username) was not found" | Write-Warning
            }

            Catch {
                "An unspecifed error occured" | Write-Error
            }
        }
        catch {
            $PSCmdlet.WriteError($_)
            return $false
        }
    Stop-Transcript
}