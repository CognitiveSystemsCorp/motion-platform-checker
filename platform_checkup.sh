#!/bin/bash
VERSION="1.0"
###########################################
#To run:
# ./platform_checkup.sh 
#or:
# sh ./platform_checkup.sh
#result file is "./platform_req_status.log"
# *******
#Make sure that the script will be executed in a writable directory.
#So the result file can be saved in current working directory.
###########################################

filename0="platform_req_status.log"
#update PATH:
export PATH="$PATH:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/opensync/tools:/usr/opensync/bin"

echo "Script version: $VERSION" > $filename0

echo "## https support " >> $filename0
##Check wget support https
status=$( wget -qO /dev/null https://www.google.com && echo Yes || echo No )
echo "wget support https:  $status" >> $filename0
#check curl support https
status=$( curl -sk https://www.google.com > /dev/null && echo Yes || echo No ) 
echo "curl support https:  $status" >> $filename0

### 1.list_fun_os_tools
# list_fun_os_tools=( ifconfig wget curl which ps route netcat/nc date tar cat awk ls tail stat ping nvram ntpd)
echo "## function_os_tools_general" >> $filename0
count=1
for item in  ifconfig wget curl which ps route nc date tar cat awk ls tail stat ping nvram ntpd ;
    do  
        # status=$( type  "$item"  > /dev/null && echo yes || echo no )
        status=$( type  "$item"  2> /dev/null  )
        echo "$count $item $status" >> $filename0
        count=$(( $count + 1 ))
        # unset f
done

## 2.list_fun_os_Broadcom
# list_fun_os_Broadcom=(wl brctl bcm_flasher bcm_bootstate)  
echo "## function_os_Broadcom" >> $filename0
count=1
for item in  wl brctl bcm_flasher bcm_bootstate pidof cevent ;
    do  
        status=$( type  "$item"  2> /dev/null )
        echo "$count $item $status" >> $filename0
        count=$(( $count + 1 ))
done

## 3.list_fun_os_cog 
# list_fun_os_cog=( find ssh md5sum perf)
echo "## function_os_cognitive" >> $filename0
count=1
for item in  find ssh telnet md5sum perf ;
    do  
        # f() { $item; }
        # status=$(fn_exists f && echo yes || echo no)
        status=$( type  "$item"    2> /dev/null )
        echo "$count $item $status" >> $filename0
        count=$(( $count + 1 ))
done

## 4.list_lib_cog
# list_lib_cog=(libssl libcrypto)
echo "## System_lib_cognitive" >> $filename0
count=1
for item in "libssl" "libcrypto";
    do
        echo "--- $count $item ---:" >> $filename0
        status=$(find / -name $item*)
        echo """ "" $status" >> $filename0
        count=$(( $count + 1 ))
done

##5. mosquito (mqtt) binaries
count=1
echo "## mosquitto_(mqtt)_binaries" >> $filename0
status=$(find / -name "mosquitto*")
echo "$count mosquitto $status" >> $filename0

# 6. file system access
# list_file_system=(/tmp/dnsmasq.lease /proc/net/arp /proc/loadavg /proc/uptime /proc/meminfo /proc/cpuinfo)
echo "## file_system_access" >> $filename0
count=1
for item in /tmp/dnsmasq.lease /proc/net/arp /proc/loadavg /proc/uptime /proc/meminfo /proc/cpuinfo; 
    do
        status=$([[ -f $item ]] && echo yes || echo no)
        echo "$(($count)) $item $status" >> $filename0
        count=$(( $count + 1 ))

    done

#dump env:
echo "## dump env" >> $filename0
echo "$(env)"  >> $filename0
##get filesystem space, etc.
echo "## get filesystem space, etc."  >> $filename0
echo "1 --- df ---"  >> $filename0
echo $(df)  >> $filename0
echo "2 --- cat /proc/mtd ---"  >> $filename0
echo $(cat /proc/mtd)  >> $filename0
echo "3 --- mount ---"  >> $filename0
echo $(mount)  >> $filename0
##mem:
echo "## mem info"  >> $filename0
echo $(cat /proc/meminfo)  >> $filename0
##cpu:
echo "## cpu info"  >> $filename0
echo $(cat /proc/cpuinfo)  >> $filename0
##ntp:
echo "## Network Time Protocol" >> $filename0
echo $(date) >> $filename0
##listening ports:
echo "## listening ports" >> $filename0
echo $(netstat -tulnp) >> $filename0
##firewall:
echo "## firewall" >> $filename0
echo "1 --- iptables -t raw -S ---"  >> $filename0
# echo $(iptables -t raw -S)  >> $filename0
echo $(iptables -t raw -S)  2>&1 $filename0
echo "2 --- iptables -t mangle -S ---" >> $filename0
echo $(iptables -t mangle -S) >> $filename0
echo "3 ---iptables -t filter -S ---" >> $filename0
echo $(iptables -t filter -S) >> $filename0
echo "4 --- iptables -t nat -S ---" >> $filename0
echo $(iptables -t nat -S) >> $filename0
##processes:
echo "## processes"  >> $filename0
echo "1 --- ps ---"  >> $filename0
echo $(ps)  >> $filename0
##or to get wide list (top might not be there though):
echo "2 --- top --- "  >> $filename0
echo $(top -b -n 1) >> $filename0
##ovsdb dump:
echo "## ovsdb dump" >> $filename0
echo $(ovsdb-client dump) >> $filename0
## Radio interfaces
echo "## radio interface (ifconfig)"  >> $filename0
echo $(ifconfig)  >> $filename0
# wl -i <wlX> csimon


#dump filesystem:
echo "## dump filesystem"  >> $filename0
# find / -name "*" >> $filename0
find / 2>/dev/null  >> $filename0


# QCOM:Check CFR is supported or not. (Motion detection capability)
    # The first command sets the cfr_timer variable to 1, and the second command reads it.
    # So a procedure you can use is:
    # (1) Set cfr_timer=1
    # (2) Read cfr_timer and confirm it is 1
    # (3) Set cfr_timer=0
    # (4) Read cfr_timer and confirm it is 0
    # But again, this only works with QSDK11 and greater.

# QSDK 5/6:
echo "# --- QSDK 5/6: "  >> $filename0
echo "# which iwpriv: "  >> $filename0
which iwpriv

echo "# iwpriv wifi0 get_cfr_timer: "  >> $filename0
iwpriv wifi0 get_cfr_timer >> $filename0
echo "# iwpriv wifi1 get_cfr_timer: "  >> $filename0
iwpriv wifi1 get_cfr_timer >> $filename0
echo "# iwpriv wifi2 get_cfr_timer: "  >> $filename0
iwpriv wifi2 get_cfr_timer >> $filename0


echo "# which  cfg80211tool："  >> $filename0
which  cfg80211tool  >> $filename0

echo "# cfg80211tool wifi0 cfr_timer 1："  >> $filename0
cfg80211tool wifi0 cfr_timer 1  >> $filename0
echo "# cfg80211tool wifi0 get_cfr_timer："  >> $filename0
cfg80211tool wifi0 get_cfr_timer  >> $filename0

echo "# cfg80211tool wifi0 cfr_timer 0："  >> $filename0
cfg80211tool wifi0 cfr_timer 1  >> $filename0
echo "# cfg80211tool wifi0 get_cfr_timer："  >> $filename0
cfg80211tool wifi0 get_cfr_timer  >> $filename0

# QSDK 10/11:
echo "# --- QSDK 10/11："  >> $filename0

echo "# cfg80211tool wifi0 get_cfr_timer："  >> $filename0
cfg80211tool wifi0 get_cfr_timer >> $filename0
echo "# cfg80211tool wifi1 get_cfr_timer："  >> $filename0
cfg80211tool wifi1 get_cfr_timer >> $filename0
echo "# cfg80211tool wifi2 get_cfr_timer："  >> $filename0
cfg80211tool wifi2 get_cfr_timer >> $filename0

# Broadcom: Check CFR is supported or not. (Motion detection capability)
echo "# --- Broadcom: Check CFR is supported or not："  >> $filename0
wl csimon state  >> $filename0
# CSI Monitor: Enabled: 1
# CSI record transfer (to DDR) count: 0
# Ack fail count: 0
# CSI record overflow count: 0