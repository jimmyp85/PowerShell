
<#
Iris Brokasure Launcher 
Version 2
J Pearman, June 2021

Description:
This is the initial version of a launcher for Brokasure created for users of both the normal dataset and Iris France dataset. Using these datasets from this tool willensure that the correct electronic forms settings are in place and that generated documents using the correct templates.

#>

## Functions ##

# Brokasure Standard

function BSLive{
    
    start-Process powershell -WorkingDirectory \\fs01\brokasure\Launcher\BatFiles {Start-Process IrisBS.bat}

}

function BSFrance{

    start-Process powershell -WorkingDirectory \\fs01\brokasure\Launcher\BatFiles {Start-Process IrisFrance.bat}

}

## Brokasure Launcher Tool Form ##

Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Form Settings

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Iris Brokasure Launcher'
$Main_Form.Size = New-Object System.Drawing.Size(650,400)
$main_form.StartPosition = "CenterScreen"
#$main_form.BackgroundImageLayout = "Zoom"
$main_form.MinimizeBox = $True
$main_form.MaximizeBox = $True
$main_form.WindowState = "Normal"
$main_form.AutoSize = $false
$main_form.BackColor = "WhiteSmoke"
$main_form.BackgroundImage = [System.Drawing.Image]::FromFile("\\fs01.iris.local\brokasure\Launcher\Files\IrisTrans.png")
$main_form.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::None;
$Icon = New-Object system.drawing.icon ("\\fs01.iris.local\brokasure\Launcher\Files\logo.ico")
$main_form.Icon = $Icon

# Title Settings

$Label = New-Object System.Windows.Forms.Label
$LabelFont = New-Object System.Drawing.Font("Calibri",24,[System.Drawing.FontStyle]::Bold)
$Label.Font = $LabelFont
$Label.Text = "Iris Brokasure launch Tool"
$Label.AutoSize = $True
$Label.Location = New-Object System.Drawing.Size(215,40)
$main_form.Controls.Add($Label)

# Buttons #

# Button Group Box

$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(10,95) 
$groupBox.size = New-Object System.Drawing.Size(180,260)
$groupBox.Font = 'Calibri,10'
$groupBox.text = "Brokasure Versions:"
$main_form.Controls.Add($groupBox)

# Iris Live Button 

$BSLive = New-Object System.Windows.Forms.Button
$BSLive.Location = New-Object System.Drawing.Size(15,30)
$BSLive.Size = New-Object System.Drawing.Size(150,60)
$BSLive.Font = 'Calibri,14'
$BSLive.Text = "Iris UK"
$BSLive.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight;
$BSLive.BackColor = "LightGray"
$BSLive.Add_Click({BSLive})
$BSLive.Cursor = [System.Windows.Forms.Cursors]::Hand
$LiveImage = [System.Drawing.Image]::FromFile("\\fs01.iris.local\brokasure\Launcher\Files\UKButton.jpg")
$BSLive.Image = $LiveImage
$BSLive.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft;
$groupBox.Controls.Add($BSLive)

# Iris France Button

$BSFrance = New-Object System.Windows.Forms.Button
$BSFrance.Location = New-Object System.Drawing.Size(15,110)
$BSFrance.Size = New-Object System.Drawing.Size(150,60)
$BSFrance.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight;
$BSFrance.Font = 'Calibri,14'
$BSFrance.Text = "Iris France"
$BSFrance.BackColor = "LightGray"
$BSFrance.Add_Click({BSFrance})
$BSFrance.Cursor = [System.Windows.Forms.Cursors]::Hand
$FranceImage = [System.Drawing.Image]::FromFile("\\fs01.iris.local\brokasure\Launcher\Files\FrenchButton.png")
$BSFrance.Image = $FranceImage
$BSFrance.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft;
$groupBox.Controls.Add($BSFrance)

# Cancel Button

$Cancel = New-Object System.Windows.Forms.Button
$Cancel.Location = New-Object System.Drawing.Size(15,190)
$Cancel.Size = New-Object System.Drawing.Size(150,60)
$Cancel.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight;
$Cancel.Font = 'Calibri,14'
$Cancel.Text = "Exit"
$Cancel.BackColor = "LightGray"
$Cancel.Cursor = [System.Windows.Forms.Cursors]::Hand
$CancelImage = [System.Drawing.Image]::FromFile("\\fs01.iris.local\brokasure\Launcher\Files\ExitButtonTrans.png")
$Cancel.Image = $CancelImage
$Cancel.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft;
$groupBox.Controls.Add($Cancel)
$Cancel.add_Click({
			Write-Host 'Cancelling' -Fore green
			$script:Canceling=$true
			[System.Windows.Forms.Application]::DoEvents()
			$main_form.Close()
		})

# End Buttons #

# Output field

$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Size(200,100) 
$outputBox.Size = New-Object System.Drawing.Size(400,200)
$outputBox.Font = New-Object System.Drawing.Font("Calibri", 14 ,[System.Drawing.FontStyle]::Regular)
$outputBox.MultiLine = $True
$outputBox.ScrollBars = "Vertical"
$outputBox.Text = "Welcome to the Iris Brokasure Launcher.` 

Select the version of Brokasure you wish to use or press Exit to leave."
$main_form.Controls.Add($outputBox)

####

$main_form.Add_Shown({$main_form.Activate()})
[void] $main_form.ShowDialog()
