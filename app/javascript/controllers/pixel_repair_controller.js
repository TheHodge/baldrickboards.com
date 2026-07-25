import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "score", "best", "faults", "speed", "intro", "overlay", "finalStats"]

  connect() {
    this.ctx = this.canvasTarget.getContext("2d")
    this.DPR = Math.max(1, Math.min(2, window.devicePixelRatio || 1))
    this.COLS = 18
    this.ROWS = 12
    this.cell = 0
    this.offX = 0
    this.offY = 0
    this.colors = ["#22d3ee", "#f97316", "#10b981", "#f43f5e", "#8b5cf6"]
    this.STATE = { LIT: 0, DARK: 1 }
    this.bulbs = []
    this.shards = []
    this.running = false
    this.score = 0
    this.best = 0
    this.faults = 0
    this.maxFaults = 10
    this.spawnBaseMs = 1100
    this.spawnTimer = 0
    this.speedMul = 1
    this.last = 0
    this.rafId = null

    this.onClick = this.onClick.bind(this)
    this.draw = this.draw.bind(this)
    this.canvasTarget.addEventListener("click", this.onClick, { passive: true })
    this.resizeObserver = new ResizeObserver(() => this.resize())
    this.resizeObserver.observe(this.canvasTarget)

    this.resize()
    this.loadBest()
    this.reset()
    this.rafId = requestAnimationFrame(this.draw)
  }

  disconnect() {
    this.canvasTarget.removeEventListener("click", this.onClick)
    if (this.resizeObserver) this.resizeObserver.disconnect()
    if (this.rafId) cancelAnimationFrame(this.rafId)
  }

  start() {
    if (this.running) return
    this.introTarget.classList.remove("show")
    this.running = true
    this.spawnTimer = 300
  }

  restart() {
    this.reset()
    this.introTarget.classList.add("show")
  }

  resize() {
    const rect = this.canvasTarget.getBoundingClientRect()
    const w = Math.floor(rect.width * this.DPR)
    const h = Math.floor(rect.height * this.DPR)
    if (this.canvasTarget.width !== w || this.canvasTarget.height !== h) {
      this.canvasTarget.width = w
      this.canvasTarget.height = h
    }
    this.layoutGrid()
  }

  layoutGrid() {
    const cw = this.canvasTarget.width
    const ch = this.canvasTarget.height
    this.COLS = Math.max(14, Math.round(cw / (34 * this.DPR)))
    this.ROWS = Math.max(10, Math.round(ch / (34 * this.DPR)))
    this.cell = Math.min(Math.floor(cw / this.COLS), Math.floor(ch / this.ROWS))
    this.offX = Math.floor((cw - this.COLS * this.cell) / 2)
    this.offY = Math.floor((ch - this.ROWS * this.cell) / 2)
    this.initBulbs()
  }

  initBulbs() {
    this.bulbs.length = 0
    for (let r = 0; r < this.ROWS; r++) {
      for (let c = 0; c < this.COLS; c++) {
        this.bulbs.push({
          r,
          c,
          state: this.STATE.LIT,
          phase: Math.random() * Math.PI * 2,
          color: this.colors[(r * this.COLS + c) % this.colors.length],
          cool: 0
        })
      }
    }
  }

  reset() {
    this.running = false
    this.score = 0
    this.faults = 0
    this.speedMul = 1
    this.spawnBaseMs = 1100
    this.spawnTimer = 0
    this.overlayTarget.classList.remove("show")
    this.shards = []
    this.updateHUD()
    this.initBulbs()
  }

  loadBest() {
    this.best = +localStorage.getItem("baldrick-pixel-repair-best") || 0
    this.bestTarget.textContent = `Best: ${this.best}`
  }

  saveBest() {
    localStorage.setItem("baldrick-pixel-repair-best", this.best)
  }

  updateHUD() {
    this.scoreTarget.textContent = `Score: ${this.score}`
    this.bestTarget.textContent = `Best: ${this.best}`
    this.faultsTarget.textContent = `Faults: ${this.faults} / ${this.maxFaults}`
    this.faultsTarget.classList.toggle("danger", this.faults >= Math.max(1, this.maxFaults - 1))
    this.speedTarget.textContent = `Speed: ${this.speedMul.toFixed(1)}×`
  }

  indexAt(x, y) {
    return y * this.COLS + x
  }

  randomLitIndex() {
    const lit = []
    for (let i = 0; i < this.bulbs.length; i++) {
      if (this.bulbs[i].state === this.STATE.LIT) lit.push(i)
    }
    if (!lit.length) return -1
    return lit[Math.floor(Math.random() * lit.length)]
  }

  spawnFault() {
    const i = this.randomLitIndex()
    if (i < 0) return
    this.bulbs[i].state = this.STATE.DARK
    this.faults++
    this.updateHUD()
    if (this.faults >= this.maxFaults) this.gameOver()
  }

  gameOver() {
    this.running = false
    this.shards = []
    const maxShards = 320
    let added = 0

    for (const b of this.bulbs) {
      b.state = this.STATE.DARK
      if (added < maxShards) {
        const bx = this.offX + b.c * this.cell + this.cell / 2
        const by = this.offY + b.r * this.cell + this.cell / 2
        for (let k = 0; k < 2 && added < maxShards; k++) {
          const ang = Math.random() * Math.PI * 2
          const sp = 0.6 + Math.random() * 1.8
          this.shards.push({
            x: bx,
            y: by,
            vx: Math.cos(ang) * sp,
            vy: Math.sin(ang) * sp - 0.2,
            life: 900 + Math.random() * 600,
            col: "rgba(239,68,68,0.85)"
          })
          added++
        }
      }
    }

    this.element.classList.add("shake")
    setTimeout(() => this.element.classList.remove("shake"), 650)

    if (this.score > this.best) {
      this.best = this.score
      this.saveBest()
    }
    this.updateHUD()
    this.finalStatsTarget.textContent = `Score ${this.score} • Best ${this.best}`
    this.overlayTarget.classList.add("show")
  }

  onClick(e) {
    if (!this.bulbs.length || !this.running) return
    const rect = this.canvasTarget.getBoundingClientRect()
    const x = (e.clientX - rect.left) * this.DPR - this.offX
    const y = (e.clientY - rect.top) * this.DPR - this.offY
    if (x < 0 || y < 0) return
    const cx = Math.floor(x / this.cell)
    const cy = Math.floor(y / this.cell)
    if (cx < 0 || cy < 0 || cx >= this.COLS || cy >= this.ROWS) return
    const b = this.bulbs[this.indexAt(cx, cy)]
    if (b.state === this.STATE.DARK) {
      b.state = this.STATE.LIT
      b.cool = 1
      this.score++
      this.faults = Math.max(0, this.faults - 1)
      if (this.score % 7 === 0) this.speedMul = Math.min(3.5, this.speedMul + 0.15)
      this.updateHUD()
    }
  }

  draw(ts) {
    this.rafId = requestAnimationFrame(this.draw)
    if (!this.last) this.last = ts
    const dt = Math.min(64, ts - this.last)
    this.last = ts
    const ctx = this.ctx

    if (this.running) {
      this.spawnTimer -= dt
      const target = Math.max(220, this.spawnBaseMs / this.speedMul)
      if (this.spawnTimer <= 0) {
        this.spawnFault()
        this.spawnTimer = target * (0.8 + Math.random() * 0.6)
      }
    }

    ctx.clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height)

    ctx.save()
    ctx.globalAlpha = 0.06
    ctx.fillStyle = "#94a3b8"
    ctx.translate(this.canvasTarget.width / 2, this.canvasTarget.height / 2)
    ctx.rotate(-Math.PI / 7)
    ctx.textAlign = "center"
    ctx.textBaseline = "middle"
    ctx.font = `${Math.floor(Math.min(this.canvasTarget.width, this.canvasTarget.height) / 9)}px ui-sans-serif, system-ui`
    ctx.fillText("baldrickboards.com", 0, 0)
    ctx.restore()

    ctx.lineWidth = Math.max(1, Math.floor(this.cell * 0.06))
    ctx.strokeStyle = "rgba(31,41,55,0.7)"
    ctx.lineCap = "round"
    for (let r = 0; r < this.ROWS; r++) {
      ctx.beginPath()
      for (let c = 0; c < this.COLS; c++) {
        const x = this.offX + c * this.cell + this.cell / 2
        const y = this.offY + r * this.cell + this.cell / 2
        if (c === 0) ctx.moveTo(x, y)
        else ctx.lineTo(x, y)
      }
      ctx.stroke()
    }

    for (const b of this.bulbs) {
      const x = this.offX + b.c * this.cell + this.cell / 2
      const y = this.offY + b.r * this.cell + this.cell / 2
      const radius = Math.max(3 * this.DPR, Math.min(this.cell * 0.22, 9 * this.DPR))
      const twinkle = 0.65 + 0.35 * Math.sin(ts * 0.004 + b.phase)

      if (b.state === this.STATE.LIT) {
        const grad = ctx.createRadialGradient(x, y, 0, x, y, radius * 5)
        grad.addColorStop(0, this.rgbaHex(b.color, 0.8 * twinkle))
        grad.addColorStop(1, this.rgbaHex(b.color, 0))
        ctx.fillStyle = grad
        ctx.beginPath()
        ctx.arc(x, y, radius * 4.6, 0, Math.PI * 2)
        ctx.fill()
        ctx.fillStyle = "rgba(255,255,255,0.85)"
        ctx.beginPath()
        ctx.arc(x, y, radius, 0, Math.PI * 2)
        ctx.fill()
        ctx.fillStyle = b.color
        ctx.beginPath()
        ctx.arc(x, y, radius * 0.8, 0, Math.PI * 2)
        ctx.fill()
      } else {
        ctx.fillStyle = "rgba(15,23,42,0.92)"
        ctx.beginPath()
        ctx.arc(x, y, radius, 0, Math.PI * 2)
        ctx.fill()
        ctx.strokeStyle = "rgba(239,68,68,0.7)"
        ctx.lineWidth = Math.max(1, radius * 0.35)
        ctx.beginPath()
        ctx.arc(x, y, radius * 0.75, 0, Math.PI * 2)
        ctx.stroke()
      }

      if (b.cool > 0) {
        b.cool -= dt * 0.004
        if (b.cool < 0) b.cool = 0
        ctx.strokeStyle = this.rgbaHex("#ffffff", 0.9 * b.cool)
        ctx.lineWidth = 1.2 * this.DPR
        ctx.beginPath()
        ctx.arc(x, y, radius * 1.45, 0, Math.PI * 2)
        ctx.stroke()
      }
    }

    if (!this.running && this.faults >= this.maxFaults) {
      const a = 0.15 + 0.1 * Math.sin(ts * 0.012)
      ctx.fillStyle = `rgba(239,68,68,${a})`
      ctx.fillRect(0, 0, this.canvasTarget.width, this.canvasTarget.height)

      for (let i = this.shards.length - 1; i >= 0; i--) {
        const s = this.shards[i]
        s.life -= dt
        s.x += s.vx * dt * 0.06
        s.y += s.vy * dt * 0.06
        s.vy += 0.0006 * dt
        if (s.life <= 0) {
          this.shards.splice(i, 1)
          continue
        }
        ctx.fillStyle = s.col
        ctx.beginPath()
        ctx.arc(s.x, s.y, Math.max(1, 1.4 * this.DPR), 0, Math.PI * 2)
        ctx.fill()
      }
    }
  }

  rgbaHex(hex, a) {
    const h = hex.replace("#", "")
    const v = parseInt(h, 16)
    const r = (v >> 16) & 255
    const g = (v >> 8) & 255
    const b = v & 255
    return `rgba(${r},${g},${b},${a})`
  }
}
