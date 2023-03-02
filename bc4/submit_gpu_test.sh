#!/bin/bash
#SBATCH --account=MATH027744
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=0-1:00:00
#SBATCH --mem=4000M
#SBATCH --error=test_stderr_gpu.txt
#SBATCH --output=test_stdout_gpu.txt
source ~/.bashrc # Put the node in the same state that we are in interactively
conda activate tf-env
date
cd $SLURM_SUBMIT_DIR
echo "Entered directory: `pwd`"
a=$(date +%s%N)
#sleep 1.234
python kerastest.py
b=$(date +%s%N)
diff=$((b-a))
date
printf "%s.%s seconds passed\n" "${diff:0: -9}" "${diff: -9:3}"
