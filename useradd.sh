#!/bin/bash
echo "You are logged into : $(hostname) : $(date)"
echo "Please fill out the details correctly"
read -p "Enter username --: " username
read -s -p "Enter password --: " password
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
cat SERVER_LIST.txt | while read a b
do
ssh -n $a "hostname; /usr/sbin/usermod -p $pass $username"
done
