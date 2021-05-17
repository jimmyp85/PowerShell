# Exchange 2013 New Mobile Device Alerts / Monitor

## Introduction

This script has been written to send an email showing what new mobile devices have been added to users mailboxes within the last 24 hours. This works by runnning the script as a scheduled task hich runs it once a day.

This was written for and tested on an Exchange 2013 on-prem server.

## Parameters to Change

Change the following parameters:

#### $Date
This has been set to the last 1 day but you can change this if you want to report further back
#### $Server
Change this to the name of your Exchange server.
#### $EmailTo
Enter the email address the report should be sent too.
#### $EmailFrom
Enter the email address it should be sent from.
#### $SMTPServer
Enter your SMTP server details to send the report via email.
#### $Report
Change the location the HTML file is saved in.


## Set as a Scheduled Task

This script can be set as a scheduled task using the following action settings:

#### Action
Set this as Start a Program

#### Program/Script
Enter the following for PowerShell:
```
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe
```
#### Add Arguments
Enter the following to run this script in EMS:
```
-version 4.0 -NonInteractive -WindowStyle Hidden -command ". 'C:\Program Files\Microsoft\Exchange Server\V15\Bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto; C:\LOCATION OF SCRIPT\NewMobDevAlrt.ps1
```

## How to Run Ad-Hoc

You can run this in the Exchange 2013 Management Shell by doing the following:

Change the path on PowerShell to the location of your script
```powershell
> cd \\location of script
```
Run the script in PowerShell
```powershell
>.\NewMobDevAlrt.ps1
```
