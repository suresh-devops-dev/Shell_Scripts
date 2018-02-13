#!/bin/sh
# Wedding guest meals
# These variables hold the counters.
NUM_CHICKEN=0
NUM_STEAK=0
ERR_MSG=""
#Bijith
# This will clear the screen before displaying the menu.
clear

while :
do
	# If error exists, display it
	if [ "$ERR_MSG" != "" ]; then
		echo "Error: $ERR_MSG"
		echo ""
	fi

	# Write out the menu options...
	echo "Chicken: $NUM_CHICKEN"
	echo "Steak: $NUM_STEAK"
	echo ""
	echo "Select an option:"
	echo " * 1: Chicken"
	echo " * 2: Steak"
	echo " * 3: Exit"

	# Clear the error message
	ERR_MSG=""

	# Read the user input
	read SEL

	case $SEL in
		1) echo "Hello World" ;;
		2) NUM_STEAK=`expr $NUM_STEAK + 1` ;;
		3) echo "Bye!"; exit ;;
		*) ERR_MSG="Please enter a valid option!"
	esac

	# This will clear the screen so we can redisplay the menu.
	clear
done
