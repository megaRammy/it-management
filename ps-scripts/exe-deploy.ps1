<#
/************************************************************/
EXE Deployment Script

Deploy exes on startup, with version checking and install checking to prevent exe from running if version is already deployed

Script bodged by https://github.com/megarammy
Find the latest version at: https://github.com/megaRammy/it-management
/************************************************************/
#>

# Stop the script of errors occur
$ErrorActionPreference = "stop"

<#
User defined variables
#>

# Name of the app
$app_name = 'ProgramName'
# App version number (Properties > Details > File version of the exe ideally)
$app_version = '1.0.0'
# Folder the program installs to locally
$install_folder = 'C:\Program Files\ProgramFolder'
# Path to the exe installer on deployment server
$install_exe = '\\alder-nas10\Deployment\ProgramName\Program.exe'

<#
Don't touch these ones unless you know what you're doing
#>

# Path to file/folder made in program's install folder to store current deployed version
$version_check = $install_folder,'\.deploy\version_deployed\',$app_version,'.version' -join ""

Write-Output "Checking for previous version: $version_check"
# Checks for version currently deployed
if (-not (Test-Path -Path $version_check)) {
    Write-Output "Installing $app_name"
    # Installs the app
    Start-Process -FilePath $install_exe -Verb runAs -ArgumentList '--silent','--desktop_shortcut'  -Wait -Passthru
    # Marks the version deployed
    New-Item -Path $version_check -ItemType File
}

# Skips everything if version deployed
else {
    Write-Output "Skipping install of $app_name"
 }