# GPU-heat-logging
Quick and dirty script to grep nvidia-SMI temps, and CPU temps, write them to log every X seconds for troubleshooting purposes\

# supported systems: 
Ubuntu 18.04LTS+, with NVIDIA gpu(s) installed
- requires: lm-sensors and moreutils installed to run properly (will prompt you to install them if you start without them)

# How to use:
1. clone this repository with sudo git clone https://scotchman0/GPU-heat-logging or copy the contents of the gpu-heat-log.sh into a new script file on your endpoint

2. make the script executable with chmod +x gpu-heat-logging.sh

3. run the script via terminal with: 
> ./gpu-heat-logging.sh

4. select interval length (sets sleep command between greps) - 1-5 seconds is recommended

5. select how many log lines you want to pull: 1-9999999 (*you can always press ctrl+c to cancel the script and exit at any time to review the logs)

6. choose whether or not you'd like to view the output as it writes to log, or if you'd just like a counter indicating how many passes have been written to file to keep in the corner while you try and recreate your problem

7. Review the files: ~/Desktop/CPU_HEAT.log and ~/Desktop/GPU_HEAT.log for output


# Why do I need this script?
You might not, but I was having a hard time figuring out if my GPU's were crashing out because of an overheat, and I wanted to be able to write to file the internal temps while I started to stress the systems. It's not a stress test, all it does is log out what the recorded temperatures are for your cores and your GPUs and timestamp it. You can spin up a job and if you can more or less point to in the log "oh weird my GPU spiked above 100C right before it turned off" you might can solve your problem. 
