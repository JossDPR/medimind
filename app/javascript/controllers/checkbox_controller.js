import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox"];

  connect() {
    console.log("Checkbox controller connected");
    console.log(this.checkboxTargets)
    console.log(this.labelTargets)
  }

  toggle(event) {
    const checkbox = event.currentTarget;  // Récupère la case à cocher cliquée
    const label = document.querySelector(`label[for='${checkbox.id}']`);  // Trouve le label associé

    console.log(label)

    if (label) {  // Vérifie si le label existe
      if (checkbox.checked) {
        label.classList.add('checked');
      } else {
        label.classList.remove('checked');
      }
    }
  }

  // toggle() {
  //   if (this.checksTarget.checked) {
  //     this.labelTargets.classList.add('checked');
  //   } else {
  //     this.labelTargets.classList.remove('checked');
  //   }
  // }
}
