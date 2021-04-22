# Exchange Server Admin Audit Report
# This script has been written to report on events in the Exchange server admin audit log over the last 24 hours.
# Version 2.0 -  James Pearman, April 2021


#Parameters

$Date = Get-Date
$yesterday = (Get-Date).AddHours(-24) | Get-Date -Format "MM/dd/yyyy"
$EmailTo = "johndoe@domain.com"
$EmailFrom = "exch@domain.com"
$EmailSubject = "Exchange Server Audit Report " + $Date 
$SMTPServer = "YOUR SMTP SVR"
$ReportFileName = "C:\Support\ExchAdminLog.html"


#Create HTML Table

$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
<title>
"Email Statistics Report"
</title>
"@

#Get Admin Logs

$logs = Search-AdminAuditLog -StartDate $yesterday | Select ObjectModified,CmdletName,@{Expression=

{$_.CmdletParameters};Label="CmdletParameters";},@{Expression={$_.ModifiedProperties};Label="ModifiedProperties";},Caller,Succeeded,Error,RunDate

$Logs | ConvertTo-HTML -Head $Header > "$ReportFileName"

#Send Email

$Body = [System.IO.File]::ReadAllText('C:\Support\ExchAdminLog.html')
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -Attachment $ReportFileName -SmtpServer $SMTPServer
