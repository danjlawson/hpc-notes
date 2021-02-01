# hpc-notes
A collection of tools for easier use of a high performance computing service (slurm and pbs)

## PBS / qsub

PBS is used on bluecrystal phase 3 (University of Bristol). The following tools are in the `pbs/` directory. 

* `qsub_array.sh`: A script to create an array job for a list of commands stored one per line in a file. Has a sensible help when run with no arguments or `qsub_array.sh -h`. It is complicated because pbs logging appears to be somewhat broken on bluecrystal (and is pretty awful generally), so we do this manually.
* `qtop.sh`: Acts like `top` for (your own) job queue, refreshing every minute by default. Very useful! Press Control-d to exit it (exit). Has a sensible help when run with `qtop.sh -a`.
* `qstop.sh`: A convenient way to access `qdel` to delete your jobs. Create lots of broken jobs? This does a pattern search (on qstat output, like qtop.sh) and will kill everything that matches. You get 3 seconds to see what will be killed and can press Control-d to cancel this. Kill everything that is your by running `qstop.sh <username>`.
* `qstop-a.sh`: As `qstop.sh`, but uses `qstat -a` output.

The remainder are just shortcuts so you don't have to remember the details:

* `qsubI`: This family of commands are just shortcuts to requesting 1/2/8/16 cpus of a node (optionally a himem node) interactively. Useful for code testing.

## Slurm /sbatch

slurm is used on bluecrystal phase 4 (University of Bristol).