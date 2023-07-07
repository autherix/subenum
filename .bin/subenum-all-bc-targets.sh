#!/usr/bin/env bash 

# Get current running file's directory and save to a var
c_path=$(dirname $0)

# In two upper directory, read the file bc_tgts_new_full.json , then jq it to get the list of targets' handles
target_handle_list=$(healerdb bc_targetinfo list -db bbplats -coll bc -j | jq -r '.result[]')

# count the targets 
target_count=$(echo $target_handle_list | wc -w)
c_count=0

# Iterate over the list of targets' handles and run subenum on each of them
for target_handle in $target_handle_list
do
    # Increment the counter
    c_count=$((c_count+1))
    # Print seperator
    printf " ----------------------------------------\n"
    # Print the target handle
    printf "Target handle: $target_handle\n"
    # print progress on the same line update
    printf "Progress: $c_count/$target_count\n"
    # Run subenum on the target handle
    # subenum -p bc -db enum -t $target_handle
    subenum -t $target_handle
    wait $!
    # Check if the subenum command was successful or not
    if [ $? -eq 0 ]
    then
        echo "----------------------------------------"
    else
        echo "subenum failed on target: $target_handle"
        echo "Error text: $?"
        echo "----------------------------------------"
    fi
done