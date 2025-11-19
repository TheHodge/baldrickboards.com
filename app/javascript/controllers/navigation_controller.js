import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "dropdownWrapper"]

  connect() {
    this.boundOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.boundOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.boundOutsideClick)
  }

  toggleDropdown(event) {
    event.preventDefault()
    event.stopPropagation()

    const wrapper = event.currentTarget.closest("[data-navigation-target='dropdownWrapper']")
    const dropdown = wrapper?.querySelector("[data-navigation-target='dropdown']")
    if (!dropdown) return

    const isOpen = dropdown.classList.contains("show")
    this.closeAllDropdowns()

    if (!isOpen) {
      dropdown.classList.add("show")
      dropdown.classList.remove("hidden")
      event.currentTarget.setAttribute("aria-expanded", "true")
    } else {
      dropdown.classList.add("hidden")
      event.currentTarget.setAttribute("aria-expanded", "false")
    }
  }

  closeAllDropdowns() {
    this.dropdownTargets.forEach((dropdown) => {
      dropdown.classList.remove("show")
      dropdown.classList.add("hidden")
      const trigger = dropdown.previousElementSibling
      trigger?.setAttribute("aria-expanded", "false")
    })
  }

  handleOutsideClick(event) {
    if (this.element.contains(event.target)) return
    this.closeAllDropdowns()
  }
}
