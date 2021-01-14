# Process Terminator

Process Terminator is a PowerShell based tool to search for pre-listed processes and end them. 

## Installation

This is a portable tool and no installation is required. Simply run the .PS1 file. If you have changed this to an .EXE run this.

## Code Changes

You will need to edit the PowerShell script so that this works the way you want to.

#### $msgBoxInput
Change the message shown and box title.
#### $Processes -Path
Change the share location to where you are storing processes.txt


## Processes.txt
This file is required to list the names of the processes you would want to stop. Write these in here and save in a location the script can find the file

## PS2EXE
Once you have made the changes you need to on the PowerShell script you can convert it into an .EXE file so it can run by end users. I used PS2EXE-GUI to do this.

You can find this tool [here](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5#content)


## Usage

Enter the processes that would need to be stopped in processes.txt and save this in a location that can read by the PS1 file. 

If you are running the PS1 file open PowerShell as admin and run the script

Change the pth on PowerShell to the location of the script
```powershell
> cd \\location of script
```
Run the script in PowerShell
```powershell
>.\ProcessTerminator.ps1
```

If you have created an .EXE then you can simply run this.
