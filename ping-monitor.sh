#!/bin/bash

# Capature ping logs
# If unsucessful, write ping error to log
# Else write ping reponse time to log
# Give each iteration 5 seconds to run
# Sleep time = (current time less than end time)

mkdir -p ~/logs
wait_duration=5
hosts="$@"

if [ "$#" -ne 3 ]; then
    echo "Expecting three domain names as arguments"
    echo "E.G ./ping-monitor.sh abc.co.uk abd.ie abe.de"
    echo "Aborting program."
    exit 1;
fi

while true; do \
    timestamp=$( date +%Y-%m-%d:%H:%M:%S ); \
    wifi_sid=$( networksetup -getairportnetwork en0 )
    end_time=$(( $(date +%s ) + ${wait_duration} ))

    for host in ${hosts}; do

        # Stop ping after receiving one response and timeout after one second
        response=$(( ping -c1 -t1 ${host} ) 2>&1 );
        exit_code=$?;

        if (( ${exit_code} != 0 ))
        then
            echo ${timestamp} Site: ${host} is down, Response: ${response}, ${wifi_sid};
        else
            ping_time=$(echo "${response}" | sed -n 2p)
            echo ${timestamp} Site: ${host} is reachable, Response: ${ping_time}, ${wifi_sid}
        fi;
    done >> ~/logs/ping-monitor.log 2>&1;

    # Wait until interval has elapsed
    while [ $( date +%s ) -lt ${end_time} ]; do
        # echo "Waiting..."
        sleep 0.5;
    done
done
