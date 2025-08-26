import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    active: Boolean 
  }

  connect() {
    this.keySequence = ''
    this.easterEggActive = false
    
    // Add global keydown listener
    document.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  disconnect() {
    // Clean up event listener
    document.removeEventListener('keydown', this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    // Ignore modifier keys and special keys
    if (event.ctrlKey || event.altKey || event.metaKey || event.shiftKey) {
      return
    }
    
    // Only add single character keys
    if (event.key.length === 1) {
      this.keySequence += event.key.toLowerCase()
      
      // Check if the sequence matches "auschristmas" BEFORE truncating
      if (this.keySequence === 'auschristmas' && !this.easterEggActive) {
        this.easterEggActive = true
        this.activateEasterEgg()
      }
    
      // Keep only the last 11 characters (length of "auschristmas")
      if (this.keySequence.length > 11) {
        this.keySequence = this.keySequence.slice(-11)
      }
    }
  }

  activateEasterEgg() {
    // Flip the entire website upside down
    document.body.style.transform = 'rotate(180deg)'
    document.body.style.transition = 'transform 1s ease-in-out'
    
    // Replace every third word with HOHOHO
    this.replaceEveryThirdWord()
    
    // Add some festive styling (keep purple background)
    document.body.style.background = 'linear-gradient(45deg, #8b5cf6, #a855f7, #c084fc)'
    document.body.style.backgroundSize = '400% 400%'
    document.body.style.animation = 'rainbow 2s ease-in-out infinite'
    
    // Add rainbow animation
    const style = document.createElement('style')
    style.textContent = `
      @keyframes rainbow {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
      }
    `
    document.head.appendChild(style)
    
    // Add some snow effect
    this.createSnow()
    
    // Reset after 10 seconds
    setTimeout(() => {
      this.deactivateEasterEgg()
    }, 10000)
  }

  deactivateEasterEgg() {
    this.easterEggActive = false
    document.body.style.transform = ''
    document.body.style.background = ''
    document.body.style.animation = ''
    
    // Remove rainbow animation
    const rainbowStyle = document.querySelector('style')
    if (rainbowStyle) {
      rainbowStyle.remove()
    }
    
    // Restore original text
    this.restoreOriginalText()
    
    // Remove snow
    const snowflakes = document.querySelectorAll('.snowflake')
    snowflakes.forEach(snowflake => snowflake.remove())
  }

  replaceEveryThirdWord() {
    // Store original text for restoration
    if (!window.originalTexts) {
      window.originalTexts = new Map()
    }
    
    const textNodes = document.evaluate(
      '//text()[normalize-space(.)!=""]',
      document,
      null,
      XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,
      null
    )
    
    for (let i = 0; i < textNodes.snapshotLength; i++) {
      const node = textNodes.snapshotItem(i)
      const text = node.textContent
      
      // Skip if already processed
      if (window.originalTexts.has(node)) continue
      
      // Store original text
      window.originalTexts.set(node, text)
      
      // Replace every third word with HOHOHO
      const words = text.split(/\s+/)
      for (let j = 2; j < words.length; j += 3) {
        words[j] = 'HOHOHO'
      }
      
      node.textContent = words.join(' ')
    }
  }

  restoreOriginalText() {
    if (window.originalTexts) {
      window.originalTexts.forEach((originalText, node) => {
        node.textContent = originalText
      })
      window.originalTexts.clear()
    }
  }

  createSnow() {
    for (let i = 0; i < 50; i++) {
      setTimeout(() => {
        const snowflake = document.createElement('div')
        snowflake.className = 'snowflake'
        snowflake.style.cssText = `
          position: fixed;
          top: -10px;
          left: ${Math.random() * window.innerWidth}px;
          width: 10px;
          height: 10px;
          background: white;
          border-radius: 50%;
          pointer-events: none;
          z-index: 9999;
          animation: snowfall ${Math.random() * 3 + 2}s linear infinite;
        `
        
        // Add snowfall animation
        const style = document.createElement('style')
        style.textContent = `
          @keyframes snowfall {
            to {
              transform: translateY(${window.innerHeight + 10}px);
            }
          }
        `
        document.head.appendChild(style)
        
        document.body.appendChild(snowflake)
        
        // Remove snowflake after animation
        setTimeout(() => {
          if (snowflake.parentNode) {
            snowflake.parentNode.removeChild(snowflake)
          }
        }, 5000)
      }, i * 100)
    }
  }
}

