# Elevate to Admin (UAC) (this is just grabbed from StackOverflow, can't tell you how it works. It works though! 😊)
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

$filename             = 'C:\Program Files\Common Files\Bentley Shared\CONNECTION Client\Bentley.Connect.Client.exe.config'
$PopupIntervalMinutes = "1440"

# Load the xml document
$xmlDoc = New-Object xml
$xmlDoc.Load($filename)

# Select all applicable nodes
$nodes = $xmlDoc.SelectNodes('//appSettings/add[@key="PopupIntervalMinutes"]')

# In each node, set the value to the value of $PopupIntervalMinutes
foreach($node in $nodes){
    $PopupIntervalMinutes
}

# Save the document
$xmlDoc.Save($filename)