
#!/bin/bash
getnode=0
oval=""
single=0
i=1
sleeptime=60
user="$USER"
qstat="qstat"
grepval=""

function help {
    echo "qtop.sh : access the PBS queue in a convenient way.
Behaves as \"top\" for the PBS queue, querying \"qstat\" periodically.

options:
-n : Get the node of each running process (can be slow).
-o : Omit queued processes from being printed (they are still counted).
-a : Display qstat -a information, instead of qstat.
-g <val> : Grep the displayed list for <val>; remember to use appropriate quotes.
-u <val> : query qstat for user <val> (default: $USER)
-s <val> : sleep for <val> seconds between queue queries (default: 60).
-1 : perform a single query instead of top like behaviour.
-h : display this help and exit.

"
}

while getopts ":noh1as:u:g:" opt; do
  case $opt in
    s)
	  sleeptime=$OPTARG;;
    u)
	  user=$OPTARG;;
    g)
	  grepval=$OPTARG;;
    o)
	  oval=" R ";;
    n)
	  getnode=1;;
    a)
	  qstat="qstat -a";;
    1)
	  single=1;;
    h)
	  help;
	  exit 0;;
    \?)
	  echo "Invalid option: -$OPTARG" >&2
	  exit 0;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1;;
  esac
done

while [ $i -le 1 ]; do
    mytemp=`mktemp`
    $qstat | grep $user > $mytemp

    while read line;  do
	node="----------"
	if [ $getnode -eq 1 ] ; then
	    if [[ "$line" == *" R "* ]] ; then
		f=`echo $line | cut -d " " -f 1`
		node=`pbsgrep.sh $f | head -n 1`
	    fi
	fi
#	if [ "$oval" == "" ] || [ "$line" != *" Q "* ] ; then
	echo "$node $line"
#	fi
    done < $mytemp | grep "$grepval" | grep "$oval"

    total=`cat $mytemp | wc -l`
    queued=`cat $mytemp | grep " Q " | wc -l`
    running=`cat $mytemp | grep " R " | wc -l`
    ending=`cat $mytemp | grep " C " | wc -l`
    echo "Total jobs = $total, Running = $running, Ending = $ending, Queued = $queued" 
    rm $mytemp
    if [ $single -eq 1 ] ; then
	exit 0
    else
	sleep $sleeptime
    fi
done
