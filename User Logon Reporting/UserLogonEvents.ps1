<#
User Logon Reporting Script
J Pearman, February 2023, Version 2

Description:
This script has been written to export a users logon, logoff, lock and unlock events for the purpose of creating a report showing these events.

The following events are exported:
    4624: User Logon (type 2: interactive)
    4624: User Logon (type 11: cached interactive)
    4647: User Logoff
    4800: Computer Locked
    4801: Computer Unlocked

Once exported these events are merged into a single CSV file where they can be viewed together.

Version History:
	Version 1 - Inital script
	Version 2 - Added event 4624 type 11

#>


$ResultPath = "C:\ResTmp\"

# Create Results path

New-Item -Path $ResultPath -ItemType Directory

# Get Type 2 Logon events

$LogonEvents = Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = 4624; Data=2}

$Logons = foreach ($LogonEvent in $LogonEvents) {
    [pscustomobject]@{
        ID = $LogonEvent.Id
        UserAccount = $LogonEvent.Properties.Value[5]
        UserDomain = $LogonEvent.Properties.Value[6]
        WorkstationName = $LogonEvent.Properties.Value[11]
        TimeCreated = $LogonEvent.TimeCreated
        Description = $LogonEvent.TaskDisplayName
        }
    }

$Logons | Export-Csv $ResultPath\LogonEvents.csv -NoTypeInformation

# Get Type 11 Logon events

$CacheLogonEvents = Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = 4624; Data=11}

$CacheLogons = foreach ($CacheLogonEvent in $CacheLogonEvents) {
    [pscustomobject]@{
        ID = $CacheLogonEvent.Id
        UserAccount = $CacheLogonEvent.Properties.Value[5]
        UserDomain = $CacheLogonEvent.Properties.Value[6]
        WorkstationName = $CacheLogonEvent.Properties.Value[11]
        TimeCreated = $CacheLogonEvent.TimeCreated
        Description = $CacheLogonEvent.TaskDisplayName
        }
    }

$CacheLogons | Export-Csv $ResultPath\CacheLogonEvents.csv -NoTypeInformation

# Get Logoff events

$LogOffEvents = Get-WinEvent -FilterHashtable @{LogName = 'Security';  ID = 4647}

$LogOffs = foreach ($LogOffEvent in $LogOffEvents) {
    [pscustomobject]@{
        ID = $LogOffEvent.Id
        UserAccount = $LogOffEvent.Properties.Value[1]
        UserDomain = $LogOffEvent.Properties.Value[2]
        WorkStation = $LogOffEvent.MachineName
        TimeCreated = $LogOffEvent.TimeCreated
        Description = $LogOffEvent.TaskDisplayName
        }
    }
$LogOffs | Export-Csv $ResultPath\LogoffEvents.csv -NoTypeInformation

# Get computer lock events

$Locks = Get-WinEvent -FilterHashtable @{LogName = 'Security';  ID = 4800}

$MachineLocked = foreach ($Lock in $Locks) {
    [pscustomobject]@{
        ID = $Lock.Id
        UserAccount = $Lock.Properties.Value[1]
        UserDomain = $Lock.Properties.Value[2]
        WorkStation = $Lock.MachineName
        TimeCreated = $Lock.TimeCreated
        Description = $Lock.TaskDisplayName
        }
    }

$MachineLocked | Export-Csv $ResultPath\LockEvents.csv -NoTypeInformation

# Get computer unlock events

$UnLocks = Get-WinEvent -FilterHashtable @{LogName = 'Security';  ID = 4801}

$MachineUnLocked = foreach ($UnLock in $UnLocks) {
    [pscustomobject]@{
        ID = $UnLock.Id
        UserAccount = $UnLock.Properties.Value[1]
        UserDomain = $UnLock.Properties.Value[2]
        WorkStation = $UnLock.MachineName
        TimeCreated = $UnLock.TimeCreated
        Description = $UnLock.TaskDisplayName
        }
    }

$MachineUnLocked | Export-Csv $ResultPath\UnlockEvents.csv -NoTypeInformation

# Merge Files

Get-ChildItem -Filter *.csv -Path C:\ResTmp | Select-Object -ExpandProperty FullName | Import-Csv | Export-Csv C:\ResTmp\AllEvents.csv -NoTypeInformation -Append
