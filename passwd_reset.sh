#!/bin/bash
######################################################################################
#                                                                                    #
# Script Created and Modified by Bijith Nair | bijithnair@hitachiconsulting.com                 #
#                                                                                    #
######################################################################################
echo "User Management Automation Tool :"
echo "Choose any of the option to proceed :"
echo "1. Create a password free authetication for single server"
echo "2. Create a password free authetication for  multiple servers"
echo "3. Reset the password<use this option when you want to perform it for multiple servers>"
echo "4. Enter the command which you would like to execute it on multiple servers"
echo "5. Remove RSA key from the jump server"
echo "6. Generate a alphanumeric PASSWORD"
echo -n "Select your choice [1 | 2 | 3 | 4 |or 5]?"
read version
if [ $version = 1 ]
then
echo "enter the ip of the server"
read -p "IP Address --:" IP && ssh-copy-id root@$IP
echo "Done...Go ahead and test it"
elif [ $version = 2 ]
then
echo " enter the location of the server's list"
read -p "Location --: " location
for host in $(cat $location); do ssh-copy-id $host; done
echo "Done...Go ahead and test it"
elif [ $version = 3 ]
then
echo "You are logged into : $(hostname) : $(date)"
echo "Please fill out the details correctly"
read -p "Enter username --: " username
read -s -p "Enter password --: " password
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
cat /tmp/Automated/SERVER_LIST.txt | while read a b
do
ssh -n $a "hostname; /usr/sbin/usermod -p $pass $username"
done
elif [ $version = 4 ]
then
echo "enter the command which you want to execute on multiple servers"
read -p "Command --:" command
#for host in $(cat $location); do ssh "$host" "$command" >"output.$host"; done
#for i in `cat /tmp/Automated/SERVER_LIST.txt`; do ssh $i 'echo -e "echo "==Hostname==" \n$(hostname) \n==Output== \n$command" '; done
clear
for i in `cat /tmp/Automated/SERVER_LIST.txt`; do ssh $i 'echo -e ""Hostname:" $(printf "\e[4m%s\e[0m\n" $(hostname))" "\n$(echo  \n==Output== \n$command)"';  echo "======================"; done
elif [ $version = 5 ]
then
echo "Enter the ip of the server"
read -p "IP Address --: " IP
ssh-keygen -R $IP
echo "Successfully removed the RSA keys!!!"
elif [ $version = 6 ]
then
echo -e "====New Password==="
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1
else
echo "Please choose from the give options only"
fi

