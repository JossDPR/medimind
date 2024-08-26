import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox"];

  connect() {
    console.log("Checkbox controller connected");
    console.log(this.checkboxTargets)
    console.log(this.labelTargets)
  }

  toggle(event) {
    const checkbox = event.currentTarget;
    const label = document.querySelector(`label[for='${checkbox.id}']`);

    console.log(label)

    if (label) {
      if (checkbox.checked) {
        label.classList.add('checked');
      } else {
        label.classList.remove('checked');
      }
    }
  }
}
