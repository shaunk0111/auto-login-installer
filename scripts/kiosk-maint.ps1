
# Constants

$RUN_SESSION = Get-Date -UFormat "%Y-%m-%d_%H"

$USER_PATH = $env:USERPROFILE

$PROFILE_CLEAN_PATH = "$USER_PATH\.clean_profile"

$RUN_CLEAN_PATH = "$PROFILE_CLEAN_PATH\$RUN_SESSION"

$CHROME_DATA="$USER_PATH\AppData\Local\Google\Chrome\User Data"

Write-Host $RUN_CLEAN_PATH

# Create temp directory

$isCleanPath = Test-Path -Path $PROFILE_CLEAN_PATH

if (!$isCleanPath)  {

	New-Item -Path $PROFILE_CLEAN_PATH -ItemType Directory 
}

# Clean directory
$isCleanRunPath = Test-Path -Path $RUN_CLEAN_PATH 

if (!$isCleanRunPath)  {

	New-Item -Path $RUN_CLEAN_PATH -ItemType Directory 
}

# Move all top level items in user directory

Get-ChildItem -Path "$USER_PATH\" -Exclude AppData,Desktop,Downloads,Documents,.*  | Move-Item -Destination "$RUN_CLEAN_PATH" 

# 
Move-Item -Force -Path "$USER_PATH\Desktop\*"  -Destination "$RUN_CLEAN_PATH" 

Move-Item -Force -Path "$USER_PATH\Documents\*"  -Destination "$RUN_CLEAN_PATH"

Move-Item -Force -Path "$USER_PATH\Downloads\*"  -Destination "$RUN_CLEAN_PATH"


# Clear Chrome Web Browser

Stop-Process -Name "chrome"

Remove-Item -Path $CHROME_DATA\* -Force -Recurse

Shutdown /t 15 /r


