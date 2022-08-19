# Print Server: Printer Status Report
Version 5, August 2022, J Pearman

## Purpose
This script provides basic status information for printers hosted on print servers. It has been written to monitor two print servers but one can be removed or others added depending on your needs.

This provides information on the following:
- Printer name
- Location
- General Status
- Whether the printer is shared
- Whether the printer is published

When run this will create a basic HTML report which will be emailed to you displaying this information in a colour coded table.

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
- Add arguments: This should be the location the .ps1 file is saved in. For example: C:\Support\Scripts\PrintServerRpt.ps1

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
>.\PrintServerRpt.ps1
```
