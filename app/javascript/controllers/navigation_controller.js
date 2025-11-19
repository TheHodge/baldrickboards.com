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

  handleSummaryClick(event) {
    event.preventDefault()
    event.stopPropagation()

    const dropdown = this.element
    const isOpen = dropdown.hasAttribute("open")

    if (isOpen) {
      dropdown.removeAttribute("open")
      this.updateSummary(false)
    } else {
      this.closeOtherDropdowns(dropdown)
      dropdown.setAttribute("open", "true")
      this.updateSummary(true)
    }
  }

  openOnHover(event) {
    if (!this.prefersHover) return
    const dropdown = this.element
    this.closeOtherDropdowns(dropdown)
    dropdown.setAttribute("open", "true")
    this.updateSummary(true)
  }

  closeOnHover(event) {
    if (!this.prefersHover) return
    const dropdown = this.element
    dropdown.removeAttribute("open")
    this.updateSummary(false)
  }

  handleToggle(event) {
    const dropdown = this.element
    const isOpen = dropdown.hasAttribute("open")
    this.updateSummary(isOpen)

    if (isOpen) {
      this.closeOtherDropdowns(dropdown)
    }
  }

  handleOutsideClick(event) {
    if (this.element.contains(event.target)) return
    if (!this.element.hasAttribute("open")) return

    this.element.removeAttribute("open")
    this.updateSummary(false)
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
