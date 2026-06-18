import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    document.body.classList.toggle("menu-open")
  }

  close() {
    document.body.classList.remove("menu-open")
  }

  connect() {
    this.resizeHandler = () => {
      if (window.innerWidth > 1180) this.close()
    }
    window.addEventListener("resize", this.resizeHandler)
  }

  disconnect() {
    window.removeEventListener("resize", this.resizeHandler)
    this.close()
  }
}
