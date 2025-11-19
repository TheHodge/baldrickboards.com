import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.prefersHover = window.matchMedia("(hover: hover) and (pointer: fine)").matches
    this.updateSummary(this.element.hasAttribute("open"))
    this.boundOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.boundOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.boundOutsideClick)
  }

  handleClick(event) {
    // For touch devices, ensure tapping summary toggles without closing immediately
    if (event.target.tagName.toLowerCase() === "a") return
    const dropdown = event.currentTarget
    if (!dropdown.hasAttribute("open")) {
      this.closeOtherDropdowns(dropdown)
      dropdown.setAttribute("open", "true")
      this.updateSummary(true)
    }
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

  handleOutsideClick(event) {
    if (this.element.contains(event.target)) return
    if (this.element.hasAttribute("open")) {
      this.element.removeAttribute("open")
      this.updateSummary(false)
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
