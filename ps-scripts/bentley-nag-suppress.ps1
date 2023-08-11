<## Elevate to Admin (UAC) (this is just grabbed from StackOverflow, can't tell you how it works. It works though! 😊)
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}#>

#$filename             = "C:\Program Files\Common Files\Bentley Shared\CONNECTION Client\Bentley.Connect.Client.exe.config"
$filename = "C:\Users\sfielding\Bentley.Connect.Client.exe.config"
$nodeName = '//appSettings/add[@key=PopupIntervalMinutes]'
$value = "1440"

# Load the xml document
$xmlDoc = New-Object xml

$xmlDoc = [xml](Get-Content -Path "C:\Users\sfielding\Bentley.Connect.Client.exe.config")

# Locate target node
$targetNode = $xmlDoc.SelectNodes('//appSettings/add[@key=PopupIntervalMinutes]')

# Overwrite attribute value
foreach ($node in $targetNode) {
  $node.value = ("1440")
}
# save file
$xmlDoc.Save("C:\Users\sfielding\Bentley.Connect.Client.exe.config")