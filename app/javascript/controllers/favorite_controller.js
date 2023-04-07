import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";
import Swal from "sweetalert2";

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
    const { id, liked } = this.element.dataset;
    this.resumeId = id;
    this.liked = liked === "true" ? true : false;

    this.updateIcon();
  }

  updateIcon() {
    if (this.liked) {
      // 把svg的class加進去就會改變svg圖案，但因為做成svg就跟原本不一樣了，所以不用remove也可以做，但不知道為何
      this.iconTarget.classList.add("fa-solid");
      return;
    }

    this.iconTarget.classList.add("fa-regular");
  }

  like() {
    this.liked = !this.liked;
    this.updateIcon();

    Rails.ajax({
      url: `/resumes/${this.resumeId}/like`,
      type: "POST",
      success: ({ id, status }) => {
        // 這裡故意改成arrow function，用this才能找到想要的function
        this.notify(status === "liked" ? "已收藏" : "取消收藏");
      },
      error: function (error) {
        console.error("Error:", error);
      },
    });
  }

  notify(message, time = 1500) {
    const Toast = Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: time,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.addEventListener("mouseenter", Swal.stopTimer);
        toast.addEventListener("mouseleave", Swal.resumeTimer);
      },
    });

    Toast.fire({
      icon: "success",
      title: message,
    });
  }
}
