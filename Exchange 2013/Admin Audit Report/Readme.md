# Exchange 2013 Admin Audit Report

## Introduction

This script is an amendment of a script I used on Exchange 2010 to report on administative events over the last 24 hours.

This will email a report stating:

- What has been modified
- The command used
- Parameters of the command used
- Modified properties
- Who made the change (caller)
- Whether the this was successful
- Any errors
- Date and time it was done

## Changes

- Date format changes
- Changes to the HTML table format

## Parameters to Change

Change the following parameters:

#### $ReportFileName
Change the location the HTML file is saved in.
#### $EmailTo
Enter the email address the report should be sent too.
#### $EmailFrom
Enter the email address it should be sent from.
#### $SMTPServer
Enter your SMTP server details to send the report via emaail.
#### $yesterday
You may need to change this so it works on the date format of your server.

## Scheduled Task Settings

Ensure the following settings are entered to run as a scheduled task:

#### Action
Start a Program
#### Program/Script
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe
#### Add Arguments
-version 4.0 -NonInteractive -WindowStyle Hidden -command ". 'C:\Program Files\Microsoft\Exchange Server\V15\Bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto; C:\LOCATION\OF\SCRIPT\AdminAuditReport.ps1

## How to Run Manually

You can run this in the Exchange 2013 Management Shell by doing the following:

Change the path on PowerShell to the location of your script
```powershell
> cd \\location of script
```
Run the script in PowerShell
```powershell
>.\AdminAuditReport.ps1
```
