import { Controller } from "@hotwired/stimulus";
import sortable from "sortablejs";
import { myAlert } from "utils/notify";
import { patch } from "@rails/request.js";

// Connects to data-controller="sortable"
export default class extends Controller {
  connect() {
    sortable.create(this.element, {
      ghostClass: "drag-ghost",
      onUpdate: async function (e) {
        const id = e.item.dataset.id;
        const newIndex = e.newIndex + 1;
        const url = `/api/v1/resumes/${id}/sort`;

        const res = await patch(url, { body: JSON.stringify({ newIndex }) });

        if (res.ok) myAlert("成功更新順序");
      },
    });
  }
}
