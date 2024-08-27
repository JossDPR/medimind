import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="color-change"
export default class extends Controller {
  static targets = ["element"]
  static values = {
    takendate: Number
  }

  connect() {
    console.log(this.takendateValue)
    console.log(this.elementTarget)
    if (this.element.taken_date === 0) {
      this.element.classList.remove("taken");
      this.element.classList.add("untaken");
    } else {
      this.element.classList.remove("untaken");
      this.element.classList.add("taken");
    }
  }
}
