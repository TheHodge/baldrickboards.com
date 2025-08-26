import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "dropdown"]

  connect() {
    // Controller is connected
  }

  toggle() {
    this.menuTarget.classList.toggle('hidden')
  }

  close() {
    this.menuTarget.classList.add('hidden')
  }

  open() {
    this.menuTarget.classList.remove('hidden')
  }

  toggleDropdown(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const dropdown = event.currentTarget.nextElementSibling
    if (dropdown && dropdown.classList.contains('mobile-dropdown')) {
      dropdown.classList.toggle('hidden')
      
      // Toggle the chevron icon
      const chevron = event.currentTarget.querySelector('.chevron')
      if (chevron) {
        chevron.classList.toggle('rotate-180')
      }
    }
  }

  closeAllDropdowns() {
    this.dropdownTargets.forEach(dropdown => {
      dropdown.classList.add('hidden')
    })
    
    // Reset all chevrons
    this.element.querySelectorAll('.chevron').forEach(chevron => {
      chevron.classList.remove('rotate-180')
    })
  }
}
