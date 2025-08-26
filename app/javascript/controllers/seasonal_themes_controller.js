import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "effects"]
  static values = { currentTheme: String }

  connect() {
    // Load saved theme from localStorage
    const savedTheme = localStorage.getItem('baldrick-seasonal-theme')
    if (savedTheme && this.hasSelectTarget) {
      this.selectTarget.value = savedTheme
      this.currentThemeValue = savedTheme
      this.applySeasonalTheme(savedTheme)
    }
  }

  change(event) {
    const selectedTheme = event.target.value
    localStorage.setItem('baldrick-seasonal-theme', selectedTheme)
    this.currentThemeValue = selectedTheme
    this.applySeasonalTheme(selectedTheme)
  }

  applySeasonalTheme(theme) {
    if (!this.hasEffectsTarget) return

    // Clear existing effects
    this.effectsTarget.innerHTML = ''
    document.body.classList.remove('christmas-theme', 'halloween-theme')

    // Remove existing theme styles
    const existingThemeStyle = document.getElementById('seasonal-theme-style')
    if (existingThemeStyle) {
      existingThemeStyle.remove()
    }

    switch(theme) {
      case 'christmas':
        this.applyChristmasTheme()
        break
      case 'halloween':
        this.applyHalloweenTheme()
        break
      default:
        // Default theme - no effects
        break
    }
  }

  applyChristmasTheme() {
    document.body.classList.add('christmas-theme')

    // Add Christmas CSS
    const style = document.createElement('style')
    style.id = 'seasonal-theme-style'
    style.textContent = `
      .christmas-theme {
        background: linear-gradient(135deg, #0a0a1a 0%, #0f1a2e 50%, #1a2a4a 100%);
        position: relative;
        overflow-x: hidden;
      }
      
      .christmas-theme::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 100vh;
        background: radial-gradient(circle at 20% 50%, rgba(255, 0, 0, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(0, 255, 0, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 40% 80%, rgba(255, 255, 0, 0.1) 0%, transparent 50%);
        pointer-events: none;
        z-index: 1;
      }
      
      .christmas-theme .bg-purple-900 {
        background: linear-gradient(135deg, #1e3a8a 0%, #1e40af 50%, #3730a3 100%);
        box-shadow: 0 0 20px rgba(255, 255, 255, 0.1);
      }
      
      .christmas-theme .bg-purple-800 {
        background: linear-gradient(135deg, #312e81 0%, #3730a3 50%, #4338ca 100%);
        box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
      }
      
      .christmas-theme .border-purple-800 {
        border-color: #4c1d95;
        box-shadow: 0 0 10px rgba(255, 255, 255, 0.2);
      }
      
      .christmas-theme .text-purple-200 {
        color: #e0e7ff;
        text-shadow: 0 0 5px rgba(255, 255, 255, 0.3);
      }
      
      .christmas-theme .text-purple-300 {
        color: #c7d2fe;
        text-shadow: 0 0 5px rgba(255, 255, 255, 0.3);
      }
      
      @keyframes twinkle {
        0%, 100% { opacity: 1; transform: scale(1); }
        50% { opacity: 0.3; transform: scale(0.8); }
      }
      
      @keyframes snowfall {
        to {
          transform: translateY(100vh) rotate(360deg);
        }
      }
      
      @keyframes float {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        50% { transform: translateY(-15px) rotate(5deg); }
      }
      
      @keyframes christmasLights {
        0%, 100% { opacity: 1; filter: brightness(1); }
        25% { opacity: 0.7; filter: brightness(1.2); }
        50% { opacity: 1; filter: brightness(0.8); }
        75% { opacity: 0.9; filter: brightness(1.1); }
      }
      
      @keyframes snowDrift {
        0% { transform: translateX(-100vw) translateY(0); }
        100% { transform: translateX(100vw) translateY(100vh); }
      }
      
      .christmas-light-string {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: repeating-linear-gradient(
          90deg,
          #ff0000 0px, #ff0000 20px,
          #00ff00 20px, #00ff00 40px,
          #ffff00 40px, #ffff00 60px,
          #ff69b4 60px, #ff69b4 80px,
          #00ffff 80px, #00ffff 100px
        );
        z-index: 9996;
        animation: christmasLights 2s ease-in-out infinite;
      }
      
      .christmas-light-string:nth-child(2) {
        top: 50px;
        animation-delay: 0.5s;
      }
      
      .christmas-light-string:nth-child(3) {
        top: 100px;
        animation-delay: 1s;
      }
    `
    document.head.appendChild(style)

    // Create Christmas light strings across the top
    this.createChristmasLightStrings()
    
    // Create massive snow effect
    this.createChristmasSnow()
    
    // Add twinkling lights everywhere
    this.createTwinklingLights()
    
    // Add floating ornaments
    this.createFloatingOrnaments()
    
    // Add snow drifts
    this.createSnowDrifts()
  }

  applyHalloweenTheme() {
    document.body.classList.add('halloween-theme')

    // Add Halloween CSS
    const style = document.createElement('style')
    style.id = 'seasonal-theme-style'
    style.textContent = `
      .halloween-theme {
        background: linear-gradient(135deg, #0a0a0a 0%, #1a0a1a 50%, #0a0a0a 100%);
        position: relative;
        overflow-x: hidden;
      }
      
      .halloween-theme::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 100vh;
        background: 
          radial-gradient(circle at 20% 30%, rgba(255, 0, 0, 0.1) 0%, transparent 50%),
          radial-gradient(circle at 80% 70%, rgba(255, 165, 0, 0.1) 0%, transparent 50%),
          radial-gradient(circle at 50% 50%, rgba(128, 0, 128, 0.1) 0%, transparent 50%);
        pointer-events: none;
        z-index: 1;
      }
      
      .halloween-theme .bg-purple-900 {
        background: linear-gradient(135deg, #2d1b3d 0%, #4c1d95 50%, #2d1b3d 100%);
        box-shadow: 0 0 20px rgba(255, 0, 0, 0.2);
      }
      
      .halloween-theme .bg-purple-800 {
        background: linear-gradient(135deg, #3d1b5d 0%, #5b21b6 50%, #3d1b5d 100%);
        box-shadow: 0 0 15px rgba(255, 165, 0, 0.2);
      }
      
      .halloween-theme .border-purple-800 {
        border-color: #7c3aed;
        box-shadow: 0 0 10px rgba(255, 0, 0, 0.3);
      }
      
      .halloween-theme .text-purple-200 {
        color: #f3e8ff;
        text-shadow: 0 0 5px rgba(255, 0, 0, 0.3);
      }
      
      .halloween-theme .text-purple-300 {
        color: #e9d5ff;
        text-shadow: 0 0 5px rgba(255, 165, 0, 0.3);
      }
      
      @keyframes spookyFloat {
        0%, 100% { transform: translateY(0px) rotate(0deg) scale(1); }
        25% { transform: translateY(-20px) rotate(5deg) scale(1.1); }
        50% { transform: translateY(-35px) rotate(0deg) scale(0.9); }
        75% { transform: translateY(-20px) rotate(-5deg) scale(1.05); }
      }
      
      @keyframes flicker {
        0%, 100% { opacity: 1; filter: brightness(1); }
        10% { opacity: 0.8; filter: brightness(1.2); }
        20% { opacity: 0.6; filter: brightness(0.8); }
        30% { opacity: 0.9; filter: brightness(1.1); }
        40% { opacity: 0.7; filter: brightness(0.9); }
        50% { opacity: 1; filter: brightness(1); }
        60% { opacity: 0.8; filter: brightness(1.3); }
        70% { opacity: 0.5; filter: brightness(0.7); }
        80% { opacity: 0.9; filter: brightness(1.1); }
        90% { opacity: 0.7; filter: brightness(0.9); }
      }
      
      @keyframes spiderWeb {
        0% { transform: scale(0.5) rotate(0deg); opacity: 0; }
        50% { transform: scale(1.2) rotate(10deg); opacity: 1; }
        100% { transform: scale(1.1) rotate(5deg); opacity: 0.8; }
      }
      
      @keyframes ghostFloat {
        0%, 100% { transform: translateY(0px) translateX(0px) rotate(0deg); opacity: 0.8; }
        25% { transform: translateY(-30px) translateX(20px) rotate(2deg); opacity: 1; }
        50% { transform: translateY(-50px) translateX(-10px) rotate(0deg); opacity: 0.6; }
        75% { transform: translateY(-30px) translateX(15px) rotate(-2deg); opacity: 0.9; }
      }
      
      @keyframes batFlight {
        0%, 100% { transform: translateX(-100px) translateY(0px) rotate(0deg); }
        25% { transform: translateX(25vw) translateY(-50px) rotate(15deg); }
        50% { transform: translateX(50vw) translateY(0px) rotate(0deg); }
        75% { transform: translateX(75vw) translateY(-30px) rotate(-15deg); }
      }
      
      @keyframes lightning {
        0%, 90%, 100% { opacity: 0; }
        5%, 15% { opacity: 1; }
      }
      
      .lightning-flash {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(255, 255, 255, 0.3);
        pointer-events: none;
        z-index: 9995;
        animation: lightning 3s ease-in-out infinite;
      }
    `
    document.head.appendChild(style)

    // Create lightning effects
    this.createLightningEffects()
    
    // Create massive spooky effects
    this.createSpookyEffects()
    
    // Add intense flickering elements
    this.createFlickeringElements()
    
    // Add spider webs everywhere
    this.createSpiderWebs()
    
    // Add flying bats
    this.createFlyingBats()
    
    // Add ghost effects
    this.createGhostEffects()
  }

  createChristmasLightStrings() {
    for (let i = 0; i < 5; i++) {
      const lightString = document.createElement('div')
      lightString.className = 'christmas-light-string'
      lightString.style.cssText = `
        position: fixed;
        top: ${i * 60}px;
        left: 0;
        right: 0;
        height: 3px;
        background: repeating-linear-gradient(
          90deg,
          #ff0000 0px, #ff0000 25px,
          #00ff00 25px, #00ff00 50px,
          #ffff00 50px, #ffff00 75px,
          #ff69b4 75px, #ff69b4 100px,
          #00ffff 100px, #00ffff 125px
        );
        z-index: 9996;
        animation: christmasLights ${Math.random() * 2 + 1}s ease-in-out infinite;
        animation-delay: ${Math.random() * 2}s;
        box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
      `
      this.effectsTarget.appendChild(lightString)
    }
  }

  createChristmasSnow() {
    for (let i = 0; i < 100; i++) {
      const snowflake = document.createElement('div')
      snowflake.className = 'snowflake'
      snowflake.style.cssText = `
        position: fixed;
        top: -10px;
        left: ${Math.random() * 100}vw;
        width: ${Math.random() * 8 + 2}px;
        height: ${Math.random() * 8 + 2}px;
        background: white;
        border-radius: 50%;
        pointer-events: none;
        z-index: 9999;
        animation: snowfall ${Math.random() * 10 + 3}s linear infinite;
        opacity: ${Math.random() * 0.8 + 0.2};
        box-shadow: 0 0 5px rgba(255, 255, 255, 0.5);
      `
      this.effectsTarget.appendChild(snowflake)
    }
  }

  createTwinklingLights() {
    const nav = document.querySelector('nav')
    if (!nav) return

    // Add lights to navigation
    for (let i = 0; i < 15; i++) {
      const light = document.createElement('div')
      light.className = 'twinkle-light'
      light.style.cssText = `
        position: absolute;
        top: ${Math.random() * 100}%;
        left: ${Math.random() * 100}%;
        width: 6px;
        height: 6px;
        background: ${['#ff0000', '#00ff00', '#ffff00', '#ff69b4', '#00ffff', '#ff4500', '#ff1493'][Math.floor(Math.random() * 7)]};
        border-radius: 50%;
        pointer-events: none;
        z-index: 1000;
        animation: twinkle ${Math.random() * 2 + 1}s ease-in-out infinite;
        animation-delay: ${Math.random() * 2}s;
        box-shadow: 0 0 8px currentColor;
      `
      nav.appendChild(light)
    }

    // Add lights scattered around the page
    for (let i = 0; i < 25; i++) {
      const light = document.createElement('div')
      light.className = 'twinkle-light'
      light.style.cssText = `
        position: fixed;
        top: ${Math.random() * 100}%;
        left: ${Math.random() * 100}%;
        width: ${Math.random() * 8 + 4}px;
        height: ${Math.random() * 8 + 4}px;
        background: ${['#ff0000', '#00ff00', '#ffff00', '#ff69b4', '#00ffff', '#ff4500', '#ff1493'][Math.floor(Math.random() * 7)]};
        border-radius: 50%;
        pointer-events: none;
        z-index: 9997;
        animation: twinkle ${Math.random() * 3 + 1}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        box-shadow: 0 0 10px currentColor;
      `
      this.effectsTarget.appendChild(light)
    }
  }

  createFloatingOrnaments() {
    const ornaments = ['🎄', '🎁', '⭐', '🎅', '❄️', '🦌', '🔔', '🕯️']

    for (let i = 0; i < 12; i++) {
      const ornament = document.createElement('div')
      ornament.className = 'floating-ornament'
      ornament.textContent = ornaments[Math.floor(Math.random() * ornaments.length)]
      ornament.style.cssText = `
        position: fixed;
        top: ${Math.random() * 80 + 10}%;
        left: ${Math.random() * 80 + 10}%;
        font-size: ${Math.random() * 20 + 20}px;
        pointer-events: none;
        z-index: 9998;
        animation: float ${Math.random() * 6 + 4}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.5));
      `
      this.effectsTarget.appendChild(ornament)
    }
  }

  createSnowDrifts() {
    for (let i = 0; i < 8; i++) {
      const drift = document.createElement('div')
      drift.className = 'snow-drift'
      drift.style.cssText = `
        position: fixed;
        top: ${Math.random() * 100}%;
        left: -100px;
        width: 200px;
        height: 50px;
        background: linear-gradient(90deg, transparent 0%, rgba(255, 255, 255, 0.3) 50%, transparent 100%);
        pointer-events: none;
        z-index: 9995;
        animation: snowDrift ${Math.random() * 20 + 15}s linear infinite;
        animation-delay: ${Math.random() * 10}s;
      `
      this.effectsTarget.appendChild(drift)
    }
  }

  createLightningEffects() {
    for (let i = 0; i < 3; i++) {
      const lightning = document.createElement('div')
      lightning.className = 'lightning-flash'
      lightning.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(255, 255, 255, 0.4);
        pointer-events: none;
        z-index: 9995;
        animation: lightning ${Math.random() * 5 + 3}s ease-in-out infinite;
        animation-delay: ${Math.random() * 5}s;
      `
      this.effectsTarget.appendChild(lightning)
    }
  }

  createSpookyEffects() {
    const spookyElements = ['👻', '🦇', '🕷️', '🕸️', '💀', '🎃', '⚰️', '🕯️']

    for (let i = 0; i < 20; i++) {
      const spooky = document.createElement('div')
      spooky.className = 'spooky-element'
      spooky.textContent = spookyElements[Math.floor(Math.random() * spookyElements.length)]
      spooky.style.cssText = `
        position: fixed;
        top: ${Math.random() * 80 + 10}%;
        left: ${Math.random() * 80 + 10}%;
        font-size: ${Math.random() * 20 + 15}px;
        pointer-events: none;
        z-index: 9998;
        animation: spookyFloat ${Math.random() * 8 + 4}s ease-in-out infinite;
        animation-delay: ${Math.random() * 4}s;
        filter: drop-shadow(0 0 8px rgba(255, 0, 0, 0.5));
      `
      this.effectsTarget.appendChild(spooky)
    }
  }

  createFlickeringElements() {
    const elements = document.querySelectorAll('h1, h2, h3, .text-purple-200, .text-purple-300, p, li')
    elements.forEach((el, index) => {
      if (Math.random() > 0.5) { // 50% chance - much more flickering
        el.style.animation = `flicker ${Math.random() * 4 + 2}s ease-in-out infinite`
        el.style.animationDelay = `${Math.random() * 3}s`
        el.style.filter = 'drop-shadow(0 0 3px rgba(255, 0, 0, 0.3))'
      }
    })
  }

  createSpiderWebs() {
    for (let i = 0; i < 8; i++) {
      const web = document.createElement('div')
      web.className = 'spider-web'
      web.innerHTML = '🕸️'
      web.style.cssText = `
        position: fixed;
        top: ${Math.random() * 60 + 20}%;
        left: ${Math.random() * 60 + 20}%;
        font-size: ${Math.random() * 30 + 25}px;
        pointer-events: none;
        z-index: 9997;
        animation: spiderWeb ${Math.random() * 6 + 4}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        filter: drop-shadow(0 0 5px rgba(255, 0, 0, 0.3));
      `
      this.effectsTarget.appendChild(web)
    }
  }

  createFlyingBats() {
    for (let i = 0; i < 6; i++) {
      const bat = document.createElement('div')
      bat.className = 'flying-bat'
      bat.innerHTML = '🦇'
      bat.style.cssText = `
        position: fixed;
        top: ${Math.random() * 50 + 10}%;
        left: -50px;
        font-size: ${Math.random() * 15 + 20}px;
        pointer-events: none;
        z-index: 9996;
        animation: batFlight ${Math.random() * 8 + 6}s linear infinite;
        animation-delay: ${Math.random() * 5}s;
        filter: drop-shadow(0 0 5px rgba(0, 0, 0, 0.8));
      `
      this.effectsTarget.appendChild(bat)
    }
  }

  createGhostEffects() {
    for (let i = 0; i < 5; i++) {
      const ghost = document.createElement('div')
      ghost.className = 'ghost-effect'
      ghost.innerHTML = '👻'
      ghost.style.cssText = `
        position: fixed;
        top: ${Math.random() * 60 + 20}%;
        left: ${Math.random() * 60 + 20}%;
        font-size: ${Math.random() * 20 + 25}px;
        pointer-events: none;
        z-index: 9997;
        animation: ghostFloat ${Math.random() * 10 + 6}s ease-in-out infinite;
        animation-delay: ${Math.random() * 4}s;
        filter: drop-shadow(0 0 8px rgba(255, 255, 255, 0.6));
      `
      this.effectsTarget.appendChild(ghost)
    }
  }
}

