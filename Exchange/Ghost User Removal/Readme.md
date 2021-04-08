# Ghost User Removal

## Introduction

This, very basic couple of lines, removes old user SIDs from Exchange 2010 Public Folders. Old SIDs can be left behind over time and can cause problems when migrating from Exchange 2010 to a newer version

## Public Folder Identity

This has been used to report on all Public Folders but you can change this to just be particular folders if you wish. To do this change the this part of the code:
```powershell
Get-PublicFolder "\" -Recurse -Resultsize unlimited|
```
## How to Run

This should be run in the Exchange Management Shell by doing the following:

Change the path on PowerShell to the location of your script
```powershell
> cd \\location of script
```
Run the script in PowerShell
```powershell
>.\GhostUserRemoval.ps1
```
