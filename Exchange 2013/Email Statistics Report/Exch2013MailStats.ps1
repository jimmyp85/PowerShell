<#
Exchange 2013 Email Statistics Report
April 2021

Description:
This script produces a basic report on inbound and outbound email between specified dates and times.
The code for this has been amended from another version found.

#>


Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

# Parameters

$LocalSvr = $env:COMPUTERNAME
$GetHub = Get-TransportServer
$TodaysDate = Get-Date
$ReportFileName = "C:\Support\EmailStat.html"
$EmailTo = "johndoe@domain.com"
$EmailFrom = "exchrpt@domain.com" 
$EmailSubject = "Email Statistics Report " + $TodaysDate
$SMTPServer = "SMTP_Server"
$Start = "04/16/2021 00:00:00"
$End = "04/16/2021 23:59:59"

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

# Get Received Message Tracking Data

$Receive = $GetHub | Get-MessageTrackingLog -Start $Start -End $End -EventID "RECEIVE" -Resultsize Unlimited | Select Sender,RecipientCount,TotalBytes,Recipients

# Get Sent Message Tracking Data

$Sent = $GetHub | Get-MessageTrackingLog -Start $Start -End $End -EventID "SEND" -Resultsize Unlimited | Select Sender,RecipientCount,TotalBytes

# Get Message Sizes

$RecMess = $Receive | Measure-Object TotalBytes -maximum -minimum -average -sum
$SentMess = $Sent | Measure-Object TotalBytes -maximum -minimum -average -sum

# Overall Quantity

$OverallCount = $RecMess.count + $SentMess.count
$Vol = ($RecMess.sum + $SentMess.sum) / (1024 * 1024)
$Vol = "{0:N2}" -f $Vol + " MB"

# Sent Email

$MSendMB = $SentMess.sum / (1024 * 1024)
$VSend = "{0:N2}" -f $MSendB + " MB"
$BigSend = $SentMess.maximum / (1024 * 1024)
$AvSend = $SentMess.average / 1024

$BigSendMB = "{0:N2}" -f $BigSend + " MB"
$AvSendKB = "{0:N2}" -f $AvSend + " KB"

# Received Email

$MReceiveMB = $RecMess.sum / (1024 * 1024)
$VReceive = "{0:N2}" -f $MReceiveMB + " MB"
$BigReceive = $RecMess.maximum / (1024 * 1024)
$AvReceive = $RecMess.average / 1024

$BigReceiveMB = "{0:N2}" -f $BigReceive + " MB"
$AvReceiveKB = "{0:N2}" -f $AvReceive + " KB"

# Senders

$Senders = $Sent | Group-Object Sender | Sort-Object Count -Descending
$TopSender = $Senders[0].Name
$TopSender += $Senders[0].Count

# Receivers

$Receivers = $Receive | Group-Object Recipients | Sort-Object Count -Descending
$TopReceiver = $Receivers[0]
$TopReceiver

# Results Output

$computer = gc env:computername
$obj = new-object psObject

$obj |Add-Member -MemberType noteproperty -Name "Generated on server" -Value $Computer
$obj |Add-Member -MemberType noteproperty -Name "Start Date" -Value $Start
$obj |Add-Member -MemberType noteproperty -Name "End Date" -Value $End
$obj |Add-Member -MemberType noteproperty -Name "Sent mails" -Value $SentMess.count
$obj |Add-Member -MemberType noteproperty -Name "Size of sent mails" -Value $VSend
$obj |Add-Member -MemberType noteproperty -Name "Size of biggest mail out" -value $BigSendMB
$obj |Add-Member -MemberType noteproperty -Name "Average size out" -value $BigSendMB
$obj |Add-Member -MemberType noteproperty -Name "Quantity incoming mail" -Value $RecMess.count
$obj |Add-Member -MemberType noteproperty -Name "Size of received mails" -Value $VReceive
$obj |Add-Member -MemberType noteproperty -Name "Size of biggest mail in" -value $BigReceiveMB
$obj |Add-Member -MemberType noteproperty -Name "Average size in" -value $AvReceiveKB
$obj |Add-Member -MemberType noteproperty -Name "Overall quantity" -Value $OverallCount
$obj |Add-Member -MemberType noteproperty -Name "Overall size" -Value $Vol

$obj | ConvertTo-HTML -Head $Header > "$ReportFileName"


# Email the Report

$Body = [System.IO.File]::ReadAllText('C:\Support\EmailStat.html')
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $ReportFileName
