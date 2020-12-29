title CWP Utilities (SlimBB Edition) >nul 2>nul
mode con: cols=99 lines=33 >nul 2>nul
@echo off
set PATH=%~dp0bin;%PATH%
cd %~dp0
cd bin\processing\hosts\processed
del "hosts.bak" >nul 2>nul
del "final-hosts.txt" >nul 2>nul
rename HOSTS hosts.bak >nul 2>nul
cd %~dp0bin
busybox rm processing/hosts/*.final >nul 2>nul
busybox rm processing/hosts/*.hosts >nul 2>nul
busybox rm processing/hosts/hosts.* >nul 2>nul
busybox rm processing/hosts/sorted-hosts.txt >nul 2>nul
busybox rm processing/hosts/sorted-hosts6.txt >nul 2>nul
busybox rm processing/hosts/hosts-dual.txt >nul 2>nul
busybox rm processing/hosts/hosts4 >nul 2>nul
busybox rm processing/hosts/hosts6 >nul 2>nul
busybox rm processing/hosts/uniq-hosts-final.pre >nul 2>nul
busybox rm processing/hosts/final-hosts.txt >nul 2>nul
@echo on
curl -s -o processing/hosts/hosts.1 "https://winhelp2002.mvps.org/hosts.txt"
curl -s -o processing/hosts/hosts.2 "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
curl -s -o processing/hosts/hosts.3 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/NoFormatting/MD-Immortal_Domains-Backup-HOSTS.txt"
curl -s -o processing/hosts/hosts.4 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/adguard_desktop-hosts.txt"
curl -s -o processing/hosts/hosts.5 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/spam_404-hosts.txt"
curl -s -o processing/hosts/hosts.6 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/adguard_mobile-hosts.txt"
curl -s -o processing/hosts/hosts.7 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/WindowsTelemetryBlockSupplements/SBBTYZ-IPv4.txt"
curl -s -o processing/hosts/hosts.8 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/easylist_desktop-hosts.txt"
curl -s -o processing/hosts/hosts.9 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/adguard_dns-hosts.txt"
curl -s -o processing/hosts/hosts.10 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/piperun-hosts.txt"
curl -s -o processing/hosts/hosts.11 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/disconnect_consolidated.txt"
curl -s -o processing/hosts/hosts.12 "https://gitlab.com/curben/urlhaus-filter/raw/master/urlhaus-filter-hosts-online.txt"
curl -s -o processing/hosts/hosts.13 "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/NoFormatting/AdditionalSupplementaryHosts.txt"
busybox cat processing/hosts/hosts.* > processing/hosts/hosts-cat.final
d2u processing/hosts/hosts-cat.final
sed -i -e "s/#.*$//" -e "/[[:space:]]*#/d" -e "/[[:blank:]]*#/d" -e "s/\t/ /g" -e "s/^127.0.0.1/0.0.0.0/g" -e "s/^::1/0.0.0.0/g" -e "s/^::/0.0.0.0/g" -e "s/[[:space:]]*$//" -e "s/[[:blank:]]*$//" -e "s/[[:space:]]\+/ /g" -e "/^0.0.0.0 /! s/^/0.0.0.0 /" -e "/[\d128-\d255]/d" -e "/\^\document/d" -e "/\^/d" -e "/\*/d" -e "/\?/d" -e "/\//d" -e "/@/d" -e "/!/d" -e "/|/d" -e "/:/d" -e "/~/d" -e "/,/d" -e "/=/d" -e "s/\(.*\)/\L\1/" processing/hosts/hosts-cat.final
pcregrep -v -f hostpatterns.dat processing/hosts/hosts-cat.final > processing/hosts/hosts-pre.final
busybox sort -u processing/hosts/hosts-pre.final > processing/hosts/uniq-hosts.final
busybox cp processing/hosts/uniq-hosts.final processing/hosts/uniq-hosts-final.pre
d2u processing/hosts/uniq-hosts.final
pcregrep -f tld-filter.dat processing/hosts/uniq-hosts.final > processing/hosts/uniq-hosts-temp.final
busybox mv -f processing/hosts/uniq-hosts-temp.final processing/hosts/uniq-hosts.final
d2u processing/hosts/uniq-hosts.final
busybox sort processing/hosts/uniq-hosts.final > processing/hosts/final-sort.hosts
d2u processing/hosts/final-sort.hosts
busybox uniq -i processing/hosts/final-sort.hosts > processing/hosts/final-uniq.hosts
d2u processing/hosts/final-uniq.hosts
busybox head -c -1 processing/hosts/final-uniq.hosts > processing/hosts/hosts.final
d2u processing/hosts/hosts.final
busybox cp processing/hosts/hosts.final processing/hosts/sorted-hosts.txt
busybox mv processing/hosts/sorted-hosts.txt processing/hosts/final-hosts.txt
busybox cp processing/hosts/final-hosts.txt processing/hosts/processed/
cd %~dp0bin\processing\hosts\processed
@echo off
cscript optimizer.js
timeout 3 >nul 2>nul
@echo on
copy /Y HOSTS %SystemDrive%\Windows\System32\Drivers\etc\HOSTS
ipconfig /flushdns
@echo off
echo ...
echo Done! Your hosts file has been updated. There is nothing left for you to do here.
timeout 1 >nul 2>nul
:parse
if "%~1"=="" goto endparse
if "%~1"=="-el" goto endloop
SHIFT
goto parse
:endparse
echo ...
echo Hit enter to return to the main menu.
echo ...
pause
cd %~dp0
cd ..
WinUtilsMultiLauncher.bat

:endloop
echo ...
echo Hit enter to exit.
echo ...
pause
exit
