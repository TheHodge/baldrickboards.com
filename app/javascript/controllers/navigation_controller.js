import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]
  static values = { 
    active: Boolean,
    currentPath: String 
  }

  connect() {
    // Set initial active state based on current path
    this.updateActiveState()
    
    // Add global click listener to close dropdowns when clicking outside
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    // Clean up event listener
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }

  toggleDropdown(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const dropdown = event.currentTarget.nextElementSibling
    if (dropdown && dropdown.classList.contains('dropdown-menu')) {
      dropdown.classList.toggle('show')
    }
  }

  closeDropdowns() {
    this.dropdownTargets.forEach(dropdown => {
      dropdown.classList.remove('show')
    })
  }

  updateActiveState() {
    const currentPath = window.location.pathname
    
    // Update active states based on current path
    this.element.querySelectorAll('a').forEach(link => {
      const href = link.getAttribute('href')
      if (href && currentPath.startsWith(href) && href !== '/') {
        link.classList.add('active')
      } else if (href === '/' && currentPath === '/') {
        link.classList.add('active')
      } else {
        link.classList.remove('active')
      }
    })
  }

  // Close dropdowns when clicking outside
  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.closeDropdowns()
    }
  }

  // Handle keyboard navigation
  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.closeDropdowns()
    }
  }
}
