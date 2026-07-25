import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "name", "dots"]

  connect() {
    this.index = 0
    this.buildDots()
    this.show(0)
    this.timer = setInterval(() => this.advance(), 3000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  pause() {
    clearInterval(this.timer)
  }

  resume() {
    clearInterval(this.timer)
    this.timer = setInterval(() => this.advance(), 3000)
  }

  advance() {
    this.show((this.index + 1) % this.slideTargets.length)
  }

  go(event) {
    this.show(parseInt(event.currentTarget.dataset.index, 10))
    this.resume()
  }

  show(n) {
    this.index = n
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("on", i === n)
    })
    if (this.hasNameTarget) {
      const current = this.slideTargets[n]
      const name = current.dataset.nm || current.querySelector("img")?.alt || ""
      this.nameTarget.textContent = name
      if (current.href) this.nameTarget.href = current.href
    }
    if (this.hasDotsTarget) {
      this.dotsTarget.querySelectorAll(".brot-dot").forEach((dot, i) => {
        dot.classList.toggle("on", i === n)
      })
    }
  }

  buildDots() {
    if (!this.hasDotsTarget) return
    this.dotsTarget.innerHTML = ""
    this.slideTargets.forEach((_, i) => {
      const btn = document.createElement("button")
      btn.type = "button"
      btn.className = "brot-dot" + (i === 0 ? " on" : "")
      btn.dataset.index = i
      btn.setAttribute("aria-label", `Show board ${i + 1}`)
      btn.addEventListener("click", (e) => this.go(e))
      this.dotsTarget.appendChild(btn)
    })
  }
}
