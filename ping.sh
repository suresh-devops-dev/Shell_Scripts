#!/bin/ksh
#
# SCRIPT: pingnodes.ksh
#
# PURPOSE:  This script is used to ping a list of nodes and
# send e-mail notification (or alpha-numeric page) of any unreachable
# nodes.
#
# set -x # Uncomment to debug this script
# set -n # Uncomment to check command syntax without any execution
#
#######################################################

# Set a trap and clean up before a trapped exit...
# REMEMBER: you CANNOT trap "kill -9"

trap 'echo "\n\nExiting on trapped signal...\n" \
        ;exit 1' 1 2 3 15

#######################################################
# Define and initialize variables here...

PING_COUNT="3"          # The number of times to ping each node
PACKET_SIZE="56"  # Packet size of each ping

typeset -u PINGNODES    # Always use the UPPERCASE value for $PINGNODES
PINGNODES="TRUE"        # To enable or disable pinging FROM this node - "TRUE"

typeset -u MAILOUT      # Always use the UPPERCASE value for $MAILOUT
MAILOUT="TRUE"          # TRUE enables outbound mail notification of events

UNAME=$(uname)          # Get the UNIXUnix flavor of this machine

PINGFILE="/tmp/Automated/SERVER_LIST.txt" # List of nodes to ping

if [ -s $PINGFILE ]
then
      # Ping all nodes in the list that are not commented out and blank
      PINGLIST=$(cat $PINGFILE | grep -v '^#')
else
echo "\nERROR: Missing file - $PINGFILE"
      echo "\nList of nodes to ping is unknown...EXITING...\n"
      exit 2
fi

MAILFILE="/usr/local/bin/mail.list" # List of persons to notify

if [ -s $MAILFILE ]
then
        # Ping all nodes in the list that are not commented out and blank
        MAILLIST=$(cat $MAILFILE | egrep -v '^#')
else
        echo "\nERROR: Missing file - $MAILFILE"
        echo "\nList of persons to notify is unknown...\n"
        echo "No one will be notified of unreachable nodes...\n"
fi
[[ -e /tmp/pingfile.out ]] || touch /tmp/pingfile.out
PING_OUTFILE="/tmp/pingfile.out" # File for e-mailed notification
>$PING_OUTFILE  # Initialize to an empty file

integer INTERVAL="3" # Number of seconds to sleep between retries

# Initialize the next two variables to NULL

PINGSTAT=    # Number of pings received back from pinging a node
PINGSTAT2=   # Number of pings received back on the secopnd try

THISHOST=`hostname`     # The hostname of this machine

########################################################
############ DEFINE FUNCTIONS HERE #####################
########################################################

function ping_host
{
# This function pings a single node based on the UNIXUnix flavor

# set -x # Uncomment to debug this function
# set -n # Uncomment to check the syntax without any execution

# Look for exactly one argument, the host to ping

if (( $# != 1 ))
then
     echo "\nERROR: Incorrect number of arguments - $#"
     echo "       Expecting exactly one argument\n"
     echo "\t...EXITING...\n"
     exit 1
fi

HOST=$1 # Grab the host to ping from ARG1.

# This next case statement executes the correct ping
# command based on the UNIXUnix flavor
case $UNAME in

AIX|Linux)
           ping -c${PING_COUNT} $HOST 2>/dev/null
           ;;
HP-UX)
           ping $HOST $PACKET_SIZE $PING_COUNT 2>/dev/null
           ;;
SunOS)
           ping -s $HOST $PACKET_SIZE $PING_COUNT 2>/dev/null
           ;;
*)
           echo "\nERROR: Unsupported Operating System - $(uname)"
           echo "\n\t...EXITING...\n"
           exit 1
esac
}

#######################################################

function ping_nodes
{
#######################################################
#
# Ping the other systems check
#
# This can be disabled if you do not want every node to be pinging all
# of the other nodes.  It is not necessary for all nodes to ping all
# other nodes .aAlthough, you do want more than one node doing the pinging
# just in case the pinging node is down.  To activate pinging the
# "$PINGNODES" variable must be set to "TRUE".  Any other value will
#  disable pinging from this node.
#

# set -x # Uncomment to debug this function
# set -n # Uncomment to check command syntax without any execution

if [[ $PINGNODES = "TRUE" ]]
then
     echo     # Add a single line to the output

     # Loop through each node in the $PINGLIST

     for HOSTPINGING in $(echo $PINGLIST) # Spaces between nodes in the
                                          # list is are assumed
     do
          # Inform the uUser what is gGoing oOn

          echo "Pinging --> ${HOSTPINGING}..."

          # If the pings received back is equal to "0" then you have a
          # problem.
# Ping $PING_COUNT times, extract the value for the pings
          # received back.


          PINGSTAT=$(ping_host $HOSTPINGING | grep transmitted \
                     | awk '{print $4}')

          # If the value of $PINGSTAT is NULL, then the node is
          # unknown to this host

          if [[ -z "$PINGSTAT" && "$PINGSTAT" = '' ]]
          then
               echo "Unknown host"
               continue
          fi
          if (( PINGSTAT == 0 ))
          then    # Let's do it again to make sure it really is reachable

               echo "Unreachable...Trying one more time..."
               sleep $INTERVAL
               PINGSTAT2=$(ping_host $HOSTPINGING | grep transmitted \
                         | awk '{print $4}')

               if (( PINGSTAT2 == 0 ))
               then # It REALLY IS unreachable...Notify!!
                    echo "Unreachable"
                    echo "Unable to ping $HOSTPINGING from $THISHOST,Please check!!!" \
                          | tee -a $PING_OUTFILE
               else
                    echo "OK"
               fi
          else
               echo "OK"
          fi

     done
fi
}

######################################################

function send_notification
{
if [ -s $PING_OUTFILE -a  "$MAILOUT" = "TRUE" ];
then
        case $UNAME in
        AIX|HP-UX|Linux) SENDMAIL="/bin/mail"
        ;;
        SunOS) SENDMAIL="/usr/lib/sendmail"
        ;;
        esac

        echo -e "Sending e-mail notification"
/usr/bin/printf "`cat $PING_OUTFILE`" | $SENDMAIL -r No-Reply -a $PING_OUTFILE -s "Node Down Alert!!!" $MAILLIST
fi
}


##################################################
############ START of MAIN #######################
##################################################


ping_nodes
send_notification


# End of script



http://www.yourownlinux.com/2013/10/bash-script-to-check-whether-a-host-is-up-or-down.html



for i in `cat /tmp/list`; do   ping -c 1 $i 2>&1 >/dev/null;   if [ $? -eq 0 ];   then      echo "$i - Pinging";   else      echo "$i  - Not Pinging";   fi; done


