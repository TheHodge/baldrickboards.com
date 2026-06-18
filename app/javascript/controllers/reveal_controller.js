import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this.element.querySelectorAll(".rv").forEach((el) => el.classList.add("in"))
      return
    }

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("in")
            this.observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.1, rootMargin: "0px 0px -6% 0px" }
    )

    this.element.querySelectorAll(".rv").forEach((el) => this.observer.observe(el))
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }
}
