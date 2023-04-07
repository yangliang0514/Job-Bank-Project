import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["icon"];

  initialize() {
    this.liked = false;
    this.resumeId = undefined;
  }

  // connect好像是load時就會連過去？
  connect() {
    // 在load時再把data-action掛到那個元素上面
    this.element.setAttribute("data-action", "click->favorite#like");
    this.resumeId = this.element.dataset.id;
  }

  like() {
    Rails.ajax({
      url: `/resumes/${this.resumeId}/like`,
      type: "POST",
      success: function ({ id, status }) {
        console.log(id, status);
      },
      error: function (error) {
        console.error("Error:", error);
      },
    });

    this.liked = !this.liked;

    if (this.liked) {
      // 把svg的class加進去就會改變svg圖案，但因為做成svg就跟原本不一樣了，所以不用remove也可以做，但不知道為何
      this.iconTarget.classList.add("fa-solid");
      return;
    }

    this.iconTarget.classList.add("fa-regular");
  }
}
