<# 
Exchange 2010 Public Folders Old Item Report

This script generates a report listing the emails in a public folder after a specified number of years.

Version: 2
Author: James Pearman
Date: March 2021

Changes from V1:
Set to go through all public folders in the database

#>

$Date = (Get-Date).AddYears(-6) | Get-Date -Format "dd/MM/yyyy"
$OldEmailsRpt = "C:\Support\EmailsOver6Yrs.csv"
$HTMLrpt = "C:\Support\PF_Over6Yrs.html"
$TodaysDate = Get-Date
$EmailTo = "johndoe@domain.com"
$EmailFrom = "from@domain.com"
$EmailSubject = "Public Folder Emails over 6 Years from " + $TodaysDate
$SMTPServer = "SMTP@domain.com"
$Attachment = "C:\Support\EmailsOver6Yrs.csv"

#Create HTML Table

$Style = "<style>"
$Style = $Style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Style = $Style + "TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color: #BDBDBD}"
$Style = $Style + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;}"
$Style = $Style + "</style>"
$Pre = "Public Folder Emails over 6 Years Old"

#Get old PF email data

	
Get-PublicFolder -Identity "\" -Recurse -ResultSize Unlimited | Get-PublicFolderItemStatistics | Where-Object {$_.CreationTime -lt [DateTime]::ParseExact($Date,'dd/MM/yyyy',$Null)} | Select PublicFolderName,Subject,CreationTime,LastModificationTime,MessageSize | Export-Csv "C:\Support\EmailsOver6Yrs.csv" -NoTypeInformation


	
#Convert CSV to HTML

Import-Csv $OldEmailsRpt | ConvertTo-HTML -Head $Style -PreContent $Pre > $HTMLrpt

#Email Report
$Body = [System.IO.File]::ReadAllText('C:\Support\PF_Over6Yrs.html')
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $Attachment
