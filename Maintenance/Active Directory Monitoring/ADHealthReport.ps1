<#
Active Directory Health Report - Version 3
J Pearman, July 2024

Description:
This script has been written to be run as a scheduled task and create a basic health report on domain controllers and active directory. Once generated the report is then emailed.

This script has been written for two AD sites but more can be added.

Change Log:
Version 1: 	- Initial version
Version 2: 	- Changed section header size 
			- Added colours for pass/fail/true/false to make it easier to read at a glance
			- Changed HTML table
Version 3: 	- Fixed bug with running DCDIAG function as Invoke-Command and ScriptBlock

#>

$SiteOne = Get-ADDomainController -Discover -Site SiteOne | foreach { $_.Name }
$SiteTwo = Get-ADDomainController -Discover -Site SiteTwo | foreach { $_.Name }
$EmailTo  = "recipient@domain.com"
$EmailFrom = "adreport@domain.com"
$EmailSubject = "Active Directory Health Report"
$SMTP = "mail.domain.com"
$ReportFileName = "C:\AD_Health\ADReport.html"
$Attachment = "C:\AD_Health\ADReport.html"

# Functions

function Get-ADServices {
	param(
	[string[]]$ComputerName,
    [string]$ServiceName
	)
	$Services='DNS','DFS Replication','Intersite Messaging','Kerberos Key Distribution Center','NetLogon','Active Directory Domain Services'
ForEach ($Service in $Services) {Get-Service $Service}

}

function Get-DcDiag {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainController
    )

    $result = dcdiag /skip:Services /s:$DomainController
    $result | select-string -pattern '\. (.*) \b(passed|failed)\b test (.*)' | foreach {
        $obj = @{
            TestName = $_.Matches.Groups[3].Value
            TestResult = $_.Matches.Groups[2].Value
            Entity = $_.Matches.Groups[1].Value
        }
        [pscustomobject]$obj
    }
    
}

# HTML Table

$Table = @"

<style>
    TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
    TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#c2d1f0}
    TD{border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
    tr:nth-child(odd) { background-color:#e6e6e6;} 
    tr:nth-child(even) { background-color:white;}    
</style>

"@

#Cell Color - Logic
$StatusColor = @{False = ' bgcolor="#FE2E2E">False<';True = ' bgcolor="#58FA58">True<';Stopped = ' bgcolor="#FE2E2E">Stopped<';Running = ' bgcolor="#58FA58">Running<';Failed = ' bgcolor="#FE2E2E">Failed<';Passed = ' bgcolor="#58FA58">Passed<';}

# DC Connectivity Tests

$SiteOneNetTest = Test-NetConnection -ComputerName $SiteOne | Select-Object *
$SiteTwoNetTest = Test-NetConnection -ComputerName $SiteTwo | Select-Object *


$NetResults = $SiteOneNetTest, $SiteTwoNetTest |
Select @{Name="Domain Controller";Expression={$_.ComputerName}},
@{Name="Connected";Expression={$_.PingSucceeded}} |
 ConvertTo-Html -PreContent "<h2>Connectivity Tests</h2>" -Fragment

 # Cell Color - Find\Replace
$StatusColor.Keys | foreach { $SiteOneNetTest = $SiteOneNetTest -replace ">$_<",($StatusColor.$_) }
$StatusColor.Keys | foreach { $SiteTwoNetTest = $SiteTwoNetTest -replace ">$_<",($StatusColor.$_) }

# Site One Tests
    
    # Services

$SouthendServices = Invoke-Command -ComputerName $SiteOne -ScriptBlock ${function:Get-ADServices} | Select-Object Name, DisplayName, Status | 
ConvertTo-Html -PreContent "<h2>Southend Services</h2>" -Fragment

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $SouthendServices = $SouthendServices -replace ">$_<",($StatusColor.$_) }

    # Diags

$SouthDiags = Get-DcDiag -DomainController $SiteOne | Select-Object TestName, TestResult, Entity | 
ConvertTo-Html -PreContent "<h2>Southend DC DIAG</h2>" -Fragment | Out-String

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $SouthDiags = $SouthDiags -replace ">$_<",($StatusColor.$_) }

# Site Two Tests

    # Services

$LondonServices = Invoke-Command -ComputerName $SiteTwo -ScriptBlock ${function:Get-ADServices} | Select-Object Name, DisplayName, Status | 
ConvertTo-Html -PreContent "<h2>London Services</h2>" -Fragment

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $LondonServices = $LondonServices -replace ">$_<",($StatusColor.$_) }

    # Diags

$LondonDiags = Get-DcDiag -DomainController $SiteTwo | Select-Object TestName, TestResult, Entity | 
ConvertTo-Html -PreContent "<h2>London DC DIAG</h2>" -Fragment | Out-String

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $LondonDiags = $LondonDiags -replace ">$_<",($StatusColor.$_) }

# Report Build

ConvertTo-Html -PreContent '<h1>AD Health Report</h1>' -PostContent "$NetResults $SouthendServices $SouthDiags $LondonServices $LondonDiags" -Head $Table -Title "AD Health Report" | Out-File $ReportFileName

# Email Report

$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTP -Attachments $Attachment
