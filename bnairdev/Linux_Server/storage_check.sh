DISKNUM=`fdisk -l | grep -i "^Disk /dev/sd" | wc -l`
i=1
while [ $i -le $DISKNUM ]
do
D=`fdisk -l | egrep -e "^Disk /dev/sd" | awk '{print$3}' | cut -f1 -d, | head -$i | tail -1`
DISK="$DISK+$D"
SUM=`python -c "print $DISK" | cut -f1 -d.`
TB=$((SUM/1024))
let i=$i+1
done
clear
echo -e "\nHostname: $(hostname)"
echo -e "\n------------------------------------"
echo -e " Total Disks  | Total Storage GB/TB                 "
echo -e "------------------------------------"
echo -e "\t"$DISKNUM"     | \t"$SUM""
echo -e "------------------------------------"
echo
