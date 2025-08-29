import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image"]
  static values = { src: String, alt: String }

  connect() {
    // Close modal when clicking outside the image
    this.element.addEventListener('click', (e) => {
      if (e.target === this.element) {
        this.close()
      }
    })

    // Close modal with Escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        this.close()
      }
    })
  }

  open() {
    this.imageTarget.src = this.srcValue
    this.imageTarget.alt = this.altValue
    this.element.classList.remove('hidden')
    document.body.style.overflow = 'hidden'
  }

  close() {
    this.element.classList.add('hidden')
    document.body.style.overflow = 'auto'
  }
}
