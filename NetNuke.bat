# Author - Zen Futral
# Created for use at PCLaptops

# This script automates a network reset process.


ipconfig /flushdns
ipconfig /registerdns
ipconfig /release
ipconfig /renew

netsh int ip reset
netsh winsock reset catalog
netsh int ipv4 reset
netsh int ipv6 reset

msdt.exe /id NetworkDiagnosticsNetworkAdapter
msdt.exe /id NetworkDiagnosticsWeb

pause