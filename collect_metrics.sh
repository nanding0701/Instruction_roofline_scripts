#!/bin/bash
set -x
kenrel=(transposeNaive transposeCoalesced)
#timing for kenrels
srun -n 1 nvprof --print-gpu-summary ./transpose |& tee clean.log 

for k in ${kenrel[@]}
do
	echo "Profiling kernel: ${k}"
	
	srun -n 1 nvprof --kernels "${k}" --csv --metrics ipc --metrics inst_executed --metrics inst_integer ./transpose |& tee ${k}_set1.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_compute_ld_st --metrics ldst_executed --metrics ldst_fu_utilization ./transpose |& tee ${k}_ld.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_bit_convert --metrics inst_control ./transpose |& tee ${k}_set2.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_fp_64  --metrics inst_fp_32 --metrics inst_fp_16 ./transpose |& tee ${k}_set3.log 
	srun -n 1 nvprof --kernels "${k}" --csv --metrics flop_count_dp --metrics flop_count_sp --metrics flop_count_hp ./transpose |& tee ${k}_set4.log 
    srun -n 1 nvprof --kernels "${k}" --csv --metrics flop_count_dp_fma ./transpose |& tee ${k}_flop_count_dp_fma.log
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
	srun -n 1 nvprof --kernels "${k}" --csv --metrics sysmem_read_transactions --metrics sysmem_write_transactions ./transpose |& tee ${k}_sysmem.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics branch_efficiency ./transpose |& tee ${k}_branch_efficiency.log
	srun -n 1 nvprof --kernels "${k}" --csv --metrics warp_nonpred_execution_efficiency --metrics warp_execution_efficiency ./transpose |& tee ${k}_warp_execu_eff.log
	srun -n 1 nvprof --kernels "${k}" --csv --events inst_executed --events thread_inst_executed ./transpose |& tee ${k}_event.log
	
    
    #srun -n 1 nvprof --kernels "${k}" --csv --events shared_ld_bank_conflict --events shared_st_bank_conflict ./transpose |& tee ${k}_controlflow.log
    #srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_constant_memory_dependency --metrics stall_exec_dependency --metrics stall_inst_fetch ./transpose |& tee ${k}_stall1.log
	#srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_memory_dependency --metrics stall_memory_throttle --metrics stall_not_select ./transpose |& tee ${k}_stall2.log
	#srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_sleeping --metrics stall_pipe_busy --metrics stall_other ./transpose |& tee ${k}_stall3.log
	#srun -n 1 nvprof --kernels "${k}" --csv --metrics stall_sync ./transpose |& tee ${k}_stall4.log



done
