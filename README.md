# Managing local admins on Windows 10

![GitHub repo size](https://img.shields.io/github/repo-size/niklasrast/Windows-10-LocalAdministrators)

![GitHub issues](https://img.shields.io/github/issues-raw/niklasrast/Windows-10-LocalAdministrators)

![GitHub last commit](https://img.shields.io/github/last-commit/niklasrast/Windows-10-LocalAdministrators)

This repo contains two powershell scripts to deploy an local administrator account on windows 10 clients. 

INSTALL-LocalAdminWithoutPassword.ps1 creates an local admin account (ladmin) without an password. The password has to be set on first login
INSTALL-LocalAdminWithPassword.ps1 creates an local admin account (ladmin) with an password. The password has to be set in the variable $Password

## Install:
```powershell
C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminWithPassword.ps1 -install
C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminWithoutPassword.ps1 -install
```

## Uninstall:
```powershell
C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminWithPassword.ps1 -uninstall
C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-LocalAdminWithoutPassword.ps1 -uninstall
```

### Parameter definitions:
- -install configures an local admin account named ladmin
- -uninstall removes an local admin account named ladmin
 
## Logfiles:
The scripts create a logfile with the name of the .ps1 script in the folder C:\Windows\Logs.

## Requirements:
- PowerShell 5.0
- Windows 10 or later

# Feature requests
If you have an idea for a new feature in this repo, send me an issue with the subject Feature request and write your suggestion in the text. I will then check the feature and implement it if necessary.

Created by @niklasrast 
