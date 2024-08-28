import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox"];

  connect() {
    this.checkboxTargets.forEach((checkbox) => {
      this.updateLabel(checkbox);
    });
  }

  toggle(event) {
    const checkbox = event.currentTarget;
    this.updateLabel(checkbox);
  }

  updateLabel(checkbox) {
    const label = document.querySelector(`label[for='${checkbox.id}']`);

    if (label) {
      if (checkbox.checked) {
        label.classList.add("checked");
      } else {
        label.classList.remove("checked");
      }
    }
  }
}
