#!/bin/bash
# ==========================================================================================================
#     name: Preboot_Check_Script
#   author: bijith.nair@hitachiconsulting.com
#     date: 2015-07-08
#      ver: 1.0.10
#  purpose: report on the health of OS services and configuration
# ==========================================================================================================
HCVer='1.0.10'                                                                 # define HC Version
logfile="/sysadmin/reports/$(basename ${0})-$(hostname -s)";                   # set logfile name
[[ -e /sysadmin/reports/ ]] || mkdir -p /sysadmin/reports/                     # if missing, create output dir
[[ -e ${logfile} ]] && mv ${logfile}{,.oldreport};                             # backup output of last run
LANG='en_US.UTF-8'                                                             # avoids formatting problems
LC_NUMERIC='en_US.UTF-8'
LC_TIME='en_US.UTF-8'                                                          # set time format
curTTY=$(tty | sed 's/\/dev\///');                                             # get current TTY
ranBy=$(who | grep -i "$curTTY" | cut -d' ' -f1);                              # who ran the script
# get servers IP
svrIP=$(nslookup $(hostname -s) | grep Name -A1 | grep Address | sed 's/.*:\s*//');
svrFQDN=$(hostname -f);                                                        # get hostname fqdn
svrKernel=$(uname -r);                                                         # get running kernel version
svrOS=$(lsb_release -d | sed 's/.*:\s*//');                                    # get os version
svrOSver=$(lsb_release -r | sed 's/.*:\s*//');                                 # get os release version
flagOCFS2=$(grep -v '^\s*#' /etc/fstab | grep -q ocfs)$?;                      # test for ocfs2 mounts
# set flag if server is a VM
flagVM=$(/usr/sbin/dmidecode -s system-manufacturer | grep -iq vmware && echo 1);


E_LINUX_DF_HOME='Free Space on /home/ is below 1536MB, consider growing it';
E_LINUX_DF_OPT='Free Space on /opt/ is below 1536MB, consider growing it';
E_LINUX_DF_TMP='Free Space on /tmp/ is below 1536MB, consider growing it';
E_LINUX_DF_USR='Free Space on /usr/ is below 1536MB, consider growing it';
E_LINUX_DF_VAR='Free Space on /var/ is below 1536MB, consider growing it';
E_LINUX_IPV6='ipv6 should be disabled on all  Linux systems';
E_VM_NOTOOLS='VMware Tools should be installed on all virtual machines';


#-BEGIN-BUILDING-HEALTH-CHECK-REPORT-------------------------------------------#
echo -e "\n"
#echo -e "\n... BUILDING Preboot checklist  REPORT ...";
echo -e "\t...\033[4mBUILDING Preboot checklist  REPORT\033[0m ..."
echo -e "\n*** ${svrFQDN} Health Check v${HCVer} ran by $(whoami) user on $(date +'%a %e %b %Y %r %Z') ***"
echo -e "\n    OS: ${svrOS}" >> ${logfile};
echo -e "kernel: ${svrKernel}" >> ${logfile};
echo -e "uptime: $(uptime | sed 's/^ //1')" >> ${logfile};
[[ $flagVM ]] && [[ -e /usr/bin/vmware-toolbox ]] && echo -e "$(/usr/bin/vmware-toolbox --version)" >> ${logfile};
echo -e "\nSystem Information\n  Manufacturer:\t$(/usr/sbin/dmidecode -s system-manufacturer)\n  Product Name:\t$(/usr/sbin/dmidecode -s system-product-name)\n        Serial:\t$(/usr/sbin/dmidecode -s system-serial-number)\n" >> ${logfile};     # report machine type
echo -e "\nBIOS Information\n        Vendor:\t$(/usr/sbin/dmidecode -s bios-vendor)\n       Version:\t$(/usr/sbin/dmidecode -s bios-version)\n  Release Date:\t$(/usr/sbin/dmidecode -s bios-release-date)\n" >> ${logfile};                # report bios information
echo -e "\n**** Memory ****\n$(free -m) \n\n$(free -m | xargs | awk '{print "Free/total memory: " $17 " / " $8 " MB"}')" >> ${logfile};
echo -e "\n**** Time Status ****\nHWCLOCK = $(/sbin/hwclock --show)\nSYSCLOCK= $(date +'%a %d %b %Y %r %Z')" >> ${logfile};
echo -e "\n**** NTP Status ****\n$(/etc/init.d/ntpd status)" >> ${logfile};
echo -e "\n**** NTP Statistics *****\n$(ntpq -pn)" >> ${logfile};
echo -e "\n**** FTP Status ****\n$(if [ -s /etc/init.d/vsftpd ]; then     /etc/init.d/vsftpd status; else     echo "FTP is not installed"; fi
)" >> ${logfile};
echo -e "\n**** SAMBA Status ****\n$(if [ -s /etc/init.d/smb ]; then     /etc/init.d/smb status; else     echo "SAMBA is not installed"; fi
)" >> ${logfile};
echo -e "\n**** Web Server Status ****\n$(if [ -s /etc/init.d/httpd ]; then    /etc/init.d/httpd status; else     echo "Cups is not installed"; fi)" >> ${logfile};
echo -e "\n**** CUPS Status ****\n$(if [ -s /etc/init.d/cups ]; then     /etc/init.d/cups status; else     echo "Cups is not installed"; fi)" >> ${logfile};
echo -e "\n**** NFS Status ****\n$( if [ -s /etc/init.d/nfs ]; then     /etc/init.d/nfs status && echo -e "\n\t===Export Details===" && cat /etc/exports && echo -e "\n\t==Showmount o/p <Locally>==" && showmount -e; else     echo "NFS Server is not configured"; fi)" >> ${logfile};
echo -e "\n**** POSTFIX Status ****\n$(if [ -s /etc/init.d/postfix ]; then     /etc/init.d/postfix status; else     echo "Postfix is not installed"; fi)" >> ${logfile};
echo -e "\n**** CUPS Status ****\n$(if [ -s /etc/init.d/cupsd ];then     /etc/init.d/cupsd status; else     echo "CUPS is not installed"; fi)" >> ${logfile};
echo -e "\n**** SENDMAIL Status ****\n$(if [ -s /etc/init.d/sendmail ]; then     /etc/init.d/sendmail status; else     echo "sendmail is not installed"; fi)" >> ${logfile};
echo -e "\n**** IPTABLES Status ****\n\n$(if [ -s /etc/init.d/iptables ];then /etc/init.d/iptables status; else     echo "IPTABLES is not installed"; fi)" >> ${logfile};
echo -e "\n**** Networking Status ****\n$(/?bin/ip -o -4 a | grep -v ': lo' | sed 's/[0-9]\+\:\s*//;s/\// \//' | column -t)" >> ${logfile};
echo -e "\n**** Routing Table ****\n$(/?bin/ip route list | column -t)" >> ${logfile};
[[ ! $flagVM ]] && echo -e "\n**** Bond Health ****\n$([[ -e /proc/net/bonding/ ]] && grep ".*" /proc/net/bonding/bond* | egrep "Mode|Active Sla|Interface|Status|ports" || echo 'no bonds found')" >> ${logfile};
echo -e "\n**** DNS Entry ****\n\n$(cat /etc/resolv.conf)"  >> ${logfile};
echo -e "\n**** SELINUX Status ****\n \n$(sestatus)" >> ${logfile};
echo -e "\n**** Mount Report ****\n\t\tEXT3\tEXT4\tOCFS2\tNFS\n   FSTAB\t $(grep -v '\s*#' /etc/fstab | grep -ic ext3)\t $(grep -v '\s*#' /etc/fstab | grep -ic ext4)\t $(grep -v '\s*#' /etc/fstab | grep -ic ocfs2)\t $(grep -v '\s*#' /etc/fstab | grep -ic nfs)\n MOUNTED\t $(mount -t ext3 | wc -l)\t $(mount -t ext4 | wc -l)\t $(mount -t ocfs2 | wc -l)\t $(mount -t nfs | wc -l)" >> ${logfile};
echo -e "\n**** Mount Output ****\n\n$(mount) \n$(echo "=================") \nTOTAL_MOUNTS: $(mount | wc -l) \n$(echo "=================")" >> ${logfile};
echo -e "\n**** df -h Output: ****\n$(df -h)" >> ${logfile};
echo -e "\n**** Local Storage: ****\n$(df -lmPT | column -t)" >> ${logfile};
echo -e "\n**** Fstab Entry <Uncommented> **** \n$(cat /etc/fstab | egrep -v "#")\n\n$(echo "========================") \nTOTAL_FSTAB_ENTRIES: $(cat /etc/fstab | egrep -v "#" | wc -l) \n$(echo "========================")" >> ${logfile};

/?bin/ifconfig -a | grep -iq inet6 && issueList+=("$E_LINUX_IPV6");            # check for ipv6
/?bin/ip -o -4 a | grep -iq usb && issueList+=("$E_LINUX_USB_ETH");            # check for usb ethernet interface

#-CHECK-OS-FILE-SYSTEM-FREE SPACE----------------------------------------------#
(( $(df -mlP / | grep '^/' | awk '{print $4}') < 3072 )) && issueList+=("$E_LINUX_DF_ROOT");
(( $(df -mlP /boot/ | grep '^/' | awk '{print $4}') < 384 )) && issueList+=("$E_LINUX_DF_BOOT");
(( $(df -mlP /home/ | grep '^/' | awk '{print $4}') < 1536 )) && issueList+=("$E_LINUX_DF_HOME");
(( $(df -mlP /opt/ | grep '^/' | awk '{print $4}') < 1536 )) && issueList+=("$E_LINUX_DF_OPT");
(( $(df -mlP /tmp/ | grep '^/' | awk '{print $4}') < 1536 )) && issueList+=("$E_LINUX_DF_TMP");
(( $(df -mlP /usr/ | grep '^/' | awk '{print $4}') < 1536 )) && issueList+=("$E_LINUX_DF_USR");
(( $(df -mlP /var/ | grep '^/' | awk '{print $4}') < 1536 )) && issueList+=("$E_LINUX_DF_VAR");

chmod 775 ${logfile}
echo -e "\n"
echo -ne '[###########                     ](33%)\r'
sleep 1
echo -ne '[###################             ](66%)\r'
sleep 1
echo -ne '[################################](100%)\r'
echo -ne '\n'
echo -e "\n"
#echo -e "Health Check Completed: ${logfile/.\/}\n";
echo -e "\033[1mHealth Check Completed, To access report:\033 \033[0m${logfile/.\/}\033[0m";
exit 0


