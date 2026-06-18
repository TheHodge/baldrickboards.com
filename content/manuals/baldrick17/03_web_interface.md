---
title: Web interface
---

The Baldrick17 includes a powerful web-based configuration interface that allows you to set up and control your board from any web browser. This comprehensive guide covers every aspect of the web interface.

### Stats Dashboard {#stats-dashboard}

#### System Information

::: figure
![Baldrick17 Web Interface Stats](baldrick17/web-interface-stats.png)
:::

The Stats board gives you a heads up as to what's going on with your controller.

<div class="spec-grid">
  <h5>Uptime</h5>
  <p>Tells you how long your controller has been powered on <em>(this is useful in June to remind you that you forgot to turn it off over christmas)</em></p>
  <h5>Frame Rate</h5>
  <p>This lets you know what the FPS (Frames Per Second) the controller is currently outputting <em>(The Baldrick17 has been optimised to output up to 2250 channels per port (which is 750 RGB pixels at 40fps))</em></p>
  <h5>Streaming State</h5>
  <p>Will indicate if the board is receiving data from a specific IP address and what type of data. <strong>The board will also show if two IPs are streaming to the board at the same time which is very useful for debugging those pesky problems</strong></p>
  <h5>Network Throughput</h5>
  <p>Like the FPS, this gives you an indication of the volume of network traffic passing through the controller, this should help with debugging.</p>
  <h5>Temperature</h5>
  <p>With a sensor next to the Ethernet connector, this gives you an indication of the board temperature <em>(in Celsius because water freezes at 0, not 32.. how does that make sense?)</em><br><br>Generally, PCBs and components are good for -40 to +85°C. Anything below 60°C on this board is fine and nothing to worry about. If the temp is above that, try blowing on it like you would a hot chip out of the oven.</p>
  <h5>Firmware Version</h5>
  <p>We regularly release new firmware updates with features (and sometimes people break our boards and we have to fix it)<br><br><em>(clicking the new version will upgrade it in place then restart the controller)</em></p>
  <h5>IP Address</h5>
  <p>It would be pretty silly to have a controller information box without showing you the IP Address of the controller wouldn't it? That would be like launching a controller without being able to manage the networking.</p>
</div>

### Test Mode {#test-mode}

#### Quick Testing & Troubleshooting

Test mode is one of the most important features of the Baldrick Board, if it's two hours before switch on and something is going wrong, YOU NEED CLEAR INFORMATION QUICKLY.

::: figure
![Baldrick17 Web Interface Test](baldrick17/web-interface-test.png)
:::

##### Colour Presets

We've created a bunch of presets to help you with your testing but we got bored with just writing colours so we thought we'd have some fun with the names. You might want to have a look at something special we've introduced called [Hodgical Mode](/breakthroughs/hodgical-test-mode)

::: figure
![Test Presets](baldrick17/test-presets.png)
:::

##### Brightness

Sometimes 100% is too much *Have you done those power calculations correctly?* so we give you the choice of brightness.

::: figure
![Brightness Control](baldrick17/test-bright.png)
:::

##### Apply to

Select your port (or all ports) then select if you want ALL configured pixels, 750 RGB pixels or 50 pixels.

::: figure
![Apply to Specific Areas](baldrick17/test-apply.png)
:::

##### Immature Humour

Some of our vendors think their customers are a bit sensitive so have asked us to put the fun stuff behind an option. If you go to [Advanced Settings](#advanced-settings) you can *Enable Immature Humour*

### CunningFX {#cunningfx}

#### Visual Effects Generator

::: figure
![Baldrick17 Web Interface CunningFX](baldrick17/cunningfx.png)
:::

With more and more of our community putting pixels on their house all year round or producing lightart, we've produced CunningFX for you to add pretty stuff to your show without a show player.

A video for this is coming soon.

### Port Configuration {#port-configuration}

#### Manual Port Setup

::: figure
![Baldrick17 Web Interface Ports](baldrick17/web-interface-ports.jpeg)
:::

Let's be honest, most of the time you are going to be using xLights to play with your ports but if you want to be a strong independent person, you can drill down into each port, monitor and configure the models, the pixel count and brightness.

### Networking Configuration {#networking}

#### Good Defaults, Easy Config

::: figure
![Baldrick17 Web Interface Networking](baldrick17/web-interface-network.png)
:::

<div class="spec-grid">
  <h5>Hostname</h5>
  <p>The default hostname is baldrickboard (hence baldrickboard.local). If you have one Baldrick17 then it's completely fine to keep this as it is, however if like us you want to collect a few of them, then we'd recommend you change this to something like <em>frontgarden</em> or <em>upstairsroof</em><br><br><strong>(Just a reminder that hostnames should be lowercase without spaces)</strong></p>
  <h5>DHCP / STATIC</h5>
  <p>The default option is DHCP (which is Dynamic Host Configuration Protocol but you don't need to know that) which basically means your router or computer gives the board an I.P. address. This is great for initial setup but when you want to run a show it's best to switch it to STATIC, that's where your controller tells the router / computer "This is my IP".</p>
  <h5>IP Address</h5>
  <p>Set this to the IP address that you want the controller to be fixed to.</p>
  <h5>Subnet Mask & Gateway</h5>
  <p>It is more than likely that you can copy the Subnet Mask (the size of your network) and the Default Gateway (the exit point of your network) from the output of an IPconfig check.</p>
  <h5>DNS Server</h5>
  <p>DNS wise, typically, your default gateway is your router IP, and that more often than not, can provide your network with DNS. However, some people like to use "outside 3rd parties" DNS like google or cloudflares DNS. If you don't know about this, its probably best just to stick to DHCP.</p>
</div>

### The Turnip Network {#turnip-network}

#### Network Discovery

::: figure
![Baldrick17 Web Interface Friends](baldrick17/web-interface-friends.png)
:::

The Baldrick17 will keep an eye out on the network for other Baldricks and let you know how they are doing (this is helpful as we don't put an LCD screen on the board).

##### Test Sync

Ticking this box will sync the test mode between all compatible boards, meaning if you are doing something on the house and want all your baldricks in Test Mode, it's very easy to do!

### Data Settings {#data-settings}

#### Protocol Configuration

::: figure
![Baldrick17 Web Interface Data Settings](baldrick17/web-interface-data-settings.png)
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
![Baldrick17 Web Interface Advanced](baldrick17/web-interface-advanced.png)
:::

We avoided it for so long but it's finally time to have a "box to stick stuff that doesn't fit in the other categories" and here it is, Advanced Settings.

##### Receive Beta Software Releases

Sometimes features need a bit more testing before we are ready to push them out to the wider world, if you like living on the edge (or just like being nosey).

##### Enable Immature Humour

Some of our vendors love the board but do NOT appreciate our humour and so asked to remove the childish brightness names and test modes. This setting lets those customers WHO BELIEVE IN FREEDOM turn them back on.

### Turniputs (Inputs) {#inputs}

#### External Input Triggers

The Baldrick17 comes with three [turninputs](/breakthroughs/turniput) to attach external triggers (buttons, beam breaks, motion sensors) that can be configured when triggered to do a multitude of tasks.

::: figure
![Baldrick17 Web Interface Buttons](baldrick17/web-button-advanced-clean.png)
:::

Each input has two action states - either pressed instantly or held. When an input is in the active state, the interface will show the status by highlighting the LED.

::: figure
![Button Pressed State](baldrick17/web-button-pressed.png)
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

##### FPP Integration Details

FPP (or Falcon Pi Player) is our recommended show player for the holiday lighting hobby. It has some really powerful functionality and is simple to setup and use, that power also extends to its API which allows people to do some really cool stuff. But we don't think you should have to learn the API to do that cool stuff.

We've two ways of using FPP which have proper names but let's call them 'Easy' (Control an FPP Instance) and 'Advanced' (Call an FPP API Directly).

::: figure
![FPP Instance Discovery](baldrick17/web-button-fpp-find.png)
:::

Both start off the same way by selecting the FPP instance that you'd like to interact with. If we can't find it automatically you can put in an IP address (although it might be worth finding out why we can't find it as it will be pretty hard to send commands to something we cannot find).

###### Control an FPP Instance

This section takes away having to use the scary API to ask FPP to do some things. For our initial version you can change the volume of FPP (either forever or for a period of seconds) or play a song / playlist / random song from a playlist.

Sorry did I say or I meant AND. You can do both of these, with one input and we will even pull in live your sequences and playlists direct from FPP.

::: figure
![FPP Instance Control](baldrick17/web-button-fpp-interface-confirm.png)
:::

###### Call an FPP API Directly

If you want to get your hands dirty with FPP commands, here it is - almost everything you can do via the API direct and configurable to be executed via a Baldrick17 input!

::: figure
![FPP API Commands](baldrick17/web-button-fpp-command.png)
:::

###### Test Mode Activation

Sometimes you just want to quickly test how the props look (or put something up when the neighbors pop round to 'see how it's going'). You can quickly enable any of our test modes at a specific brightness with the touch (or activation) of an input.

::: figure
![Test Mode Configuration](baldrick17/web-button-advanced-test-mode.png)
:::

###### BaldrickSwitchy Control

Have you heard about BaldrickSwitchy? Do you want to turn on your bubble machine, snow machine, AC lights or anything else via xLights or a Baldrick Button?

From this section you can turn on (or off) a BaldrickSwitchy port for x number of seconds.

Much like FPP, we will automatically detect the board and whilst I'd love to have the screenshot of it here, at the time of writing this documentation my BaldrickSwitchy is in another building and it's far too hot to move from the sofa, did you know Britain is having a bit of a heatwave right now?

###### BaldrickDMX Preset Activation

This function will activate a preset command on your BaldrickDMX, perfect for activating a snow machine, bubble machine or pointing a moving head at one specific spot.

###### HTTP URL Calls

When we first launched the Baldrick17, we were so proud of this feature! Imagine being able to call a web API from a simple trigger! We even wrote a
