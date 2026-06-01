# --- CONFIGURATION VARS ---
$SourcePath = "C:\Office2013Source"
$SetupFile  = "$SourcePath\setup.exe"
$ConfigPath = "$SourcePath\outlook_silent_config.xml"

# --- CHECK SOURCE ---
if (-not (Test-Path $SetupFile)) {
    Write-Error "Setup.exe not found at $SetupFile. Please check your source path."
    exit
}

# --- GENERATE SILENT CONFIG.XML ---
# This XML forces a silent installation and targets ONLY Outlook.
$ConfigXmlContent = @"
<Configuration Product="ProPlus">
    <Display Level="none" CompletionNotice="no" SuppressModal="yes" AcceptEula="yes" />
    <Setting Id="AUTO_ACTIVATE" Value="1" />
    
    <!-- Optional: Add your 25-character product key below -->
    <!-- <PIDKEY Value="AAAAA-BBBBB-CCCCC-DDDDD-EEEEE" /> -->

    <!-- Exclude all other Office components except Outlook -->
    <OptionState Id="ACCESSFiles" State="Absent" Children="force" />
    <OptionState Id="EXCELFiles" State="Absent" Children="force" />
    <OptionState Id="OneNoteFiles" State="Absent" Children="force" />
    <OptionState Id="OUTLOOKFiles" State="Local" Children="force" />
    <OptionState Id="PPTFiles" State="Absent" Children="force" />
    <OptionState Id="PubFiles" State="Absent" Children="force" />
    <OptionState Id="WORDFiles" State="Absent" Children="force" />
    <OptionState Id="SHAREDFiles" State="Local" Children="force" />
    <OptionState Id="TOOLSFiles" State="Local" Children="force" />
</Configuration>
"@

# Save the XML configuration file
$ConfigXmlContent | Out-File -FilePath $ConfigPath -Encoding UTF8 -Force
Write-Host "Configuration file generated at $ConfigPath" -ForegroundColor Cyan

# --- LAUNCH INSTALLATION ---
Write-Host "Installing Outlook 2013 silently... Please wait." -ForegroundColor Yellow

# Start setup process and wait for completion
$Process = Start-Process -FilePath $SetupFile -ArgumentList "/config `"$ConfigPath`"" -Wait -NoNewWindow -PassThru

# --- VERIFY EXIT CODE ---
if ($Process.ExitCode -eq 0 -or $Process.ExitCode -eq 3010) {
    Write-Host "Outlook 2013 installation triggered successfully!" -ForegroundColor Green
    if ($Process.ExitCode -eq 3010) {
        Write-Host "Notice: A system reboot is required to complete the installation." -ForegroundColor Yellow
    }
} else {
    Write-Error "Installation failed with exit code $($Process.ExitCode)"
}
