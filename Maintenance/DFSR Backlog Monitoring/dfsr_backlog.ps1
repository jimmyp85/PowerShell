# DFSR Backlog Monitoring Script
# Version: 1.0, October 2020



#Parameters
$DFSroot  = "ENTER DFS NAMESPACE"
$smtpServer = "ENTER SMTP SERVER"
$smtpFrom = "FROM@DOMAIN.COM"
$smtpTo = "TO@DOMAIN.COM"
$Subject = "'DFSR' Report: Generated $([DateTime]::Now)"

#Create HTML Table for Backlog info
$Style =  "<style>"
$Style += "<html><head><title>DFSR Backlog Status report</title>"
$Style += "<style type=`"text/css`">"
$Style += "</style>"
$Style += "</head>"
$Style += "<body>"
$Style += "<br>"
$Style += "<span style=$THt1>DFSR Backlog</span>"
$Style += "<table id='t1'>"
$Style += "<tr bgcolor=#9999CC>"
$Style += "<td width=140 style=$THt1>FOLDER</td>" 
$Style += "<td width=90 style=$THt1>SOURCE</td>" 
$Style += "<td width=90 style=$THt1>DESTINATION</td>" 
$Style += "<td width=80 style=$THt1>BACKLOG</td>" 
$Style += "</tr>"


#Getting group and folder info
$RGList = (Get-DfsReplicationGroup -GroupName *)
foreach ($G in $RGList) 
{
$RGName = $G.GroupName
$RF = (Get-DfsReplicatedFolder -GroupName $RGName)
$RFName = $RF.FolderName
$ConList = (Get-DfsrConnection -GroupName $RGName)
foreach ($C in $ConList)
{
$ConSrc = $C.SourceComputerName
$ConDst = $C.DestinationComputerName

$BLcount = (Get-DfsrBacklog -GroupName $RGName -FolderName $RFName -SourceComputerName $ConSrc -DestinationComputerName $ConDst -Verbose 4>&1).Message.Split(':')[2]
$BL = $BLcount
$int = [int]$BL
$Style += "<tr>"
$Style += "<td bgcolor=#dddddd align=left><B>$RFName</B></td>"
$Style += "<td bgcolor=#f5f5f5 align=left>$ConSrc</td>"
$Style += "<td bgcolor=#f5f5f5 align=left>$ConDst</td>"

if ($Int -eq "0"){$Style += "<td bgcolor=#98FB98 align=center><b>0</b></td>"}
elseif ($Int -lt "100"){$Style += "<td bgcolor=#FFFF99 align=center><b>$Int</b></td>"}
else {$Style += "<td bgcolor=#CC6666 align=center><b>$Int</b></td>"}
$Style += "</tr>"
}
}
$Style += "</table>"


#Getting DFSR service info
$Style+= "<br>"
$Style+= "<span style=$THt2>DFS NameSpace Service Status</span>"
$Style+= "<table id='t4'>" 
$NSerr = 0
$NSsvc = @()
ForEach ($NS in $TestDFSConfig){
if ($NS -ilike "*Error*"){
$NSsvc = $NS
$NSerr += 1
$Style+= "<tr>"
$Style+= "<td><font color='#CC6666'>$NSsvc</td>"
$Style+= "</tr>"
}
}
if ($NSerr -eq 0){
$Style+= "<td>DFS Namespace service is started and Set to Automatic on all servers.</td>"
}
$Style+= "</table>"


#List Backlogged files
$Style+= "<br>"
$Style+= "<span style=$THt2>First 100 Backlog Files</span>"
$Style+= "<table id='t2'>"
$Style+= "<tr bgcolor=#ADD8E6>"
$Style+= "<td width=75 style=$TDt2b>FOLDER</td>" 
$Style+= "<td width=75 style=$TDt2b>SOURCE</td>" 
$Style+= "<td width=75 style=$TDt2b>DESTINATION</td>" 
$Style+= "<td width=1000 style=$TDt2b>FILES</td>" 
$Style+= "</tr>" 

$RGList = (Get-DfsReplicationGroup -GroupName *)
foreach ($G in $RGList) 
{
$RGName = $G.GroupName
$RF = (Get-DfsReplicatedFolder -GroupName $RGName)
$RFName = $RF.FolderName
$ConList = (Get-DfsrConnection -GroupName $RGName)
foreach ($C in $ConList)
{
$ConSrc = $C.SourceComputerName
$ConDst = $C.DestinationComputerName
$BLF = (Get-DfsrBacklog -GroupName $RGName -FolderName $RFName -SourceComputerName $ConSrc -DestinationComputerName $ConDst | select FullPathName )
foreach ($L in $BLF) {
$BL = $L.FullPathName
$Style+= "<tr>"
$Style+= "<td style=$TDt2 width=75>$RFName</td>"
$Style+= "<td style=$TDt2 width=75>$ConSrc</td>"
$Style+= "<td style=$TDt2 width=75>$ConDst</td>"
$Style+= "<td style=$TDt2 width=1000>$BL</td>"
}
}
}
$Style+= "</table>"
$Style+= "</body>"
$Style+= "</html>"


#Email results
Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $Subject -Body $Style -BodyAsHtml -SmtpServer $smtpServer

