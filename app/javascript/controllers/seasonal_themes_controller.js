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

    // Clean up navigation lights
    this.cleanupNavigationLights()

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
      case 'easter':
        this.applyEasterTheme()
        break
      case 'british':
        this.applyBritishTheme()
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
      
      @keyframes snowDrift {
        0% { transform: translateX(-100vw) translateY(0); }
        100% { transform: translateX(100vw) translateY(100vh); }
      }
    `
    document.head.appendChild(style)

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
      
      @keyframes subtleFlicker {
        0%, 100% { opacity: 1; filter: brightness(1); }
        25% { opacity: 0.95; filter: brightness(1.05); }
        50% { opacity: 0.9; filter: brightness(0.95); }
        75% { opacity: 0.95; filter: brightness(1.02); }
      }
      
      @keyframes spiderWeb {
        0% { transform: scale(0.5) rotate(0deg); opacity: 0; }
        50% { transform: scale(1.2) rotate(10deg); opacity: 1; }
        100% { transform: scale(1.1) rotate(5deg); opacity: 0.8; }
      }
      
      .corner-web {
        position: fixed;
        width: 80px;
        height: 80px;
        pointer-events: none;
        z-index: 9997;
      }
      
      .corner-web::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: 
          radial-gradient(circle at 20% 20%, transparent 0%, transparent 15%, rgba(255,255,255,0.3) 16%, transparent 17%),
          radial-gradient(circle at 80% 20%, transparent 0%, transparent 15%, rgba(255,255,255,0.3) 16%, transparent 17%),
          radial-gradient(circle at 20% 80%, transparent 0%, transparent 15%, rgba(255,255,255,0.3) 16%, transparent 17%),
          radial-gradient(circle at 80% 80%, transparent 0%, transparent 15%, rgba(255,255,255,0.3) 16%, transparent 17%),
          radial-gradient(circle at 50% 50%, transparent 0%, transparent 25%, rgba(255,255,255,0.2) 26%, transparent 27%);
        animation: spiderWeb 8s ease-in-out infinite;
      }
      
      .corner-web::after {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: 
          conic-gradient(from 0deg, transparent 0deg, rgba(255,255,255,0.4) 10deg, transparent 20deg, rgba(255,255,255,0.4) 30deg, transparent 40deg, rgba(255,255,255,0.4) 50deg, transparent 60deg, rgba(255,255,255,0.4) 70deg, transparent 80deg, rgba(255,255,255,0.4) 90deg, transparent 100deg, rgba(255,255,255,0.4) 110deg, transparent 120deg, rgba(255,255,255,0.4) 130deg, transparent 140deg, rgba(255,255,255,0.4) 150deg, transparent 160deg, rgba(255,255,255,0.4) 170deg, transparent 180deg, rgba(255,255,255,0.4) 190deg, transparent 200deg, rgba(255,255,255,0.4) 210deg, transparent 220deg, rgba(255,255,255,0.4) 230deg, transparent 240deg, rgba(255,255,255,0.4) 250deg, transparent 260deg, rgba(255,255,255,0.4) 270deg, transparent 280deg, rgba(255,255,255,0.4) 290deg, transparent 300deg, rgba(255,255,255,0.4) 310deg, transparent 320deg, rgba(255,255,255,0.4) 330deg, transparent 340deg, rgba(255,255,255,0.4) 350deg, transparent 360deg);
        animation: spiderWeb 8s ease-in-out infinite;
        animation-delay: 2s;
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
      
      @keyframes spookyTwinkle {
        0%, 100% { opacity: 0.8; transform: scale(1); filter: brightness(1); }
        25% { opacity: 1; transform: scale(1.2); filter: brightness(1.3); }
        50% { opacity: 0.6; transform: scale(0.8); filter: brightness(0.7); }
        75% { opacity: 0.9; transform: scale(1.1); filter: brightness(1.1); }
      }
      
      @keyframes lightning {
        0%, 95%, 100% { opacity: 0; }
        2%, 8% { opacity: 1; }
      }
      
      .lightning-flash {
        position: fixed;
        pointer-events: none;
        z-index: 9995;
        animation: lightning 3s ease-in-out infinite;
      }
    `
    document.head.appendChild(style)

    // Create lightning effects
    this.createLightningEffects()
    
    // Create spooky effects
    this.createSpookyEffects()
    
    // Add spooky navigation lights
    this.createSpookyNavigationLights()
    
    // Add subtle flickering to specific elements only
    this.createSubtleFlickering()
    
    // Add spider webs
    this.createSpiderWebs()
    
    // Add flying bats
    this.createFlyingBats()
    
    // Add ghost effects
    this.createGhostEffects()
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
    // Create targeted lightning strikes instead of full-screen overlay
    for (let i = 0; i < 3; i++) {
      const lightning = document.createElement('div')
      lightning.className = 'lightning-flash'
      lightning.style.cssText = `
        position: fixed;
        top: ${Math.random() * 40}%;
        left: ${Math.random() * 80}%;
        width: ${Math.random() * 200 + 100}px;
        height: ${Math.random() * 300 + 200}px;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.3) 0%, rgba(255, 255, 255, 0.1) 50%, transparent 100%);
        pointer-events: none;
        z-index: 9995;
        animation: lightning ${Math.random() * 8 + 6}s ease-in-out infinite;
        animation-delay: ${Math.random() * 10}s;
        border-radius: 50%;
        filter: blur(20px);
      `
      this.effectsTarget.appendChild(lightning)
    }
  }

  createSpookyEffects() {
    const spookyElements = ['👻', '🦇', '🕷️', '🕸️', '💀', '🎃', '⚰️', '🕯️']

    for (let i = 0; i < 12; i++) {
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

  createSubtleFlickering() {
    // Only apply subtle flickering to a few specific elements, not all text
    const flickerCandidates = document.querySelectorAll('h1, .text-purple-200, .text-purple-300')
    const elementsToFlicker = Array.from(flickerCandidates).filter(() => Math.random() > 0.7) // Only 30% chance
    
    elementsToFlicker.slice(0, 3).forEach((el) => { // Limit to max 3 elements
      el.style.animation = `subtleFlicker ${Math.random() * 8 + 6}s ease-in-out infinite`
      el.style.animationDelay = `${Math.random() * 5}s`
      el.style.filter = 'drop-shadow(0 0 2px rgba(255, 0, 0, 0.2))'
    })
  }

  createSpiderWebs() {
    // Create corner webs
    const corners = [
      { top: '10px', left: '10px', transform: 'rotate(-15deg)' },
      { top: '10px', right: '10px', transform: 'rotate(15deg)' },
      { bottom: '10px', left: '10px', transform: 'rotate(15deg)' },
      { bottom: '10px', right: '10px', transform: 'rotate(-15deg)' }
    ]
    
    // corners.forEach((corner, index) => {
    //   const web = document.createElement('div')
    //   web.className = 'corner-web'
    //   web.style.cssText = `
    //     ${Object.entries(corner).map(([key, value]) => `${key}: ${value}`).join('; ')}
    //     animation-delay: ${Math.random() * 3}s;
    //   `
    //   this.effectsTarget.appendChild(web)
    // })
    
    // Add a couple of random webs in other areas
    for (let i = 0; i < 2; i++) {
      const web = document.createElement('div')
      web.className = 'spider-web'
      web.innerHTML = '🕸️'
      web.style.cssText = `
        position: fixed;
        top: ${Math.random() * 60 + 20}%;
        left: ${Math.random() * 60 + 20}%;
        font-size: ${Math.random() * 20 + 25}px;
        pointer-events: none;
        z-index: 9997;
        animation: spiderWeb ${Math.random() * 6 + 4}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        filter: drop-shadow(0 0 5px rgba(255, 0, 0, 0.3));
        opacity: 0.6;
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

  cleanupNavigationLights() {
    // Remove all twinkle-light elements from the navigation
    const nav = document.querySelector('nav')
    if (nav) {
      const twinkleLights = nav.querySelectorAll('.twinkle-light')
      twinkleLights.forEach(light => light.remove())
    }
  }

  createSpookyNavigationLights() {
    const nav = document.querySelector('nav')
    if (!nav) return

    // Spooky Halloween colors - candy cane orange and deep purple focus
    const spookyColors = ['#FF6B35', '#8B4513', '#4B0082', '#800080', '#FF8C00', '#2F4F4F', '#FF4500', '#8A2BE2', '#FF7F50', '#9932CC']

    // Add spooky lights to navigation
    for (let i = 0; i < 12; i++) {
      const light = document.createElement('div')
      light.className = 'twinkle-light'
      light.style.cssText = `
        position: absolute;
        top: ${Math.random() * 100}%;
        left: ${Math.random() * 100}%;
        width: ${Math.random() * 6 + 4}px;
        height: ${Math.random() * 6 + 4}px;
        background: ${spookyColors[Math.floor(Math.random() * spookyColors.length)]};
        border-radius: 50%;
        pointer-events: none;
        z-index: 1000;
        animation: spookyTwinkle ${Math.random() * 3 + 2}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        box-shadow: 0 0 8px currentColor, 0 0 12px currentColor;
        opacity: 0.8;
      `
      nav.appendChild(light)
    }
  }

  applyEasterTheme() {
    document.body.classList.add('easter-theme')

    // Add Easter CSS
    const style = document.createElement('style')
    style.id = 'seasonal-theme-style'
    style.textContent = `
      .easter-theme {
        background: linear-gradient(135deg, #f0f8ff 0%, #e6f3ff 50%, #f5f0ff 100%);
        position: relative;
        overflow-x: hidden;
      }
      
      .easter-theme::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 100vh;
        background: 
          radial-gradient(circle at 20% 30%, rgba(255, 182, 193, 0.1) 0%, transparent 50%),
          radial-gradient(circle at 80% 70%, rgba(173, 216, 230, 0.1) 0%, transparent 50%),
          radial-gradient(circle at 50% 50%, rgba(221, 160, 221, 0.1) 0%, transparent 50%);
        pointer-events: none;
        z-index: 1;
      }
      
      .easter-theme .bg-purple-900 {
        background: linear-gradient(135deg, #8b5a8b 0%, #9370db 50%, #8a2be2 100%);
        box-shadow: 0 0 20px rgba(255, 182, 193, 0.3);
      }
      
      .easter-theme .bg-purple-800 {
        background: linear-gradient(135deg, #9370db 0%, #8a2be2 50%, #9932cc 100%);
        box-shadow: 0 0 15px rgba(173, 216, 230, 0.3);
      }
      
      .easter-theme .border-purple-800 {
        border-color: #8a2be2;
        box-shadow: 0 0 10px rgba(255, 182, 193, 0.4);
      }
      
      .easter-theme .text-purple-200 {
        color: #f0f8ff;
        text-shadow: 0 0 5px rgba(255, 182, 193, 0.4);
      }
      
      .easter-theme .text-purple-300 {
        color: #e6f3ff;
        text-shadow: 0 0 5px rgba(173, 216, 230, 0.4);
      }
      
      @keyframes easterBounce {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        25% { transform: translateY(-20px) rotate(5deg); }
        50% { transform: translateY(-35px) rotate(0deg); }
        75% { transform: translateY(-20px) rotate(-5deg); }
      }
      
      @keyframes easterFloat {
        0%, 100% { transform: translateY(0px) translateX(0px) rotate(0deg); }
        25% { transform: translateY(-15px) translateX(10px) rotate(2deg); }
        50% { transform: translateY(-25px) translateX(-5px) rotate(0deg); }
        75% { transform: translateY(-15px) translateX(8px) rotate(-2deg); }
      }
      
      @keyframes easterTwinkle {
        0%, 100% { opacity: 0.8; transform: scale(1); filter: brightness(1); }
        25% { opacity: 1; transform: scale(1.1); filter: brightness(1.2); }
        50% { opacity: 0.6; transform: scale(0.9); filter: brightness(0.8); }
        75% { opacity: 0.9; transform: scale(1.05); filter: brightness(1.1); }
      }
      
      @keyframes easterRainbow {
        0% { filter: hue-rotate(0deg); }
        100% { filter: hue-rotate(360deg); }
      }
    `
    document.head.appendChild(style)

    // Create Easter effects
    this.createEasterEggs()
    this.createEasterBunnies()
    this.createEasterFlowers()
    this.createEasterNavigationLights()
    this.createEasterRainbow()
  }

  applyBritishTheme() {
    document.body.classList.add('british-theme')

    // Add British CSS
    const style = document.createElement('style')
    style.id = 'seasonal-theme-style'
    style.textContent = `
      .british-theme {
        background: linear-gradient(135deg, #012169 0%, #c8102e 50%, #ffffff 100%);
        position: relative;
        overflow-x: hidden;
      }
      
      .british-theme::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 100vh;
        background: 
          radial-gradient(circle at 20% 30%, rgba(1, 33, 105, 0.1) 0%, transparent 50%),
          radial-gradient(circle at 80% 70%, rgba(200, 16, 46, 0.1) 0%, transparent 50%),
          radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
        pointer-events: none;
        z-index: 1;
      }
      
      .british-theme .bg-purple-900 {
        background: linear-gradient(135deg, #012169 0%, #1e3a8a 50%, #3730a3 100%);
        box-shadow: 0 0 20px rgba(200, 16, 46, 0.3);
      }
      
      .british-theme .bg-purple-800 {
        background: linear-gradient(135deg, #1e3a8a 0%, #3730a3 50%, #4338ca 100%);
        box-shadow: 0 0 15px rgba(1, 33, 105, 0.3);
      }
      
      .british-theme .border-purple-800 {
        border-color: #c8102e;
        box-shadow: 0 0 10px rgba(255, 255, 255, 0.4);
      }
      
      .british-theme .text-purple-200 {
        color: #ffffff;
        text-shadow: 0 0 5px rgba(1, 33, 105, 0.4);
      }
      
      .british-theme .text-purple-300 {
        color: #f0f8ff;
        text-shadow: 0 0 5px rgba(200, 16, 46, 0.4);
      }
      
      @keyframes britishFloat {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        25% { transform: translateY(-20px) rotate(5deg); }
        50% { transform: translateY(-35px) rotate(0deg); }
        75% { transform: translateY(-20px) rotate(-5deg); }
      }
      
      @keyframes britishTwinkle {
        0%, 100% { opacity: 0.8; transform: scale(1); filter: brightness(1); }
        25% { opacity: 1; transform: scale(1.2); filter: brightness(1.3); }
        50% { opacity: 0.6; transform: scale(0.8); filter: brightness(0.7); }
        75% { opacity: 0.9; transform: scale(1.1); filter: brightness(1.1); }
      }
      
      @keyframes britishSparkle {
        0%, 100% { opacity: 0; transform: scale(0); }
        50% { opacity: 1; transform: scale(1); }
      }
      
      @keyframes britishFlag {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        25% { transform: translateY(-10px) rotate(2deg); }
        50% { transform: translateY(-20px) rotate(0deg); }
        75% { transform: translateY(-10px) rotate(-2deg); }
      }
    `
    document.head.appendChild(style)

    // Create British effects
    this.createBritishSymbols()
    this.createBritishFlags()
    this.createBritishSparkles()
    this.createBritishNavigationLights()
  }

  createEasterEggs() {
    const easterEggs = ['🥚', '🥚', '🥚', '🥚', '🥚', '🥚', '🥚', '🥚']

    for (let i = 0; i < 15; i++) {
      const egg = document.createElement('div')
      egg.className = 'easter-egg'
      egg.textContent = easterEggs[Math.floor(Math.random() * easterEggs.length)]
      egg.style.cssText = `
        position: fixed;
        top: ${Math.random() * 80 + 10}%;
        left: ${Math.random() * 80 + 10}%;
        font-size: ${Math.random() * 15 + 20}px;
        pointer-events: none;
        z-index: 9998;
        animation: easterBounce ${Math.random() * 6 + 4}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        filter: drop-shadow(0 0 5px rgba(255, 182, 193, 0.5));
      `
      this.effectsTarget.appendChild(egg)
    }
  }

  createEasterBunnies() {
    for (let i = 0; i < 8; i++) {
      const bunny = document.createElement('div')
      bunny.className = 'easter-bunny'
      bunny.innerHTML = '🐰'
      bunny.style.cssText = `
        position: fixed;
        top: ${Math.random() * 60 + 20}%;
        left: ${Math.random() * 60 + 20}%;
        font-size: ${Math.random() * 20 + 25}px;
        pointer-events: none;
        z-index: 9997;
        animation: easterFloat ${Math.random() * 8 + 6}s ease-in-out infinite;
        animation-delay: ${Math.random() * 4}s;
        filter: drop-shadow(0 0 8px rgba(173, 216, 230, 0.6));
      `
      this.effectsTarget.appendChild(bunny)
    }
  }

  createEasterFlowers() {
    const flowers = ['🌸', '🌷', '🌼', '🌻', '🌺', '🌹', '💐', '🌿']

    for (let i = 0; i < 12; i++) {
      const flower = document.createElement('div')
      flower.className = 'easter-flower'
      flower.textContent = flowers[Math.floor(Math.random() * flowers.length)]
      flower.style.cssText = `
        position: fixed;
        top: ${Math.random() * 80 + 10}%;
        left: ${Math.random() * 80 + 10}%;
        font-size: ${Math.random() * 15 + 18}px;
        pointer-events: none;
        z-index: 9996;
        animation: easterFloat ${Math.random() * 7 + 5}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        filter: drop-shadow(0 0 5px rgba(221, 160, 221, 0.5));
      `
      this.effectsTarget.appendChild(flower)
    }
  }

  createEasterNavigationLights() {
    const nav = document.querySelector('nav')
    if (!nav) return

    // Easter pastel colors
    const easterColors = ['#FFB6C1', '#ADD8E6', '#DDA0DD', '#98FB98', '#F0E68C', '#FFA07A', '#87CEEB', '#D8BFD8']

    for (let i = 0; i < 10; i++) {
      const light = document.createElement('div')
      light.className = 'twinkle-light'
      light.style.cssText = `
        position: absolute;
        top: ${Math.random() * 100}%;
        left: ${Math.random() * 100}%;
        width: ${Math.random() * 6 + 4}px;
        height: ${Math.random() * 6 + 4}px;
        background: ${easterColors[Math.floor(Math.random() * easterColors.length)]};
        border-radius: 50%;
        pointer-events: none;
        z-index: 1000;
        animation: easterTwinkle ${Math.random() * 3 + 2}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        box-shadow: 0 0 8px currentColor, 0 0 12px currentColor;
        opacity: 0.8;
      `
      nav.appendChild(light)
    }
  }

  createEasterRainbow() {
    for (let i = 0; i < 5; i++) {
      const rainbow = document.createElement('div')
      rainbow.className = 'easter-rainbow'
      rainbow.innerHTML = '🌈'
      rainbow.style.cssText = `
        position: fixed;
        top: ${Math.random() * 40 + 10}%;
        left: ${Math.random() * 60 + 20}%;
        font-size: ${Math.random() * 30 + 40}px;
        pointer-events: none;
        z-index: 9995;
        animation: easterRainbow ${Math.random() * 10 + 8}s linear infinite;
        animation-delay: ${Math.random() * 5}s;
        opacity: 0.7;
      `
      this.effectsTarget.appendChild(rainbow)
    }
  }

  createBritishSymbols() {
    const britishSymbols = ['👑', '🏰', '☕', '🌹', '🦢', '🐦', '🌧️', '🎭']

    for (let i = 0; i < 12; i++) {
      const symbol = document.createElement('div')
      symbol.className = 'british-symbol'
      symbol.textContent = britishSymbols[Math.floor(Math.random() * britishSymbols.length)]
      symbol.style.cssText = `
        position: fixed;
        top: ${Math.random() * 80 + 10}%;
        left: ${Math.random() * 80 + 10}%;
        font-size: ${Math.random() * 20 + 25}px;
        pointer-events: none;
        z-index: 9998;
        animation: britishFloat ${Math.random() * 8 + 6}s ease-in-out infinite;
        animation-delay: ${Math.random() * 4}s;
        filter: drop-shadow(0 0 8px rgba(1, 33, 105, 0.6));
      `
      this.effectsTarget.appendChild(symbol)
    }
  }

  createBritishFlags() {
    for (let i = 0; i < 8; i++) {
      const flag = document.createElement('div')
      flag.className = 'british-flag'
      flag.innerHTML = '🇬🇧'
      flag.style.cssText = `
        position: fixed;
        top: ${Math.random() * 60 + 20}%;
        left: ${Math.random() * 60 + 20}%;
        font-size: ${Math.random() * 25 + 30}px;
        pointer-events: none;
        z-index: 9997;
        animation: britishFlag ${Math.random() * 6 + 4}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        filter: drop-shadow(0 0 10px rgba(200, 16, 46, 0.6));
      `
      this.effectsTarget.appendChild(flag)
    }
  }

  createBritishSparkles() {
    for (let i = 0; i < 20; i++) {
      const sparkle = document.createElement('div')
      sparkle.className = 'british-sparkle'
      sparkle.innerHTML = '✨'
      sparkle.style.cssText = `
        position: fixed;
        top: ${Math.random() * 100}%;
        left: ${Math.random() * 100}%;
        font-size: ${Math.random() * 12 + 15}px;
        pointer-events: none;
        z-index: 9996;
        animation: britishSparkle ${Math.random() * 4 + 2}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        color: ${['#012169', '#c8102e', '#ffffff'][Math.floor(Math.random() * 3)]};
      `
      this.effectsTarget.appendChild(sparkle)
    }
  }

  createBritishNavigationLights() {
    const nav = document.querySelector('nav')
    if (!nav) return

    // British flag colors
    const britishColors = ['#012169', '#c8102e', '#ffffff', '#012169', '#c8102e', '#ffffff']

    for (let i = 0; i < 12; i++) {
      const light = document.createElement('div')
      light.className = 'twinkle-light'
      light.style.cssText = `
        position: absolute;
        top: ${Math.random() * 100}%;
        left: ${Math.random() * 100}%;
        width: ${Math.random() * 6 + 4}px;
        height: ${Math.random() * 6 + 4}px;
        background: ${britishColors[Math.floor(Math.random() * britishColors.length)]};
        border-radius: 50%;
        pointer-events: none;
        z-index: 1000;
        animation: britishTwinkle ${Math.random() * 3 + 2}s ease-in-out infinite;
        animation-delay: ${Math.random() * 3}s;
        box-shadow: 0 0 8px currentColor, 0 0 12px currentColor;
        opacity: 0.8;
      `
      nav.appendChild(light)
    }
  }
}

