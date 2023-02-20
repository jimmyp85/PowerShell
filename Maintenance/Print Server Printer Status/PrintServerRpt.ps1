<#
Print Server: Printer Status Report
J Pearman, August 2022, Version 5

Change Log:
    	V1 - Initial script
    	V2 - Added colour to True, False, Offline, Online results, Added odd/event row shading   
	V3 - Added colour for TonerLow status.
    	V4 - Added additional states
	V5 - Added additional states
#>



# Params
$EmailTo  = "reportto@domain.com"
$EmailFrom = "printers@domain.com"
$EmailSubject = "Daily Printer Report"
$SMTP = "10.10.10.10"
$ReportFileName = "C:\Task\Printers.html"
$Attachment = "C:\Task\Printers.html"

# HTML Table
$Style = "
<style>
    TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
    TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#c2d1f0}
    TD{border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
    tr:nth-child(odd) { background-color:#e6e6e6;} 
    tr:nth-child(even) { background-color:white;}    
</style>
"

#Cell Color - Logic
$StatusColor = @{False = ' bgcolor="#FE2E2E">False<';True = ' bgcolor="#58FA58">True<';Offline = ' bgcolor="#FE2E2E">Offline<';Error = ' bgcolor="#FE2E2E">Offline<';Normal = ' bgcolor="#58FA58">Normal<';PaperOut = ' bgcolor="#FC9704">TonerLow<';TonerLow = ' bgcolor="#FC9704">TonerLow<';NoToner = ' bgcolor="#FE2E2E">NoToner<';}

# Southend Print Server
$prt1 = Get-Printer -ComputerName ps01 |
select @{Name="Printer Name";Expression={$_.Name}},
@{Name="Location";Expression={$_.Location}},
@{Name="Status";Expression={$_.PrinterStatus}},
@{Name="Shared";Expression={$_.Shared}},
@{Name="Published";Expression={$_.Published}} | 

ConvertTo-Html -PreContent "<h2>PS01 Printers</h2>" -Fragment

# Cell Color - Find\Replace
$StatusColor.Keys | foreach { $PS01 = $PS01 -replace ">$_<",($StatusColor.$_) }

# London Print Server
$prt2 = Get-Printer -ComputerName PS02 |
select @{Name="Printer Name";Expression={$_.Name}},
@{Name="Location";Expression={$_.Location}},
@{Name="Status";Expression={$_.PrinterStatus}},
@{Name="Shared";Expression={$_.Shared}},
@{Name="Published";Expression={$_.Published}} | 

ConvertTo-Html -PreContent "<h2>PS02 Printers</h2>" -Fragment

# Cell Color - Find\Replace
$StatusColor.Keys | foreach { $PS02 = $PS02 -replace ">$_<",($StatusColor.$_) }

# Create final report
ConvertTo-HTML -head $Style -PostContent "$prt1 $prt2" -PreContent '<h1>Printer Report</h1>'| Out-File "$ReportFileName"

# Email Report
$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTP -Attachments $Attachment
