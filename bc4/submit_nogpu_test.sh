#!/bin/bash
#SBATCH --account=MATH027744
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=0-1:00:00
#SBATCH --mem=1000M
#SBATCH --error=test_stderr_nogpu.txt
#SBATCH --output=test_stdout_nogpu.txt
source ~/.bashrc # Put the node in the same state that we are in interactively
conda activate tf-env
date
cd $SLURM_SUBMIT_DIR
a=$(date +%s%N)
#sleep 1.234
python kerastest.py
b=$(date +%s%N)
diff=$((b-a))
date
printf "%s.%s seconds passed\n" "${diff:0: -9}" "${diff: -9:3}"
