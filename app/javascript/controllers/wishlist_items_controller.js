import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.initializeItemNumbers()
    this.toggleRemoveButtons()
    
    // Observer to watch for changes in the items container
    this.observer = new MutationObserver(() => this.toggleRemoveButtons())
    this.observer.observe(this.containerTarget, { childList: true })
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  // Stimulus action methods
  add() {
    this.addNewItem()
  }

  remove(event) {
    const itemGroup = event.target.closest(".wishlist-item-group")
    if (itemGroup) {
      this.removeItem(itemGroup)
    }
  }

  getNextItemIndex() {
    const existingItems = this.containerTarget.querySelectorAll(".wishlist-item-group")
    return existingItems.length
  }

  addNewItem() {
    const itemTemplate = document.getElementById("wishlist-item-template")
    if (!itemTemplate) return

    const templateContent = itemTemplate.content.cloneNode(true)
    const newItem = templateContent.querySelector(".wishlist-item-group")

    // Get current index dynamically
    const currentIndex = this.getNextItemIndex()

    // Set the item index
    newItem.setAttribute("data-item-index", currentIndex)

    // Update the item number
    const itemNumber = newItem.querySelector(".item-number")
    if (itemNumber) {
      itemNumber.textContent = currentIndex + 1
    }

    // Update form field names
    this.updateFormFieldNames(newItem, currentIndex)

    // Append to container
    this.containerTarget.appendChild(newItem)

    // Update all item numbers to ensure consistency
    this.updateItemNumbers()

    // Animate in
    requestAnimationFrame(() => {
      newItem.style.opacity = "0"
      newItem.style.transform = "translateY(20px)"
      newItem.style.transition = "all 0.3s ease"

      requestAnimationFrame(() => {
        newItem.style.opacity = "1"
        newItem.style.transform = "translateY(0)"
      })
    })

    // Focus on the first input of the new item
    const firstInput = newItem.querySelector("input")
    if (firstInput) {
      firstInput.focus()
    }
  }

  removeItem(itemElement) {
    const items = this.containerTarget.querySelectorAll(".wishlist-item-group")

    // Don't allow removing if it's the last item
    if (items.length <= 1) {
      alert("You must have at least one item in your wishlist.")
      return
    }

    // Animate out
    itemElement.style.transition = "all 0.3s ease"
    itemElement.style.opacity = "0"
    itemElement.style.transform = "translateY(-20px)"

    setTimeout(() => {
      itemElement.remove()
      // Update all item numbers after removal
      this.updateItemNumbers()
    }, 300)
  }

  updateItemNumbers() {
    const items = this.containerTarget.querySelectorAll(".wishlist-item-group")
    items.forEach((item, index) => {
      const itemTitle = item.querySelector(".item-title")
      const itemNumber = item.querySelector(".item-number")

      if (itemTitle && !itemNumber) {
        itemTitle.textContent = `Item ${index + 1}`
      } else if (itemNumber) {
        itemNumber.textContent = index + 1
      }

      // Update the data-item-index
      item.setAttribute("data-item-index", index)

      // Update form field names and IDs
      this.updateFormFieldNames(item, index)
    })
  }

  updateFormFieldNames(itemGroup, index) {
    const inputs = itemGroup.querySelectorAll("input, textarea")
    const labels = itemGroup.querySelectorAll("label")

    for (const input of inputs) {
      let fieldType
      if (input.getAttribute("placeholder")?.includes("wishing for")) {
        fieldType = "name"
      } else if (input.type === "url") {
        fieldType = "url"
      } else if (input.type === "file") {
        fieldType = "image"
      } else {
        fieldType = "notes"
      }

      input.name = `wishlist[wishlist_items_attributes][${index}][${fieldType}]`
      input.id = `wishlist_wishlist_items_attributes_${index}_${fieldType}`
    }

    labels.forEach((label, labelIndex) => {
      const fieldTypes = ["name", "url", "notes", "image"]
      if (fieldTypes[labelIndex]) {
        label.setAttribute(
          "for",
          `wishlist_wishlist_items_attributes_${index}_${fieldTypes[labelIndex]}`
        )
      }
    })
  }

  initializeItemNumbers() {
    this.updateItemNumbers()
  }

  toggleRemoveButtons() {
    const items = this.containerTarget.querySelectorAll(".wishlist-item-group")
    const removeButtons = this.containerTarget.querySelectorAll(".remove-item-btn")

    for (const btn of removeButtons) {
      btn.style.display = items.length <= 1 ? "none" : "flex"
    }
  }
}