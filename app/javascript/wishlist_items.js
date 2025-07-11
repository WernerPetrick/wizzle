document.addEventListener("DOMContentLoaded", () => {
	const addMoreBtn = document.getElementById("add-more-items");
	const fieldsContainer = document.getElementById("wishlist-items-fields");

	if (addMoreBtn && fieldsContainer) {
		addMoreBtn.addEventListener("click", () => {
			const lastFields = fieldsContainer.querySelector(
				".wishlist-item-fields:last-child",
			);
			if (lastFields) {
				const newFields = lastFields.cloneNode(true);
				for (const input of newFields.querySelectorAll("input, textarea")) {
					input.value = "";
				}
				fieldsContainer.appendChild(newFields);
			}
		});

		fieldsContainer.addEventListener("click", (e) => {
			if (e.target.classList.contains("remove-item-btn")) {
				const allFields = fieldsContainer.querySelectorAll(
					".wishlist-item-fields",
				);
				if (allFields.length > 1) {
					e.target.closest(".wishlist-item-fields").remove();
				}
			}
		});
	}
});

document.addEventListener("DOMContentLoaded", () => {
	const modal = document.getElementById("share-modal");
	const closeBtn = document.getElementById("close-share-modal");
	const shareBtns = document.querySelectorAll(".share-wishlist-btn");
	const shareForm = document.getElementById("share-form");
	const wishlistIdInput = document.getElementById("modal-wishlist-id");

	for (const btn of shareBtns) {
		btn.addEventListener("click", () => {
			wishlistIdInput.value = btn.getAttribute("data-wishlist-id");
			shareForm.action = `/wishlists/${btn.getAttribute("data-wishlist-id")}/shared_wishlists`;
			modal.style.display = "flex";
		});
	}

	closeBtn.addEventListener("click", () => {
		modal.style.display = "none";
	});

	window.addEventListener("click", (event) => {
		if (event.target === modal) {
			modal.style.display = "none";
		}
	});

	// AJAX form submission
	shareForm.addEventListener("submit", (e) => {
		e.preventDefault();
		const formData = new FormData(shareForm);
		fetch(shareForm.action, {
			method: "POST",
			headers: {
				"X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
					.content,
				Accept: "text/vnd.wizzle.flash",
			},
			body: formData,
		})
			.then((response) => response.text())
			.then((html) => {
				document.getElementById("flash").innerHTML = html;
				modal.style.display = "none";
				shareForm.reset();
			})
			.catch(() => {
				document.getElementById("flash").innerHTML =
					'<div class="flash alert">There was an error sending the invite.</div>';
			});
	});
});
