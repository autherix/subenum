#!/usr/bin/env bash

# Get current script working directory
binpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check whether crontab is installed
if [ ! -x /usr/bin/crontab ]; then
    echo "Crontab is not installed. Please install it first."
    exit 1
fi

# Check whether crontab service is running
if [ ! -x /etc/init.d/cron ]; then
    # If we have sudo access, try to start the service
    if [ -x /usr/bin/sudo ]; then
        sudo /etc/init.d/cron start
    else
        echo "Crontab service is not running. Please start it first or run this script as root."
        exit 1
    fi
fi

# Define the script to be run
# script='python3 /ptv/healer/bbplats/h1/get_programs.py && python3 /ptv/healer/bbplats/h1/get_program.py && python3 /ptv/healer/bbplats/h1/diff_program.py'

# Check all the required files exist, create a list of strings
list_of_files=("$binpath/.bin/subenum-all-bc-targets.sh" "$binpath/.bin/subenum-all-h1-targets.sh" "$binpath/.bin/subenum")
# if any of these files do not exist, print error message saying the list of non-existing required files and exit 1
# Create an empty list to store non-existing files
non_existing_files=()
for file in "${list_of_files[@]}"; do
    if [ ! -f "$file" ]; then
        non_existing_files+=("$file")
    fi
done
# If the list of non-existing files is not empty, print error message and exit 1
if [ ${#non_existing_files[@]} -ne 0 ]; then
    echo "The following required files do not exist:"
    for file in "${non_existing_files[@]}"; do
        echo "$file"
    done
    echo "Please make sure all the required files exist."
    exit 1
fi

# Clear crontab for the current user
# crontab -r

# Define the cron job to run the script every 5 days (if not already defined)
if crontab -l | grep -q "$binpath/subenum-all-job.sh"; then
    echo "Cron job already exists."
    exit 1
else
    cronjob="0 0 */5 * * $binpath/subenum-all-job.sh"
    # Add the cron job
    (crontab -l 2>/dev/null; echo "$cronjob") | crontab - && echo "Cron job added successfully."
fi