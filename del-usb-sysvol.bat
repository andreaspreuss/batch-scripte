@echo off 
SETLOCAL 
title Batch Datei zum entfernen von System Volume Information Ordnern auf USB Laufwerken
:: author: Andreas Preuß, Flensburg, den 26.04.2020, andreas@apreuss.de
COLOR 9F
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO                          ---   Administrator Privilegien Erkannt !  ---
) ELSE (
   for /l %%i in (1,1,3) do echo.
   echo      ######## ########  ##     ## ##       ######## ########  
   echo      ##       ##        ##     ## ##       ##       ##     ## 
   echo      ##       ##        ##     ## ##       ##       ##     ## 
   echo      ######   ######    ######### ##       ######   ########  
   echo      ##       ##        ##     ## ##       ##       ##  ##   
   echo      ##       ##        ##     ## ##       ##       ##    ##  
   echo      ##       ########  ##     ## ######## ######## ##     ## 
   echo.
   echo.
   echo  ########### FEHLER: ADMINISTRATOR RECHTE ERFORDERLICH ###########
   echo   Dieses Script sollte mit Administratorrechten gestartet werden!  
   echo   Mit rechter Maustaste "Als Administrator ausfuehren" waehlen.
   echo  #################################################################
   echo.
   echo  Mit beliebiger Taste bestaetigen.
   PAUSE >nul
   EXIT /B 1
)
echo.
echo                                            Hallo %USERNAME%
echo.
echo                               Diese kleine Batch Datei soll den Ordner 
echo                          System Volume Information von USB Laufwerken entfernen                        
@ping -n 1 localhost> nul
echo.
echo.
for /l %%i in (1,1,3) do echo. 
echo                     Folgende Wechseldatentraeger befinden sich auf Deinem Computer: 
echo.
@ping -n 2 localhost> nul
for /f %%L in ('wmic logicaldisk where drivetype^=2 get deviceid ^|findstr ":" ^|findstr /v /r "^^$"') do echo                     USB - Laufwerk: %%L erkannt.
@ping -n 5 localhost> nul
cls
for /l %%i in (1,1,3) do echo.
echo    Versuche nun die Systemwiderherstellung fuer alle USB Laufwerke zu deaktivieren.
echo.
@ping -n 2 localhost> nul
for /f %%L in ('wmic logicaldisk where drivetype^=2 get deviceid ^|findstr ":" ^|findstr /v /r "^^$"') do wmic /namespace:\\root\default path SystemRestore call Disable %%L\ 
for /f %%L in ('wmic logicaldisk where drivetype^=2 get deviceid ^|findstr ":" ^|findstr /v /r "^^$"') do vssadmin delete shadows /For=%%L /all /quiet
echo    Versuche den unnoetigen Speicherdienst zu deaktivieren.
sc config StorSvc start= disabled
sc stop StorSvc
echo    Versuche die Indizierung von Wechseldatentraegern zu deaktivieren.
@ping -n 5 localhost> nul
cls
for /l %%i in (1,1,3) do echo.
echo    Gebe %USERNAME% nun das Systemrecht zum loeschen von Systemordnern auf Wechseldatentraegern.
echo.
@ping -n 2 localhost> nul
for /f %%L in ('wmic logicaldisk where drivetype^=2 get deviceid ^|findstr ":" ^|findstr /v /r "^^$"') do cacls "%%L\System Volume Information" /E /G %USERNAME%:F 
@ping -n 5 localhost> nul
cls
for /l %%i in (1,1,3) do echo.
echo    Falls kein NTFS USB Laufwerk, dann weist dieser Befehl den Vollzugriff zu
echo.
@ping -n 2 localhost> nul
for /f %%L in ('wmic logicaldisk where drivetype^=2 get deviceid ^|findstr ":" ^|findstr /v /r "^^$"') do icacls "%%L\System Volume Information" /grant %USERNAME%:(CI)(OI)(F) 
@ping -n 5 localhost> nul
cls
for /l %%i in (1,1,3) do echo.
echo    Entferne nun alle Ordner auf USB Laufwerken, die "System Volume Information" heissen.
echo.
@ping -n 2 localhost> nul
for /f %%L in ('wmic logicaldisk where drivetype^=2 get deviceid ^|findstr ":" ^|findstr /v /r "^^$"') do rd /S /Q "%%L\System Volume Information" 
for /f %%L in ('wmic logicaldisk where drivetype^=2 get deviceid ^|findstr ":" ^|findstr /v /r "^^$"') do del /A /F /Q "%%L\.dropbox.device"
echo                   Ordner wurde erfolgreich geloescht.
@ping -n 5 localhost> nul
cls
for /l %%i in (1,1,3) do echo.
echo   #######################################################################
echo   #         Da das Verzeichnis immer wieder neu angelegt wird,          #
echo   #       wenn der Stick an deinen Windows PC angeschlossen wird,       #
echo   #         kannst Du diese Batch Datei beliebig oft ausfuehren,        #
echo   #              um den betreffenden Ordner zu loeschen.                #
echo   #######################################################################
echo.
echo        Lieber %USERNAME%, Ich hoffe ich konnte Dir ein wenig helfen.   
echo.        
)
COLOR 
echo                   Zum Beenden beliebige Taste druecken.
Pause >nul
exit


:: [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore]
:: "DisableSR"=dword:00000001
:: If it does not exit, create it by right clicking the right pane, select New > Key and make the key a DWORD Value.
:: change the value to 1 
:: services.msc
:: while you are in services.msc disabling "Windows Search" you also need to disable "Storage Service", by using the exact same sequence of steps.
:: reg add /?
:: net stop srservice
:: sc config srservice start= disabled
::                                      REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableRemovableDriveIndexing /t REG_DWORD /d 1 /f
:: if %username% == username %systemroot%\system32\reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows" /v DisableRemovableDriveIndexing /t REG_DWORD /d 1 /f
:: if %username% == username %systemroot%\system32\reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v DisableSR /t REG_DWORD /d 1 /f