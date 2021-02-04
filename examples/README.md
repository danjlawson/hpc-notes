## Examples for PBS-style HPC code

This is a short example for PBS job submission. Start by examining `test.sh`, which starts:

```{sh}
#!/bin/bash
#PBS -t 1-4
#PBS -l nodes=1:ppn=2,walltime=1:00:00
```

* The first line tells it to run in `bash`. Unless you know what you are doing, this is probably always what you want.
* The next two lines are instructions to PBS for how to queue the job. 
  * This is an **array job** with 4 sub-jobs (`-t 1-4`).
  * We request 1 node, 2 cores per node, and a run time (wall time) of an hour.
* You would run this with:

```{sh}
qsub test.sh
```

## Use of the included scripts

* Make sure you've copied the scripts into your $PATH.
```{sh}
mkdir -p ~/bin # Make the bin directory if it doesn't exist
cd ../pbs
cp qsub_array.sh ~/bin/
cp qtop.sh ~/bin
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc ## Add to your PATH
source ~/.bashrc # Reload it to add the path
```
* Imagine we wanted to run each of the 5 commands in `cmds.txt`. We can make a qsub job for this with:

```{sh}
qsub_array.sh -f cmds.txt -w 1 -p
```

* See `qsub_array.sh` for details.
* The `-p` option tell it to 'pretend', i.e. not submit the job but create the script. It creates the following script:

```{sh}
#!/bin/bash -login
#PBS -l walltime=1:00:00,nodes=1:ppn=1
#PBS -t 1-5
cd $PBS_O_WORKDIR
echo "This is job number $PBS_JOBID in $PBS_O_WORKDIR running command number $PBS_ARRAYID on node $PBS_NODEFILE" &>> /newhome/madjl/log/mytest.Tj5UE3/$PBS_JOBID.out
date  &>> /newhome/madjl/log/mytest.Tj5UE3/$PBS_JOBID.out
cmd=`head -n $PBS_ARRAYID cmds.txt | tail -n 1`
echo "Running: $cmd"  &>> /newhome/madjl/log/mytest.Tj5UE3/$PBS_JOBID.out
eval $cmd  &>> /newhome/madjl/log/mytest.Tj5UE3/$PBS_JOBID.out
echo "Completed..."  &>> /newhome/madjl/log/mytest.Tj5UE3/$PBS_JOBID.out
date  &>> /newhome/madjl/log/mytest.Tj5UE3/$PBS_JOBID.out
```

* This is setting up logging for Bluecrystal (to your ~/log/ directory), and then running the i-th line of `cmds.txt`.
* So now run the job, and another with `cmdsR.txt`, with:
```{sh}
qsub_array.sh -f cmds.txt -w 1
qsub_array.sh -f cmdsR.txt -w 1
```
* Now we can examine the queue for your own jobs with:
```{sh}
qtop.sh
```
