<#
New Mobile Device Alerts / Monitor
J Pearman, May 2021, Version 1

Description:
This script can be set as a scheduled task on an Exchange 2013 server to run every 24 hours to report on any new mobile devices added to user accounts within the last 24 hours.

#>

# Parameters

$Date = ((Get-Date).AddDays(-1))
$RptDate = Get-Date -Format dd/MM/yyyy
$Server = "EXCHANGE"
$EmailTo = "johndoe@domain.com"
$EmailFrom = "exch@domain.com"
$EmailSubject = "New Mobile Device Detected " + $RptDate
$SMTPServer = "YOUR SMTP SERVER"
$Report = "C:\LOCATION\NewActSynDev.html"


# HTML Table

$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
<title>
"ActiveSync Devices Report"
</title>
"@

# Report on Mobile Devices

$MobileDevices = @(Get-MobileDevice | Where-Object {$_.WhenCreated -gt $Date}) | Select-Object @{Name='User';Expression={(Get-Mailbox -Identity $_.UserDisplayName) | Select-Object -expand WindowsEmailAddress}},DeviceType,DeviceOS,DeviceUserAgent,DeviceModel,WhenCreated,GUID

$CountResults = ($MobileDevices).Count

If ($CountResults -gt 0) {
	
	$MobileDevices | ConvertTo-Html -Head $Header > "$Report"
	
	$Body = [System.IO.File]::ReadAllText('C:\LOCATION\NewActSynDev.html')
	Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -Attachment $Report -SmtpServer $SMTPServer
	
}

ElseIf ($CountResults -eq 0) {

	Send-MailMessage -To $EmailTo -From $EmailFrom -Subject "Mobile Devices $RptDate" -Body "No new mobile devices detected" -BodyAsHtml -SmtpServer $SMTPServer
	
}
