<# 
Exchange 2013 Mobile Device Report
Version 1, May 2021, J Pearman

Description:
This script can be run as a one off or scheduled task to display all active sync devices connected to Exchange 2013 users.

#>

# Parameters
$Date = Get-Date -Format dd/MM/yyyy
$Report = "C:\Support\ScriptOutput\ActSyncDevRpt.html"
$EmailTo = "jdoe@domain.com"
$EmailFrom = "exch@domain.com"
$EmailSubject = "Exchange ActiveSync Device Report " + $Date
$SMTPServer = "Your SMTP Server"


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


# Get device list
$MobileDevice = Get-MobileDevice | Select UserDisplayName,FriendlyName,DeviceOS,DeviceType,DeviceModel,FirstSyncTime,WhenChanged,Guid

	$MobileDevice | ConvertTo-Html -Head $Header > "$Report"

# Email the report

$Body = [System.IO.File]::ReadAllText('C:\Support\ScriptOutput\ActSyncDevRpt.html')

Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -Attachment $Report -SmtpServer $SMTPServer
