#!/bin/bash
#==========================================================================================================

logfile="${0}-$(date +%F)"                           # Set logfile name

hosts=( $(tr -d \\r < /tmp/Automated/SERVER_LIST.txt ) ) # Read list of servers into an array



for cur_host in ${hosts[@]}; do

  sudo ping -qc1 ${cur_host}                         # Test IP connection to server

  rc_ping=$?                                         # store return code from ping cmd



  if [ $rc_ping -eq 0 ]; then                        # Proceed if ping return code is clean

    printf -- '---------------------------\n %s\n---------------------------\n' "checking: ${cur_host}"



    #

    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o NumberOfPasswordPrompts=1 ${USER}@${cur_host} '/usr/sbin/useradd -c "ABC/C//test user" -m -G wheel -p sa2MbgpzbTQ5A testuser' >> ${logfile}.csv || printf '%s\n' "${cur_host}: exit code ${?} $(date)" >> ${logfile}.err



  elif [ $rc_ping -eq 1 ]; then                      # check ping return code for no response

    echo "${cur_host},NO REPLY, $(date), exit code:${rc_ping}" >> ${logfile}-noPing.log

    printf -- '***************************\n %s\n***************************\n' "no reply: ${cur_host}"

  elif [ $rc_ping -eq 2 ]; then                      # check ping return code for unknown host

    echo "${cur_host},UNKNOWN HOST, $(date), exit code:${rc_ping}" >> ${logfile}-noPing.log

    printf -- '***************************\n %s\n***************************\n' "unknown host: ${cur_host}"

  else                                               # return ping error code

    echo "${cur_host},CANNONT PING, $(date), exit code:${rc_ping}" >> ${logfile}-noPing.log

    printf -- '***************************\n %s\n***************************\n' "error: ${cur_host}"

  fi



done

exit 0

