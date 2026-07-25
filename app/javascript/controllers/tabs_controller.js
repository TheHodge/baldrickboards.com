import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Tabs controller connected")
    // Set initial state - v1.1 is default
    this.showTab("v1-1")
  }

  switch(event) {
    console.log("Tab switch clicked")
    event.preventDefault()
    const targetTab = event.currentTarget.dataset.tab
    console.log("Target tab:", targetTab)
    this.showTab(targetTab)
  }

  showTab(targetTab) {
    console.log("showTab called with:", targetTab)
    
    // Find all buttons and panels within this controller
    const buttons = this.element.querySelectorAll('.tab-button, .manual-tab')
    const panels = this.element.querySelectorAll('.tab-panel')

    buttons.forEach(button => {
      const isActive = button.dataset.tab === targetTab
      if (button.classList.contains("manual-tab")) {
        button.classList.toggle("active", isActive)
      } else if (isActive) {
        button.classList.remove("border-transparent", "text-gray-500", "hover:text-gray-700", "hover:border-gray-300")
        button.classList.add("border-purple-500", "text-purple-600")
      } else {
        button.classList.remove("border-purple-500", "text-purple-600")
        button.classList.add("border-transparent", "text-gray-500", "hover:text-gray-700", "hover:border-gray-300")
      }
    })

    // Update content visibility
    panels.forEach(panel => {
      if (panel.dataset.tab === targetTab) {
        panel.classList.remove("hidden")
        console.log("Showing panel:", targetTab)
      } else {
        panel.classList.add("hidden")
        console.log("Hiding panel:", panel.dataset.tab)
      }
    })
  }
}
