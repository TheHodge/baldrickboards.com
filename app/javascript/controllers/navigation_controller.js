import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "trigger"]
  static values = {
    openOnHover: { type: Boolean, default: false }
  }

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
    const dropdown = this.findDropdown(trigger)

    if (!dropdown) return

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
      const trigger = this.findTriggerForDropdown(dropdown)
      trigger?.setAttribute("aria-expanded", "false")
    })
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.closeDropdowns()
    }
  }

  handleMouseEnter(event) {
    if (!this.openOnHoverValue) return

    const trigger = event.currentTarget
    const dropdown = this.findDropdown(trigger)
    if (!dropdown) return

    this.closeDropdowns()
    dropdown.classList.add("show")
    trigger.setAttribute("aria-expanded", "true")
  }

  handleMouseLeave(event) {
    if (!this.openOnHoverValue) return

    const trigger = event.currentTarget
    const dropdown = this.findDropdown(trigger)
    if (!dropdown) return

    dropdown.classList.remove("show")
    trigger.setAttribute("aria-expanded", "false")
  }

  findDropdown(trigger) {
    if (!trigger) return null
    const wrapper = trigger.closest("[data-navigation-target='trigger']")
    if (!wrapper) return trigger.nextElementSibling

    const dropdownId = wrapper.getAttribute("data-navigation-dropdown-id")
    if (dropdownId) {
      return this.dropdownTargets.find(
        (dropdown) => dropdown.dataset.navigationDropdownId === dropdownId
      )
    }

    const dropdown = wrapper.querySelector("[data-navigation-target='dropdown']")
    if (dropdown) return dropdown

    return trigger.nextElementSibling?.classList?.contains("dropdown-menu")
      ? trigger.nextElementSibling
      : null
  }

  findTriggerForDropdown(dropdown) {
    if (!dropdown) return null
    const dropdownId = dropdown.dataset.navigationDropdownId
    if (!dropdownId) {
      const trigger =
        dropdown.previousElementSibling?.tagName === "BUTTON"
          ? dropdown.previousElementSibling
          : dropdown.parentElement?.querySelector("button")
      return trigger || null
    }

    return this.triggerTargets.find(
      (trigger) => trigger.dataset.navigationDropdownId === dropdownId
    )
  }
}
