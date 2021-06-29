# Instruction Roofline for Adept

This repository contains the essential scripts of profiling, building, and visualizing the Instruction Roofline Model for the Adept kernels on NVIDIA GPUs.

## Usage Instructions
1. Open the file `collect_metric_extended.sh` and edit the lines 7 to 14 to reflect Adept application paths.     

```bash
7 # path to adept's repo home
8 apphome=$HOME/repos/mhaseeb/adept_revamp
9
10 # path to adept_test app and three arguments to it
11 app=${apphome}/build/adept_test
12 arg1=/global/cscratch1/sd/mhaseeb/sw-benchmarks/ref_set_1.fasta
13 arg2=/global/cscratch1/sd/mhaseeb/sw-benchmarks/read_set_1.fasta
14 arg3=${apphome}/build/aligned.out
15
```

2. Allocate a GPU node (preferably with `--exclusive`) using the following command:     

```bash
salloc -G 1 -C gpu -t 00:30:00 --exclusive
```

3. Run the `collect_metric_extended.sh` script as:     

```bash
./collect_metric_extended.sh
```

4. After completion, copy the `merge.sh` to the `extended_output` folder and run to obtain `Adept_F.csv` and `Adept_R.csv`:     

```bash
extended_output` using: `cp merge.sh ./extended_output && pushd ./extended_output && ./merge.sh && popd
```

5. Finally, run the `adept_roofline.py` script to build and visualize the roofline as:     

```bash
python ./adept_rooflines.py -f ./extended_output/Adept_F.csv -r ./extended_output/Adept_R.csv && ps2pdf ./adept_glob.eps && ps2pdf ./adept_shm.eps
```

## References
1. Ding, Nan, and Samuel Williams. "An instruction roofline model for gpus." 2019 IEEE/ACM Performance Modeling, Benchmarking and Simulation of High Performance Computer Systems (PMBS). IEEE, 2019    