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
rm -rf output_extended

# make a new output directory
mkdir -p output_extended

# timing for kernels
nvprof --print-gpu-summary ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/clean.log

# collect all metrics for all kernels individually
for k in ${kernel[@]}
do
    echo "Profiling kernel: ${k}"

    nvprof --kernels "${k}" --csv --metrics ipc --metrics inst_executed --metrics inst_integer ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_set1.log
    nvprof --kernels "${k}" --csv --metrics inst_compute_ld_st --metrics ldst_executed --metrics ldst_fu_utilization ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_ld.log
    nvprof --kernels "${k}" --csv --metrics inst_bit_convert --metrics inst_control ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_set2.log
    nvprof --kernels "${k}" --csv --metrics inst_fp_64  --metrics inst_fp_32 --metrics inst_fp_16 ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_set3.log
    nvprof --kernels "${k}" --csv --metrics flop_count_dp --metrics flop_count_sp --metrics flop_count_hp ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_set4.log
    nvprof --kernels "${k}" --csv --metrics flop_count_dp_fma ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_flop_count_dp_fma.log
    nvprof --kernels "${k}" --csv --metrics local_load_transactions --metrics local_store_transactions ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_local.log
    nvprof --kernels "${k}" --csv --metrics shared_load_transactions --metrics shared_store_transactions  ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_share.log
    nvprof --kernels "${k}" --csv --metrics gst_transactions --metrics gld_transactions ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_global.log
    nvprof --kernels "${k}" --csv --metrics local_load_transactions_per_request --metrics local_store_transactions_per_request ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_local_req.log
    nvprof --kernels "${k}" --csv --metrics shared_load_transactions_per_request --metrics shared_store_transactions_per_request ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_shared_req.log
    nvprof --kernels "${k}" --csv --metrics gld_transactions_per_request --metrics gst_transactions_per_request ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_gld_req.log
    nvprof --kernels "${k}" --csv --metrics inst_executed_global_reductions --metrics inst_executed_global_stores --metrics inst_executed_global_loads ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_inst_glo.log
    nvprof --kernels "${k}" --csv --metrics inst_executed_local_loads --metrics inst_executed_local_stores ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_inst_local.log
    nvprof --kernels "${k}" --csv --metrics inst_executed_shared_loads --metrics inst_executed_shared_stores ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_inst_shared.log
    nvprof --kernels "${k}" --csv --metrics l2_write_transactions --metrics l2_read_transactions ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_l2.log
    nvprof --kernels "${k}" --csv --metrics dram_read_transactions --metrics dram_write_transactions ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_dram.log
    nvprof --kernels "${k}" --csv --metrics sysmem_read_transactions --metrics sysmem_write_transactions ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_sysmem.log
    nvprof --kernels "${k}" --csv --metrics branch_efficiency ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_branch_efficiency.log
    nvprof --kernels "${k}" --csv --metrics warp_nonpred_execution_efficiency --metrics warp_execution_efficiency ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_warp_execu_eff.log

    nvprof --kernels "${k}" --csv --events inst_executed --events thread_inst_executed ${app} ${arg1} ${arg2} ${arg3} |&  tee output_extended/${k}_event.log
done

# remove the output file from the app (not needed here)
rm -rf ${arg3}