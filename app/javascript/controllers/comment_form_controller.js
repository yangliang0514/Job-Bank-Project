// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  input(e) {
    const content = e.target.value.trim();

    if (content) {
      this.buttonTarget.classList.remove("btn-disable");
      this.buttonTarget.classList.add("btn-primary");
      this.buttonTarget.removeAttribute("disabled");
    }

    if (!content) {
      this.buttonTarget.classList.remove("btn-primary");
      this.buttonTarget.classList.add("btn-disable");
      this.buttonTarget.setAttribute("disabled", "");
    }
  }
}
