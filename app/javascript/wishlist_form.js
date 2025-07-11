// Dynamic Wishlist Item Fields
document.addEventListener("DOMContentLoaded", () => {
	const addItemBtn = document.getElementById("add-item-btn");
	const addAnotherItemBtn = document.getElementById("add-another-item");
	const itemsContainer = document.getElementById("wishlist-items-container");
	const itemTemplate = document.getElementById("wishlist-item-template");

	let itemIndex = getNextItemIndex();

	itemsContainer.addEventListener("click", (e) => {
		if (e.target.closest(".remove-item-btn")) {
			const itemGroup = e.target.closest(".wishlist-item-group");
			if (itemGroup) {
				if (
					itemsContainer.querySelectorAll(".wishlist-item-group").length > 1
				) {
					itemGroup.remove();
				} else {
					alert("You must have at least one item in your wishlist.");
				}
			}
		}
	});

	// Function to get the next available item index
	function getNextItemIndex() {
		const existingItems = itemsContainer.querySelectorAll(
			".wishlist-item-group",
		);
		return existingItems.length;
	}

	// Function to update item numbers
	function updateItemNumbers() {
		const items = itemsContainer.querySelectorAll(".wishlist-item-group");
		items.forEach((item, index) => {
			const itemTitle = item.querySelector(".item-title");
			const itemNumber = item.querySelector(".item-number");

			if (itemTitle && !itemNumber) {
				itemTitle.textContent = `Item ${index + 1}`;
			} else if (itemNumber) {
				itemNumber.textContent = index + 1;
			}

			// Update the data-item-index
			item.setAttribute("data-item-index", index);

			// Update form field names and IDs
			updateFormFieldNames(item, index);
		});
	}

	// Function to update form field names for proper Rails nested attributes
	function updateFormFieldNames(itemGroup, index) {
		const inputs = itemGroup.querySelectorAll("input, textarea");
		const labels = itemGroup.querySelectorAll("label");

		for (const input of inputs) {
			const fieldType = input
				.getAttribute("placeholder")
				?.includes("wishing for")
				? "name"
				: input.type === "url"
					? "url"
					: "notes";

			input.name = `wishlist[wishlist_items_attributes][${index}][${fieldType}]`;
			input.id = `wishlist_wishlist_items_attributes_${index}_${fieldType}`;
		}

		labels.forEach((label, labelIndex) => {
			const fieldTypes = ["name", "url", "notes"];
			if (fieldTypes[labelIndex]) {
				label.setAttribute(
					"for",
					`wishlist_wishlist_items_attributes_${index}_${fieldTypes[labelIndex]}`,
				);
			}
		});
	}

	// Function to add a new item
	function addNewItem() {
		if (!itemTemplate) return;

		const templateContent = itemTemplate.content.cloneNode(true);
		const newItem = templateContent.querySelector(".wishlist-item-group");

		// Set the item index
		newItem.setAttribute("data-item-index", itemIndex);

		// Update the item number
		const itemNumber = newItem.querySelector(".item-number");
		if (itemNumber) {
			itemNumber.textContent = itemIndex + 1;
		}

		// Update form field names
		updateFormFieldNames(newItem, itemIndex);

		// Add remove functionality
		const removeBtn = newItem.querySelector(".remove-item-btn");
		if (removeBtn) {
			removeBtn.addEventListener("click", () => {
				removeItem(newItem);
			});
		}

		// Append to container
		itemsContainer.appendChild(newItem);

		// Animate in
		requestAnimationFrame(() => {
			newItem.style.opacity = "0";
			newItem.style.transform = "translateY(20px)";
			newItem.style.transition = "all 0.3s ease";

			requestAnimationFrame(() => {
				newItem.style.opacity = "1";
				newItem.style.transform = "translateY(0)";
			});
		});

		itemIndex++;

		// Focus on the first input of the new item
		const firstInput = newItem.querySelector("input");
		if (firstInput) {
			firstInput.focus();
		}
	}

	// Function to remove an item
	function removeItem(itemElement) {
		const items = itemsContainer.querySelectorAll(".wishlist-item-group");

		// Don't allow removing if it's the last item
		if (items.length <= 1) {
			alert("You must have at least one item in your wishlist.");
			return;
		}

		// Animate out
		itemElement.style.transition = "all 0.3s ease";
		itemElement.style.opacity = "0";
		itemElement.style.transform = "translateY(-20px)";

		setTimeout(() => {
			itemElement.remove();
			updateItemNumbers();
		}, 300);
	}

	// Event listeners
	if (addItemBtn) {
		addItemBtn.addEventListener("click", addNewItem);
	}

	if (addAnotherItemBtn) {
		addAnotherItemBtn.addEventListener("click", addNewItem);
	}

	// Add remove functionality to existing items
	document.addEventListener("click", (e) => {
		if (e.target.closest(".remove-item-btn")) {
			const itemGroup = e.target.closest(".wishlist-item-group");
			if (itemGroup) {
				removeItem(itemGroup);
			}
		}
	});

	// Initialize item numbers for existing items
	updateItemNumbers();

	// Hide remove buttons if only one item exists
	function toggleRemoveButtons() {
		const items = itemsContainer.querySelectorAll(".wishlist-item-group");
		const removeButtons = itemsContainer.querySelectorAll(".remove-item-btn");

		for (const btn of removeButtons) {
			btn.style.display = items.length <= 1 ? "none" : "flex";
		}
	}

	// Initial toggle
	toggleRemoveButtons();

	// Observer to watch for changes in the items container
	const observer = new MutationObserver(toggleRemoveButtons);
	observer.observe(itemsContainer, { childList: true });
});
