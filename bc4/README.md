# Tensorflow with GPU acceleration on BC4

To use the **GPU** with Tensorflow, everything is very fussy. But it can be made to work...

First follow the instructions for logging on to BC4 GPU node, which from bash are:
```{bash}
ssh -X <username>@bc4gpulogin.acrc.bris.ac.uk
```
This enables you to test interactively.


If you have previously tried to get tensorflow working, you will need to RESET. You can move your old content to save for later, or delete them with:
```{bash}
rm -rf ~/.bashrc ~/.conda
```
You should then exit and relogin to make sure there is no version confusion.

First, we need to make a barebones `~/.bashrc` file, to work around a conda bug. This is run every time that you log on or run a job on a node. The following text creates this. Note that we need the `module load` command in place **before** we run `conda init` later, so that everything happens in the right order.
```{bash}
echo "# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
module load languages/anaconda3/2019.10-3.7.4-tflow-2.1.0
" > ~/.bashrc
```

Now run this (which loads the module):
```{bash}
source ~/.bashrc
```
Now we are ready to initialise conda, and then reload the .bashrc file to access the changes:
```{bash}
conda init
source ~/.bashrc
```

Whilst you can use this version of python and it will work, you can't install new modules for it. For that we need to start a clean conda environment.

Now we can create a new environment:

```{bash}
conda create -y -n tf-env
```

Everything should be set up correctly. If it is, you can run:

```{bash}
conda activate tf-env
conda install tensorflow-gpu keras pandas scikit-learn
```
and use conda and python as intended. To test this, try:
```{bash}
git clone https://github.com/danjlawson/hpc-notes.git
cd hpc-notes/bc4/
python gputest.py
```
which should produce output like the following:
```
(tf-env) [madjl@bc4gpulogin1 bc4]$ python gputest.py
2023-03-02 11:15:14.797517: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcudart.so.10.1
2023-03-02 11:15:16.675914: I tensorflow/compiler/jit/xla_cpu_device.cc:41] Not creating XLA devices, tf_xla_enable_xla_devices not set
2023-03-02 11:15:16.677337: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcuda.so.1
2023-03-02 11:15:16.686233: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1720] Found device 0 with properties:
pciBusID: 0000:0b:00.0 name: Tesla P100-PCIE-16GB computeCapability: 6.0
coreClock: 1.3285GHz coreCount: 56 deviceMemorySize: 15.89GiB deviceMemoryBandwidth: 681.88GiB/s
2023-03-02 11:15:16.686307: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcudart.so.10.1
2023-03-02 11:15:16.691927: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcublas.so.10
2023-03-02 11:15:16.691997: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcublasLt.so.10
2023-03-02 11:15:16.696212: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcufft.so.10
2023-03-02 11:15:16.697080: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcurand.so.10
2023-03-02 11:15:16.702699: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcusolver.so.10
2023-03-02 11:15:16.705176: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcusparse.so.10
2023-03-02 11:15:16.714882: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcudnn.so.7
2023-03-02 11:15:16.715305: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1862] Adding visible gpu devices: 0
Num GPUs Available:  1
```

Congratulations! You now have GPU access working as intended!

You can also test that the real data processing works:

```{bash}
python kerastest.py
```

Don't expect it to be fast on the busy login node, but you should see some reassuring output, specifically:
```
Num GPUs Available:  1
...
... Adding visible gpu devices: 0
...
```
which means that **device number 0** has been identified and will be used.

## Running on the nodes

You can't use the login nodes for jobs. You need to use `sbatch` to submit jobs to the job queue which run on nodes.

To submit a job to the GPU queue, run:
```{bash}
sbatch submit_gpu_test.sh
sbatch submit_nogpu_test.sh
```
These create outputs `test_stdout_gpu.txt` and `test_stdout_nogpu.txt` which allow you to see the computational timings. Oddly the GPU is very slow - probably because the time is dominated by copying content into and out of the GPU memory.

There are some gotchas with the gpu. If you get a `bus error` it is likely that you have not allocated enough memory. If you only allocate 1000M in the above script, it gives this error. Try asking for an entire half of the resource - GPU nodes have 128Gb RAM, 14 cores and 2 GPU cards [https://www.acrc.bris.ac.uk/acrc/phase4.htm](https://www.acrc.bris.ac.uk/acrc/phase4.htm) so ask for half of this.
