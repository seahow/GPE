@echo off
cd
CALL C:\ProgramData\chocolatey\bin\bginfo.exe C:\Bootstrap\bastion\main.bgi /timer:0 /nolicprompt
del "C:\Users\Public\Desktop\Google Chrome.lnk"
del "C:\Users\Public\Desktop\WinSCP.lnk"
del "C:\Users\Public\Desktop\Visual Studio Code.lnk"
del "C:\Users\Public\Desktop\VMware.PowerCLI.lnk"
del "c:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\setbginfo.cmd"