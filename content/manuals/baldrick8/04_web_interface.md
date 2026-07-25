---
title: Web interface
---

Every Baldrick8 has a web UI. This page is what the buttons and pages actually do.

### Stats Dashboard {#stats-dashboard}

#### System Information

::: figure
![Baldrick8 Web Interface Stats](baldrick8/web-interface-stats.png)
:::

The Stats board gives you a heads up as to what's going on with your controller.

<div class="spec-grid">
  <h5>Uptime</h5>
  <p>Tells you how long your controller has been powered on <em>(this is useful in June to remind you that you forgot to turn it off over christmas)</em></p>
  <h5>Frame Rate</h5>
  <p>This lets you know what the FPS (Frames Per Second) the controller is currently outputting. <strong>The Baldrick8 has been optimised to output up to 2250 channels per port (which is 750 RGB pixels at 40fps)</strong></p>
  <h5>Streaming State</h5>
  <p>Will indicate if the board is receiving data from a specific IP address and what type of data. <strong>The board will also show if two IPs are streaming to the board at the same time which is very useful for debugging those pesky problems.</strong></p>
  <h5>Network Throughput</h5>
  <p>Like the FPS, this gives you an indication of the volume of network traffic passing through the controller, this should help with debugging.</p>
  <h5>Temperature</h5>
  <p>With a sensor next to the Ethernet connector, this gives you an indication of the board temperature <em>(in Celsius because water freezes at 0, not 32.. how does that make sense?)</em><br><br>Generally, PCBs and components are good for -40 to +85°C. Anything below 60°C on this board is fine and nothing to worry about. If the temp is above that, try blowing on it like you would a hot chip out of the oven.</p>
  <h5>Firmware Version</h5>
  <p>The Baldrick8 is pretty new in the world of controllers and we've got a LOT of features left to add, this will let you know your current version and if there is a version to upgrade to.<br><br><em>(clicking the new version will upgrade it in place then restart the controller)</em></p>
  <h5>IP Address</h5>
  <p>It would be pretty silly to have a controller information box without showing you the IP Address of the controller wouldn't it? That would be like launching a controller without being able to manage the networking.</p>
</div>

### Test Mode {#test-mode}

#### Quick Testing & Troubleshooting

Test mode is one of the most important features of the Baldrick Board. If it's two hours before switch on and something is going wrong, YOU NEED CLEAR INFORMATION QUICKLY.

::: figure
![Baldrick8 Web Interface Test](baldrick8/web-interface-test.png)
:::

##### Colour Presets

We've created a bunch of presets to help you with your testing but we got bored with just writing colours so we thought we'd have some fun with the names.

::: figure
![Test Presets](baldrick8/test-presets.png)
:::

##### Brightness Control

Sometimes 100% is too much *Have you done those power calculations correctly?* so we give you the choice of brightness.

::: figure
![Brightness Control](baldrick8/test-bright.png)
:::

##### Apply to Specific Areas

Select your port (or all ports) then select if you want ALL configured pixels, 750 RGB pixels or 50 pixels.

::: figure
![Apply to Specific Areas](baldrick8/test-apply.png)
:::

### Port Configuration {#port-configuration}

#### Manual Port Setup

::: figure
![Baldrick8 Web Interface Ports](baldrick8/web-interface-ports.png)
:::

I'll be honest, the Baldrick8 is designed on the basis that 99% of the time you'll be pushing config directly from xLights to the board so you should *never* have to play with this section.

But if you do, you can drill down into each port, monitor and configure the models, the pixel count and brightness.

### Networking Configuration {#networking}

#### Good Defaults, Easy Config

::: figure
![Baldrick8 Web Interface Networking](baldrick8/web-interface-network.png)
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

### Button Configuration {#button-configuration}

#### External Input Triggers

The Baldrick comes with three inputs to attach external triggers (buttons, beam breaks, motion sensors) that can be configured when triggered to do a multitude of tasks.

::: figure
![Baldrick8 Web Interface Buttons](baldrick8/web-button-advanced-clean.png)
:::

Each input has two action states - either pressed instantly or held. When an input is in the active state, the interface will show the status by highlighting the LED.

::: figure
![Button Pressed State](baldrick8/web-button-pressed.png)
:::

##### Available Actions

<div class="spec-grid">
  <h6>FPP Integration</h6>
  <p>Control FPP (Falcon Pi Player) instances, change volume, play songs/playlists, or call FPP API directly.</p>
  <h6>Toggle Test Mode</h6>
  <p>Quickly enable any test mode at a specific brightness for quick prop testing.</p>
  <h6>BaldrickSwitchy Control</h6>
  <p>Turn on/off BaldrickSwitchy ports for specific durations (bubble machines, snow machines, etc.).</p>
  <h6>BaldrickDMX Presets</h6>
  <p>Activate preset commands on your BaldrickDMX for moving heads, effects, etc.</p>
  <h6>HTTP URL Calls</h6>
  <p>Call web APIs from simple triggers - perfect for custom integrations.</p>
  <h6>Do Nothing</h6>
  <p>Sometimes you set an input to do something and think "oh actually no, that's not what I want."</p>
</div>

##### FPP Integration Details {#fpp-integration}

FPP (or Falcon Pi Player) is our recommended show player for the holiday lighting hobby. We've two ways of using FPP which have proper names but let's call them 'Easy' (Control an FPP Instance) and 'Advanced' (Call an FPP API Directly).

::: figure
![FPP Instance Discovery](baldrick8/web-button-fpp-find.png)
:::

Both start off the same way by selecting the FPP instance that you'd like to interact with. If we can't find it automatically you can put in an IP address.

###### Control an FPP Instance

This section takes away having to use the scary API to ask FPP to do some things. For our initial version you can change the volume of FPP (either forever or for a period of seconds) or play a song / playlist / random song from a playlist.

::: figure
![FPP Instance Control](baldrick8/web-button-fpp-interface-confirm.png)
:::

###### Call an FPP API Directly

If you want to get your hands dirty with FPP commands, here it is - almost everything you can do via the API direct and configurable to be executed via a Baldrick8 input!

::: figure
![FPP API Commands](baldrick8/web-button-fpp-command.png)
:::

###### Test Mode Activation

Sometimes you just want to quickly test how the props look (or put something up when the neighbours pop round to 'see how it's going'). You can quickly enable any of our test modes at a specific brightness with the touch (or activation) of an input.

::: figure
![Test Mode Configuration](baldrick8/web-button-advanced-test-mode.png)
:::

###### HTTP URL Calls {#http-url-calls}

When we first launched the Baldrick8, we were so proud of this feature! Imagine being able to call a web API from a simple trigger!

::: figure
![HTTP URL Configuration](baldrick8/web-button-url.png)
:::

::: tip Final Result
When that's all done, you might have a little something that looks like this.
:::

::: figure
![Final Button Configuration](baldrick8/web-interface-buttons-improved.png)
:::

::: warn Note
Technically some have three states as don't forget the physical buttons on the board - these will activate the functionality AND have secret functionality.
:::
