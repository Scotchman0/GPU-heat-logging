#!/bin/bash
#capture heat information script for troublesome GPU systems. 
#Will Russell - 11/18/2020
#published on Github - feel free to use/repurpose/share/fork.
#Supported Operating systems: Ubuntu 18.04LTS, 20.04LTS


#Logfile 1: NVIDIA Temp only (with identifier)
#queries nvidia-smi command, asks for which GPU is running, identifies it, and tags out
#a timestamp (TS) and the temperature in the order (index, name, temperature) and tees the result
#for live view + logging
RED_TEXT=$(printf "\033[31m")

NVIDIA_LOOP_QUIET() {
nvidia-smi --query-gpu=index,name,temperature.gpu --format=csv,noheader | ts >> ~/Desktop/GPU_HEAT.log
echo "_________________________" >> ~/Desktop/GPU_HEAT.log
}

NVIDIA_LOOP_LIVE() {
nvidia-smi --query-gpu=index,name,temperature.gpu --format=csv,noheader | ts | tee -a >> ~/Desktop/GPU_HEAT.log
echo "_________________________"
echo "_________________________" >> ~/Desktop/GPU_HEAT.log
}

#logfile 2: sensors (all) with timestamp:
SENSORS_LOOP_QUIET() {
sensors | grep -A 0 '+' | cut -c15-20 | ts >> ~/Desktop/CPU_HEAT.log
echo "_________________________" >> ~/Desktop/CPU_HEAT.log
}

SENSORS_LOOP_LIVE() {
sensors | grep -A 0 '+' | cut -c15-20 | ts | tee -a ~/Desktop/CPU_HEAT.log
echo "_________________________"
echo "_________________________" >> ~/Desktop/CPU_HEAT.log
}

timestamp_check() {

#ensure timestamp is attached:
if which ts | grep "/"
then echo "timestamps available"
else echo "time stamping not installed, please run: 'sudo apt install moreutils' before running script" && exit_early
fi
}

lm-sensors_check() {
	if which sensors | grep "/"
		then echo "sensors available"
		else echo "lm-sensors not installed, please run: 'sudo apt install lm-sensors' before running script" && exit_early
}

exit_early() {
	exit 0
}

#define user + set ownership:
whoami=USER

#create files:
touch ~/Desktop/CPU_HEAT.log
touch ~/Desktop/GPU_HEAT.log

chown $USER ~/Desktop/CPU_HEAT.log
chown $USER ~/Desktop/GPU_HEAT.log

timestamp_check

echo "Quick and Dirty heat logging system for troubleshooting only"
echo "this script is going to generate a fairly lengthy set of logs, so don't run it indefinitely"
sleep 1
echo ""
echo "insert number in seconds for length of time between log writes (1-5 seconds recommended)"
read LOGINTERVAL

echo "you've selected '$LOGINTERVAL' seconds between each grep command"
sleep 2
echo ""
echo "select number of lines you want to capture (1-99999)"
read LOGTIME
echo "you've selected $LOGTIME seconds to run"
echo "you can always ctrl + c to cancel out and review logs early"
sleep 1
echo ""
echo "would you like to see the output here or just write to file and see passes only?"
read -p "(y) for view live, (n) for quiet logging with counter  (y/n)?" choice

case "$choice" in 
  y|Y ) 
for ((i = 0 ; i <=$LOGTIME ; i++));
do
NVIDIA_LOOP_LIVE
SENSORS_LOOP_LIVE
echo "check $i completed"
sleep $LOGINTERVAL
done
		;;
  n|N ) 
for ((i = 0 ; i <=$LOGTIME ; i++));
do
NVIDIA_LOOP_QUIET
SENSORS_LOOP_QUIET
echo "check $i completed"
sleep $LOGINTERVAL
done
		;;
esac

echo "completed - please review ~/Desktop/CPU_HEAT.log and ~/Desktop/GPU_HEAT.log"
exit 0
