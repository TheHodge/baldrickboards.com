import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]

  connect() {
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.boundHandleClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.boundHandleClickOutside)
  }

  toggleDropdown(event) {
    event.preventDefault()
    event.stopPropagation()

    const trigger = event.currentTarget
    const dropdown = trigger.nextElementSibling

    if (!dropdown || !dropdown.classList.contains("dropdown-menu")) return

    const isOpen = dropdown.classList.contains("show")
    this.closeDropdowns()

    if (!isOpen) {
      dropdown.classList.add("show")
      trigger.setAttribute("aria-expanded", "true")
    } else {
      trigger.setAttribute("aria-expanded", "false")
    }
  }

  closeDropdowns() {
    this.dropdownTargets.forEach((dropdown) => {
      dropdown.classList.remove("show")
      const trigger = dropdown.previousElementSibling
      if (trigger?.tagName === "BUTTON") {
        trigger.setAttribute("aria-expanded", "false")
      }
    })
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.closeDropdowns()
    }
  }
}
