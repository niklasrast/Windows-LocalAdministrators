# Managing local admins on Windows 10

This repo contains two powershell scripts to deploy an local administrator account on windows 10 clients. 

W10_CreateUser_ladmin_withoutPassword.ps1 creates an local admin account (ladmin) without an password. The password has to be set on first login

W10_CreateUser_ladmin_withPassword.ps1 creates an local admin account (ladmin) with an password. The password has to be set in the variable $Password

## Install:
```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_CreateUser_ladmin.ps1
PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_CreateUser_ladmin_withoutPassword.ps1 -install

...
```

## Uninstall:
```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_CreateUser_ladmin_withoutPassword.ps1 -uninstall
...
```

### Parameter definitions:
- -install configures an local admin account named ladmin
- -uninstall removes an local admin account named ladmin
 
## Logfiles:
The scripts create a logfile with the name of the .ps1 script in the folder C:\Windows\Logs.

## Requirements:
- PowerShell 5.0
- Windows 10
- 

Created by @niklasrast 