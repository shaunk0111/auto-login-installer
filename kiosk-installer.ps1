param([Switch]$install,[Switch]$remove) 


# Constants

$BASE_PATH = split-path -parent $MyInvocation.MyCommand.Path

$START_MENU_PATH = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Instrument Kiosk"

$INSTRUMENT_KIOSK_PATH = "C:\Program Files\Instrument Kiosk"

$INSTALLER_PATH = "$BASE_PATH\bin\LogonExpertSetup64.msi"

$LICENSE_PATH = "C:\Program Files\Softros Systems\LogonExpert"


<# Install Kiosk Logon #>
function Install-Autologin {

    Write-Host $BASE_PATH

	# Install Expertlogon 

	Start-Process msiexec -ArgumentList "/i $INSTALLER_PATH /quiet /norestart" -wait 

	# Create kiosk control directories

	$isShortcutPath = Test-Path -Path $START_MENU_PATH

	if (!$isShortcutPath)  {

		New-Item -Path $START_MENU_PATH -ItemType Directory 
	}

	# Remove start menu links
	Remove-Item -Force -Path "$START_MENU_PATH\*"

	# Copy start menu links
	Copy-Item -Force -Path "$BASE_PATH\links\*" -Destination "$START_MENU_PATH"

	$isKioskPath = Test-Path -Path $INSTRUMENT_KIOSK_PATH

	if (!$isKioskPath)  {

		New-Item -Path $INSTRUMENT_KIOSK_PATH -ItemType Directory 

		Write-Host "Created program directory"
	}
	
	# Remove scripts
	Remove-Item -Force -Path "$INSTRUMENT_KIOSK_PATH\*"

	# Copy manual configuration script Kiosk Config.ps1
	Copy-Item -Force -Path "$BASE_PATH\scripts\*" -Destination "$INSTRUMENT_KIOSK_PATH"

	# Copy License
	Copy-Item -Force -Path "$BASE_PATH\bin\LogonExpertKey.lic" -Destination "$LICENSE_PATH\LogonExpertKey.lic"
	
	Register-Profile-Maintenance

    Write-Host "$env:computername kiosk installed"
}


<# Remove Kiosk Logon #>
function Remove-Autologin {

	# Remove Expertlogon 
	Start-Process msiexec -ArgumentList "/x $INSTALLER_PATH" -wait 
	
	# Remove start menu links
	Remove-Item -Force -Path "$START_MENU_PATH\*"

	# Remove  Kiosk Config.ps1
	Remove-Item -Force -Path "$INSTRUMENT_KIOSK_PATH\*"

	# Remove License
	Remove-Item -Force -Path  "$LICENSE_PATH\LogonExpertKey.lic"
	
	Unregister-Profile-Maintenance -Confirm $false

    Write-Host "$env:computername kiosk removed"
}


<# Register Profile Maintenance #>
function Register-Profile-Maintenance {


	$script = '-ExecutionPolicy Bypass -File "C:\Program Files\Instrument Kiosk\kiosk-maint.ps1"'

	$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument $script

	$time = New-ScheduledTaskTrigger -Daily -At '3am'

	$principle = New-ScheduledTaskPrincipal "mcs\chemistry_kiosk"

	$settings = New-ScheduledTaskSettingsSet

	$task = New-ScheduledTask -Action $action -Principal $principle -Trigger $time -Settings $settings

	Register-ScheduledTask "KioskProfileMaintenance" -InputObject $task
 
}


<# Unregister Profile Maintenance #>
function Unregister-Profile-Maintenance {

	Unregister-ScheduledTask -TaskName "KioskProfileMaintenance" -Confirm $false
}


# init
if ($install) {

	Install-Autologin
	
} if($remove)  {
	
	Remove-Autologin
	
} 