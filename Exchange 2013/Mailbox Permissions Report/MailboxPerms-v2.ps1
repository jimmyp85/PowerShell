<# 
Mailbox Permissions Report - Version 2

Description:
This is the second version of a script to report on full access user permissions for Microsoft Exchange. This was first written for Exchange 2010 and has been slightly improved to fit my needs. This also runs on Exchange 2013.

Version History:
Version 1 - January 2019
Version 2 - June 2021

J Pearman
#>

# Parameters 
$EmailTo = "johndoe@domain.com"
$EmailFrom = "exchperms@domain.com"
$EmailSubject = "Mailbox Permissions Report for " +$Month
$SMTPServer = "YOUR SMTP SVR"
$Month = (Get-Culture).DateTimeFormat.GetMonthName((Get-Date).Month)
$Date = Get-Date
$Computer = "exchange.domain.com"
$Attachment = "C:\MailboxPerms.csv"
$HtmlReport = "C:\MailboxPerms.html"


# HTML Table
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
<title>
"Mailbox Permissions Report"
</title>
"@

# Report Generation
$MailboxPermissions = Get-Mailbox | Get-MailboxPermission | where { ($_.AccessRights -eq "FullAccess") -and ($_.IsInherited -eq $false) -and -not ($_.User -like "NT AUTHORITY\SELF") } | Select {$_.AccessRights}, Deny, InheritanceType, User, Identity, IsInherited, IsValid

$MailboxPermissions | Export-Csv "C:\MailboxPerms.csv" -NoTypeInformation

$MailboxPermissions | ConvertTo-HTML -Head $Header > "$HtmlReport"

# Send Email
$Body = [System.IO.File]::ReadAllText('C:\MailboxPerms.html')
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -Attachments $Attachment -SmtpServer $SMTPServer
