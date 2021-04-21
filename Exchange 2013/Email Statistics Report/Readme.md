# Exchange 2013 Email Statistics Report

## Introduction

This is script has been created by amending and adding code to suit what I needed it to do.

This script provides information on the following between specified dates and times on Exchange 2013:

- Number of Sent Emails
- Size of Sent Emails
- Size of the Largest Sent Email
- Average Size of Sent Emails
- Quantity of Incoming Emails
- Size of Incoming Emails
- Size of the Largest Incoming Email
- Average Size of Incoming Email
- Overall Quantity of Emails
- Overall Size of Emails

This should be run on an Exchange 2013 server or computer running the Exchange 2013 management tools. Once run the report will be emailed to an address specified in the parameters.

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
#### $Start
Change this to the date and time you want to start reporting from. This is currently in MM/DD/YYYY format.
#### $End
Change this to the date and time you want to stop reporting from. This is currently in MM/DD/YYYY format.

## How to Run

You can run this in the Exchange 2013 Management Shell by doing the following:

Change the path on PowerShell to the location of your script
```powershell
> cd \\location of script
```
Run the script in PowerShell
```powershell
>.\Exch2013MailStats.ps1
```
