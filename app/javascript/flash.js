document.addEventListener("turbo:load", () => {
	const bar = document.getElementById("notification-bar");
	if (!bar) return;

	const flashKey = bar.dataset.flashKey;
	const closedKey = localStorage.getItem("closedNotificationKey");

	if (closedKey === flashKey) {
		bar.style.display = "none";
	}

	const closeBtn = bar.querySelector(".notification-close");
	if (closeBtn) {
		closeBtn.onclick = () => {
			bar.style.display = "none";
			localStorage.setItem("closedNotificationKey", flashKey);
		};
	}
});
