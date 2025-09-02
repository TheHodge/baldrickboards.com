import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('click', this.handleClick.bind(this))
  }

  disconnect() {
    this.element.removeEventListener('click', this.handleClick.bind(this))
  }

  handleClick(event) {
    const href = event.currentTarget.getAttribute('href')
    
    if (href && href.startsWith('#')) {
      event.preventDefault()
      const targetElement = document.querySelector(href)
      
      if (targetElement) {
        targetElement.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        })
        
        // Update URL hash without jumping
        history.pushState(null, null, href)
      }
    }
  }
}
