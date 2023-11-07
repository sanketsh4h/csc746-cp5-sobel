#!/bin/bash

# Path to your CUDA program
CUDA_PROGRAM="./sobel_gpu"

# List of thread block and thread per block configurations
N_BLOCKS=(1 4 16 64 256 1024)
N_THREADS_PER_BLOCK=(32 64 128 256 512 1024)

# Output file for metrics
METRICS_OUTPUT="metrics_output.txt"

# Clear the metrics output file
> "$METRICS_OUTPUT"

# Loop through different configurations
for nBlocks in "${N_BLOCKS[@]}"; do
  for nThreadsPerBlock in "${N_THREADS_PER_BLOCK[@]}"; do
    echo "Running with $nBlocks blocks and $nThreadsPerBlock threads per block"
    
    # Run your CUDA program with ncu to collect metrics
    ncu --set default --section SourceCounters --metrics smsp__cycles_active.avg.pct_of_peak_sustained_elapsed,dram__throughput.avg.pct_of_peak_sustained_elapsed,gpu__time_duration.avg "$CUDA_PROGRAM" "$nBlocks" "$nThreadsPerBlock" >> "$METRICS_OUTPUT"

    echo "Metrics collection complete for $nBlocks blocks and $nThreadsPerBlock threads per block"
  done
done

echo "All metrics collected. Results saved to $METRICS_OUTPUT"
cat "$METRICS_OUTPUT"