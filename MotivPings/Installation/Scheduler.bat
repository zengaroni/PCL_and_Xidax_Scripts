cd ..
SCHTASKS /CREATE /SC ONLOGON /TN "MotivPingAuto" /TR "D:\Code\MotivPings\Installation\AutoExec.bat"
exit