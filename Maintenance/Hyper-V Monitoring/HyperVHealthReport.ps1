<#
Hyper-V Health Report
J Pearman, May 2022, Version 3

Description:
This script looks up information on the hyper-v host and virtual machines and then emails this to an address you enter below.

Change Log:
Version 1 -		Initial Script

Version 2 -		Changed test order
			Changed HTML Table to make it clearer
			Added Green/Red colours for test results

Version 3 - 		Added server uptime and last boot date
#>


# Parameters

$EmailTo  = "jdoe@domainad.com"
$EmailFrom = "host01@domain.com"
$EmailSubject = "Hyper-V Daily Status Report for " + $ServerName
$SMTP = "smtp.domain.com"
$ServerName = $env:computername
$ReportFileName = "C:\HyperVRpt.html"
$Attachment = "C:\HyperVRpt.html"


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

$StatusColor = @{False = ' bgcolor="#FE2E2E">False<';True = ' bgcolor="#58FA58">True<';Stopped = ' bgcolor="#FE2E2E">Stopped<';Unknown = ' bgcolor="#FE2E2E">Unknown<';Running = ' bgcolor="#58FA58">Running<';Failed = ' bgcolor="#FE2E2E">Failed<';Passed = ' bgcolor="#58FA58">Passed<';OK = ' bgcolor="#58FA58">OK<';}


# OS and Hardware information - 1

$HostOSHW = Get-ComputerInfo -ErrorAction SilentlyContinue |
Select @{Name="Operating System";Expression={$_.OsName}},
@{Name="Version";Expression={$_.WindowsVersion}},
@{Name="Server Name";Expression={$_.CsName}},
@{Name="Manufacturer";Expression={$_.CsManufacturer}},
@{Name="Model";Expression={$_.CsModel}},
@{Name="Logical Processors";Expression={$_.CsNumberOfLogicalProcessors}},
@{Name="Physical Processors";Expression={$_.CsNumberOfProcessors}},
@{Name="MemGB";Expression={$_.CsTotalPhysicalMemory/1GB -as [int]}},
@{Name="Serial Number";Expression={$_.BiosSeralNumber}},
@{Name="Server Uptime";Expression={$_.OsUptime.ToString("dd\.hh\:mm\:ss")}},
@{Name="Last Bootup";Expression={$_.OsLastBootUpTime}} | 

ConvertTo-Html -PreContent "<h2>OS and Hardware information</h2>" -Fragment

# Hyper-V Services - 2

$HVServices = Get-Service HvHost, vmickvpexchange, vmicguestinterface, vmicshutdown, vmicheartbeat, vmcompute, vmicvmsession, vmicrdv, vmictimesync, vmms, vmicvss |
Select @{Name="Name";Expression={$_.DisplayName}},
@{Name="Status";Expression={$_.Status}} | 

ConvertTo-Html -PreContent "<h2>Hyper-V Services</h2>" -Fragment

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $HVServices = $HVServices -replace ">$_<",($StatusColor.$_) }

# Host HDD info - 3

$HostHDD = Get-Volume -ErrorAction SilentlyContinue |
Select @{Name="Drive";Expression={$_.DriveLetter}},
@{Name="File System";Expression={$_.FileSystem}},
@{Name="Disk Label";Expression={$_.FileSystemLabel}},
@{Name="Health Status";Expression={$_.HealthStatus}},
@{Name="Operational Status";Expression={$_.OperationalStatus}},
@{Name="Volume Size";Expression={$_.Size/1GB -as [int]}},
@{Name="Volume Free Space";Expression={$_.SizeRemaining/1GB -as [int]}} | 

ConvertTo-Html -PreContent "<h2>Host Hard Drive Information</h2>" -Fragment

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $HostHDD = $HostHDD -replace ">$_<",($StatusColor.$_) }

# Virtual Machine Information - 4

$GetVM = Get-VM -ErrorAction SilentlyContinue | Select-Object * |
Select @{Name="Name";Expression={$_.VMName}},
@{Name="State";Expression={$_.State}},
@{Name="Checkpoint Location";Expression={$_.CheckpointFileLocation}},
@{Name="Configuration Location";Expression={$_.ConfigurationLocation}},
@{Name="Cores";Expression={$_.ProcessorCount}},
@{Name="CPU Usage";Expression={$_.CPUUsage}},
@{Name="Memory Assigned GB";Expression={$_.MemoryAssigned/1GB -as [int]}},
@{Name="Memory Demand GB";Expression={$_.MemoryDemand/1GB -as [int]}},
@{Name="Uptime";Expression={$_.Uptime}},
@{Name="Operational Status";Expression={$_.PrimaryOperationalStatus}},
@{Name="Status";Expression={$_.Status}},
@{Name="Version";Expression={$_.Version}},
@{Name="Virtual Machine Type";Expression={$_.VirtualMachineSubType}} | 

ConvertTo-Html -PreContent "<h2>Virtual Machines</h2>" -Fragment

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $GetVM = $GetVM -replace ">$_<",($StatusColor.$_) }

# VM Network Adapters - 5

$VMNet = Get-VMNetworkAdapter -VMName * -ErrorAction SilentlyContinue | Select-Object * |
Select @{Name="Server Name";Expression={$_.VMName}},
@{Name="Virtual Switch";Expression={$_.SwitchName}},
@{Name="IP Address";Expression={$_.IPAddresses}},
@{Name="Status";Expression={$_.Status}},
@{Name="Connected";Expression={$_.Connected}} | 

ConvertTo-Html -PreContent "<h2>VM Network Adapters</h2>" -Fragment

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $VMNet = $VMNet -replace ">$_<",($StatusColor.$_) }

# Detailed VHDX Information - 6

$VHDX_Info = Get-VM -ErrorAction SilentlyContinue | Select-Object VMId | Get-VHD | select-object * |
Select @{Name="VHDX Location";Expression={$_.Path}},
@{Name="Format";Expression={$_.VhdFormat}},
@{Name="Type";Expression={$_.VhdType}},
@{Name="Disk Size GB";Expression={$_.Size/1GB -as [int]}},
@{Name="Attached";Expression={$_.Attached}} | 

ConvertTo-Html -PreContent "<h2>VHDX Information</h2>" -Fragment

    # Cell Color - Find\Replace

$StatusColor.Keys | foreach { $VHDX_Info = $VHDX_Info -replace ">$_<",($StatusColor.$_) }

# Virtual Machine Drive Information - 7

$VMHDD = Get-VM -ErrorAction SilentlyContinue | Get-VMHardDiskDrive | Select-Object * |
Select @{Name="Virtual Machine";Expression={$_.VMName}},
@{Name="VHDX Path";Expression={$_.Path}} | 

ConvertTo-Html -PreContent "<h2>Virtual Machine Drives</h2>" -Fragment


# Hyper-V VM Switch Infomation - 8

$VMSwitch = Get-VMSwitch -ErrorAction SilentlyContinue |
Select @{Name="Name";Expression={$_.Name}},
@{Name="Network Adapter";Expression={$_.NetAdapterInterfaceDescription}},
@{Name="Switch Type";Expression={$_.SwitchType}},
@{Name="Allow Management OS";Expression={$_.AllowManagementOS}} | 

ConvertTo-Html -PreContent "<h2>Virtual Switch Information</h2>" -Fragment


# RAM Details - 9

$HostRAM = Get-ComputerInfo -ErrorAction SilentlyContinue |
Select @{Name="Total Memory GB";Expression={$_.OsTotalVisibleMemorySize/1024/1024 -as [int]}},
@{Name="Free Memory GB";Expression={$_.OsFreePhysicalMemory/1024/1024 -as [int]}},
@{Name="Total Virtual Memory GB";Expression={$_.OsTotalVirtualMemorySize/1024/1024 -as [int]}},
@{Name="Free Virtual Memory GB";Expression={$_.OsFreeVirtualMemory/1024/1024 -as [int]}},
@{Name="Virtual Memory In Use GB";Expression={$_.OsInUseVirtualMemory/1024/1024 -as [int]}},
@{Name="Stored in Page File GB";Expression={$_.OsSizeStoredInPagingFiles/1024/1024 -as [int]}},
@{Name="Page File Free GB";Expression={$_.OsFreeSpaceInPagingFiles/1024/1024 -as [int]}},
@{Name="Page Files";Expression={$_.OsPagingFiles}} | 

ConvertTo-Html -PreContent "<h2>Memory Details</h2>" -Fragment

# Hyper-V Events - 10

$SystemLogs = Get-EventLog -LogName System -EntryType Error, Warning -After (Get-Date).AddHours(-24) -ErrorAction SilentlyContinue |
Select @{Name="Time Generated";Expression={$_.TimeGenerated}},
@{Name="Type";Expression={$_.EntryType}},
@{Name="Source";Expression={$_.Source}},
@{Name="Event ID";Expression={$_.InstanceId}},
@{Name="Server";Expression={$_.MachineName}} | 

ConvertTo-Html -PreContent "<h2>System Events</h2>" -Fragment

$AppLogs = Get-EventLog -LogName Application -EntryType Error, Warning -After (Get-Date).AddHours(-24) -ErrorAction SilentlyContinue |
Select @{Name="Time Generated";Expression={$_.TimeGenerated}},
@{Name="Type";Expression={$_.EntryType}},
@{Name="Source";Expression={$_.Source}},
@{Name="Event ID";Expression={$_.InstanceId}},
@{Name="Server";Expression={$_.MachineName}} | 

ConvertTo-Html -PreContent "<h2>Application Events</h2>" -Fragment

# Create HTML Report

ConvertTo-HTML -Body "$HostOSHW $HVServices $HostHDD $GetVM $VMNet $VHDX_Info $VMHDD $VMSwitch $HostRAM $SystemLogs $AppLogs" -Head $Table | Out-File "$ReportFileName"

# Email Report

$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTP -Attachments $Attachment
