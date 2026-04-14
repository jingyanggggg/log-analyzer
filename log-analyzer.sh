#!/bin/bash

# handle ctrl+c
function handle_interrupt {
	echo -e "\n Exiting program."
	exit 1
}
trap handle_interrupt SIGINT

# print usage instructions
function print_usage {
	echo "Usage: ${0#./} <log_file> [threshold]"
	echo "	<log_file> : Path to the log file to analyze."
	echo "	[threshold]: Number of failed attemps before alerting. (Default: 5)"
}

# check arguments
if [ $# -lt 1 ] ; then
	echo "Error: Missing required arguments."
	print_usage
	exit 1
fi

# assign first argument to a variable log_file
log_file=$1
# echo "log_file: $log_file"

# assign second argument to variable threshold, if missing, default to 5
threshold=${2:-5}
# echo "threshold: $threshold"

# check if log file exists and is readable
if [ ! -f "$log_file" ]; then
	echo "Error: File \"$log_file\" does not exist."
	exit 2
elif [ ! -r "$log_file" ] ; then
	echo "Error: You are not allowed to read \"$log_file\". Try running with sudo."
	exit 2
fi

echo "=================================================="
echo " Analyzing $log_file for failed SSH logins..."
echo " Alert Threshold: $threshold failed attempts"
echo "=================================================="

# array to track malicious IPs
malicious_ips=()

grep "Failed 
