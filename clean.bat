@echo off
setlocal enabledelayedexpansion
if not "%1" == "max" start /MAX cmd /c %0 max & exit /b

rem Record start time
for /f "tokens=2 delims==" %%A in ('%SystemRoot%\System32\wbem\WMIC.exe OS GET LocalDateTime /VALUE ^| find "="') do set start=%%A

echo.
echo Cleaning system junk files, please wait . . .
echo.

rem Delete system junk files
del /f /s /q %systemdrive%\*.tmp 2>nul
del /f /s /q %systemdrive%\*._mp 2>nul
del /f /s /q %systemdrive%\*.log 2>nul
del /f /s /q %systemdrive%\*.gid 2>nul
del /f /s /q %systemdrive%\*.chk 2>nul
del /f /s /q %systemdrive%\*.old 2>nul
del /f /s /q %systemdrive%\$Recycle.Bin\*.* 2>nul
del /f /s /q %windir%\*.bak 2>nul
del /f /s /q %windir%\Prefetch\*.pf 2>nul

rem Clear temporary folders
rd /s /q %windir%\temp & md %windir%\temp
rd /s /q "%localappdata%\Temp" & md "%localappdata%\Temp"

rem Clear user-specific junk
del /f /q %userprofile%\Cookies\*.* 2>nul
del /f /q %appdata%\Microsoft\Windows\Recent\*.* 2>nul

rem Clear Windows Update cache
rd /s /q %windir%\SoftwareDistribution\Download 2>nul

rem Flush DNS cache
ipconfig /flushdns

echo.
echo Junk files cleaning finished!
echo Checking disk space . . .

rem Capture free disk space before cleanup
for /f "tokens=3 delims=," %%A in ('dir "%systemdrive%" ^| find "bytes free"') do set DriveFreeAfter=%%A

rem Record end time
for /f "tokens=2 delims==" %%A in ('%SystemRoot%\System32\wbem\WMIC.exe OS GET LocalDateTime /VALUE ^| find "="') do set end=%%A

rem Calculate elapsed time
set /a startSeconds=(!start:~8,2! * 3600 + !start:~10,2! * 60 + !start:~12,2!)
set /a endSeconds=(!end:~8,2! * 3600 + !end:~10,2! * 60 + !end:~12,2!)
if !endSeconds! LSS !startSeconds! set /a endSeconds+=86400
set /a duration=!endSeconds! - !startSeconds!

rem Convert to HH:MM:SS format
set /a hours=!duration! / 3600
set /a minutes=(!duration! %% 3600) / 60
set /a seconds=!duration! %% 60

echo.
echo Space available: !DriveFreeAfter! bytes
echo Script execution time: !hours!h !minutes!m !seconds!s
echo. & pause
