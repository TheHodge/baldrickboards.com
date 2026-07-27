import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["primary", "label", "hint", "card"]
  static values = {
    macUrl: String,
    windowsUrl: String,
    linuxUrl: String,
    macLabel: { type: String, default: "macOS" },
    windowsLabel: { type: String, default: "Windows" },
    linuxLabel: { type: String, default: "Linux" },
    version: String
  }

  connect() {
    const platform = this.detectPlatform()
    this.highlightCard(platform)
    this.configurePrimary(platform)
  }

  detectPlatform() {
    const ua = navigator.userAgent || ""
    const platform = navigator.platform || ""
    const combined = `${ua} ${platform}`.toLowerCase()

    if (/iphone|ipad|ipod|macintosh|mac os x/.test(combined)) return "mac"
    if (/win/.test(combined)) return "windows"
    if (/android|linux|cros|x11/.test(combined)) return "linux"
    return "mac"
  }

  configurePrimary(platform) {
    if (!this.hasPrimaryTarget) return

    const url = this.urlFor(platform)
    const label = this.labelFor(platform)

    if (url) {
      this.primaryTarget.href = url
      this.primaryTarget.classList.remove("is-disabled")
      if (this.hasLabelTarget) {
        this.labelTarget.textContent = `Download for ${label}`
      }
      if (this.hasHintTarget) {
        const versionBit = this.versionValue ? ` ${this.versionValue}` : ""
        this.hintTarget.textContent = `Detected ${label}${versionBit} — or pick another platform below.`
      }
    } else {
      this.primaryTarget.href = `#download-${platform}`
      if (this.hasLabelTarget) {
        this.labelTarget.textContent = "Choose your platform"
      }
      if (this.hasHintTarget) {
        this.hintTarget.textContent = `No ${label} build for this release yet — try another platform below.`
      }
    }
  }

  highlightCard(platform) {
    this.cardTargets.forEach((card) => {
      card.classList.toggle("is-detected", card.dataset.platform === platform)
    })
  }

  urlFor(platform) {
    return {
      mac: this.macUrlValue,
      windows: this.windowsUrlValue,
      linux: this.linuxUrlValue
    }[platform] || ""
  }

  labelFor(platform) {
    return {
      mac: this.macLabelValue,
      windows: this.windowsLabelValue,
      linux: this.linuxLabelValue
    }[platform] || platform
  }
}
