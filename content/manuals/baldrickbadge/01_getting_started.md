---
title: Getting started
---

### Step 1: Badge Setup {#step-1-badge-setup}

#### Wireless Network Setup

When your badge is plugged into a power supply, it will create a wireless network which starts with `baldrickbadge-` followed by an alphanumeric code on the back of it which matches the one on the sticker on the back of your badge.

::: note Event Tip
hotplates For events, we would recommend you do not join the WiFi network as that would give everyone else access to your badge... and we wouldn't want people putting rude messages on them would we?
:::

### Step 2: Using the Matrix {#step-2-using-the-matrix}

#### Matrix Display Mode

You can use your badge as a matrix display. As I'm writing this I cannot remember how to do it but I know it works...

The onboard matrix is 95 x 5 pixels.

### Step 3: Syncing Multiple Badges {#step-3-syncing-multiple-badges}

#### ESP-NOW Synchronization

WLED has the ability to use ESP-NOW to synchronize the badge effects between them.

If you'd have bought the badges we would have done a really detailed instruction on how to set this up but you didn't so we didn't.

Figure it out, it will be great!

### Step 4: xLights Connection {#step-4-xlights-connection}

#### Connecting with xLights

You can connect the badge to xLights and use it as a controller. xLights discover won't work, but if you get the IP address of it, you can use the following settings.

::: figure
![xLights Baldrick Badge Configuration](baldrickbadge/xlights.png)
:::

##### Port Configuration

- **Port 1** - Should be the onboard pixels
- **Port 2** - Should be the one built in
- **Ports 3, 4 and 5** - Should be the additional ones if you have the upgrade kit

### Step 5: Button Configuration {#step-5-button-configuration}

#### Onboard Buttons

We've added two buttons to the board for you to use. We've not quite worked out how to program them in the interface, but these are the default responses.

<div class="spec-grid">
  <h5>Button One</h5>
  <ul>
    <li><strong>Short press:</strong> Turns LEDs on/off</li>
    <li><strong>Long press:</strong> Changes the palette colour (randomly?)</li>
  </ul>
  <h5>Button Two</h5>
  <ul>
    <li><strong>Short press:</strong> Cycles through effects (randomly?)</li>
    <li><strong>Long press:</strong> Adjusts the brightness (up one press, down the next)</li>
  </ul>
</div>

::: note Future Update
Button programming interface coming soon!
:::
