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
	echo "	<log_file> : Path to the auth.log to analyze."
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

# print filename and threshold used for analysis
echo "=================================================="
echo " Analyzing $log_file for failed SSH logins..."
echo " Alert Threshold: $threshold failed attempts"
echo "=================================================="

# array to track malicious IPs
malicious_ips=()

# logic explanation:
# pipe 1: find lines with "Failed password"
# pipe 2: extract ipv4 addresses using regex
# pipe 3, 4, 5: count unique ips and sort them in descending order
# output is fed into a while loop to display alert based on count and ip
while read count ip ; do
	if [ $count -ge $threshold ] ; then
		echo "[ALERT] $ip detected with $count login attempts."
		malicious_ips[${#malicious_ips[@]}]=$ip
	fi
done < <(grep "Failed password" "$log_file" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort | uniq -c | sort -nr)

echo "=================================================="

total_alerts=${#malicious_ips[@]}

# produce a summary of the findings
if [ $total_alerts -gt 0 ] ; then
	echo "Summary: Found $total_alerts IP(s) exceeding the threshold."
	echo "Recommended Action: Consider blocking the following IP(s) in your firewall:"
	
	for malicious_ip in "${malicious_ips[@]}" ; do
		echo " - sudo ufw deny from $malicious_ip"
	done
else
	echo "Summary: No IPs exceeded the threshold of $threshold."
fi

exit 0
