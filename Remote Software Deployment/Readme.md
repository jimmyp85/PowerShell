# Remote Installation Script
October 2018

## Purpose
This script has been written to allow the mass deployment of particular software. This script works with a .cmd file which has the installation configuration for a silent install. Any changes to MSI install config will need to be made to the .cmd file.

## File Changes
Make changes to the following text files:
##### Computers.txt
Change this to list the hostnames of the computers you are installing software on

##### Files.txt
Enter the shared locations of the install.cmd script and the .EXE file you wish to run on the remote computers

##### Install.cmd
Change this file with the setup.exe parameters you require to remotlely install the software. Information about how to do this can be found [here](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-command-line-options).

## Parameter changes
The following parameters will need to be changed:

##### $computers
This is the path of the computer list stating which machines the software needs to be installed on. Update the list and location of file if needed.

##### $Files
List of files that are top be copied to the remote machine. Update this text file withg the file names and/or location of text file

##### $Source and $Destination
Change these to the correwct source of the installation files and where they are to be saved on the remote PC.

## Usage
Once all the required file and parameter changes have been made run this script in PowerShell as administrator. The administrator account being used will need to have remote access to the computers you are installing on as well as the share locations containing the installation files.

```powershell
>.\RemoteInstall.ps1
```
