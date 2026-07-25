---
title: Web interface
---

The web interface has been designed to be as simple as possible

### Stats Dashboard {#stats-dashboard}

#### System Information

::: figure
![BaldrickSwitchy Web Interface Stats](baldrickswitchy/web-interface-stats.png)
:::

The Stats board gives you a heads up as to what's going on with your controller.

<div class="spec-grid">
  <h5>Uptime</h5>
  <p>Tells you how long your controller has been powered on <em>(this is useful in June to remind you that you forgot to turn it off over christmas)</em></p>
  <h5>Frame Rate</h5>
  <p>This lets you know what FPS (Frames Per Second) the controller is currently outputting <em>(Why would I need this for a relay board you may ask, and we will let you keep guessing)</em></p>
  <h5>Network Throughput</h5>
  <p>Like the FPS, this gives you an indication of the volume of network traffic passing through the controller, this should help with debugging.</p>
  <h5>Temperature</h5>
  <p>With a sensor next to the Ethernet connector, this gives you an indication of the board temperature <em>(in Celsius because water freezes at 0, not 32.. how does that make sense?)</em><br><br>Generally, PCBs and components are good for -40 to +85°C. Anything below 60°C on this board is fine and nothing to worry about. If the temp is above that, try blowing on it like you would a hot chip out of the oven.</p>
  <h5>Firmware Version</h5>
  <p>Let's you know what version firmware your BaldrickSwitchy is currently running.<br><br><em>(clicking the new version will upgrade it in place then restart the controller)</em></p>
  <h5>IP Address</h5>
  <p>Tells you the current IP address of the Baldrick Switchy.</p>
</div>

### Test Mode {#test-mode}

#### Quick Testing & Troubleshooting

Test mode is one of the most important features of the Baldrick Board. If it's two hours before switch on and something is going wrong, YOU NEED CLEAR INFORMATION QUICKLY.

::: figure
![BaldrickSwitchy Web Interface Test](baldrickswitchy/web-interface-test.png)
:::

##### Presets

At the moment we only have one preset, **Alternate Relay** which alternates between on and off every second, but you can see we've made that Presets box into a dropdown as we know we'll think of some later.

##### Apply to

Select your port (or all ports) you'd like the effect applied to.

### Relay Configuration {#relay-configuration}

#### Manual Relay Setup

::: figure
![BaldrickSwitchy Web Interface Relay](baldrickswitchy/web-interface-relay.png)
:::

Whilst we expect much of the configuration to be pushed from xLights, you can directly add your devices to the BaldrickSwitchy from this section.

It's a simple interface with only a name and a trigger threshold.

### Networking Configuration {#networking}

#### Good Defaults, Easy Config

::: figure
![BaldrickSwitchy Web Interface Networking](baldrickswitchy/web-interface-network.png)
:::

<div class="spec-grid">
  <h5>Hostname</h5>
  <p>The default hostname is baldrickswitchy (hence baldrickswitchy.local). If you have one BaldrickSwitchy then it's completely fine to keep this as it is, however if like us you want to collect a few of them, then we'd recommend you change this to something like <em>frontgarden</em> or <em>upstairsroof</em><br><br><strong>(Just a reminder that hostnames should be lowercase without spaces)</strong></p>
  <h5>DHCP / STATIC</h5>
  <p>The default option is DHCP (which is Dynamic Host Configuration Protocol but you don't need to know that) which basically means your router or computer gives the board an I.P. address. This is great for initial setup but when you want to run a show it's best to switch it to STATIC, that's where your controller tells the router / computer "This is my IP".</p>
  <h5>IP Address</h5>
  <p>Set this to the IP address that you want the controller to be fixed to.</p>
  <h5>Subnet Mask &amp; Gateway</h5>
  <p>It is more than likely that you can copy the Subnet Mask (the size of your network) and the Default Gateway (the exit point of your network) from the output of an IPconfig check.</p>
  <h5>DNS Server</h5>
  <p>DNS wise, typically, your default gateway is your router IP, and that more often than not, can provide your network with DNS. However, some people like to use "outside 3rd parties" DNS like google or cloudflares DNS. If you don't know about this, its probably best just to stick to DHCP.</p>
</div>

### The Turnip Network {#turnip-network}

#### Network Discovery

::: figure
![BaldrickSwitchy Web Interface Friends](baldrickswitchy/web-interface-friends.png)
:::

The Baldrick Boards will keep an eye out on the network for other Baldricks and let you know how they are doing (this is helpful as we don't put an LCD screen on the board).

You can directly jump to their control panel from this interface and when they appear in this list, more board functionality will become available.

### Data Settings {#data-settings}

#### Protocol Configuration

::: figure
![BaldrickSwitchy Web Interface Data Settings](baldrickswitchy/web-interface-data-settings.png)
:::

<div class="spec-grid">
  <h5 id="ddp-start-channel">DDP Start Channel</h5>
  <p>Configure the starting channel for DDP (Distributed Display Protocol) communication.</p>
  <h5 id="sacn-artnet">sACN/ArtNet Start Universe</h5>
  <p>Set the starting universe for sACN (Streaming ACN) and ArtNet protocols.</p>
  <h5>sACN/ArtNet Channels Per Universe</h5>
  <p>Configure how many channels are used per universe for sACN and ArtNet protocols.</p>
</div>
