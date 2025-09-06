import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "modalImage", "modalCaption"]

  connect() {
    // Close modal with Escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        this.closeModal()
      }
    })
  }

  openModal(event) {
    const imageSrc = event.currentTarget.dataset.imageSrc
    const imageAlt = event.currentTarget.dataset.imageAlt
    
    if (!imageSrc) {
      console.error("No image source found")
      return
    }
    
    this.modalImageTarget.src = imageSrc
    this.modalImageTarget.alt = imageAlt
    this.modalCaptionTarget.textContent = imageAlt
    
    this.modalTarget.classList.remove('hidden')
    document.body.style.overflow = 'hidden'
  }

  closeModal() {
    this.modalTarget.classList.add('hidden')
    document.body.style.overflow = 'auto'
  }
}
