#!/bin/bash -le

# print usage
function usage() {
    echo "USAGE: merge.sh </path/to/extended_output>"
}

# if no input params
if [ -z "$1" ]; then 
    usage
    exit -1
fi

# extended_output path
OPATH=${1}

# list of kernels
kernels=(Adept_F Adept_R)

# list of metrics
metric=(inst_integer inst_compute_ld_st ldst_executed inst_fp_64 inst_fp_32 inst_fp_16 flop_count_dp flop_count_sp flop_count_hp flop_count_dp_fma local_load_transactions local_store_transactions local_load_transactions_per_request local_store_transactions_per_request inst_executed_local_loads inst_executed_local_stores shared_load_transactions shared_store_transactions shared_load_transactions_per_request shared_store_transactions_per_request inst_executed_shared_loads inst_executed_shared_stores gst_transactions gld_transactions gld_transactions_per_request gst_transactions_per_request inst_executed_global_reductions inst_executed_global_loads inst_executed_global_stores l2_read_transactions l2_write_transactions dram_read_transactions dram_write_transactions sysmem_read_transactions sysmem_write_transactions ipc) 

# list of events
event=(inst_executed thread_inst_executed)

# extract and append all of them in one file
for kernel in ${kernels[@]}
do
	echo ${kernel}
	filename="${OPATH}/${kernel}"
	echo ${filename}

	# remove previous file if exists
	rm -rf ${filename}

	# write all metrics
	for m in ${metric[@]}
	do
		echo $m
		data=`grep -rin -E "${kernel}.*\"${m}\"" ${OPATH}/${kernel}_*.log | awk -F',' '{print $NF}'`  
		echo "${m},${data}" >> ${filename}.csv
	done

	# write events
	for e in ${event[@]}
	do
		echo $e
		data=`grep -rin -E "${kernel}.*\"${e}\"" ${OPATH}/${kernel}_event.log | awk -F',' '{print $NF}'`  
		echo "${e},${data}" >> ${filename}.csv
	done

	# replace all spaces with comma to make a csv
	sed -i "s/,[[:blank:]]*$//g" ${filename}.csv

	# remove any trailing whitespaces
	sed -i 's/[[:blank:]]*$//' ${filename}.csv
done
