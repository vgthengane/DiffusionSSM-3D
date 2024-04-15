#!/bin/bash

# Function to get the output directory with an incremented name if necessary
# get_output_dir() {
#     local dir_id="$1"
#     local exp_id="$2"
#     local output_dir="$dir_id/$exp_id"
#     if [ ! -d "$output_dir" ]; then
#         mkdir -p "$output_dir"
#     else
#         local increment=1
#         while true; do
#             local incremented_dir="${output_dir}_$(printf '%02d' "$increment")"
#             if [ ! -d "$incremented_dir" ]; then
#                 output_dir="$incremented_dir"
#                 mkdir -p "$output_dir"
#                 break
#             fi
#             ((increment++))
#         done
#     fi
#     echo "$output_dir"
# }

# get_output_dir() {
#     local dir_id="$1"          # Assign the first argument (dir_id) to a local variable
#     local exp_id="$2"          # Assign the second argument (exp_id) to a local variable
#     local output_dir="$dir_id/$exp_id"  # Combine dir_id and exp_id to form the output directory path
#     if [ ! -d "$output_dir" ]; then    # Check if the output directory already exists
#         mkdir -p "$output_dir"         # If not, create the directory recursively
#     else
#         local increment=1              # If the directory exists, set the increment counter to 1
#         while true; do                 # Start an infinite loop
#             local incremented_dir="${output_dir}_$(printf '%02d' "$increment")"  # Form the incremented directory name
#             if [ ! -d "$incremented_dir" ]; then   # Check if the incremented directory exists
#                 exp_id="${exp_id}_$(printf '%02d' "$increment")"  # Update the experiment ID with the increment
#                 # mkdir -p "$incremented_dir"             # Create the incremented directory
#                 break                              # Exit the loop
#             fi
#             ((increment++))         # Increment the counter for the next iteration
#         done
#     fi
#     echo "$exp_id"      # Output the updated experiment ID
# }

get_output_dir() {
    local dir_id="$1"          # Assign the first argument (dir_id) to a local variable
    local exp_id="$2"          # Assign the second argument (exp_id) to a local variable
    local output_dir="$dir_id/$exp_id"  # Combine dir_id and exp_id to form the output directory path
    if [ -d "$output_dir" ]; then    # Check if the output directory already exists
        local increment=1              # If the directory exists, set the increment counter to 1
        while true; do                 # Start an infinite loop
            local incremented_dir="${output_dir}_$(printf '%02d' "$increment")"  # Form the incremented directory name
            if [ ! -d "$incremented_dir" ]; then   # Check if the incremented directory exists
                exp_id="${exp_id}_$(printf '%02d' "$increment")"  # Update the experiment ID with the increment
                break                              # Exit the loop
            fi
            ((increment++))         # Increment the counter for the next iteration
        done
    fi
    echo "$exp_id"      # Output the updated experiment ID
}
