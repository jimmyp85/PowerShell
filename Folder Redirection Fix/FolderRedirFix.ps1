<#
Folder Redirection Fix - Reg Key Changes
J Pearman, October 2021, Version 1
This script fixes an issue where registry keys are not updated when a change has occured for the foldewr redirection GPO
The keys changed are:
	{56784854-C6CB-462B-8169-88E350ACB882}
	Desktop
	Favorites
	My Music
	My Pictures
	My Video
	Personal
#>


# Backup registry key

reg export 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' C:\Support\ShellFolderBackup.reg

# Make registry changes

$Username = $env:UserName

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{56784854-C6CB-462B-8169-88E350ACB882}" -Value "\\SERVER\FOLDER\$Username\Contacts"

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value "\\SERVER\FOLDER\$Username\Desktop"

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Favorites" -Value "\\SERVER\FOLDER\$Username\Favorites"

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music" -Value "\\SERVER\FOLDER\$Username\My Documents\My Music"

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures" -Value "\\SERVER\FOLDER\$Username\My Documents\My Pictures"

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video" -Value "\\SERVER\FOLDER\$Username\My Documents\My Video"


Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Personal" -Value "\\SERVER\FOLDER\$Username\My Documents"

# View the results

Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" | select "{56784854-C6CB-462B-8169-88E350ACB882}","Desktop","Favorites","My Music","My Pictures","My Video","Personal" | Write-Output
