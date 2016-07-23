#!/bin/bash
 #
 # pspeek.sh - brute force peek at specific ps processes
 #
 echo "Waiting for avr, gcc, or make commands... (Ctrl-C to abort)"
 FOUND=""
 while [  "$FOUND" == "" ]; do
   FOUND=$(ps aux | grep -E "avr|gcc|make" | grep -v grep)
 done
 echo "Scanning..."
 STOPAT=$(( $(date +%s) + 5 )) #run for only 5 seconds
 while :
  do
    FOUND+="\n"$(ps aux | grep -E 'avr|gcc|make'  | grep -v grep)
    if [[ $STOPAT < $(date +%s) ]]
    then
        break
    fi
  done
 printf "$FOUND" | cut -c66- | grep -v grep | sort -u | while read -r line
   do
    echo "$line"
    echo
   done

 echo "Done!"
