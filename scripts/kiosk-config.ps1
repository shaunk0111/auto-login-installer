param([Switch]$kioskenable,[Switch]$kioskdisable,[Switch]$setup,[Switch]$maint,[Switch]$maintenable,[Switch]$maintdisable) 

<# Enable Kiosk Logon #>
if ($kioskenable) {
le -setparams DelayLogon=1 
le -setparams DelayLogonValue=15
le -setparams AllowUsersConfigure=1
le -setparams KeepComputerUnlocked=1 
le -setparams BypassLegalNotice=1
le -setparams KeepComputerLoggedOn=1 
le -setparams ShowLogo=0
le -enable 
logoff
}

<# Disable Kiosk Logon #>
if ($kioskdisable) {
le -setparams KeepComputerLoggedOn=0 
le -disable 
le -logoff 
}

<# Setup Kiosk Logon #>
if ($setup) {

# Set Kiosk User
le -setparams DelayLogon=1 
le -setparams DelayLogonValue=15
le -setparams AllowUsersConfigure=1
le -setparams KeepComputerUnlocked=1 
le -setparams BypassLegalNotice=1
le -setparams KeepComputerLoggedOn=1 
le -setparams ShowLogo=0
}

<# Disable Kiosk Logon #>
if ($maint) {
	& "C:\Program Files\Instrument Kiosk\kiosk-maint.ps1"
}

<# Disable Kiosk Logon #>
if ($maintenable) {
	Enable-ScheduledTask -TaskName "KioskProfileMaintenance"
}


<# Disable Kiosk Logon #>
if ($maintdisable) {
	Disable-ScheduledTask -TaskName "KioskProfileMaintenance"
}
