# Exchange 2010 Public Folders Old Item Report

## Introduction

This script has been written to find items stored within Public Folders on Exchange 2010 that are over X years old. I have written this to look for items older than 6 years but you can change this varriable in the script.

This is useful if you want to declutter Public Folders.

## Parameters to Change

Change the following parameters:

#### $Date
Change the years on this from 6 to what ever you want to report on. You could also chnge the .AddYears to Months or Days if needed.
#### $OldEmailsRpt
Change this to the path the .CSV file will be saved.
#### $HTMLrpt
Change this to the path th .HTML file will be saved
#### $EmailTo
Change this to the email address the report will be sent too.
#### $EmailFrom
Change this to the email address the report is being sent from.
#### $SMTPServer
Enter your SMTP server details here
#### $Attachment
If you want an attachment in your email, then save location of the CSV file above.

## Public Folder Identity

This has been used to report on all Public Folders but you can change this to just be particular folders if you wish. To do this change the -Identity in the code to where you want this to search.
```powershell
Get-PublicFolder -Identity "\" -Recurse -ResultSize Unlimited |
```
## How to Run

You can run this in the Exchange 2010 Management Shell by doing the following:

Change the path on PowerShell to the location of your script
```powershell
> cd \\location of script
```
Run the script in PowerShell
```powershell
>.\Exch2010_OldPFItemsRpt.ps1
```
