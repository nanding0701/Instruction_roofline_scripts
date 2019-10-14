#!/bin/bash
set -x
kernel=(transposeNaive transposeCoalesced)
#timing for kenrels
srun -n 1 nvprof --print-gpu-summary ./transpose |& tee clean.log 

for k in ${kernel[@]}
do
	echo "Profiling kernel: ${k}"
	
	srun -n 1 nvprof --kernels "${k}" --csv --metrics ipc --metrics inst_executed --metrics inst_integer ./transpose |& tee ${k}_set1.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_compute_ld_st --metrics ldst_executed --metrics ldst_fu_utilization ./transpose |& tee ${k}_ld.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_bit_convert --metrics inst_control ./transpose |& tee ${k}_set2.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_fp_64  --metrics inst_fp_32 --metrics inst_fp_16 ./transpose |& tee ${k}_set3.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics local_load_transactions --metrics local_store_transactions ./transpose |& tee ${k}_local.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics shared_load_transactions --metrics shared_store_transactions  ./transpose |& tee ${k}_share.log  
	srun -n 1 nvprof --kernels "${k}" --csv --metrics gst_transactions --metrics gld_transactions ./transpose |& tee ${k}_global.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics local_load_transactions_per_request --metrics local_store_transactions_per_request ./transpose |& tee ${k}_local_req.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics shared_load_transactions_per_request --metrics shared_store_transactions_per_request ./transpose |& tee ${k}_shared_req.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics gld_transactions_per_request --metrics gst_transactions_per_request ./transpose |& tee ${k}_gld_req.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_global_reductions --metrics inst_executed_global_stores --metrics inst_executed_global_loads ./transpose |& tee ${k}_inst_glo.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_local_loads --metrics inst_executed_local_stores ./transpose |& tee ${k}_inst_local.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_shared_loads --metrics inst_executed_shared_stores ./transpose |& tee ${k}_inst_shared.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics l2_write_transactions --metrics l2_read_transactions ./transpose |& tee ${k}_l2.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics dram_read_transactions --metrics dram_write_transactions ./transpose |& tee ${k}_dram.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics sysmem_read_transactions --metrics sysmem_write_transactions ./transpose |& tee ${k}_sysmem.log	srun -n 1 nvprof --kernels "${k}" --csv --events inst_executed --events thread_inst_executed ./transpose |& tee ${k}_event.lo
    
        srun -n 1 nvprof --kernels "${k}" --csv --events inst_executed --events thread_inst_executed ./cudaTensorCoreGemm |& tee ${k}_event.log
done
