<# 
Public Folder Ghost User Removal

Version: 1 
Autheo: James Pearman
Date: April 2021

Description:
The purpose of this is to remove the SID's of previous users from Exchange 2010 Public Folders.

#>


$GhostUser = Get-PublicFolder "\" -Recurse -Resultsize unlimited | Get-PublicFolderClientPermission | where {$_.user -like "NT User:*"}

$GhostUser |
	ForEach-Object{ 
		Remove-PublicFolderClientPermission -Identity $_.identity -User $_.user -Access $_.accessrights -Confirm:$false
		} 

