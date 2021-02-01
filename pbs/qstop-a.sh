#!/bin/sh
file=$@
user="$USER"
if [ -n "$file" ]; then
    qstat -a | grep $user | grep "$file"
    echo "Killing in 3 seconds!"
    sleep 3
    qstat -a | grep $user | grep "$file" | awk '{print $1}' | sed 's/.cm//' | xargs qdel
else
    echo "Please provide a search term as an argument!"
fi
