---
sidebar_position: 3
---

# How to find your network IP information
Sometimes you need to find your network information or the IP address of your computer, for this we can use IP/IF Config on most operating systems

## Windows

Go to command prompt and type "ipconfig"

## Mac

Go to terminal and type "ifconfig"

## Linux

- Open a terminal emulator window.
- Type the following command to access the Network Namespace subsystem: *sudo ip netns*
- You'll see a list of network namespaces. Choose one arbitrarily (let's say ns1).
- Enter the chosen namespace: *sudo ip netns exec ns1 bash*
- In the new shell, run the following command to list all network interfaces: *ip addr show*
- Find the interface you're interested in. Note its name (e.g., eth0).
- Use tcpdump to monitor traffic on that interface:
- sudo tcpdump -i eth0
- Now, you'll see a stream of network packets. Look for IP addresses in the packets. This might require some parsing if the output is extensive.
- When you find an IP address of interest, you can stop tcpdump by pressing Ctrl + C.
