# ping-monitor-analyser

Two shell scripts contrived to run on OSX, one to ping monitor domains, and the second to analyse packet loss and latency

## Background

The first script  `./ping-monitor.sh` currently monitors 3 arbitrary domain names. The ping command waits for one response per domain else timeout after 1 second. In order to keep the number of entries in the log file consistent a 5 second internal to complete each run has been set, combined with the ping timeout. Therefore no run will go over the 5 second period, else inconsistencies will occur. In turn this will result in unreliable stats from the second script `./packet-loss-analyser.sh`, for packet loss and latency.

## Usage

Run the ping monitoring script as a background process.

```
./ping-monitor.sh abc.co.uk abd.ie abe.de &"
```

View logs generated via.

```
tail -f 100 ~/logs/ping-monitor.log
```

Now analyse the logs.

```
./packet-loss-analyser.sh
```

This will produce an output similar to.

```
2019-11-06:15:16:41
1 hour packet loss :  0.74 %
Packet Latency  > 29 ms :  9.35 %
12 hour packet loss :  0.26 %
Packet Latency > 29 ms :  3.48 %
24 hour packet loss :  0.13 %
Packet Latency > 29 ms :  1.74 %
```

## Analysis Algorithm

### Packet Loss

Number of log entries per hour
    - entries per run x (seconds per minute / wait time) x minutes per hour

Number of log entries per hour
    - 3 x (60 / 5) x 60 = 2160

1 hour packet loss equation
    - (loss/2160 x 100/1) = (loss/21.6)

12 hour packet loss equation
    - (loss/25920 x 100/1) = (loss/259.2)

24 hour packet loss equation
    - (loss/51840 x 100/1) = (loss/518.4)

### Latency

If ping time is greater than 29 ms, then report latency
