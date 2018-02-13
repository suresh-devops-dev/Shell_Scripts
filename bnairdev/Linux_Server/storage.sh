DISKNUM=`fdisk -l | grep -e "^Disk /dev/sd" | wc -l`
i=1
while [ $i -le $DISKNUM ]
do
D=`fdisk -l | grep -e "^Disk /dev/sd" | awk '{print$3}' | cut -f1 -d, | head -$i | tail -1`
DISK="$DISK+$D"
SUM=`python -c "print $DISK" | cut -f1 -d.`
TB=$((SUM/1024))
let i=$i+1
done
echo "Total Disks Attached Are : $DISKNUM."
echo "Total Storage Attached is : $SUM GB or $TB TB."
