import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.prefersHover = window.matchMedia("(hover: hover) and (pointer: fine)").matches
    this.updateSummary(this.element.hasAttribute("open"))
  }

  openOnHover(event) {
    if (!this.prefersHover) return
    const dropdown = event.currentTarget
    dropdown.setAttribute("open", "true")
    this.updateSummary(true)
  }

  closeOnHover(event) {
    if (!this.prefersHover) return
    const dropdown = event.currentTarget
    dropdown.removeAttribute("open")
    this.updateSummary(false)
  }

  handleToggle(event) {
    const dropdown = event.currentTarget
    const isOpen = dropdown.hasAttribute("open")
    this.updateSummary(isOpen)

    if (isOpen) {
      this.closeOtherDropdowns(dropdown)
    }
  }

  closeOtherDropdowns(currentDropdown) {
    document.querySelectorAll("details.nav-dropdown[open]").forEach((dropdown) => {
      if (dropdown !== currentDropdown) {
        dropdown.removeAttribute("open")
        const summary = dropdown.querySelector("summary")
        summary?.setAttribute("aria-expanded", "false")
      }
    })
  }

  updateSummary(expanded) {
    const summary = this.element.querySelector("summary")
    summary?.setAttribute("aria-expanded", expanded ? "true" : "false")
  }
}
