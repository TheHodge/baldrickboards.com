---
sidebar_position: 10
---

# The Asking for Help Checklist

If you are reading this it means someone has send you this link to help you get answers to your question quicker.

We know that with showtime looming it can be stressful when things go wrong so here is a handy checklist for you to just quickly run through and double check.


## If the pixels are not doing what they should
This is usually a channel overlap issue and easily sortable.

* Make sure each of your controllers has Auto Layout Models and Auto Layout Size and if possible full xLights Control enabled. *If you are unable to do that, make sure all your controllers have separate channels and universes*
* Re-render the sequence
* In xLights on the controller tab, click 'output to lights' on each of your controllers and keep an eye on the bottom left that they all succeed (sometimes they can fail)
* then in xLights click FPP Connect and do an upload with **UDP Out** set to *ALL* on your main show controller.
* Check that the channels in xLights match the channels in FPP and on the Baldrick8 controller

## If the pixels are not outputting via FPP

* Make sure test mode isn't enabled on the Baldrick8
* Check the E1.31 Outputs tab in FPP and ensure the I.P. address matches your controller IP address
* Check the E1.31 Outputs tab in FPP and ensure the channels match the ones in the xLights controller tab 
* Enable test mode on FPP and look at the stats box on the Baldrick8 is it receiving data?

## If the pixels are not outputting via xLights

* Make sure test mode isn't enabled on the Baldrick8
* Check the controller tab in xLights and ensure the I.P. address matches your controller IP address
* Push outputs to the controller and make sure it's successful 
* Enable test mode on FPP and look at the stats box on the Baldrick8 is it receiving data?


## That didn't help

If the checklist didn't solve it then it's time to ask for help, If you are going to post on the [Baldrick Community Facebook Group](https://www.facebook.com/groups/ilightthat/) then here are some things that are really helpful to include (and will almost certainly be asked for so posting them now will get you help quicker)

* What is the issue you are having (be as detailed as possible)
* What have you tried so far
* What version of xLights, FPP &/or Baldrick8 firmware are you using
* Please include screenshots of your xLights controller tab (with the Baldrick8 selected), your FPP e1.31 Outputs page & your xLights Models section.
* If possible, a photo of the controller wired up.
* A bit of info about your network setup!

These might seem like a pain in the arse to gather but trust us, it will get you a solution quicker, there is no such thing as too much information. 