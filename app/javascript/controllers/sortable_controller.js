import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
	static targets = ["list"];
	static values = { url: String, status: String };

	connect() {
		this.sortable = Sortable.create(this.listTarget, {
			animation: 150,
			group: "roadmap",
			onEnd: this.end.bind(this),
		});
	}

	end(event) {
		const ids = [...this.listTarget.children].map((el) => el.dataset.id);
		const newStatus = this.listTarget.dataset.status;

		fetch(this.urlValue, {
			method: "POST",
			headers: {
				"X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				roadmap_item: ids,
				status: newStatus,
				moved_id: event.item.dataset.id,
			}),
		});
	}
}
