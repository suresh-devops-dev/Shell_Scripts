#!/bin/bash
# Create an SHA512 binary password hash using a randomly generated 16 character salt
#
# This hash can be used to change the user password using the command:
#     echo "youruserid:$(source createpass.sh)" | sudo chpasswd –e
#
read -s -p "Password: " _password
export _salt=$(openssl rand 1000 | strings | grep -io [0-9A-Za-z\.\/] | head -n 16 | tr -d '\n' )
export _password=$_password
echo $(perl -e 'print crypt("$ENV{'_password'}","\$6\$"."$ENV{'_salt'}"."\$")')
unset _password
unset _salt
