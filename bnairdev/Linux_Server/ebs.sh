#!/bin/sh

# Hostname to add/remove.
#hostname=$1

function 1500() {
#echo " Adding groups to the server "
#sleep 1
#groupadd -g 5004 dba
#groupadd -g 504 asmdba
#groupadd -g 505  asmadmin
#groupadd -g 506 asmoper
#groupadd -g 5001 grid
#groupadd -g 5003 oinstall

#echo "Creating users ...."
#sleep 1
#useradd -c "Oracle admin" -g dba -G asmdba,asmadmin,asmoper,grid,oinstall -p Q/WEMMCE6I3IE -m  oracle
#useradd -c "oem admin" -g dba -G oinstall,grid -p Prv9mTvT1EHP. -m oemagnt
#useradd -c "grid admin" -g dba -G asmdba,asmadmin,asmoper,grid,oinstall -p 3KYVvtETbwEz6 -m grid
#useradd -c "app admin" -g dba -G asmdba,asmadmin,asmoper,grid,oinstall -p AqPCepH3kjpDw -m applmgr

#echo "Creating directories.."
#[[ -e /agent/oem13c/oraInventory ]] || mkdir -p /agent/oem13c/oraInventory
#inventory_loc=/agent/oem13c/oraInventory
#inst_group=dba

#echo " Creating agent directory for OEM Agent installation"
#sleep 1
#[[ -e /agent/oem13c ]] || mkdir -p /agent/oem13c
#chown -R oemagnt:dba /agent/oem13c
#chmod -R 777 /agent/oem13c


#[[ -e /agent/oraInventory ]]  || mkdir -p /agent/oraInventory
#[[ -e /opt/install ]] || mkdir -p /opt/install
#chmod 777 /agent/oraInventory
#chmod 777 /opt/install

echo "Updating sudoers"
sed -i 's/^Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers
sed -i 's/^Defaults    visiblepw/Defaults    !visiblepw/g' /etc/sudoers

echo "Please enter the ip of oem server :"
echo "Please enter the mount point:"
read oem
read mount
[[ -e $mount ]] || mkdir -p $mount
mount $oem:/OEM	  $mount 


echo “Updating kernel parameters”
sleep 1
cat <<EOF>> /etc/sysctl.conf

kernel.shmmax=34359738368
kernel.shmall=4718592
kernel.shmmni=4096
kernel.msgmax=65536
kernel.msgmnb=65535
kernel.shmmsl=24000
kernel.msgmni=4096
kernel.panic_on_oops=1
kernel.sem= 256 32000 100 128
fs.file-max=6815744
nr.huge_pages=16000
EOF
echo -e "\n\t\t====== Listing the parameters ======"
sleep 1
sysctl -p

echo “Updating limit.conf”
sleep 1

cat <<EOF >> /etc/security/limits.conf
* soft nproc  65536
* hard nproc  65536
* soft nofile  65536
* hard nofile  65536
* soft stack  10240
* soft memlock 41943040
* hard memlock 41943040
EOF

echo "updating /etc/hosts"
echo -e "\n$(echo -e "$(ifconfig  | egrep "eth*|enp0*" | grep inet  | awk '{print $2}' | head -n 1)")  $(hostname)  $(hostname -f)" >> /etc/hosts



}
$@

