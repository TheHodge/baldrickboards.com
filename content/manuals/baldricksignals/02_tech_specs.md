---
title: Technical specifications
specs_table: true
---

### Board components {#board-components}

<div class="manual-tabs" data-controller="tabs">
  <div class="manual-tab-nav">
    <nav>
      <button class="manual-tab active" type="button" data-action="click->tabs#switch" data-tab="v1-1">BaldrickSignals v1.1</button>
      <button class="manual-tab" type="button" data-action="click->tabs#switch" data-tab="v1-0">BaldrickSignals v1.0</button>
    </nav>
  </div>
  <div class="tab-content">
    <div class="tab-panel" data-tab="v1-1">
      <div class="figure">
        <div class="fimg">
          <img src="baldricksignals/breakdown11.png" alt="BaldrickSignals v1.1 Board Overview" class="doc-img">
        </div>
      </div>
      <ul>
        <li><strong>1. Power Jack —</strong> You can put 5v-48v through a barrel connector (centre positive) and we use 5.5x2.1mm barrel jacks.</li>
        <li><strong>2. 2 Pin Pheonix Connector —</strong> You can put 5v-48v through this connector.</li>
        <li><strong>3. CR2032 Coin cell clip —</strong> Using this will allow the BaldrickSignals to keep the time even when the board is disconnected from the network (this will not power the board). Your vendor will probably not supply this so make sure you've got one.</li>
        <li><strong>4. Wireless Chip —</strong> The BaldrickSignals uses wifi to detect other devices, you'll need an <a href="/faq#antennas">antenna</a>.</li>
        <li><strong>5. 100mb Ethernet Port —</strong> You can use this to connect to your show network.</li>
        <li><strong>6. QR Code —</strong> An easy to scan QR code which will take you to these docs for easy troubleshooting.</li>
        <li><strong>7. Oh No button —</strong> Use this to reset the board by holding for 5 seconds when the board is booting.</li>
      </ul>
    </div>
    <div class="tab-panel hidden" data-tab="v1-0">
      <div class="figure">
        <div class="fimg">
          <img src="baldricksignals/breakdown.png" alt="BaldrickSignals v1.0 Board Overview" class="doc-img">
        </div>
      </div>
      <ol>
        <li><strong>Power Jack —</strong> Can take 5v to 24v (each side can take different voltages) and will automatically step down to power the components, no jumpers needed. <strong>Whatever voltage you used here is also used to power the lamp</strong>.</li>
        <li><strong>CR2032 Coin cell clip —</strong> Using this will allow the BaldrickSignals to keep the time even when the board is disconnected from the network (this will not power the board). Your vendor will probably not supply this so make sure you've got one.</li>
        <li><strong>Wireless Chip —</strong> The BaldrickSignals uses wifi to detect other devices, you'll need an <a href="/faq#antennas">antenna</a>.</li>
        <li><strong>100mb Ethernet Port —</strong> You can use this to connect to your show network.</li>
        <li><strong>QR Code —</strong> An easy to scan QR code which will take you to these docs for easy troubleshooting.</li>
        <li><strong>Oh No button —</strong> Use this to reset the board by holding for 5 seconds when the board is booting.</li>
      </ol>
    </div>
  </div>
</div>
