#!/usr/bin/env bash
# Get current script working directory
binpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
seplog="▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃"
# Create folder $binpath/logs/ if does not exist
mkdir -p "$binpath/logs"
echo $seplog >> $binpath/logs/subenum-all-targets.log
echo "Job started" >> $binpath/logs/subenum-all-targets.log
source /root/.bashrc
# source /ptv/add_to_path.sh
# source /ptv/setup-everything/.bin/setup-bashrc-bin-path.sh

srclist=()
# define an empty array
declare -a srclist
# iterate over lines of bashrc_content and echo them
while IFS= read -r line; do
    # If line starts with 'source', then add it to srclist
    if [[ $line == source* ]]; then
        # select everything after 'source '
        srclist+=("${line:7}")
    fi
done < ~/.bashrc
for i in "${srclist[@]}"
do
    source "$i" > /dev/null 2>&1
done

# echo date,time,venv and current working directory
echo "[+] Current date and time: $(TZ=":Asia/Tehran" date)" >> $binpath/logs/subenum-all-targets.log
echo "[+] Current PATH: $PATH" >> $binpath/logs/subenum-all-targets.log
echo "[+] Current virtual environment: $(which python3)" >> $binpath/logs/subenum-all-targets.log
echo "[+] Current working directory: $(pwd)" >> $binpath/logs/subenum-all-targets.log
# Check whether notifio is available
a=$(which notifio)
# If a is empty, then notifio is not available
if [ -z "$a" ]; then
    printf "notifio is not available. Please install it first." >> $binpath/logs/subenum-all-targets.log
    exit 1
fi

# Run the scripts
$binpath/.bin/subenum-all-h1-targets.sh | tee $binpath/logs/subenum-all-targets.log
$binpath/.bin/subenum-all-bc-targets.sh | tee $binpath/logs/subenum-all-targets.log

# Send a finished job notification to logs file
printf "Job finished" >> $binpath/logs/subenum-all-targets.log
printf "" >> $binpath/logs/subenum-all-targets.log
printf "" >> $binpath/logs/subenum-all-targets.log