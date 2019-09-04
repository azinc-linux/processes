#!/bin/bash

function formattime()
 { 
 local prinmin
 local printsec
 local min
 local sec
 if (( $1 < 60))
 then
  if (($1 < 10 ))
  then 
   printmin="00"
   printsec="0"$1
  else
  printmin="00"
  printsec=$1
  fi
 else
 min=$(($1 / 60))
 if (( $min  >  0 ))
  then
  if [ ${#min} = 1 ]
  then
  printmin="0"$min
  fi
  sec=$(( $1 - $min*60))
  if [ ${#sec} = 1 ]
  then  
  printsec="0"$sec
  else
  printsec=$sec
  fi
 else
 printmin="00"
fi
fi
res="$printmin:$printsec"
}
printf "%s\t%s\t%s\t%s\t%s\n" "pid" "tty" "status" "time" "command"
for i in `ls /proc | grep '[0-9]'`; do
pid=$i
if [ -d /proc/$pid ]; then
 if [ -e /proc/$pid/fd/0 ]; then
   tty=`ls -n /proc/$pid/fd/0 | awk -F"->" '{print$2}' | sed -e 's/\/dev\///g'`
 else
   tty="null"
 fi
# if (( ${#tty} > 6)) 
# then
#  tty="??"
# fi
time=`cat /proc/$i/stat | awk '{print $14 + $15}'`
time=$((time / 100))
status=`cat /proc/$i/stat | awk '{print$3}'`
command=$(cat /proc/$i/cmdline)
 if [ ${#command} = 0 ]
  then
    command=$(cat /proc/$i/comm)
    command="["$command"]"
 fi 
command=${command:0:80}
command=` echo $command | sed -e 's/ //g'` 

formattime $time
printf "10%d\t%s\t%s\t%s\t%s\n" $pid $tty $status $res $command
#echo $pid $tty $status $res $command
fi
done
