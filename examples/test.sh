#!/bin/bash
#PBS -t 1-4
#PBS -l nodes=1:ppn=2,walltime=1:00:00
# Change into working directory
# Execute code
#Set -e allows you to test the script
set -e

echo "Running on ${HOSTNAME}"
if [ -n "${1}" ]; then
  echo "${1}"
  PBS_ARRAYID=${1}
fi

i=${PBS_ARRAYID}

cd /newhome/madjl/tmp

echo "$i $HOSTNAME" &> test${i}.txt
