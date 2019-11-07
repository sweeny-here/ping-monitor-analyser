#!/bin/bash

# Packet loss
# Number of log enteries per hour - enteries per run x (seconds per minute / wait time) x minutes per hour
# Number of log enteries per hour - 3 x (60 / 5) x 60 = 2160
# 1 hour packet loss equation (loss/2160 x 100/1) = (loss/21.6)
# Number of log enteries per 12 hours - 2160 x 12 = 25920
# 12 hour packet loss equation (loss/25920 x 100/1) = (loss/259.2)
# Number of log enteries per 24 hours - 2160 x 24 = 51840
# 24 hour packet loss equation (loss/51840 x 100/1) = (loss/518.4)
#
# Latency analyser
# If ping time is greater than 29ms, then report latency

echo $(date +%Y-%m-%d:%H:%M:%S)

data=$(tail -2160 ~/logs/ping-monitor.log); \
echo "$data" |grep -i 'down' |wc -l|awk '{printf "1 hour packet loss :  %2.2f %%\n",$1/21.6}';
echo "$data" |grep -Po "(?<=time=)[0-9]{2,}(?=\.)" |awk '$1>29' |wc -l|awk '{printf "Packet Latency  > 29 ms :  %2.2f %%\n",$1/21.6}';

data=$(tail -25920 ~/logs/ping-monitor.log); \
echo "$data" |grep -i 'down' |wc -l|awk '{printf "12 hour packet loss :  %2.2f %%\n",$1/259.2}';
echo "$data" |grep -Po "(?<=time=)[0-9]{2,}(?=\.)" |awk '$1>29' |wc -l|awk '{printf "Packet Latency > 29 ms :  %2.2f %%\n",$1/259.2}';

data=$(tail -51840 ~/logs/ping-monitor.log); \
echo "$data" |grep -i 'down' |wc -l|awk '{printf "24 hour packet loss :  %2.2f %%\n",$1/518.4}';
echo "$data" |grep -Po "(?<=time=)[0-9]{2,}(?=\.)" |awk '$1>29' |wc -l|awk '{printf "Packet Latency > 29 ms :  %2.2f %%\n",$1/518.4}';
