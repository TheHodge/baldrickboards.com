---
title: Getting started
---

Got a Baldrick8. Here's how to power it, flash it, wire pixels, and talk to xLights.

::: warn Warning
Unplug the power supply before you change any wiring. Check it twice before you switch on.
:::

### Step 1: Plugging in Your Controller {#step-1-plugging-in-your-controller}

#### Always Use a Power Supply

::: warn WARNING
Never, ever EVER EVER plug your controller directly into the wall outlet, it will go bang and you'll have to buy another one and explain to your partner what that burn mark on the kitchen table is.
:::

You'll notice that a British plug has three wires and our power jack inputs only have two - that's because you need to put a power supply in between them.

We recommend the use of [Meanwell Power Supplies](https://buildalightshow.com/search?controller=search&s=meanwell).

##### The Power Supply Explained

::: figure
![Meanwell Power Supply Diagram](baldrick8/meanwell-explained.png)

1. **Live** - The live wire carries electricity from the power source to appliances or circuits, supplying the energy needed for operation. On a British plug this is generally BROWN.
2. **Neutral** - This carries the electricity back to the power source. On a British plug this is generally BLUE.
3. **Earth** - This grounds electrical systems, redirecting excess current safely into the ground to prevent shocks and fires. On a British plug this is generally GREEN / YELLOW.
4. **+V** - The positive voltage output of the power supply, typically you'd attach a RED cable to this.
5. **-V** - The negative voltage output of a power supply, typically you'd attach a BLACK cable to this.
:::

##### Powering the Board

::: figure
![Baldrick Power Ports](baldrick8/board-power.png)

- Port 1 will power pixel ports 1 - 4
- Port 2 will power pixel ports 5 - 8
- Either port will automatically power the board, you do not need to configure this
- Both ports will handle between 5v to 24v and can be different voltages
:::

::: warn Important
As with all power connectors, please check for stray strands BEFORE turning on your controller, those aren't the flashing lights we want to create.
:::

##### What Cable Do I Use?

The thicker the cable the better (within limits), DO NOT use the wire your wall plug came with to link your power supply to your controller.

It is almost certainly not thick enough to handle the amps.

We recommend [10AWG cable wire](https://amzn.to/3uOmTz6) at a minimum but please do further research for your requirements.

### Step 2: Installing the Firmware {#step-2-installing-the-firmware}

#### Initial Firmware Setup

When your controller arrives it will be in a 'sleeping state' - you just need to plug it into your network and head to [http://baldrickboard.local](http://baldrickboard.local) (if your DNS doesn't accept that then just look for it on your network).

::: figure
![First Firmware Screen](baldrick8/first-firmware.png)
:::

##### How to Install

To put it simply, press the button that says *Lets Go* then go and have a brew, the controller will connect to our server, download the latest firmware and automatically install it, once it's done the page will refresh and you can start connecting pixels.

::: note Tip
You must plug the board directly into your network for the initial firmware download (or make sure your computer can give it an IP address and internet access).
:::

##### How Do I Update After That?

When you go to the Web interface and look at the stats section, you'll see the version number, if there is a new version, you can click that and it will automatically update in a similar interface to how this initial install works.

### Step 3: Connecting Pixels {#step-3-connecting-pixels}

#### It's Time to Connect the Lights

##### To Pigtail or Not to Pigtail

We recommend adding [pigtails](https://buildalightshow.com/accessories-hardware/113-weatherproof-pigtails.html) to your controller rather than pixels directly.

Your controller will come with 3 port Phoenix connectors.

::: figure
![Phoenix Connector](baldrick8/phoenix-connector.png)
:::

##### The Phoenix Connector Explained

1. **GROUND** - The negative wire of your pixels (this is BLACK)
2. **DATA** - The data in wire of your pixels (this is YELLOW)
3. **LIVE** - The positive wire of your pixels (this is RED)

::: warn Note
The colour suggestions are for BALS pixels, if you are buying from somebody else... then ask them.
:::

### Step 4: xLights Connection {#step-4-xlights-connection}

#### Connecting with xLights

You can connect directly with xLights, look for Baldrick Controller under ilightthat.

::: figure
![xLights Download and Push](baldrick8/xlights-settings.png)
:::

From here you can push your model settings directly to the controller and output to lights nice and easily!

You can either:

- Click **Discover** and xLights will automagically find the Baldrick8.
- Add the board manually by selecting *ILightThat* as a vendor and *Baldrick 8 Port v1* as the Model. You will then need to put the IP Address in manually.
