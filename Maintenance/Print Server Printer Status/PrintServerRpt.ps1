<#
Print Server: Printer Status Report
J Pearman, January 2022, Version 2

Change Log:
    V1 - Initial script
    V2 - Added colour to True, False, Offline, Online results
         Added odd/event row shading   

#>



# Params
$EmailTo  = "jdoe@domain.com"
$EmailFrom = "printers@domain.com"
$EmailSubject = "Daily Printer Report"
$SMTP = "smtp.domain.com"
$ReportFileName = "C:\Temp\Printers.html"
$Attachment = "C:\Temp\Printers.html"

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
$StatusColor = @{False = ' bgcolor="#FE2E2E">False<';True = ' bgcolor="#58FA58">True<';Offline = ' bgcolor="#FE2E2E">Offline<';Normal = ' bgcolor="#58FA58">Normal<';}

# Site 1 Print Server
$PrintSvr1 = Get-Printer -ComputerName Printers01 |
select @{Name="Printer Name";Expression={$_.Name}},
@{Name="Location";Expression={$_.Location}},
@{Name="Status";Expression={$_.PrinterStatus}},
@{Name="Shared";Expression={$_.Shared}},
@{Name="Published";Expression={$_.Published}} | 

ConvertTo-Html -PreContent "<h2>Printers01 Printers</h2>" -Fragment

# Cell Color - Find\Replace
$StatusColor.Keys | foreach { $PrintSvr1 = $PrintSvr1 -replace ">$_<",($StatusColor.$_) }

# Site 2 Print Server
$PrintSvr2 = Get-Printer -ComputerName Printers02 |
select @{Name="Printer Name";Expression={$_.Name}},
@{Name="Location";Expression={$_.Location}},
@{Name="Status";Expression={$_.PrinterStatus}},
@{Name="Shared";Expression={$_.Shared}},
@{Name="Published";Expression={$_.Published}} | 

ConvertTo-Html -PreContent "<h2>Printers02 Printers</h2>" -Fragment

# Cell Color - Find\Replace
$StatusColor.Keys | foreach { $PrintSvr2 = $PrintSvr2 -replace ">$_<",($StatusColor.$_) }

# Create final report
ConvertTo-HTML -head $Style -PostContent "$PrintSvr1 $PrintSvr2" -PreContent '<h1>Printer Report</h1>'| Out-File "$ReportFileName"

# Email Report
$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTP -Attachments $Attachment
