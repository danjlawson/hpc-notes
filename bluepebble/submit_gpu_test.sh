#!/bin/bash
#SBATCH --account=XXX
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=0-1:00:00
#SBATCH --mem=1000M
#SBATCH --error=test_stderr_gpu.txt
#SBATCH --output=test_stdout_gpu.txt
module load lang/python/anaconda/3.9.7-2021.12-tensorflow.2.7.0
eval "$(conda shell.bash hook)" # in interactive mode, conda activate doesn't get set up without this
conda activate tf-env
date
cd $SLURM_SUBMIT_DIR
a=$(date +%s%N)
#sleep 1.234
python3 test.py
b=$(date +%s%N)
diff=$((b-a))
date
printf "%s.%s seconds passed\n" "${diff:0: -9}" "${diff: -9:3}"
