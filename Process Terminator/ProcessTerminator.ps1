$ErrorActionPreference = 'SilentlyContinue'

Add-Type -AssemblyName "PresentationFramework"

$msgBoxInput = [System.Windows.MessageBox]::Show('ENTER MESSAGE HERE','ENTER BOX TITLE HERE','YesNoCancel','Error')

  switch  ($msgBoxInput) {

  'Yes' {

 $Processes = Get-Content -Path "\\SHARE\FILE.TXT"


Get-Process -Name $Processes | Stop-Process -Force -ErrorAction $ErrorActionPreference

  }

  'No' {

  Exit

  }
  }

[System.Windows.MessageBox]::Show('Termination has been completed. Please exit.','ENTER BOX TITLE') | Out-Null



© 2021 GitHub, Inc.
