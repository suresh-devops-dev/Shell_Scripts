#!/bin/bash
# A menu driven Shell script which has following options
# Contents of /etc/passwd
# List of users currently logged
# Prsent handling directory
# Exit
# As per option do the job
# -----------------------------------------------
# Copyright (c) 2005 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
 
while :
do
 clear
 echo "   M A I N - M E N U"
 echo "1. Contents of /etc/passwd"
 echo "2. List of users currently logged"
 echo "3. Prsent handling directory"
 echo "4. Exit"
 echo -n "Please enter option [1 - 4]"
 read opt
 case $opt in
  1) echo "************ Conents of /etc/passwd *************";
     more /etc/passwd;;
     pause
  2) echo "*********** List of users currently logged";
     who | more;;
  3) echo "You are in $(pwd) directory";   
     echo "Press [enter] key to continue. . .";
     read enterKey;;
  4) echo "Bye $USER";
     exit 1;;
  *) echo "$opt is an invaild option. Please select option between 1-4 only";
     echo "Press [enter] key to continue. . .";
     read enterKey;;
esac
done
