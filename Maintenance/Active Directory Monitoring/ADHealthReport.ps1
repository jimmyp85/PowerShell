<#
Active Directory Health Report - Version 1
J Pearman, December 2021

Description:
This script has been written to be run as a scheduled task and create a basic health report on domain controllers and active directory. Once generated the report is then emailed.

This script has been written for two AD sites but more can be added or the second removed if you only have one site.

#>

# Parameters

$SiteOne = Get-ADDomainController -Discover -Site "ENTER AD MAIN" | Select Name
$SiteTwo = Get-ADDomainController -Discover -Site "ENTER SECOND AD MAIN"  | Select Name
$EmailTo  = "ENTER ADDRESS RECEIVING"
$EmailFrom = "ENTER ADDRESS SENDING"
$EmailSubject = "Active Directory Health Report"
$SMTP = "ENTER SMTP SVR"
$ReportFileName = "C:\PATH\TO\REPORT\ADReport.html"
$Attachment = "C:\PATH\TO\REPORT\ADReport.html"

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

    $result = dcdiag /s:$DomainController
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

Table {
	border-width: 1px;
	border-style: solid;
	border-color: black;
	border-collapse: collapse;
    
}

TH {
	border-width: 1px;
	border-style: solid;
	border-color: black;
	background-color: #BDBDBD;
}

TD {
	border-width: 1px;
	padding: 4px;
	border-style: solid;
	border-color: black;
}

</style>

"@

# DC Connectivity Tests

$SiteOneNetTest = Test-NetConnection -ComputerName $SiteOne.Name | Select-Object *
$SiteTwoNetTest = Test-NetConnection -ComputerName $SiteTwo.Name | Select-Object *

$NetResults = $SiteOneNetTest, $SiteTwoNetTest |
Select @{Name="Domain Controller";Expression={$_.ComputerName}},
@{Name="Connected";Expression={$_.PingSucceeded}} |
 ConvertTo-Html -PreContent "<h1>Connectivity Tests</h1>" -Fragment

# Site One Tests

$SiteOneServices = Invoke-Command -ComputerName $SiteOne.Name -ScriptBlock ${function:Get-ADServices} | Select-Object Name, DisplayName, Status | 
ConvertTo-Html -PreContent "<h1>Site One Services</h1>" -Fragment

$SiteOneDiags = Invoke-Command -ComputerName $SiteOne.Name -ScriptBlock ${function:Get-DcDiag} -ArgumentList $SiteOne.Name | Select-Object TestName, TestResult, Entity | 
ConvertTo-Html -PreContent "<h1>Site One DC DIAG</h1>" -Fragment | Out-String

# Site Two Tests

$SiteTwoServices = Invoke-Command -ComputerName $SiteTwo.Name -ScriptBlock ${function:Get-ADServices} | Select-Object Name, DisplayName, Status | 
ConvertTo-Html -PreContent "<h1>Site Two Services</h1>" -Fragment

$SiteTwoDiags = Invoke-Command -ComputerName $SiteTwo.Name -ScriptBlock ${function:Get-DcDiag} -ArgumentList $SiteTwo.Name | Select-Object TestName, TestResult, Entity | 
ConvertTo-Html -PreContent "<h1>Site Two DC DIAG</h1>" -Fragment | Out-String

# Report Build

ConvertTo-Html -Body "$NetResults $SiteOneServices $SiteOneDiags $SiteTwoServices $SiteTwoDiags" -Head $Table -Title "AD Health Report" | Out-File $ReportFileName

# Email Report

$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTP -Attachments $Attachment
