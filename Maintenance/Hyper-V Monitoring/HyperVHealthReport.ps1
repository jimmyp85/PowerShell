<#
Hyper-V Health Report
J Pearman, December 2021, Version 1

Description
This script looks up information on the hyper-v host and virtual machines and then emails this to an address you enter below.

#>


# Parameters

$EmailTo  = "ENTER RECPT"
$EmailFrom = "ENTER SENDER"
$EmailSubject = "Hyper-V Daily Status Report for " + $ServerName
$SMTP = "ENTER SMTP SVR"
$ServerName = "$env:computername"
$ReportFileName = "ENTER FILE PATH\HyperVRpt.html"
$Attachment = "ENTER FILE PATH\HyperVRpt.html"


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

# OS and Hardware information

$HostOSHW = Get-ComputerInfo -ErrorAction SilentlyContinue |
Select @{Name="Operating System";Expression={$_.OsName}},
@{Name="Version";Expression={$_.WindowsVersion}},
@{Name="Server Name";Expression={$_.CsName}},
@{Name="Manufacturer";Expression={$_.CsManufacturer}},
@{Name="Model";Expression={$_.CsModel}},
@{Name="Logical Processors";Expression={$_.CsNumberOfLogicalProcessors}},
@{Name="Physical Processors";Expression={$_.CsNumberOfProcessors}},
@{Name="MemGB";Expression={$_.CsTotalPhysicalMemory/1GB -as [int]}},
@{Name="Serial Number";Expression={$_.BiosSeralNumber}} | 

ConvertTo-Html -PreContent "OS and Hardware information" -Fragment


# RAM Details

$HostRAM = Get-ComputerInfo -ErrorAction SilentlyContinue |
Select @{Name="Total Memory GB";Expression={$_.OsTotalVisibleMemorySize/1024/1024 -as [int]}},
@{Name="Free Memory GB";Expression={$_.OsFreePhysicalMemory/1024/1024 -as [int]}},
@{Name="Total Virtual Memory GB";Expression={$_.OsTotalVirtualMemorySize/1024/1024 -as [int]}},
@{Name="Free Virtual Memory GB";Expression={$_.OsFreeVirtualMemory/1024/1024 -as [int]}},
@{Name="Virtual Memory In Use GB";Expression={$_.OsInUseVirtualMemory/1024/1024 -as [int]}},
@{Name="Stored in Page File GB";Expression={$_.OsSizeStoredInPagingFiles/1024/1024 -as [int]}},
@{Name="Page File Free GB";Expression={$_.OsFreeSpaceInPagingFiles/1024/1024 -as [int]}},
@{Name="Page Files";Expression={$_.OsPagingFiles}} | 

ConvertTo-Html -PreContent "Memory Details" -Fragment

# Host HDD info

$HostHDD = Get-Volume -ErrorAction SilentlyContinue |
Select @{Name="Drive";Expression={$_.DriveLetter}},
@{Name="File System";Expression={$_.FileSystem}},
@{Name="Disk Label";Expression={$_.FileSystemLabel}},
@{Name="Health Status";Expression={$_.HealthStatus}},
@{Name="Operational Status";Expression={$_.OperationalStatus}},
@{Name="Volume Size";Expression={$_.Size/1GB -as [int]}},
@{Name="Volume Free Space";Expression={$_.SizeRemaining/1GB -as [int]}} | 

ConvertTo-Html -PreContent "Host Hard Drive Information" -Fragment

# Hyper-V Services

$HVServices = Get-Service HvHost, vmickvpexchange, vmicguestinterface, vmicshutdown, vmicheartbeat, vmcompute, vmicvmsession, vmicrdv, vmictimesync, vmms, vmicvss |
Select @{Name="Name";Expression={$_.DisplayName}},
@{Name="Status";Expression={$_.Status}} | 

ConvertTo-Html -PreContent "Hyper-V Services" -Fragment

# Hyper-V VM Switch Infomation

$VMSwitch = Get-VMSwitch -ErrorAction SilentlyContinue |
Select @{Name="Name";Expression={$_.Name}},
@{Name="Network Adapter";Expression={$_.NetAdapterInterfaceDescription}},
@{Name="Switch Type";Expression={$_.SwitchType}},
@{Name="Allow Management OS";Expression={$_.AllowManagementOS}} | 

ConvertTo-Html -PreContent "Virtual Switch Information" -Fragment

# Virtual Machine Information

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

ConvertTo-Html -PreContent "Virtual Machines" -Fragment

# Virtual Machine Drive Information

$VMHDD = Get-VM -ErrorAction SilentlyContinue | Get-VMHardDiskDrive | Select-Object * |
Select @{Name="Virtual Machine";Expression={$_.VMName}},
@{Name="VHDX Path";Expression={$_.Path}} | 

ConvertTo-Html -PreContent "Virtual Machine Drives" -Fragment

# Detailed VHDX Information

$VHDX_Info = Get-VM -ErrorAction SilentlyContinue | Select-Object VMId | Get-VHD | select-object * |
Select @{Name="VHDX Location";Expression={$_.Path}},
@{Name="Format";Expression={$_.VhdFormat}},
@{Name="Type";Expression={$_.VhdType}},
@{Name="Disk Size GB";Expression={$_.Size/1GB -as [int]}},
@{Name="Attached";Expression={$_.Attached}} | 

ConvertTo-Html -PreContent "VHDX Information" -Fragment

# VM Network Adapters 

$VMNet = Get-VMNetworkAdapter -VMName * -ErrorAction SilentlyContinue | Select-Object * |
Select @{Name="Server Name";Expression={$_.VMName}},
@{Name="Virtual Switch";Expression={$_.SwitchName}},
@{Name="IP Address";Expression={$_.IPAddresses}},
@{Name="Status";Expression={$_.Status}},
@{Name="Connected";Expression={$_.Connected}} | 

ConvertTo-Html -PreContent "VM Network Adapters" -Fragment

# Hyper-V Events

$SystemLogs = Get-EventLog -LogName System -EntryType Error, Warning -After (Get-Date).AddHours(-24) -ErrorAction SilentlyContinue |
Select @{Name="Time Generated";Expression={$_.TimeGenerated}},
@{Name="Type";Expression={$_.EntryType}},
@{Name="Source";Expression={$_.Source}},
@{Name="Event ID";Expression={$_.InstanceId}},
@{Name="Server";Expression={$_.MachineName}} | 

ConvertTo-Html -PreContent "System Events" -Fragment

$AppLogs = Get-EventLog -LogName Application -EntryType Error, Warning -After (Get-Date).AddHours(-24) -ErrorAction SilentlyContinue |
Select @{Name="Time Generated";Expression={$_.TimeGenerated}},
@{Name="Type";Expression={$_.EntryType}},
@{Name="Source";Expression={$_.Source}},
@{Name="Event ID";Expression={$_.InstanceId}},
@{Name="Server";Expression={$_.MachineName}} | 

ConvertTo-Html -PreContent "Application Events" -Fragment

# Create HTML Report

ConvertTo-HTML -Body "$HostOSHW $HostRAM $HostHDD $HVServices $VMSwitch $GetVM $VMHDD $VHDX_Info $VMNet $SystemLog $AppLogs" -Head $Table | Out-File "$ReportFileName"

# Email Report

$Body = Get-Content -Raw $ReportFileName
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTP -Attachments $Attachment
