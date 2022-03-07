<#
Windows Page File Calculater GUI
J Pearman, March 2022, Version 1

Description:
This tool allows you to calculate the recommended and maximum page file size based on the amount of physical memory detected.

#>


Function CalculateRec {
	
		$TotalRAM = Get-WMIObject -class win32_ComputerSystem | Select-Object -Expand TotalPhysicalMemory
		[Math]::Round($TotalRAM/1MB) | out-null
		$Initial = 1.5*$TotalRAM
		[Math]::Round($Initial/1MB)
		
	}


Function CalculateMax {
	
		$TotalRAM = Get-WMIObject -class win32_ComputerSystem | Select-Object -Expand TotalPhysicalMemory
		[Math]::Round($TotalRAM/1MB) | out-null
		$Initial2 = 3*$TotalRAM
		[Math]::Round($Initial2/1MB)
	
	}

Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Form Settings

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Page File Size Calculator'
$Main_Form.Size = New-Object System.Drawing.Size(650,400)
$main_form.StartPosition = "CenterScreen"
$main_form.MinimizeBox = $True
$main_form.MaximizeBox = $True
$main_form.WindowState = "Normal"
$main_form.AutoSize = $false
$main_form.BackColor = "WhiteSmoke"
$main_form.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::None;


# Title Settings

$Label = New-Object System.Windows.Forms.Label
$LabelFont = New-Object System.Drawing.Font("Calibri",24,[System.Drawing.FontStyle]::Bold)
$Label.Font = $LabelFont
$Label.Text = "Page File Size Calculator"
$Label.AutoSize = $True
$Label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$Label.Location = New-Object System.Drawing.Size(150,20)
$main_form.Controls.Add($Label)

# Button Group Box

$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(50,70) 
$groupBox.size = New-Object System.Drawing.Size(540,250)
$main_form.Controls.Add($groupBox)

# Calculate Recommended Button

$Calc = New-Object System.Windows.Forms.Button
$Calc.Location = New-Object System.Drawing.Size(15,30)
$Calc.Size = New-Object System.Drawing.Size(150,60)
$Calc.Font = 'Calibri,12'
$Calc.Text = "Calculate Recommended Page File (MB)"
$Calc.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter;
$Calc.BackColor = "LightGray"
$Calc.Add_Click({
	$RecResults.Text = CalculateRec})
$Calc.Cursor = [System.Windows.Forms.Cursors]::Hand
$groupBox.Controls.Add($Calc)

# Calculate Maximum Button

$CalcMax = New-Object System.Windows.Forms.Button
$CalcMax.Location = New-Object System.Drawing.Size(15,100)
$CalcMax.Size = New-Object System.Drawing.Size(150,60)
$CalcMax.Font = 'Calibri,12'
$CalcMax.Text = "Calculate Maximum Page File (MB)"
$CalcMax.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter;
$CalcMax.BackColor = "LightGray"
$CalcMax.Add_Click({
	$MaxResults.Text = CalculateMax})
$CalcMax.Cursor = [System.Windows.Forms.Cursors]::Hand
$groupBox.Controls.Add($CalcMax)

# Exit Button

$Cancel = New-Object System.Windows.Forms.Button
$Cancel.Location = New-Object System.Drawing.Size(15,170)
$Cancel.Size = New-Object System.Drawing.Size(150,60)
$Cancel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter;
$Cancel.Font = 'Calibri,12'
$Cancel.Text = "Exit"
$Cancel.BackColor = "LightGray"
$Cancel.Cursor = [System.Windows.Forms.Cursors]::Hand
$groupBox.Controls.Add($Cancel)
$Cancel.add_Click({
			Write-Host 'Cancelling' -Fore green
			$script:Canceling=$true
			[System.Windows.Forms.Application]::DoEvents()
			$main_form.Close()
		})

# Recommended Results Box

$RecResults = New-Object system.Windows.Forms.TextBox
$RecResults.multiline = $True
$RecResults.location = New-Object System.Drawing.Point(250,30)
$RecResults.width = 150
$RecResults.height = 60
$RecResults.Font = 'Calibri,12'
$groupBox.Controls.Add($RecResults)

# Max Results Box

$MaxResults = New-Object system.Windows.Forms.TextBox
$MaxResults.multiline = $True
$MaxResults.location = New-Object System.Drawing.Point(250,100)
$MaxResults.width = 150
$MaxResults.height = 60
$MaxResults.Font = 'Calibri,12'
$groupBox.Controls.Add($MaxResults)

# End of form

$main_form.Add_Shown({$main_form.Activate()})
[void] $main_form.ShowDialog()

