# Active Directory User Password Expiry Report
Version 1, February 2022, J Pearman

## Purpose
This basic script has been created to report on when user passwords are due to expire in Active Directory. This has been made to look in two OUs and take the users display name and password expiry date out and into an HTML table which is then emailed to an address you specify.

You don't have to have two OUs you could take one out or copy the code and add more as your network requires. 

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
##### $FirstOU
Enter the first OU you want to get this information from.
##### $SecondOU
Enter the second OU you want to get this information from.

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
- Add arguments: This should be the location the .ps1 file is saved in. For example: C:\Scripts\ADPwrdExpRpt.ps1

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
>.\ADPwrdExpRpt.ps1
```
