---
title: Technical specifications
specs_table: true
---

### Board components {#board-components}

<div class="manual-tabs" data-controller="tabs">
  <div class="manual-tab-nav">
    <nav>
      <button class="manual-tab active" type="button" data-action="click->tabs#switch" data-tab="v1-1">BaldrickSwitchy v1.1</button>
      <button class="manual-tab" type="button" data-action="click->tabs#switch" data-tab="v1-0">BaldrickSwitchy v1.0</button>
    </nav>
  </div>
  <div class="tab-content">
    <div class="tab-panel" data-tab="v1-1">
      <div class="figure">
        <div class="fimg">
          <img src="baldrickswitchy/breakdown11.png" alt="BaldrickSwitchy v1.1 Board Overview" class="doc-img">
        </div>
      </div>
      <ul>
        <li><strong>1. Power Jack —</strong> You can put 5v-48v through a barrel connector (centre positive) and we use 5.5x2.1mm barrel jacks. Please remember you are just powering the board not the devices.</li>
        <li><strong>2. 2 Pin Pheonix Connector —</strong> You can put 5v-48v through this connector. Please remember you are just powering the board not the devices.</li>
        <li><strong>3. 3 Pin Relays —</strong> Connect your device to enable control via the BaldrickSwitchy.</li>
        <li><strong>4. QR Code —</strong> An easy to scan QR code which will take you to these docs for quick troubleshooting.</li>
        <li><strong>5. Ethernet port —</strong> To ensure the consistent connection to your devices, we've added a 100mb ethernet port to connect to your show network.</li>
        <li><strong>6. Oh No Button —</strong> Did you break our board? Press and hold this for 5 seconds on boot to reset to factory settings.</li>
        <li><strong>7. Mounting Holes —</strong> The BaldrickSwitchy is classed as a medium family member.</li>
      </ul>
      <div class="callout warn">
        <svg class="ci" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 9v4m0 4h.01M10.3 3.6 2.6 17a2 2 0 0 0 1.7 3h15.4a2 2 0 0 0 1.7-3L13.7 3.6a2 2 0 0 0-3.4 0z"/></svg>
        <div><b>Mounting holes</b> DO NOT DRILL out these holes to make them fit the screws you've got already, doing this will void any warranty.</div>
      </div>
      <div class="callout info">
        <svg class="ci" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 16v-4m0-4h.01M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0z"/></svg>
        <div><b>Note</b> The board will also come affixed to a <a href="/boards/baldrickswitchy/faq#darwin-tray">Darwin Tray</a> for your protection.</div>
      </div>
    </div>
    <div class="tab-panel hidden" data-tab="v1-0">
      <div class="figure">
        <div class="fimg">
          <img src="baldrickswitchy/breakdown.png" alt="BaldrickSwitchy v1.0 Board Overview" class="doc-img">
        </div>
      </div>
      <ol>
        <li><strong>Power Jack —</strong> You can put 5v-24v through a barrel connector (centre positive) and we use 5.5x2.1mm barrel jacks. Please remember you are just powering the board not the devices.</li>
        <li><strong>Relay 1 —</strong> Connect your device to enable control via the BaldrickSwitchy.</li>
        <li><strong>Relay 2 —</strong> Connect your device to enable control via the BaldrickSwitchy.</li>
        <li><strong>Relay 3 —</strong> Connect your device to enable control via the BaldrickSwitchy.</li>
        <li><strong>Relay 4 —</strong> Connect your device to enable control via the BaldrickSwitchy.</li>
        <li><strong>QR Code —</strong> An easy to scan QR code which will take you to these docs for quick troubleshooting.</li>
        <li><strong>Ethernet port —</strong> To ensure the consistent connection to your devices, we've added a 100mb ethernet port to connect to your show network.</li>
        <li><strong>ESP32 —</strong> The brains of our board, don't worry about this too much, that's our job, not yours.</li>
        <li><strong>Company logo —</strong> Our company logo, isn't it great?</li>
        <li><strong>Mounting Holes —</strong> We've designed the BaldrickSwitchy to not only be as compact as possible, we've matched the mounting holes to other common controllers so mounts can be reused (in this case the Falcon SRX2 Receiver).</li>
      </ol>
      <div class="callout warn">
        <svg class="ci" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 9v4m0 4h.01M10.3 3.6 2.6 17a2 2 0 0 0 1.7 3h15.4a2 2 0 0 0 1.7-3L13.7 3.6a2 2 0 0 0-3.4 0z"/></svg>
        <div><b>Mounting holes</b> DO NOT DRILL out these holes to make them fit the screws you've got already, doing this will void any warranty.</div>
      </div>
      <div class="callout info">
        <svg class="ci" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 16v-4m0-4h.01M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0z"/></svg>
        <div><b>Note</b> The board will also come affixed to a <a href="/boards/baldrickswitchy/faq#darwin-tray">Darwin Tray</a> for your protection.</div>
      </div>
    </div>
  </div>
</div>
