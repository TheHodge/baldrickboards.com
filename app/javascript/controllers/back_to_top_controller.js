import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.scrollThreshold = 300 // Show button after scrolling 300px
    this.isVisible = false
    this.handleScroll = this.handleScroll.bind(this)
    
    // Add scroll event listener
    window.addEventListener('scroll', this.handleScroll)
    
    // Initial check
    this.handleScroll()
  }

  disconnect() {
    // Clean up event listener
    window.removeEventListener('scroll', this.handleScroll)
  }

  handleScroll() {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    const shouldShow = scrollTop > this.scrollThreshold

    if (shouldShow && !this.isVisible) {
      this.showButton()
    } else if (!shouldShow && this.isVisible) {
      this.hideButton()
    }
  }

  showButton() {
    this.buttonTarget.classList.remove('opacity-0', 'pointer-events-none')
    this.buttonTarget.classList.add('opacity-100')
    this.isVisible = true
  }

  hideButton() {
    this.buttonTarget.classList.add('opacity-0', 'pointer-events-none')
    this.buttonTarget.classList.remove('opacity-100')
    this.isVisible = false
  }

  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }
}
