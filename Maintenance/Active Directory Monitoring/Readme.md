# Active Directory Monitoring Script
J Pearman, Version 2, January 2022

## Purpose
This script has been written to run as a scheduled take and report daily on the general health of your domain controllers.

This will check and provide a pass (or true) or fail (or false) on the following:

- Network connectivity
- Services
	* DNS
	* DFS Replication
	* Intersite Messaging
	* Kerberos Key Distribution Center
	* NetLogon
	* Active Directory Domain Services

- DC Diag
	* Connectivity
	* Advertising
	* FrsEvent
	* DFSREvent
	* SysVolCheck
	* KccEvent
	* KnowsOfRoleHolders
	* MachineAccount
	* NCSecDesc
	* NetLogons
	* ObjectsReplicated
	* Replications
	* RidManager
	* Services
	* SystemLog
	* VerifyReferences
	* CheckSDRefDom
	* CheckSDRefDom
	* CheckSDRefDom
	* CrossRefValidation
	* CheckSDRefDom
	* CrossRefValidation
	* CheckSDRefDom
	* CrossRefValidation
	* LocatorCheck
	* Intersite

Once the tests have been completed an HTML report will be created and emailed to you.

This script has been written for two AD sites (as that's what I have and wrote it for) but you can take one of these out or add more as required.

Please note: You will need the Active Directory module installed on the machine you run this on. It's better not to run on a DC but rather a seperate PC/Server running the AD module.

## Change Log
Version 1: Initial version
Version 2: Changed section header size 
           Added colours for pass/fail/true/false to make it easier to read at a glance
           Changed HTML table

##  Parameters to Change
The following parameters need to be changed in the script:

##### $SiteOne
Enter the name of your primary AD site after -Site
##### $SiteTwo
Enter the name of your second AD site after -Site
##### $EmailTo
Enter the email address the report is to be sent to.
##### $EmailFrom
Enter the email address the report is to be sent from.
##### $SMTP
Enter the IP/Hostname of your SMTP server
##### $ReportFileName
Enter the path to save the HTML report to.
##### $Attachment
Enter the path to attache the HTML report to the email from.

## Scheduled Task Settings
The following settings should be set in Windows Task Scheduler.
##### General
- Should be run under and administrator account
- Run with highest privileges
- Run whether user is logged on or not

##### Triggers
Set this to run at the frequancy you desire. For example you could run this daily at 0800 every day.
##### Actions
- Action: Start a program
- Program/Script: %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe
- Add arguments: This should be the location the .ps1 file is saved in. For example: C:\Support\Scripts\ADHealthReport.ps1.ps1

##### Conditions, Settings & History
These can be left at default or changes for your own needs.

##### Testing
Once you have set your sceduled task up run it to make sure it works

## Running the script
The script can be run from a PowerShell console as well as with a scheduled task. To do this change the console location to the location of your script.
```powershell
>cd C:\ScriptLocation
```
Then run the script with .\ like below.
```powershell
>.\ADHealthReport.ps1
```
