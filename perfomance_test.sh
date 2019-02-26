#!/bin/bash
url="http://127.0.0.1:3000/query/"
querry="SELECT%20*%20FROM%20user_details"
count=1
time=0

# Check for valid number
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
	   echo "error: Argument 1 should be a number!" >&2
	   exit 1
fi

# Main loop
while [[ $count -le $1 ]]; do
	# execute curl get
	output=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" ${url}${querry})

	# Get request time and return code
	req_time=$(echo $output |awk '{print $2}')
	returnCode=$(echo $output | awk '{print $1}')	

	# Check that returncode is 200
	if [[ $returnCode != "200" ]]; then
		echo "NOT 200er"
		exit 99
	fi

	# Calculate 
	time=$(bc -l <<< "$time+$req_time")
	echo "${count}/${1}: ${returnCode} - ${req_time}s"
	count=$(($count + 1))
done

# Calculations
middle_time=$(bc -l <<< "$time/$1")
middle_time_rounded=$(printf '%.*f\n' 4 $middle_time)

# Output
echo "##############################################"
echo "## $1 requests in average time of ${middle_time_rounded}s     #"
echo "##############################################"
