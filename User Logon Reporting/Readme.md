# User Logon Report Script
J Pearman, Version 2, February 2023

## Purpose
This script has been written to export a users logon, logoff, lock and unlock events for the purpose of creating a report showing these events.

The following events are exported:
* 4624 - User Logon (interactive only)
* 4624 - User Logon (cached interactive)
* 4647 - User Logoff
* 4800 - Computer Locked
* 4801 - Computer Unlocked

Once exported these events are merged into a single CSV file where they can be viewed together.

## Change Log
Version 1: Initial version
Version 2: Added extraction of cached interactive logon events.

## Running the Script
The script can be run from PowerShell on a local computer or on a remote computer using `Invoke-Command`. 

To run the script locally change the console location to the location of the .ps1 file.
```powershell
>cd C:\ScriptLocation
```

Then run the script with .\ like below.
```powershell
>.\UserLogonEvents.ps1
```

If this is being run on a remote computer then in this scripts current version you will need access to the remote computers C: drive to retrieve the generated .csv files.

## Planned Improvements in Version 3

I am aiming to make the following improvements in the next version:
* Start and End date options for when events were created
* Better support for reporting on remote computers
* Improve .csv file management
