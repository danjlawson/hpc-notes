To use the **GPU** with Tensorflow, first set up a conda environment "tf-env", and then add the gpu support with:

```{bash}
module load lang/python/anaconda/3.9.7-2021.12-tensorflow.2.7.0
conda activate tf-env
conda install tensorflow-gpu
```

Test using:

```{bash}
sbatch submit_gpu_test.sh
```

which should produce the following output:

```{bash}
$ cat test_stdout_gpu.txt
Fri 24 Feb 08:09:38 GMT 2023
Num GPUs Available:  1
Fri 24 Feb 08:10:18 GMT 2023
40.108 seconds passed
```
