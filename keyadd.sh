#!/bin/bash
#Version 1.0
#Author:  Chris Carmichael
#Date:  2/25/2017
# Version 1.1
#ReAuthored by: Bijith Nair
#Date: 03/29/2017
#===Change Log===
# V1.1 V1.0 works like a charm, This is the use case when you have a local repository being setup with users public keys
# V1.1 Now script will compare the home directory keys with local repo keys to make sure user has the updated keys and if its not 
synced it gets the lastest keys from local repo and will update user's home directory



#Create and download the repository if doesn't exist
#[[ -e /Accounts/Keys/ ]] || mkdir -p /Accounts/Keys/ && chmod -R 777 /Accounts/Keys/
#wget -m http://192.168.21.24/public_keys/ > /dev/null 2>&1
#rm -rf /root/192.168.21.24/public_keys/index.html* && rsync -rav /root/192.168.21.24/public_keys/ /Accounts/Keys/


#Check if user profile home directory exists or not...creates profile if it doesn't exist
USERNAME="$1"

if [ -d "/home/$USERNAME" ]; then
    echo "$USERNAME user profile already exists...looking at authorized_keys for possible updates"
    sleep 1
    #Check if key you are passing already exists or not.  Update if it's not there already.
    if grep -Fqx "$(cat /home/"$USERNAME"/.ssh/authorized_keys)" /Accounts/Keys/"$USERNAME".pub; then
        echo -e "\nSSH key found..."["$USERNAME"]" profile already has the updated key"
    else
        find  /Accounts/Keys/ -name "$USERNAME.pub" | xargs cat >> /home/"$USERNAME"/.ssh/authorized_keys
        sleep 1
        echo -e "\n$USERNAME SSH key updated"
    fi

#Create user profile with authorized_keys entry
else

if [ -e /Accounts/Keys/"$USERNAME".pub ]
then
useradd -c "$FULLNAME" -G wheel -m "$USERNAME" && mkdir /home/"$USERNAME"/.ssh/ && chmod 700 /home/"$USERNAME"/.ssh/ && touch /home/"$USERNAME"/.ssh/authorized_keys && chmod 600 /home/"$USERNAME"/.ssh/authorized_keys && find  /Accounts/Keys/ -name "$USERNAME.pub" | xargs cat >> /home/"$USERNAME"/.ssh/authorized_keys && echo -e "\n=== Account Details === \n\n$(cat /etc/passwd| grep "$USERNAME") \n\n=== Key Location === \n\n$(ls -ld /Accounts/Keys/"$USERNAME.pub" | awk  '{print $9}') \n\n=== Access Key === \n\n$(cat  /home/"$USERNAME"/.ssh/authorized_keys)"
else
echo -e "\nKey Doesn't exist, Please upload public key of the user under /Accounts/Keys/<username>.pub and try again"
fi
fi
