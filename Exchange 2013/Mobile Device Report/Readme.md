# Exchange 2013 Mobile Device Report

## Introduction

This script has been written to create a report on which accounts have mobile devices attached to them and then email you the report.

This should be run on an Exchange 2013 server or computer running the Exchange 2013 management tools.

## Parameters to Change

Change the following parameters:

#### $Report
Change the location the HTML file is saved in.
#### $EmailTo
Enter the email address the report should be sent too.
#### $EmailFrom
Enter the email address it should be sent from.
#### $SMTPServer
Enter your SMTP server details to send the report via email.

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
-version 4.0 -NonInteractive -WindowStyle Hidden -command ". 'C:\Program Files\Microsoft\Exchange Server\V15\Bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto; C:\LOCATION OF SCRIPT\Exch13MobDevRpt.ps1
```

## How to Run Ad-Hoc

You can run this in the Exchange 2013 Management Shell by doing the following:

Change the path on PowerShell to the location of your script
```powershell
> cd \\location of script
```
Run the script in PowerShell
```powershell
>.\Exch13MobDevRpt.ps1
```
