#!/bin/bash
set -x
kenrel=(compute_gemm)
#timing for kenrels
#srun -n 1 nvprof --print-gpu-summary ./cudaTensorCoreGemm |& tee clean.log

#for nvvp
#srun -n 1 nvprof --analysis-metrics --output-profile xdrop.nvvp ./cudaTensorCoreGemm
for k in ${kenrel[@]}
do
    echo "Profiling kernel: ${k}"

    srun -n 1 nvprof --kernels "${k}" --csv --metrics ipc --metrics inst_executed --metrics inst_integer ./cudaTensorCoreGemm |& tee ${k}_set1.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_compute_ld_st --metrics ldst_executed --metrics ldst_fu_utilization ./cudaTensorCoreGemm |& tee ${k}_ld.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_bit_convert --metrics inst_control ./cudaTensorCoreGemm |& tee ${k}_set2.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_fp_64  --metrics inst_fp_32 --metrics inst_fp_16 ./cudaTensorCoreGemm |& tee ${k}_set3.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics flop_count_dp --metrics flop_count_sp --metrics flop_count_hp ./cudaTensorCoreGemm |& tee ${k}_set4.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics flop_count_dp_fma ./cudaTensorCoreGemm |& tee ${k}_flop_count_dp_fma.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics local_load_transactions --metrics local_store_transactions ./cudaTensorCoreGemm |& tee ${k}_local.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics shared_load_transactions --metrics shared_store_transactions  ./cudaTensorCoreGemm |& tee ${k}_share.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics gst_transactions --metrics gld_transactions ./cudaTensorCoreGemm |& tee ${k}_global.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics local_load_transactions_per_request --metrics local_store_transactions_per_request ./cudaTensorCoreGemm |& tee ${k}_local_req.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics shared_load_transactions_per_request --metrics shared_store_transactions_per_request ./cudaTensorCoreGemm |& tee ${k}_shared_req.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics gld_transactions_per_request --metrics gst_transactions_per_request ./cudaTensorCoreGemm |& tee ${k}_gld_req.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_global_reductions --metrics inst_executed_global_stores --metrics inst_executed_global_loads ./cudaTensorCoreGemm |& tee ${k}_inst_glo.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_local_loads --metrics inst_executed_local_stores ./cudaTensorCoreGemm |& tee ${k}_inst_local.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics inst_executed_shared_loads --metrics inst_executed_shared_stores ./cudaTensorCoreGemm |& tee ${k}_inst_shared.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics l2_write_transactions --metrics l2_read_transactions ./cudaTensorCoreGemm |& tee ${k}_l2.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics dram_read_transactions --metrics dram_write_transactions ./cudaTensorCoreGemm |& tee ${k}_dram.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics sysmem_read_transactions --metrics sysmem_write_transactions ./cudaTensorCoreGemm |& tee ${k}_sysmem.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics branch_efficiency ./cudaTensorCoreGemm |& tee ${k}_branch_efficiency.log
    srun -n 1 nvprof --kernels "${k}" --csv --metrics warp_nonpred_execution_efficiency --metrics warp_execution_efficiency ./cudaTensorCoreGemm |& tee ${k}_warp_execu_eff.log
    srun -n 1 nvprof --kernels "${k}" --csv --events inst_executed --events thread_inst_executed ./cudaTensorCoreGemm |& tee ${k}_event.log

    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics smsp__inst_executed_pipe_tensor.sum ./cudaTensorCoreGemm |& tee ${k}_tensor_inst_sum.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics smsp__inst_executed_pipe_tensor.avg ./cudaTensorCoreGemm |& tee ${k}_tensor_inst_avg.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics smsp__inst_executed_pipe_tensor.max ./cudaTensorCoreGemm |& tee ${k}_tensor_inst_max.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics smsp__inst_executed_pipe_tensor_op_hmma.sum ./cudaTensorCoreGemm |& tee ${k}_tensor_gmma_sum.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics smsp__inst_executed_pipe_tensor_op_hmma.avg ./cudaTensorCoreGemm |& tee ${k}_tensor_gmma_avg.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics smsp__inst_executed_pipe_tensor_op_hmma.max ./cudaTensorCoreGemm |& tee ${k}_tensor_gmma_max.log

    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics sm__inst_executed_pipe_tensor.sum ./cudaTensorCoreGemm |& tee ${k}_sm_tensor_inst_sum.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics sm__inst_executed_pipe_tensor.avg ./cudaTensorCoreGemm |& tee ${k}_sm_tensor_inst_avg.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics sm__inst_executed_pipe_tensor.max ./cudaTensorCoreGemm |& tee ${k}_sm_tensor_inst_max.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics sm__inst_executed_pipe_tensor_op_hmma.sum ./cudaTensorCoreGemm |& tee ${k}_sm_tensor_gmma_sum.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics sm__inst_executed_pipe_tensor_op_hmma.avg ./cudaTensorCoreGemm |& tee ${k}_sm_tensor_gmma_avg.log
    srun -n 1  nv-nsight-cu-cli -k "${k}" --metrics sm__inst_executed_pipe_tensor_op_hmma.max ./cudaTensorCoreGemm |& tee ${k}_sm_tensor_gmma_max.log
done
