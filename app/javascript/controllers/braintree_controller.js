import { Controller } from "@hotwired/stimulus";
import dropin from "braintree-web-drop-in";

export default class extends Controller {
  static targets = ["dropin", "nonce"];

  initialize() {
    this.dropInstance = null;
  }

  initElements() {
    // dropin
    const dropIn = document.createElement("div");
    dropIn.setAttribute("data-braintree-target", "dropin");
    this.element.insertAdjacentElement("afterbegin", dropIn);

    // form
    this.element.setAttribute("data-action", "submit->braintree#getNonce");

    // hidden field
    const hidden = document.createElement("input");
    hidden.setAttribute("type", "hidden");
    hidden.setAttribute("name", "nonce");
    hidden.setAttribute("data-braintree-target", "nonce");
    this.element.append(hidden);
  }

  async connect() {
    try {
      this.initElements();
      const token = this.element.dataset.token;

      const dropInstance = await dropin.create({
        authorization: token,
        container: this.dropinTarget,
      });

      this.dropInstance = dropInstance;
    } catch (err) {
      console.log(err);
    }
  }

  async getNonce(e) {
    try {
      e.preventDefault();

      if (!this.dropInstance) return;

      const { nonce } = await this.dropInstance.requestPaymentMethod();

      this.nonceTarget.value = nonce;
      this.element.submit();
    } catch (err) {
      console.log(err);
    }
  }
}
