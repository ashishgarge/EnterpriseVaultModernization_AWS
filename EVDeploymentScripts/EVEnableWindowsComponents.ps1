Import-Module ServerManager

$CheckIfMaintenanceIsRunning = $true
While($CheckIfMaintenanceIsRunning)
{
    $RunningTasks = Get-ScheduledTask | Where TaskPath -like "*TaskScheduler*" | Where State -eq "Running"
    If($RunningTasks)
    {
        Start-Sleep -Seconds 10
        $CheckIfMaintenanceIsRunning = $True
        Write-Host "Waiting for Task Scheduler to finish running a task. If you see this message again, Task Scheduler may need you to restart your computer."
    }
Else
    {
        $CheckIfMaintenanceIsRunning = $false
    }
}

$featurelist = "NET-Framework-Core","NET-Framework-45-Core","MSMQ-Server","Web-Server","Web-Static-Content","Web-Default-Doc","Web-Dir-Browsing","Web-Http-Errors","Web-Http-Redirect","Web-Asp-Net","Web-Net-Ext","Web-ASP","Web-ISAPI-Ext","Web-ISAPI-Filter","Web-Http-Logging","Web-Log-Libraries","Web-Request-Monitor","Web-Http-Tracing","Web-Basic-Auth","Web-Windows-Auth","Web-Url-Auth","Web-Filtering","Web-IP-Security","Web-Stat-Compression","Web-Mgmt-Console","Web-Scripting-Tools","Web-Mgmt-Service","WAS","Web-Asp-Net45","NET-Framework-45-ASPNET","Windows-TIFF-IFilter","FS-Resource-Manager","NET-WCF-HTTP-Activation45","RSAT-FSRM-Mgmt","NET-HTTP-Activation","NET-Non-HTTP-Activ","Web-CGI"

$ver = [Environment]::OSVersion.Version

if (($ver.Major -eq 6 -and $ver.Minor -ge 2) -or ($ver.Major -ge 10))
{
    Install-WindowsFeature $featurelist -restart
}   
else
{
    echo "This script cannot run because the installed version of Windows is not supported by Enterprise Vault."
}

echo "Close this dialog to continue."
