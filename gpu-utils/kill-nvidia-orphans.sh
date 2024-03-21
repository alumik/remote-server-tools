#!/bin/bash

# Get PIDs using the NVIDIA device
fuser_pids=$(fuser /dev/nvidia* 2>/dev/null | awk '{$1=$1}1' | tr -s ' ' '\n' | sort -n | uniq | tr '\n' ' ')
echo "All processes using NVIDIA devices:"
echo "$fuser_pids"

# Get PIDs reported by nvidia-smi
nvidia_pids=$(nvidia-smi | grep ' C \| G ' | awk '{ print $5 }' | sort -n | uniq | tr '\n' ' ')
echo "Active processes using NVIDIA devices (from nvidia-smi):"
echo "$nvidia_pids"

# Convert nvidia_pids to a bash array
readarray -t nvidia_pids_array <<<"$nvidia_pids"

# Iterate over fuser_pids and check if they are not in nvidia_pids
for pid in $fuser_pids; do
  if [[ ! " ${nvidia_pids_array[*]} " =~ ${pid} ]]; then
    echo "Killing orphaned process: $pid"
    kill -9 "$pid"
  fi
done
