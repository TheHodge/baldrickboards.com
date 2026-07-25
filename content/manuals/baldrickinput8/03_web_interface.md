---
title: Web interface
---

The BaldrickInput8 includes a powerful web-based configuration interface that allows you to set up and control your board from any web browser. This comprehensive guide covers every aspect of the web interface.

### Stats Dashboard {#stats-dashboard}

#### System Information

::: figure
![BaldrickInput8 Web Interface Stats](baldrickinput8/web-interface-stats.png)
:::

The Stats board gives you a heads up as to what's going on with your controller.

<div>
<div class="spec-grid">
    <h5>Uptime</h5>
    <p>Tells you how long your controller has been powered on <em>(this is useful in June to remind you that you forgot to turn it off over christmas)</em></p>
    <h5>Temperature</h5>
    <p>With a sensor next to the Ethernet connector, this gives you an indication of the board temperature <em>(in Celsius because water freezes at 0, not 32.. how does that make sense?)</em><br><br>Generally, PCBs and components are good for -40 to +85°C. Anything below 60°C on this board is fine and nothing to worry about. If the temp is above that, try blowing on it like you would a hot chip out of the oven.</p>
    <h5>Firmware Version</h5>
    <p>The BaldrickInput8 is pretty new in the world of controllers and we've got a LOT of features left to add, this will let you know your current version and if there is a version to upgrade to.<br><br><em>(clicking the new version will upgrade it in place then restart the controller)</em></p>
    <h5>IP Address</h5>
    <p>It would be pretty silly to have a controller information box without showing you the IP Address of the controller wouldn't it? That would be like launching a controller without being able to manage the networking.</p>
</div>
</div>

### Turniput Configuration {#turniput-configuration}

#### External Input Triggers

::: figure
![BaldrickInput8 Turniput Configuration](baldrickinput8/web-interface-turnip-config.png)
:::

The BaldrickInput8 comes with eight Turniput ports to attach external triggers (buttons, beam breaks, motion sensors) that can be configured when triggered to do a multitude of tasks.

##### Available Actions

<div>
<div class="spec-grid">
      <h6 id="fpp-integration">FPP Integration</h6>
      <p>Control FPP (Falcon Pi Player) instances, change volume, play songs/playlists, or call FPP API directly.</p>
      <h6>Toggle Test Mode</h6>
      <p>Quickly enable any test mode at a specific brightness for quick prop testing.</p>
      <h6>BaldrickSwitchy Control</h6>
      <p>Turn on/off BaldrickSwitchy ports for specific durations (bubble machines, snow machines, etc.).</p>
      <h6>BaldrickDMX Presets</h6>
      <p>Activate preset commands on your BaldrickDMX for moving heads, effects, etc.</p>
      <h6 id="http-url-calls">HTTP URL Calls</h6>
      <p>Call web APIs from simple triggers - perfect for custom integrations.</p>
      <h6>Do Nothing</h6>
      <p>Sometimes you set an input to do something and think "oh actually no, that's not what I want."</p>
</div>
</div>

::: warn Note
The main difference between this and the Button input on the Baldrick8 is the addition of Lamp controls.
:::

### Networking Configuration {#networking}

#### Good Defaults, Easy Config

::: figure
![BaldrickInput8 Web Interface Networking](baldrickinput8/web-interface-networking.png)
:::

<div>
<div class="callout warn">
  <svg class="ci" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 9v4m0 4h.01M10.3 3.6 2.6 17a2 2 0 0 0 1.7 3h15.4a2 2 0 0 0 1.7-3L13.7 3.6a2 2 0 0 0-3.4 0z"/></svg>
  <div>
    <b>Note</b> WiFi on the Input8 is currently in testing and will be released soon.
    <h5>Hostname</h5>
    <p>The default hostname is baldrickboard (hence baldrickboard.local). If you have one BaldrickInput8 then it's completely fine to keep this as it is, however if like us you want to collect a few of them, then we'd recommend you change this to something like <em>frontgarden</em> or <em>upstairsroof</em><br><br><strong>(Just a reminder that hostnames should be lowercase without spaces)</strong></p>
    <h5>DHCP / STATIC</h5>
    <p>The default option is DHCP (which is Dynamic Host Configuration Protocol but you don't need to know that) which basically means your router or computer gives the board an I.P. address. This is great for initial setup but when you want to run a show it's best to switch it to STATIC, that's where your controller tells the router / computer "This is my IP".</p>
    <h5>IP Address</h5>
    <p>Set this to the IP address that you want the controller to be fixed to.</p>
    <h5>Subnet Mask &amp; Gateway</h5>
    <p>It is more than likely that you can copy the Subnet Mask (the size of your network) and the Default Gateway (the exit point of your network) from the output of an IPconfig check.</p>
    <h5>DNS Server</h5>
    <p>DNS wise, typically, your default gateway is your router IP, and that more often than not, can provide your network with DNS. However, some people like to use "outside 3rd parties" DNS like google or cloudflares DNS. If you don't know about this, its probably best just to stick to DHCP.</p>
  </div>
</div>
</div>

### Turnip Network {#turnip-network}

#### The Turnip Network

::: figure
![BaldrickInput8 Turnip Network](baldrickinput8/web-interface-turnip-network.png)
:::

The Baldrick family of boards have developed with *ease of use* as one of the core principles, this lead the creation of 'The Turnip Network'.

The BaldrickBoards will find each other on the network, allowing you to easily switch between them when doing configuration.

Test Sync allows you to enable test mode on one Baldrick board and all the others in that series will follow (so when you turn Hodgical Test Mode on one Baldrick8, it will turn on the rest of them).

Some of the Baldrick boards have buttons (or Turniputs) and these allow integration with not only all the other boards in the family, but also FPP and web hooks!

::: note It's what those people in business suits call 'synergy'!
:::

### Advanced Settings {#advanced-settings}

#### Advanced Configuration Options

Advanced settings provide additional configuration options for power users and complex installations.

##### Coming Soon

Advanced settings documentation will be added as new features are developed and released.
