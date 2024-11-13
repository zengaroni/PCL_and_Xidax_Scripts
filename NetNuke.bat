# Author - Zen Futral
# Created for use at PCLaptops

# This script automates a network reset process.

netsh wlan show wlanreport

ipconfig /release
ipconfig /flushdns
ipconfig /registerdns
ipconfig /renew

set http_proxy=
set https_proxy=

netsh int ip reset
netsh winsock reset catalog
netsh advfirewall reset
netsh int ipv4 reset
netsh int ipv6 reset
netsh wlan delete profile name=* i=*

msdt.exe /id NetworkDiagnosticsNetworkAdapter
msdt.exe /id NetworkDiagnosticsWeb

echo THIS SYSTEM NEEDS TO RESTART TO FINISH THE NETWORK RESET
pause

shutdown /r
