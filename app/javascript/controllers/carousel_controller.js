import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "dot"]

  connect() {
    this.currentSlide = 0
    this.autoPlayInterval = null
    this.startAutoPlay()
  }

  disconnect() {
    this.stopAutoPlay()
  }

  goToSlide(event) {
    const slideIndex = parseInt(event.currentTarget.dataset.slide) - 1 // Convert from 1-based to 0-based
    this.stopAutoPlay()
    this.showSlide(slideIndex)
    this.startAutoPlay()
  }

  showSlide(index) {
    // Hide all slides
    this.slideTargets.forEach(slide => {
      slide.classList.remove('active')
    })
    
    // Remove active class from all dots
    this.dotTargets.forEach(dot => {
      dot.classList.remove('active')
    })
    
    // Show current slide
    this.slideTargets[index].classList.add('active')
    this.dotTargets[index].classList.add('active')
    
    this.currentSlide = index
  }

  nextSlide() {
    const next = (this.currentSlide + 1) % this.slideTargets.length
    this.showSlide(next)
  }

  prevSlide() {
    const prev = (this.currentSlide - 1 + this.slideTargets.length) % this.slideTargets.length
    this.showSlide(prev)
  }

  startAutoPlay() {
    this.autoPlayInterval = setInterval(() => {
      this.nextSlide()
    }, 5000) // Change slide every 5 seconds
  }

  stopAutoPlay() {
    if (this.autoPlayInterval) {
      clearInterval(this.autoPlayInterval)
      this.autoPlayInterval = null
    }
  }

  // Pause auto-play on hover
  pauseOnHover() {
    this.stopAutoPlay()
  }

  resumeOnLeave() {
    this.startAutoPlay()
  }
}
