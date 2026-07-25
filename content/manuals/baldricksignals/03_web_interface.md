---
title: Web interface
---

The web interface has been designed to be as simple as possible

### Stats Dashboard {#stats-dashboard}

#### System Information

::: figure
![BaldrickSignals Web Interface Stats](baldricksignals/web-interface-stats.png)
:::

The Stats board gives you a heads up as to what's going on with your controller.

<div class="spec-grid">
  <h5>Uptime</h5>
  <p>Tells you how long your controller has been powered on <em>(this is useful in June to remind you that you forgot to turn it off over christmas)</em></p>
  <h5>Temperature</h5>
  <p>With a sensor next to the Ethernet connector, this gives you an indication of the board temperature <em>(in Celsius because water freezes at 0, not 32.. how does that make sense?)</em><br><br>Generally, PCBs and components are good for -40 to +85°C. Anything below 60°C on this board is fine and nothing to worry about. If the temp is above that, try blowing on it like you would a hot chip out of the oven.</p>
  <h5>Firmware Version</h5>
  <p>This will let you know your current version and if there is a version to upgrade to.<br><br><em>(clicking the new version will upgrade it in place then restart the controller)</em></p>
  <h5>IP Address</h5>
  <p>It would be pretty silly to have a controller information box without showing you the IP Address of the controller wouldn't it? That would be like launching a controller without being able to manage the networking.</p>
</div>

### Crowd Monitoring {#crowd-monitoring}

#### Crowd Detection

::: figure
![BaldrickCrowd Web Interface Crowd](baldricksignals/web-interface-crowd.png)
:::

Now we get to the good stuff. Every 30 seconds we will poll the universe (or at least as far as the [antenna](/faq#antennas) will detect).

### Network Configuration {#network-configuration}

#### Good Defaults, Easy Config

::: figure
![BaldrickSignals Web Interface Network](baldricksignals/web-interface-network.png)
:::

<div class="spec-grid">
  <h5>Hostname</h5>
  <p>The default hostname is baldrickboard (hence baldrickboard.local). If you have one Baldrick8 then it's completely fine to keep this as it is, however if like us you want to collect a few of them, then we'd recommend you change this to something like <em>frontgarden</em> or <em>upstairsroof</em><br><br><strong>(Just a reminder that hostnames should be lowercase without spaces)</strong></p>
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
![BaldrickSignals Web Interface Friends](baldricksignals/web-interface-turnip.png)
:::

The Baldrick Boards will keep an eye out on the network for other Baldricks and let you know how they are doing (this is helpful as we don't put an LCD screen on the board).

You can directly jump to their control panel from this interface and when they appear in this list, more board functionality will become available.

### Advanced Settings {#advanced-settings}

#### Advanced Configuration Options

<div class="spec-grid">
  <h5 id="beta-updates">Enable Beta Updates</h5>
  <p>Sometimes we put updates out that aren't quite ready for prime time (or in the case of a Seasonal Freeze, it's an update which isn't critical).</p>
  <h5 id="device-offset">Permanent Device Offset</h5>
  <p>At this current state of development and to comply with all data protection and GDPR laws, Signals gives you a static number of the devices detected. In many cases there will be devices detected which are present all the time (such as your phone). You can offset this by putting a number in this box (the number will never go below zero!).</p>
  <h5 id="crowd-multiplier">Crowd Multiplier</h5>
  <p>Depending on your audience type, you might find that your audience isn't quite representative of the number of mobile devices detected (if you have a lot of young children visiting with parents you might find it vastly under counts). You can offset this by putting a multiplier in this box (the base number minus the offset will be multiplied by this amount).</p>
</div>
