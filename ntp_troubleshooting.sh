#creating temporary directory
if [ -d $targetdir ]
then
echo "Temp directory $targetdir exists already."
else
mkdir $targetdir
fi
collect_file () {
if [ -f "$1" ]; then
cp -p "$1" "$targetdir"\/"$(echo "$1" | sed -e 's/^\/[^/]*\///' -e 's/\//-/g')"
fi
}
echo "Collecting NTP configuration files "
#collect ntp configurations
conf=/etc/ntp.conf
collect_file $conf
ntpstep=/etc/ntp/step-tickers
collect_file $ntpstep
drift=/var/lib/ntp/drift
collect_file $drift
log=/var/log/ntp.log
collect_file $log
sconf=/etc/sysconfig/ntpd
collect_file $sconf
sclock=/etc/sysconfig/clock
collect_file $sclock
localt=/etc/localtime
collect_file $localt
adjt=/etc/adjtime
collect_file $adjt
stscr=/etc/init.d/ntpd
collect_file $stscr
echo "Collecting clock settings/status "
#hwclock
hwclock --show > $targetdir/hwclock.txt
#date
date > $targetdir/date.txt
## checking time sources
cat /sys/devices/system/clocksource/clocksource0/available_clocksource > $targetdir/av_clocksource
cat /sys/devices/system/clocksource/clocksource0/current_clocksource > $targetdir/cu_clocksource
##checking timezone file
echo "Dumping and collecting timezone file "
YEAR=`date +"%Y"`
ZN=`cat /etc/sysconfig/clock | grep ZONE | cut -d = -f 2 | tr -d '"'`
zdump -v $ZN | grep $YEAR > $targetdir/timzone-check.txt
#tars the complete /etc/ntp directory
#NOTE: this will collect the key file as well
echo "Collecting /etc/ntp directory files "
tar cvzf $targetdir/etc-ntp-dir.tar.gz /etc/ntp 2>/dev/null
echo "Collecting system info files "
##collect sysinfo
cat /etc/*-release > $targetdir/release.txt
chkconfig --list > $targetdir/chkconfig.txt
top -b -n1 > $targetdir/top.txt
ps aux > $targetdir/psaux.txt
dmesg > $targetdir/dmesg.txt
rpm -qa > $targetdir/rpm.txt
uname -a > $targetdir/uname.txt
cat /proc/cmdline > $targetdir/kernel-cmdl.txt
# collecting syslogs
echo "Collecting messages files, depending on the size it can take a few mintues "
tar cvzf $targetdir/messages.tar.gz /var/log/messages* 2>/dev/null
##ntpq commands to gather status information
echo "Collecting ntp status information "
ntpq -p > $targetdir/ntpq-p.txt
ntpq -c as > $targetdir/ntpq-cas.txt
ntpq -c version > $targetdir/ntpq-cversion.txt
ntpq -c rv > $targetdir/ntpq-crv.txt
##other ntp status information and configurations
if [ -f /usr/sbin/ntptrace ]
then
echo "Collecting ntptrace information, you may get a timeout message here"
ntptrace -n > $targetdir/ntptrace.txt
else
echo "ntptrace not found, please install ntp-perl, 'yum install ntp-perl', and re-run this scrip"
fi
ntpstat > $targetdir/ntpstat.txt
##assID
##getting the ass id to run ntpq -c "rv assid" for every configured server
assID=`ntpq -cas | awk '{ print $2 }'`
count=`echo $assID | awk -F ' ' '{ print NF}'`
i=2
while ! [ $i -gt $count ]
do
ARR[$i]=`echo $assID | awk -F ' ' '{print $'"$i"'}'`
id=${ARR[$i]}
ntpq -c "rv $id" >> $targetdir/ntpq-assID$id.txt
i=$(expr $i + 1)
done
sleep 3
#create archive
echo "Creating tar file"
tar cvzf /tmp/ntpd.tar.gz $targetdir 2>/dev/null
echo "Please upload /tmp/ntpd.tar.gz to your SR"

