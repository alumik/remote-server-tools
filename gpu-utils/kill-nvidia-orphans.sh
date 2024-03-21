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

# Create an array to hold all child PIDs
declare -a child_pids_array

# Populate child_pids_array with child PIDs of each nvidia_pid
for nvidia_pid in ${nvidia_pids_array[*]}; do
  # Using pstree to list children of the current nvidia_pid, then awk to extract PIDs
  children=$(pstree -p "$nvidia_pid" | grep -o '([0-9]\+)' | tr -d '()' | tr '\n' ' ')
  echo "Children of $nvidia_pid:"
  echo "$children"
  # Read the children PIDs into the array
  readarray -t temp_array <<<"$children"
  # Merge arrays
  child_pids_array=("${child_pids_array[@]}" "${temp_array[@]}")
done

# Iterate over fuser_pids and check if they are not in nvidia_pids and not a child PID
for pid in $fuser_pids; do
  (
    if [[ ! " ${nvidia_pids_array[*]} " =~ ${pid} ]] && [[ ! " ${child_pids_array[*]} " =~ ${pid} ]]; then
      match_count=0
      for _ in {1..3}; do
        # Refresh fuser_pids to get the current list of PIDs using the NVIDIA device
        current_fuser_pids=$(fuser /dev/nvidia* 2>/dev/null | awk '{$1=$1}1' | tr -s ' ' '\n' | sort -n | uniq | tr '\n' ' ')
        if [[ " $current_fuser_pids " =~ ${pid} ]]; then
          ((match_count++))
        fi
        sleep 2
      done
      # If the PID is found in all three checks, proceed to kill
      if [[ $match_count -eq 3 ]]; then
        echo "Killing PID $pid as it was found active in all checks."
        kill -9 "$pid"
        # Optionally, you can use 'kill -9 $pid' to forcefully kill the process if 'kill $pid' does not work
      else
        echo "PID $pid was not consistently active; no action taken."
      fi
    fi
  ) &
done
wait
