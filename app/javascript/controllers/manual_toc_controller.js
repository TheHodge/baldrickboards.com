import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.openFromHash()

    this.sections = this.linkTargets
      .map((link) => {
        const id = link.getAttribute("href")?.slice(1)
        const el = id ? document.getElementById(id) : null
        return el ? { link, el } : null
      })
      .filter(Boolean)

    this.onScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.onScroll, { passive: true })
    this.onScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
  }

  openFromHash() {
    const id = window.location.hash?.slice(1)
    if (!id) return

    const el = document.getElementById(id)
    if (!el) return

    if (el.tagName === "DETAILS") {
      el.open = true
    } else {
      const details = el.closest("details")
      if (details) details.open = true
    }
  }

  jump(event) {
    event.preventDefault()
    const id = event.currentTarget.getAttribute("href")?.slice(1)
    const el = id ? document.getElementById(id) : null
    if (!el) return

    if (el.tagName === "DETAILS") {
      el.open = true
    } else {
      const details = el.closest("details")
      if (details) details.open = true
    }

    el.scrollIntoView({ behavior: "smooth", block: "start" })
  }

  onScroll() {
    const offset = 160
    let current = this.sections[0]

    for (const section of this.sections) {
      if (section.el.getBoundingClientRect().top <= offset) current = section
    }

    this.linkTargets.forEach((link) => link.classList.remove("active"))
    if (current) current.link.classList.add("active")
  }
}
