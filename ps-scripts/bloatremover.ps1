<#
/************************************************************/
Windows Install Bloat Remover 
Script bodged by https://github.com/megarammy
Find the latest version at: https://github.com/megaRammy/it-management
/************************************************************/

Adapted (rewritten) from a script by https://liam-robinson.co.uk/ whilst working with Liam at Mount Carmel

Will elevate the shell to admin via UAC, and remove the list of applications '$appname = @()', remove the Windows Recovery Partition, and optionally: remove the permissions to run PS scripts, and delete the script itself.

Uncomment the appropriate lines below to enable optional features. Customise the app list as needed below. 
Currently contains a selection of junk that comes with Windows 11.

Depending on environment settings, you may need to open an elevated PS window and run the following command to enable running PS scripts:
'Set-ExecutionPolicy -ExecutionPolicy Unrestricted'

If you wish to find a list of apps installed in the format needed for this script, use this command in a PS window:
'Get-AppxPackage | Select Name, PackageFullName'
/************************************************************/
#>

# Elevate to Admin (UAC) (this is just grabbed from StackOverflow, can't tell you how it works. It works though! 😊)
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

# List Currently Installed Apps into file on Desktop
Get-AppxPackage | Select Name, PackageFullName | Out-File -FilePath $env:USERPROFILE\Desktop\$env:computername-prewipe-apps.txt

# Remove Default Installed Stuff
$appname = @(
"*SkypeApp*" # Skype
"*LinkedIn*" # LinkedIn
"*Microsoft.GamingApp*" # The Xbox app
"*Xbox*" # Any app in the Xbox family (except the actual Xbox app)
"*windowscommunication*" # Windows Mail + Calendar
"*Clipchamp*" # Clipchamp video editor
"*Microsoft.WindowsMaps*" # Windows Maps
"*Microsoft.BingNews*" # Windows News
"*Microsoft.BingWeather*" # Windows Weather
"*Microsoft.Solitaire*" # Microsoft Solitaire Collection
"*Microsoft.StickyNotes*" # Windows Sticky Notes
"*Microsoft.People*" # Microsoft People
"*Microsoft.MicrosoftOfficeHub*" # Microsoft Office Hub
"*Microsoft.Todos*" # Microsoft Todo
"*Microsoft.Messaging*" # Microsoft Messaging
"*MixedReality.Portal*" # Mixed Reality Portal
"*Microsoft.Office.OneNote*" # OneNote
)

ForEach($app in $appname){
Get-AppxPackage -Name $app | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
Get-AppXProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -AllUsers -Online
}

#Disable Windows Recovery Partition
reagentc.exe /disable

# List Currently Installed Apps into file on Desktop
Get-AppxPackage | Select Name, PackageFullName | Out-File -FilePath $env:USERPROFILE\Desktop\$env:computername-postwipe-apps.txt

#Disable running .ps1 Powershell scripts
#Set-ExecutionPolicy -ExecutionPolicy Restricted

#Delete script file
Remove-Item $PSCommandPath -Force 