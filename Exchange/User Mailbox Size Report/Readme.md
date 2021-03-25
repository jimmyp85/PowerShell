# Exchange 2010: User Mailbox Size Report

### Introduction
This script produces a user mailbox size report which is then emailed to an email address you specify.

### Parameters to Change
When running this script change the following parameters to suit your own environment:

##### $EmailTo
Enter the email address that wil recieve the report here.
##### $EmailFrom
Enter the email address the report is being sent from.
##### $SMTPServer
Enter the IP or FQDN of your SMTP server to send the email
##### $ReportFileName
Change this to the location and name of the HTML file that will be created
##### $Attachment
This should be changed to the same location as $ReportFileName

### Running the Script
To run the script save in a location on a PC or Server running Exchange 2010 and open the Exchange Management Shell. (EMS)

In EMS change the location to where you have saved the script.
```shell
PS C:\ CD C:\Support
```

Once the location has been change run the script using .\ similar to below:
```shell
PS C:\Support> .\MailboxSizeRpt.ps1
```
Once the script has been run as above an email containing the report will be received by the address specified in the parameters.
