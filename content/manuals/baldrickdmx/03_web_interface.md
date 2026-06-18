---
title: Web interface
---

The BaldrickDMX includes a powerful web-based configuration interface that allows you to set up and control your board from any web browser. This comprehensive guide covers every aspect of the web interface.

### Stats Dashboard {#stats-dashboard}

#### System Information

::: figure
![BaldrickDMX Web Interface Stats](baldrickdmx/web-interface-stats.png)
:::

The Stats board gives you a heads up as to what's going on with your controller.

<div class="spec-grid">
  <h5>Uptime</h5>
  <p>Tells you how long your controller has been powered on <em>(this is useful in June to remind you that you forgot to turn it off over christmas)</em></p>
  <h5>Frame Rate</h5>
  <p>This lets you know what the FPS (Frames Per Second) the controller is currently outputting.</p>
  <h5>Network Throughput</h5>
  <p>Like the FPS, this gives you an indication of the volume of network traffic passing through the controller, this should help with debugging.</p>
  <h5>Temperature</h5>
  <p>With a sensor next to the Ethernet connector, this gives you an indication of the board temperature <em>(in Celsius because water freezes at 0, not 32.. how does that make sense?)</em><br><br>Generally, PCBs and components are good for -40 to +85°C. Anything below 60°C on this board is fine and nothing to worry about. If the temp is above that, try blowing on it like you would a hot chip out of the oven.</p>
  <h5>Firmware Version</h5>
  <p>The BaldrickDMX is pretty new in the world of controllers and we've got a LOT of features left to add, this will let you know your current version and if there is a version to upgrade to.<br><br><em>(clicking the new version will upgrade it in place then restart the controller)</em></p>
  <h5>IP Address</h5>
  <p>It would be pretty silly to have a controller information box without showing you the IP Address of the controller wouldn't it? That would be like launching a controller without being able to manage the networking.</p>
</div>

### Test Mode {#test-mode}

#### Quick Testing & Troubleshooting

Test Mode allows you to, well, test the board.

::: figure
![BaldrickDMX Web Interface Test](baldrickdmx/web-interface-test.png)
:::

##### Test Patterns

<div class="spec-grid">
  <h6>Alternate Channels</h6>
  <p>Alternates between channels for testing individual DMX outputs.</p>
  <h6>Slow Sine Wave</h6>
  <p>All channels start at zero, go to 255, and back to zero in a slow sine wave pattern.</p>
  <h6>Fast Sine Wave</h6>
  <p>Same as slow sine wave but at a faster speed for more dynamic testing.</p>
  <h6>Sine Ripple</h6>
  <p>Creates a sine wave that moves across channels over time, each channel moving between 0 and 255.</p>
  <h6>DMX Preset</h6>
  <p>Allows you to select a DMX preset that you've created as a test mode.</p>
</div>

### Networking Configuration {#networking}

#### Good Defaults, Easy Config

::: figure
![BaldrickDMX Web Interface Networking](baldrickdmx/web-interface-network.png)
:::

<div class="spec-grid">
  <h5>Hostname</h5>
  <p>The default hostname is baldrickdmx (hence baldrickdmx.local). If you have one BaldrickDMX then it's completely fine to keep this as it is, however if like us you want to collect a few of them, then we'd recommend you change this to something like <em>frontgarden</em> or <em>upstairsroof</em><br><br><strong>(Just a reminder that hostnames should be lowercase without spaces)</strong></p>
  <h5>DHCP / STATIC</h5>
  <p>The default option is DHCP (which is Dynamic Host Configuration Protocol but you don't need to know that) which basically means your router or computer gives the board an I.P. address. This is great for initial setup but when you want to run a show it's best to switch it to STATIC, that's where your controller tells the router / computer "This is my IP".</p>
  <h5>IP Address</h5>
  <p>Set this to the IP address that you want the controller to be fixed to.</p>
  <h5>Subnet Mask & Gateway</h5>
  <p>It is more than likely that you can copy the Subnet Mask (the size of your network) and the Default Gateway (the exit point of your network) from the output of an IPconfig check.</p>
  <h5>DNS Server</h5>
  <p>DNS wise, typically, your default gateway is your router IP, and that more often than not, can provide your network with DNS. However, some people like to use "outside 3rd parties" DNS like google or cloudflares DNS. If you don't know about this, its probably best just to stick to DHCP.</p>
</div>

### DMX Presets {#presets}

#### Preset Management

::: figure
![BaldrickDMX Presets](baldrickdmx/dmx-presets.png)
:::

The BaldrickDMX lets you define Presets of set channels and values that can be used either in a test mode or via an action over the [Turnip Network](/breakthroughs/turnip-network).

##### Adding a Preset

::: figure
![Add a BaldrickDMX Preset](baldrickdmx/dmx-preset-add.png)
:::

When you add a preset, you are asked for the channels and a value, you can add as many channels and values as you like.

The channels input takes comma separated values such as *11,16,19,21* but also can take ranges such as *100-150* this will include all the numbers between 100 and 150 (including 100 and 150).

##### Mark Mode

Coming soon...

### The Turnip Network {#turnip-network}

#### Network Discovery

::: figure
![BaldrickDMX Web Interface Friends](baldrickdmx/web-interface-friends.png)
:::

The BaldrickDMX will keep an eye out on the network for other Baldricks and let you know how they are doing (this is helpful as we don't put an LCD screen on the board).

##### Test Sync

Ticking this box will sync the test mode between all compatible boards, meaning if you are doing something on the house and want all your baldricks in Test Mode, it's very easy to do!

### Data Settings {#data-settings}

#### Protocol Configuration

::: figure
![BaldrickDMX Web Interface Data Settings](baldrickdmx/web-interface-data-settings.png)
:::

<div class="spec-grid">
  <h5>DDP Start Channel</h5>
  <p>Configure the starting channel for DDP (Distributed Display Protocol) communication.</p>
  <h5>sACN/ArtNet Start Universe</h5>
  <p>Set the starting universe for sACN (Streaming ACN) and ArtNet protocols.</p>
  <h5>sACN/ArtNet Channels Per Universe</h5>
  <p>Configure how many channels are used per universe for sACN and ArtNet protocols.</p>
</div>

### Advanced Settings {#advanced-settings}

#### Advanced Configuration Options

::: figure
![BaldrickDMX Web Interface Advanced](baldrickdmx/web-interface-advanced.png)
:::

We avoided it for so long but it's finally time to have a "box to stick stuff that doesn't fit in the other categories" and here it is, Advanced Settings.

##### Launch Preset at Boot

This allows you to select a preset to be loaded by default when the board is loaded, if a signal is detected from the network then this preset is overridden.
