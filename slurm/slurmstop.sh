#!/bin/sh
file=$@
user="$USER"
if [ -n "$file" ]; then
    squeue -u $user | grep "$file"
    echo "Killing in 3 seconds!"
    sleep 3
    squeue -u $user | grep "$file" | awk '{print $1}' | xargs scancel
else
    echo "Please provide a search term as an argument!"
fi
