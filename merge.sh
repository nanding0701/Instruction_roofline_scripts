#!/bin/bash
kernels=(extendSeedLGappedXDropOneDirectionShared)
metric=(inst_executed thread_inst_executed inst_integer inst_compute_ld_st ldst_executed inst_fp_64 inst_fp_32 inst_fp_16 flop_count_dp flop_count_sp flop_count_hp flop_count_dp_fma local_load_transactions local_store_transactions local_load_transactions_per_request local_store_transactions_per_request inst_executed_local_loads inst_executed_local_stores shared_load_transactions shared_store_transactions shared_load_transactions_per_request shared_store_transactions_per_request inst_executed_shared_loads inst_executed_shared_stores gst_transactions gld_transactions gld_transactions_per_request gst_transactions_per_request inst_executed_global_reductions inst_executed_global_loads inst_executed_global_stores l2_read_transactions l2_write_transactions dram_read_transactions dram_write_transactions sysmem_read_transactions sysmem_write_transactions ipc) 
for kernel in ${kernels[@]}
do
	echo ${kernel}
	filename="${dir}_${kernel}"
	echo ${filename}
	
	for m in ${metric[@]}
	do
		echo $m
		data=`grep -rin -E "${kernel}.*\"${m}\"" ./${kernel}_*.log | awk -F':' '{print $3}'`  
		echo "${data}" >> ${filename}.csv
	
	done
done
