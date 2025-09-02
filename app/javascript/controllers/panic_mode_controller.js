import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updateCountdowns()
    this.interval = setInterval(() => {
      this.updateCountdowns()
    }, 60000) // Update every minute
  }

  disconnect() {
    if (this.interval) {
      clearInterval(this.interval)
    }
  }

  updateCountdowns() {
    const now = new Date()
    const currentYear = now.getFullYear()
    
    // Halloween show starts week before Oct 31st (Oct 24th)
    let halloweenShowStart = new Date(currentYear, 9, 24) // Month is 0-indexed, so 9 = October
    if (now > halloweenShowStart) {
      halloweenShowStart = new Date(currentYear + 1, 9, 24)
    }
    
    // Christmas show starts December 1st
    let christmasShowStart = new Date(currentYear, 11, 1) // Month is 0-indexed, so 11 = December
    if (now > christmasShowStart) {
      christmasShowStart = new Date(currentYear + 1, 11, 1)
    }
    
    // Calculate days remaining
    const halloweenDays = Math.ceil((halloweenShowStart - now) / (1000 * 60 * 60 * 24))
    const christmasDays = Math.ceil((christmasShowStart - now) / (1000 * 60 * 60 * 24))
    
    // Update countdown displays
    const halloweenCountdown = document.getElementById('halloween-countdown')
    const christmasCountdown = document.getElementById('christmas-countdown')
    
    if (halloweenCountdown) {
      halloweenCountdown.textContent = halloweenDays
    }
    if (christmasCountdown) {
      christmasCountdown.textContent = christmasDays
    }
    
    // Calculate panic levels and update gauges
    this.updateGauge(halloweenDays, 'halloween-gauge-pointer', 'halloween-gauge-title')
    this.updateGauge(christmasDays, 'christmas-gauge-pointer', 'christmas-gauge-title')
  }

  updateGauge(days, gaugeId, titleId) {
    let level, position, text
    
    if (days > 30) {
      level = 1 // Groovy
      position = '10%'
      text = "Everything's groovy"
    } else if (days > 20) {
      level = 2 // Hmm
      position = '30%'
      text = "Hmm. Something's not quite right."
    } else if (days > 13) {
      level = 3 // Scary
      position = '50%'
      text = "Getting kind of scary"
    } else if (days > 6) {
      level = 4 // Really Scary
      position = '70%'
      text = "Getting really scary!"
    } else {
      level = 5 // DOOM
      position = '90%'
      text = "DOOM!!!"
    }
    
    const gaugePointer = document.getElementById(gaugeId)
    const gaugeTitle = document.getElementById(titleId)
    
    if (gaugePointer) {
      gaugePointer.style.left = position
    }
    if (gaugeTitle) {
      gaugeTitle.textContent = text
    }
  }
}
