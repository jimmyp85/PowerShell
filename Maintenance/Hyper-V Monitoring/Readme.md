# Hyper-V Monitoring Script
J Pearman, May 2022, Version 3

## Purpose
This script has been written to provide basic monitoring and auditing of Hyper-V hypervisors and the virtual machines they are running.

This provides information on the following:
- OS and Hardware information
- Host Memory and Storage
- Hyper-V Services
- Virtual Switches
- Virtual Machines
- Virtual HDD's
- Virtual Machine Networking
- Host System and Application event logs

## Change Log
#### Version 1 	
- Initial Script

#### Version 2 	
- Changed test order
- Changed HTML Table to make it clearer
- Added Green/Red colours for test results

#### Version 3
- Added server uptime and last boot date and time.

##  Parameters to Change
The following parameters need to be changed in the script:

##### $EmailTo
Change this to the email address receiving the report.
##### $EmailFrom
Change this to an email address sending the report.
##### $SMTP
Enter your SMTP server IP or Hostname.
##### $ReportFileName
Enter the file path to save the report.
##### $Attachment
Enter the file path of the report.

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
- Add arguments: This should be the location the .ps1 file is saved in. For example: C:\Support\Scripts\HyperVHealthReport.ps1

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
>.\HyperVHealthReport.ps1
```
