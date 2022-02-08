<#
User Password Expiry Report
J Pearman, February 2022, Version 1

Description:
Generates list of users in particular AD OU and when their passwords are due to expire.

#>

# Parameters

$EmailTo  = "jdoe@domain.com"
$EmailFrom = "dc@domain.com"
$EmailSubject = "Staff Password Expiry Dates"
$SMTP = "smtp.domain.com"
$ReportFileName = "C:\tmp\PwExpRpt.html"
$Attachment = "C:\tmp\PwExpRpt.html"
$FirstOU = "OU=Users,OU=OrgUnit2,OU=OrgUnit1,DC=DOMAIN,DC=com"
$SecondOU = "OU=Users,OU=OrgUnitB,OU=OrgUnitA,DC=DOMAIN,DC=com"

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

# Department 1 Staff

$Dept1Users = Get-ADUser -SearchBase $FirstOU -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |

Select @{Name="Name";Expression={$_."Displayname"}},
@{Name="Expiry Date";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | 

Sort-Object -Property "Expiry Date" |

ConvertTo-Html -PreContent "<h2>Department 1 Staff Password Expirations</h2>" -Fragment

# Department 2 Staff

$Dept2Users = Get-ADUser -SearchBase $SecondOU -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |

Select @{Name="Name";Expression={$_."Displayname"}},
@{Name="Expiry Date";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | 

Sort-Object -Property "Expiry Date" |

ConvertTo-Html -PreContent "<h2>Department 2 Staff Password Expirations</h2>" -Fragment

# Create HTML Report

ConvertTo-HTML -Body "$Dept1Users $Dept2Users" -Head $Table | Out-File "$ReportFileName"

# Email Report

$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTP -Attachments $Attachment
