#!/bin/bash
set -x

# list of kernels to profile
kernel=(Adept_F Adept_R)

# path to app's home
apphome=$HOME/repos/mhaseeb/adept_revamp

# path to app and arguments
app=${apphome}/build/adept_test
arg1=/global/cscratch1/sd/mhaseeb/sw-benchmarks/ref_set_1.fasta
arg2=/global/cscratch1/sd/mhaseeb/sw-benchmarks/read_set_1.fasta
arg3=${apphome}/build/aligned.out

# prepare the app
pushd ${apphome}/build
cmake .. -DADEPT_INSTR=OFF
make clean
make install -j 4
popd

# remove previous output directory if exists
rm -rf output

# make a new output directory
mkdir -p output

# timing for kenrels
nvprof --print-gpu-summary ${app} ${arg1} ${arg2} ${arg3} |& tee output/clean.log 

# collect all metrics for all kernels individually
for k in ${kernel[@]}
do
	echo "Profiling kernel: ${k}"

	nvprof --kernels "${k}" --csv --metrics inst_executed --metrics inst_integer ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_inst.log 
	nvprof --kernels "${k}" --csv --metrics inst_fp_64  --metrics inst_fp_32 --metrics inst_fp_16 ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_fp_inst.log 
	nvprof --kernels "${k}" --csv --metrics local_load_transactions_per_request --metrics local_store_transactions_per_request ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_local_req.log
	nvprof --kernels "${k}" --csv --metrics shared_load_transactions_per_request --metrics shared_store_transactions_per_request ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_shared_req.log
	nvprof --kernels "${k}" --csv --metrics gld_transactions_per_request --metrics gst_transactions_per_request ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_gld_req.log
	nvprof --kernels "${k}" --csv --metrics l2_write_transactions --metrics l2_read_transactions ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_l2.log 
	nvprof --kernels "${k}" --csv --metrics dram_read_transactions --metrics dram_write_transactions ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_dram.log
	nvprof --kernels "${k}" --csv --metrics sysmem_read_transactions --metrics sysmem_write_transactions ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_sysmem.log

	# event-based metrics
	nvprof --kernels "${k}" --csv --events inst_executed --events thread_inst_executed ${app} ${arg1} ${arg2} ${arg3} |& tee output/${k}_event.log
done

# remove the output file from the app (not needed here)
rm -rf ${arg3}