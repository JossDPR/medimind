import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="color-change"
export default class extends Controller {
  static targets = ["element"]
  static values = {
    takendate: Boolean
  }

  connect() {
    console.log(this.takendateValue)
    console.log(this.elementTarget)
    if (this.takendateValue) {
      this.elementTarget.classList.remove("untaken");
      this.elementTarget.classList.add("taken");
    } else {
      this.elementTarget.classList.remove("taken");
      this.elementTarget.classList.add("untaken");
    }
  }
}
