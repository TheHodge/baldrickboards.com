---
title: Board Tour
---

We've produced two different versions of the Baldrick8 board so far, but the only real difference is that the version 1.0 boards can take 5v - 24v and the 1.1 boards can take 5v - 48v.

The way you tell the difference between the boards is that if under the ILightThat logo on your board it says 1.1 then you've got a 1.1 board, if not then you've got a 1.0 board.

::: figure
![Baldrick8 v1.1 board overview](baldrick8/breakdown11.jpg)
:::

1. **Left Power Jack** - See below.
2. **Right Power Jack:** Our screw jacks are voltage independent (each side can take different voltages) and will handle 5v-48v (24v for 1.0 boards) they will step down to power the components and have reverse polairty protection. We recommend 10AWG cable for these inputs.
3. **Pixel Phoenix Connectors** - Ordering G (Ground) D (Data) + (Positive / Voltage).
4. **Fuse Holder** - Comes profilled with 7.5A fuses, these easy to access fuses are for protection and their location makes them easy to change.
5. **Ethernet Port** - The Baldrick8 does not run over wifi to ensure the high FPS that this controller is designed for we've added a 100mb ethernet port to connect to your show network.
6. **QR Code** - Each Baldrick controller has a QR code on which takes you to a dedicaed webpage for that device with an easy link to the manual and help docs, perfect for when you are outside and just need a quick reminder how something works.
7. **Button connectors** - The Baldrick8 has three input ports and test buttons, as well as the ability to do amazing thing with The Turnip Network, the onboard test buttons have prebuilt actions when booting the board
	* *Pressing and holding B1* - Will reset the network settings of the board (if you've set a static IP or hostname for instance)
	* *Pressing and holding B2* - Will set the board IP address to 192.168.68.68, useful if you are having trouble with your DHCP server.
	* *Pressing and holding B3* - *oh no* this will reset the board to factory settings, wiping all settings, configuration and firmware from the device. (**Do not do this if you have no internet access, you will need to redownload the firmware**)
8. **Mounting Holes** - The Baldrick8 is a *Medium* Baldrick board so will fit all *Medium* mounts and connections. **DO NOT DRILL out these holes to make them fit the screws you've got already, doing this will void any warranty.** If you think it's silly that we are putting this in the manual, ask yourself why we'd put it in the manual.