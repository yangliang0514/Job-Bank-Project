import { Controller } from "@hotwired/stimulus";
import sortable from "sortablejs";

// Connects to data-controller="sortable"
export default class extends Controller {
  connect() {
    sortable.create(this.element, {
      ghostClass: "drag-ghost",
      onUpdate: function (e) {
        // 處理邏輯，然後去打API
      },
    });
  }
}
