whiptail --title "Hitachi Consulting Cooperation " --msgbox " \n   Welcome to Identity Access Management console you must hit OK to continue." 8 88
#!/bin/bash
[[ -e  /tmp/useradd.log ]] || touch  /tmp/useradd.log
[[ -e  /tmp/userdel.log ]] || touch  /tmp/userdel.log
[[ -e /tmp/end.log ]] || touch /tmp/end.log
HEIGHT=15
WIDTH=58
CHOICE_HEIGHT=8
BACKTITLE="IAM Admin Menu"
MENU="Choose one of the following options:"



OPTIONS=(1 "Add User:  Add a user to the system."
         2 "Delete User:  Delete user from the system."
         3 "Find User:   List all users on the system.")


CHOICE=$(whiptail --title "$BACKTITLE" \
                  --menu "$MENU" \
                  $HEIGHT $WIDTH $CHOICE_HEIGHT \
                  "${OPTIONS[@]}" \
                  2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
#!/bin/bash
USERNAME=$(whiptail --inputbox "Enter the userID:" 10 60 3>&1 1>&2 2>&3)
FULLNAME=$(whiptail --inputbox "Enter the First and Last name:" 10 60 3>&1 1>&2 2>&3)
EMAIL=$(whiptail --inputbox "Enter Email Address:" 10 60 3>&1 1>&2 2>&3)
#ORG=$(whiptail --inputbox "Enter the Org details: <Infra/SAP/DB Admin>:" 10 60 3>&1 1>&2 2>&3)

if [ -e /Accounts/Keys/$USERNAME.pub ]
then
useradd -c "$FULLNAME" -G wheel -m $USERNAME && mkdir /home/$USERNAME/.ssh/ && chmod 700 /home/$USERNAME/.ssh/ && touch /home/$USERNAME/.ssh/authorized_keys && chmod 600 /home/$USERNAME/.ssh/authorized_keys && echo -e "\n=== Account Details === \n\n$(cat /etc/passwd| grep $USERNAME) \n\n=== Key Location === \n\n$(ls -ld /Accounts/Keys/$USERNAME.pub | awk  '{print $9}') \n\n=== Access Key === \n\n$(find  /Accounts/Keys/ -name "$USERNAME.pub" | xargs cat /home/$USERNAME/.ssh/authorized_keys)" > /tmp/useradd.log

#!/bin/bash
whiptail --title "Account Summary" --textbox /tmp/useradd.log  25 100
#!/bin/bash
{     for ((i = 0 ; i <= 100 ; i+=30)); do         sleep 1;         echo $i;     done; } | whiptail --gauge "    Please wait while user is getting configured.." 6 60 0
else

whiptail --title "Exiting Summary" --textbox /tmp/end.log  20 80

fi

            ;;
        2)
#!/bin/bash
USERNAME=$(whiptail --inputbox "Enter the userID:" 10 60 3>&1 1>&2 2>&3)
#EMAIL=$(whiptail --inputbox "Enter Email Address:" 10 60 3>&1 1>&2 2>&3)

userdel -rf $USERNAME

whiptail --title "User Deletion Summary" --textbox /tmp/userdel.log  20 80

            ;;
        3)
            echo "You chose Option 3"
            ;;
esac

