<#
Exchange 2010: Mailbox Size Report

Version: 1 
Auther: James Pearman
date: March 2021

Description:
This script has been written to produce and email a report on the user mailbox sizes on Exchange 2010.

#>

#Parameters

$Date = Get-Date
$EmailTo = "johndoe@domain.com"
$EmailFrom = "from@domain.com"
$EmailSubject = "Exchange 2010 Mailbox Size Report " + $Date
$SMTPServer = "smtp.domain.com"
$ReportFileName = "C:\Support\MailboxSize.html"
$Attachment = "C:\Support\MailboxSize.html"


#Create HTML Table

$Style = "<style>"
$Style = $Style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Style = $Style + "TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color: #BDBDBD}"
$Style = $Style + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;}"
$Style = $Style + "</style>"
$Pre = "Exchange 2010 Mailbox Size Report"

#Get Mailbox Size informaation

$MailboxSize = Get-Mailbox -ResultSize unlimited | Get-MailboxStatistics | select DisplayName,TotalItemSize,Itemcount

$MailboxSize | ConvertTo-HTML -Head $Style -PreContent $Pre > "$ReportFileName"

#Email report

$Body = [System.IO.File]::ReadAllText('C:\Support\MailboxSize.html')
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $Attachment
