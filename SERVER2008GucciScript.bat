@echo off

:: Start Message
title Despacito.exe
echo ==========================================
echo       Server 2008 CyberPatriot Script
echo            by Jackson Kauflin
echo.
echo     This script is dedicated to Drake
echo  because he make sure that north-side eat
echo ==========================================
echo.

pause

:: Setup
set automode=false
mode con: cols=100 lines=22
set desktop=%userprofile%\Desktop
set compfiles=%desktop%\Server2008CompFiles
set pshellrun=@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command
set PATH=%PATH%;%programfiles%\Git\bin;%programfiles%\nodejs\node_modules\npm\bin;%appdata%\npm;%compfiles%
del /f /q C:\users.txt C:\approved_users.txt C:\approved_users_gucci.txt C:\users_admins.txt C:\mediafiles.txt C:\sketchyfiles.txt C:\eek.txt

:: Motivational Speech
cls
echo Reminders! PLEASE READ
echo.
echo - For any prompt, you can type "n" or "re"
echo   to skip that choice or go back to menu, respectively.
echo.
echo - Read the messages that show up so you don't forget stuff.
echo.
echo - MAKE NOTE of each step you have done in case
echo   of a screw up *ahem* Timon
echo.
echo - Follow checklist/script closely and don't forget simple stuff.
echo   (Also double, triple check cause script sometimes broken)
echo.
pause
echo.
echo Did ya read it all? DID YA?
echo.
pause

:: Set stickykeys to CMD
takeown /f "%systemroot%\System32\sethc.exe"
takeown /f "%systemroot%\System32\cmd.exe"
icacls "%systemroot%\System32\sethc.exe" /grant %username%:f
icacls "%systemroot%\System32\cmd.exe" /grant %username%:f
ren "%systemroot%\System32\sethc.exe" "%systemroot%\System32\sethc1.exe"
copy "%systemroot%\System32\cmd.exe" "%systemroot%\System32\sethc.exe"

:: Ask if first time setup
cls
set /p cont="Is this first time setup? (y/n) "
if %cont% == n goto autochoice

:: Install git and pull from master
cls
%pshellrun% "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco feature enable -n allowGlobalConfirmation

choco install git
set PATH=%programfiles%\Git\bin;%PATH%

cd %desktop%
git init
git remote add origin https://github.com/Marduk28/CyberPatriot_Windows_Scripts.git
git fetch origin master
git checkout origin/master Server2008CompFiles OurGloriousChecklist2018_Windows.txt

:: Install diffchecker CLI
cls
choco install nodejs
call npm install -g diffchecker

:: Ask if menu or automode
:autochoice
cls
echo Menu is for quick stuff ya need to do, Auto mode is main option
echo.
echo Note: Auto mode will still take you to menu, you just choose where to start.
echo.
set /p autochoice="Menu or auto mode? (m/a) "

if %autochoice% == a (
	set automode=true
	goto menu
)
if %autochoice% == m (
	set automode=false
	start /d "%compfiles%" DankMMC.msc
	goto menu
)
else (
	cls
	echo That's not an option, ya gaylord!
	echo.
	pause
	goto autochoice
)

:: Menu
:menu
cls
echo 1) README                          g) Readme Requirements
echo 2) Windows Update + Service Pack   h) Event Viewer
echo 3) Server Manager                  i) Sysinternals
echo 4) Inf files                       j) Install programs
echo 5) SCM OS Baselines                k) Update programs
echo 6) DISA Stig                       l) Services
echo 7) Audit Policy                    m) Media files
echo 8) Forensics                       n) Remove programs + features
echo 9) Add/Delete users                o) SCM IE baselines
echo a) Activate/Disable users          p) Backup
echo b) Add/Delete admins               q) Application Settings
echo c) Change passwords                r) Hosts file
echo d) Enable Firewall                 s) Operating system settings
echo e) Nessus                          t) Defensive Countermeasures
echo f) MMC Stuff                       u) Prohibited files
echo                                    v) Random list of things at the end
echo.
echo w) Open DankMMC
echo x) Open official checklist
echo y) Open master checklist
echo.

choice /c 123456789abcdefghijklmnopqrstuvxy /n /m "Where would you like to start? "
goto %errorlevel%

:: README
:1
cls
echo Read the README, ya bigot higot!
echo.

pause

if %automode% == true goto 2

goto menu

:: Windows Update + Service Pack
:2
if %automode% == true (
	cls
	sc config wuauserv start= auto
	if %errorlevel% == 1 echo. && echo Uh oh. Error happened.
	sc start wuauserv
	if %errorlevel% == 1 echo. && echo Uh oh. Error happened.
	echo.

	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f

	start /d "%desktop%" Server2008ServicePack32bit.exe

	cls
	echo Windows Update yeet
	echo Still gotta start it manually oof
	echo.
	start wuapp.exe
	pause

	goto 3
)

cls
echo Set automatic updates.
echo.

start wuapp.exe

start /d "%compfiles%" Server2008ServicePack32bit.exe

pause

goto menu

:: Server Manager
:3
cls
echo Do all the things for Server Manager:
echo.
echo - Enable Powershell and Backup
echo - Enable Firewall
echo - Remove Roles + Features
echo - IE Enhanced Security Configuration
echo.

start /d "%SystemRoot%\system32" CompMgmtLauncher.exe

pause

if %automode% == true goto 4

goto menu

:: Inf files
:4

cls
set /p inf="Good or Bad Inf? (g/b) "
if %inf% == e goto goodinf
if %inf% == d goto badinf
if %inf% == re goto menu
if %inf% == n (
	if %automode% == true goto 5
	goto menu
)

:goodinf
cls
secedit /configure /db "%systemroot%\dankdatabase1.db" /cfg "%compfiles%\Server2008EnabledInf.inf"
if %errorlevel% == 1 echo. && echo Uh oh. Error happened.
cls
echo Good INF Done!
echo.
echo Check the scoring report and copy/paste the vulnerabilities into notepad.
echo.

pause

goto 4

:badinf
cls
secedit /configure /db "%systemroot%\dankdatabase2.db" /cfg "%compfiles%\Server2008DisabledInf.inf"
if %errorlevel% == 1 echo. && echo Uh oh. Error happened.
cls
echo Bad Inf Done!
echo.
echo Check the scoring report and copy/paste the vulnerabilities into notepad.
echo.

pause

goto 4

:: SCM OS Baselines
:5
cls

"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\AD_Cert"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\DHCP_Server"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\DNS_Server"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Dom_Cont"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Dom_Sec"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\File_Server"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Hyper_V_Sec"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Mbr_Serv"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Net_Access"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Print_Serv"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Term_Serv"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Web_Serv"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\Server2008\Web_Serv"
cls
echo SCM Baselines Done!
echo.
echo Check the scoring report and copy/paste the vulnerabilities into notepad.
echo.

pause

if %automode% == true goto 6

goto menu

:: DISA Stig
:6
cls

secedit /configure /db "%systemroot%\dankdatabase3.db" /cfg "%compfiles%\Server2008DISAStig.inf"
if %errorlevel% == 1 echo. && echo Uh oh. Error happened.
cls
echo DISA Stig Done!
echo.
echo Check the scoring report and copy/paste the vulnerabilities into notepad.
echo.

pause

if %automode% == true goto 7

goto menu

:: Audit Policy
:7
cls
echo Import the two audit templates (AllAudit then NoAudit)
echo.
echo Check the scoring report and copy/paste the vulnerabilities into notepad.
echo.
start gpedit.msc

pause

if %automode% == true goto gpting

goto menu

:: GPting
:gpting
cls
echo Alrighty, my dude. Get all the Group Policy stuff done.
echo Basically make sure you didn't miss anything in MMC.
echo.

pause

goto 8

:: Forensics
:8
cls
echo Hey! Do thein forensic question. Eek.
echo.

pause

if %automode% == true goto 9

:: Add/Delete Users
:9
cls
if %automode% == true (
	%pshellrun% Get-LocalUser > C:\usertemp_ps.txt

	for /f "skip=3" %%G in (C:\usertemp_ps.txt) do (echo %%G >> C:\users_admins.txt)
	findstr /v "BroPants BroShirt DefaultAccount defaultuser0" C:\users_admins.txt > C:\users.txt
	call jrepl " +$" "" /f C:\users.txt /o -
	call jrepl " +$" "" /f C:\users_admins.txt /o -

	del /f /q C:\usertemp_ps.txt C:\usertemp_1.txt

	echo Please put all the users from README, including admins here and save then close > C:\approved_users.txt
	echo Replace these 2 lines btw smh >> C:\approved_users.txt
	start C:\approved_users.txt
	pause

	sort < C:\approved_users.txt > C:\approved_users_gucci.txt

	diffchecker C:\approved_users_gucci.txt C:\users.txt

	goto userchoice
)
:userchoice
cls
net user

set /p choice="Add or remove user? (a/r) "
if %choice% == a goto addusers
if %choice% == r goto delusers
if %choice% == n (
	if %automode% == true goto 10
	goto menu
)
if %choice% == re goto menu

:addusers
cls
net user

set /p user="Enter a username and their password to add... "
if %user% == n goto 9
if %user% == re goto menu
net user "%user%" /add

goto addusers

:delusers
cls
net user

set /p user="Enter a user to delete... "
if %user% == n goto 9
if %user% == re goto menu
net user %user% /delete

goto delusers

:: Activate/Disable Users
:10
if %automode% == true (
	cls
	net user BroShirt /active:no
	net user BroPants /active:no
	for /f %%G in (C:\users.txt) do net user %%G /active:yes
	cls
	echo Activate users done!
	echo.
	pause
	goto 11
)

net user BroPants /active:no

cls
net user

echo Enable all accounts. Guest account has been disabled.
echo.

set /p choice="Activate or disable user? (a/d) "
if %choice% == a goto activateusers
if %choice% == d goto disableusers
if %choice% == n (
	if %automode% == true goto 11
	goto menu
)
if %choice% == re goto menu

:activateusers
cls
net user

set /p user="Enter a user to activate... "
if %user% == n goto 10
if %user% == re goto menu
net user %user% /active:yes

goto activateusers

:disableusers
cls
net user

set /p user="Enter a user to disable... "
if %user% == n goto 10
if %user% == re goto menu
net user %user% /active:no

goto disableusers

:: Deleting/adding admins
:11
cls
net localgroup administrators

set /p choice="Add or remove admin? (a/r) "

if %choice% == a goto addadmins
if %choice% == r goto deladmins
if %choice% == n (
	if %automode% == true goto 12
	goto menu
)
if %choice% == re goto menu

:addadmins
cls
net user
net localgroup administrators

set /p user="Enter a user to add to admin group... "
if %user% == n goto 11
if %user% == re goto menu
net localgroup administrators %user% /add

goto addadmins

:deladmins
cls
net localgroup administrators

set /p user="Enter a user to remove from admin group... "
if %user% == n goto 11
if %user% == re goto menu
net localgroup administrators %user% /delete

goto deladmins

:: Changing passwords
:12
if %automode% == true (
	cls
	for /f %%G in (C:\users_admins.txt) do net user %%G abc123ABC123@@
	cls
	echo Changing all passwords done!
	echo.
	pause
	goto 13
)

cls
net user

echo All users' passwords will be abc123ABC123@@
echo.

set /p user="Enter user for password change... "
if %user% == n (
	if %automode% == true goto 13
	goto menu
)
if %user% == re goto menu
net user %user% abc123ABC123@@

goto 12

:: Enable firewall + template
:13
cls
netsh advfirewall import "%compfiles%\Server2008Firewall.wfw"
if %errorlevel% == 1 echo. && echo Uh oh. Error happened.
netsh advfirewall set allprofiles state on
if %errorlevel% == 1 echo. && echo Uh oh. Error happened.
cls
echo Firewall enabled!
echo.
pause
cls
echo Check firewall exceptions for sketchiness...
echo.
firewall.cpl
pause

if %automode% == true goto 14

goto menu

:: Nessus
:14
cls
ipconfig
echo.

echo Run the Nessus immediately cause it might help and stuff yooo!
echo.

pause

if %automode% == true goto 15

goto menu

:: MMC Stuff
:15
:sharestart
cls
net share
echo.
set /p share="Choose a share to delete cause it sketchy... "
if %share% == n goto mmccont
if %share% == re goto menu
net share %share% /del
goto sharestart

:mmccont
cls
echo Check locked users/other user stuff
echo.
if %automode% == true start compmgmt.msc
pause

cls
echo Enable Windows Defender
echo.
if %automode% == true start gpedit.msc
pause

cls
echo Enable Smartscreen (doesn't apply to Server 2008)
echo.
pause

cls
echo Disable autoplay
echo.
pause

if %automode% == true goto 16

goto menu

:: README Requirements
:16
cls
echo Open the readme and do the specific things it says to do.
echo Could be enabling service, adding user/group, etc.
echo.

pause

if %automode% == true goto 17

goto menu

:: Event Viewer
:17
cls
echo Look at the Event Viewer for stuff that's BAD
echo.
start eventvwr.msc
pause

if %automode% == true goto 18

goto menu

:: Sysinternals
:18
cls Installing Sysinternals...
echo.
choco install sysinternals

cls
echo Opening TCPView, Process Explorer, and Autoruns...
echo.
echo Make sure to delete the file itself, not just the process
echo.
procexp
autoruns
tcpview
pause

if %automode% == true goto 19

goto menu

:: Install programs
:19
cls
echo The programs should open automatically after they all install,
echo but if not run the programs n stuff.
echo.

choco feature enable -n useFipsCompliantChecksums

cls
choco install firefox ie9 malwarebytes mbsa microsoftsecurityessentials --ignorechecksum --force
pause

start /d "%programfiles%\Malwarebytes\Anti-Malware" mbam.exe
start /d "%programfiles%\Microsoft Baseline Security Analyzer 2" mbsa.exe
start /d "%programfiles%\Microsoft Security Client" msseces.exe

if %automode% == true goto 20

goto menu

:: Update programs
:20
if %automode% == true (
	cls
	choco upgrade all
	goto install
)

:install
cls
echo PUT LOTS OF EFFORT INTO THIS AND DONT FORGET IT.
echo.
echo Install programs that need to be updated.
echo.

start firefox.exe chocolatey.org

set /p install="Enter a program to update... "
if %install% == n goto manualupdate
if %install% == re goto menu
echo.

choco install %install% --ignorechecksum
choco upgrade %install% --ignorechecksum

goto install

:manualupdate
cls
echo Update all programs you can't with chocolatey.
echo.

pause

if %automode% == true goto 21

goto menu

:: Services
:21
cls
if %automode% == true (
	sc stop tlntsvr
	sc config tlntsvr start= disabled
	sc stop msftpsvc
	sc config msftpsvc start= disabled
	sc stop snmptrap
	sc config snmptrap start= disabled
	sc stop ssdpsrv
	sc config ssdpsrv start= disabled
	sc stop termservice
	sc config termservice start= disabled
	sc stop sessionenv
	sc config sessionenv start= disabled
	sc stop remoteregistry
	sc config remoteregistry start= disabled
	sc stop Messenger
	sc config Messenger start= disabled
	sc stop upnphos
	sc config upnphos start= disabled
	sc stop WAS
	sc config WAS start= disabled
	sc stop RemoteAccess
	sc config RemoteAccess start= disabled
	sc stop mnmsrvc
	sc config mnmsrvc start= disabled
	sc stop NetTcpPortSharing
	sc config NetTcpPortSharing start= disabled
	sc stop RasMan
	sc config RasMan start= disabled
	sc stop TabletInputService
	sc config TabletInputService start= disabled
	sc stop RpcSs
	sc config RpcSs start= disabled
	sc stop SENS
	sc config SENS start= disabled
	sc stop EventSystem
	sc config EventSystem start= disabled
	sc stop SysMain
	sc config SysMain start= disabled
	sc config EventLog start= auto
	sc start EventLog
	goto manualserv
)

echo tlntsvr (Telnet)
echo msftpsvc (FTP)
echo snmptrap (SNMP Trap)
echo ssdpsrv (SSDP Discovery)
echo termservice, sessionenv (Remote Desktop Services) *Dont disable these if remote desktop is needed*
echo remoteregistry (Remote Registry)
echo Messenger (Windows Messenger)
echo upnphos (Universal Plug n Play)
echo WAS (Web server Service)
echo RemoteAccess (Routing and Remote Access)
echo mnmsrvc (NetMeeting Remote Desktop Sharing)
echo NetTcpPortSharing (Net.Tcp Port Sharing Service)
echo RasMan (Access for dial-up and VPN)
echo TabletInputService (Tablet crap)
echo RpcSs (Remote Procedure Call)
echo SENS (System Event Notification Service)
echo EventSystem (COM+ Event System)
echo SysMain (Superfetch)
echo EventLog (Event Log duh)
echo.

set /p choice="Enable or Disable Service? (e/d/def) "

if %choice% == e goto enableserv
if %choice% == d goto disablegud
if %choice% == n goto manualserv
if %choice% == re goto menu
if %choice% == def (
	sc stop tlntsvr
	sc config tlntsvr start= disabled
	sc stop msftpsvc
	sc config msftpsvc start= disabled
	sc stop snmptrap
	sc config snmptrap start= disabled
	sc stop ssdpsrv
	sc config ssdpsrv start= disabled
	sc stop termservice
	sc config termservice start= disabled
	sc stop sessionenv
	sc config sessionenv start= disabled
	sc stop remoteregistry
	sc config remoteregistry start= disabled
	sc stop Messenger
	sc config Messenger start= disabled
	sc stop upnphos
	sc config upnphos start= disabled
	sc stop WAS
	sc config WAS start= disabled
	sc stop RemoteAccess
	sc config RemoteAccess start= disabled
	sc stop mnmsrvc
	sc config mnmsrvc start= disabled
	sc stop NetTcpPortSharing
	sc config NetTcpPortSharing start= disabled
	sc stop RasMan
	sc config RasMan start= disabled
	sc stop TabletInputService
	sc config TabletInputService start= disabled
	sc stop RpcSs
	sc config RpcSs start= disabled
	sc stop SENS
	sc config SENS start= disabled
	sc stop EventSystem
	sc config EventSystem start= disabled
	sc stop SysMain
	sc config SysMain start= disabled
	sc config EventLog start= auto
	sc start EventLog
	goto 21
)

:enableserv
cls
echo tlntsvr (Telnet)
echo msftpsvc (FTP)
echo snmptrap (SNMP Trap)
echo ssdpsrv (SSDP Discovery)
echo termservice, sessionenv (Remote Desktop Services) *Dont disable these if remote desktop is needed*
echo remoteregistry (Remote Registry)
echo Messenger (Windows Messenger)
echo upnphos (Universal Plug n Play)
echo WAS (Web server Service)
echo RemoteAccess (Routing and Remote Access)
echo mnmsrvc (NetMeeting Remote Desktop Sharing)
echo NetTcpPortSharing (Net.Tcp Port Sharing Service)
echo RasMan (Access for dial-up and VPN)
echo TabletInputService (Tablet crap)
echo RpcSs (Remote Procedure Call)
echo SENS (System Event Notification Service)
echo EventSystem (COM+ Event System)
echo SysMain (Superfetch)
echo EventLog (Event Log duh)
echo.

set /p serv="Enter a service to enable... "
if %serv% == n goto 21
if %serv% == re goto menu

sc config %serv% start= auto
sc start %serv%

goto enableserv

:disablegud
cls
echo tlntsvr (Telnet)
echo msftpsvc (FTP)
echo snmptrap (SNMP Trap)
echo ssdpsrv (SSDP Discovery)
echo termservice, sessionenv (Remote Desktop Services) *Dont disable these if remote desktop is needed*
echo remoteregistry (Remote Registry)
echo Messenger (Windows Messenger)
echo upnphos (Universal Plug n Play)
echo WAS (Web server Service)
echo RemoteAccess (Routing and Remote Access)
echo mnmsrvc (NetMeeting Remote Desktop Sharing)
echo NetTcpPortSharing (Net.Tcp Port Sharing Service)
echo RasMan (Access for dial-up and VPN)
echo TabletInputService (Tablet crap)
echo RpcSs (Remote Procedure Call)
echo SENS (System Event Notification Service)
echo EventSystem (COM+ Event System)
echo SysMain (Superfetch)
echo EventLog (Event Log duh)
echo.

set /p serv="Enter a service to disable... "
if %serv% == n goto 21
if %serv% == re goto menu

sc stop %serv%
sc config %serv% start= disabled

goto disablegud

:manualserv
cls
echo Now look for sketchy services to disable and stuff
echo.
start services.msc
pause

if %automode% == true goto 22

goto menu

:: Media Files
:22

if %automode% == true goto deletemf

cls
set /p choice="Search for or delete media files? (s/d) "
if %choice% == s goto searchmf
if %choice% == d goto deletemf
if %choice% == n (
	if %automode% == true goto 23
	goto menu
)
if %choice% == re goto menu

:deletemf
cls
echo Note: "Couldn't find mediafiles.txt" is expected here.
echo.

del "%homedrive%\mediafiles.txt" /f /q

del /s "%homedrive%\*.mp3" /f /q /a
del /s "%homedrive%\*.mp4" /f /q /a
del /s "%homedrive%\*.avi" /f /q /a
del /s "%homedrive%\*.wmv" /f /q /a
del /s "%homedrive%\*.mid" /f /q /a
del /s "%homedrive%\*.mov" /f /q /a
del /s "%homedrive%\*.m4v" /f /q /a
del /s "%homedrive%\*.3gp" /f /q /a
del /s "%homedrive%\*.wma" /f /q /a

cls
echo Media files deleted.
echo.
echo Now check for ones missed. Wait for dis.
echo.

cd %homedrive%\
dir /s /a /b /o-d *.mp3 *.mp4 *.avi *.wmv *.mid *.mov *.m4v *.3gp *.wma *.wav >> mediafiles.txt

start mediafiles.txt

pause

if %automode% == true goto 23

goto 22

:searchmf
cls
echo Note: "Couldn't find mediafiles.txt" is expected here.
echo.
echo Searching for media files...
echo.

del "%homedrive%\mediafiles.txt" /f /q

cd %homedrive%\
dir /s /a /b /o-d *.mp3 *.mp4 *.avi *.wmv *.mid *.mov *.m4v *.3gp *.wma *.wav >> mediafiles.txt

start mediafiles.txt

pause

if %automode% == true goto 23

goto 22

:: Remove Programs + Features
:23
cls
echo MAKE SURE YOU DO ALL OF THE TINGS. DO IT GOOD.
echo.
echo Uninstall programs
echo.
echo Remove features
echo.
echo Remove folders in Program Files
echo.
echo Remove .zip, .exe, .msi
echo.

start appwiz.cpl
cd %homedrive%\
dir /s /a /b /o-d *.zip *.exe *.msi >> sketchyfiles.txt
start sketchyfiles.txt

pause

if %automode% == true goto 24

goto menu

:: SCM IE Baselines
:24
cls
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\IE9_Com_Sec"
"%compfiles%\SCMBaselines\LGPO.exe" /g "%compfiles%\SCMBaselines\IE9_User_Sec"

if %automode% == true goto 25

goto menu

:: Backup
:25
cls
set /p location="Enter the drive letter for the backup location... "

wbadmin enable backup -addtarget:%location%: -include:C: -schedule:03:00 -quiet

if %automode% == true goto 26

goto menu

:: Application Settings
:26
cls
echo IF YOU'RE ON A SERVER OS, focus on this a little more.
echo.
echo Set all dem application security settings.
echo.
echo Firefox:
echo	- Warn when try to install addons
echo	- Popup blocker
echo	- other crap
echo.
echo See if there are security settings for other programs.
echo Use the interwebs to your advantage.
echo.

start firefox.exe

pause

if %automode% == true goto 27

goto menu

:: Hosts file
:27
cls
takeown /f "%systemroot%\system32\drivers\etc"

del "%systemroot%\system32\drivers\etc\hosts"
copy "%compfiles%\hosts" "%systemroot%\system32\drivers\etc\hosts"

if %automode% == true goto 28

goto menu

:: Operating System Settings
:28
cls
echo IF YOU'RE ON A SERVER OS, focus on this a little more.
echo.
echo Enable screen saver + check "logon on resume"
echo.
control desktop
pause

cls
echo Check file permissions for danko folders
echo.
pause

cls
echo Disable remote desktop
echo.
start sysdm.cpl
pause

cls
echo Enable UAC
echo.
pause

if %automode% == true goto 29

goto menu

:: Defensive Countermeasures
:29
cls
echo Make sure windows defender is danko enabled
echo.
pause

cls
echo Make sure you have the security programs installed
echo.
pause

cls
echo Scan on all those programs
echo.
pause

if %automode% == true goto 30

goto menu

:: Prohibited files
:30
cls
echo Yaboi prohibited files.
echo.
echo - Look for xml, txt, etc. in notepad that will open in a second.
echo.
echo - Look in folders for files (sort by date modified)
echo.

cd %homedrive%\
dir /s /a /b /o-d >> eek.txt
start eek.txt

pause

if %automode% == true goto 31

goto menu

:: Random Things At The End
:31
cls
echo Check processes for sketchiness.
echo.
start taskmgr.exe
start firefox.exe www.processlibrary.com
pause

cls
echo Vulns from other images
echo.
pause

cls
echo Go through every single step again (extreme thorough-ness not super necessary)
echo.
pause

cls
echo Past comp vulns (Make Peter or someone read them)
echo.
pause

cls
echo Go through everthing AGAIN MY MAN
echo.
pause

cls
echo Official checklist
echo.
start /d "%compfiles%" OfficialServer2008Checklist.docx
pause

if %automode% == true goto end

goto menu

:: End
:end
echo If you reached this screen, you did a good. Maybe. Idk man.
echo.
echo Sending you back to the menu now...
echo.

pause

goto menu

:: Open DankMMC
:32
start /d "%compfiles%" DankMMC.msc
goto menu

:: Open official checklist
:33
start /d "%compfiles%" OfficialServer2008Checklist.docx
goto menu

:: Open master checklist
:34
start /d "%desktop%" OurGloriousChecklist2018_Windows.txt
goto menu
